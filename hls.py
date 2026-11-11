"""
HLS tool driver: equations -> SSA -> DAG -> schedule -> datapath + FSM -> Verilog.

    python hls.py testdata/provided.txt
    python hls.py testdata/provided.txt --schedule casap --adders 1 --muls 1
    python hls.py testdata/provided.txt --schedule custom --latency 4 --export-ssa
    python hls.py testdata/provided.txt --hardcode B=2 --fpga

Stages:
    run_ssa         Parts 1-2 (make_ssa.py: get_file_equ + form_ssa)
    build_dag       Part 3   (dag.py)
    run_schedule    Part 3   (dag.py)
    build_datapath  Part 4   (datapath.py)
    write_reports   schedule (and SSA) text files in output/<name>/
    generate        Part 6   (make_v.py) -> verilog-gen/<name>/
    project         Part 7   (fpga_project.py) -> vivado/<name>/create_project.tcl
    fpga            Part 7   (fpga_build.py) -> build/<name>.bit, programs the board
"""

import argparse
import sys
from pathlib import Path

import make_ssa
import dag as dagmod
import datapath as dpmod
import make_v
from dag import HLSError

MODES = {
    "asap": "ASAP (unconstrained)",
    "alap": "ALAP (unconstrained, from latency bound)",
    "casap": "constrained ASAP (resource-limited list scheduling)",
    "calap": "constrained ALAP (resource-limited reverse list scheduling)",
    "custom": "custom: force-directed scheduling (min. FUs for a latency bound)",
}
MAX_LINES = 20


def banner(title):
    print("-----------------------------------------")
    print(title)


# ---------------------------------------------------------------- stages

def run_ssa(path):
    """Parts 1-2: reuse the partner's parser and SSA converter unchanged."""
    if not Path(path).is_file():
        raise HLSError(f"input file '{path}' not found")
    try:
        equs = make_ssa.get_file_equ(path)
    except make_ssa.SSAFormatError as e:
        raise HLSError(str(e))
    n = sum(1 for e in equs if "=" in e)
    if n == 0:
        raise HLSError(f"'{path}' contains no equations")
    if n > MAX_LINES:
        print(f"WARNING: {n} equations; the assignment guarantees at most {MAX_LINES}")
    try:
        ssa, var_map = make_ssa.form_ssa(equs)
    except make_ssa.SSAFormatError as e:
        raise HLSError(str(e))
    except Exception as e:  # make_ssa raises raw Python errors on malformed lines
        raise HLSError(f"could not convert the equations to SSA ({type(e).__name__}: {e}); "
                       f"check that every line looks like 'X = A + B'")
    return ssa, var_map


def build_dag(ssa, var_map):
    return dagmod.DAG(dagmod.parse_ssa(ssa), var_map)


def run_schedule(dag, mode, limits, latency):
    return dagmod.run_scheduler(dag, mode, limits, latency)


def write_reports(outdir, stem, ssa, dag, sched, export_ssa):
    outdir.mkdir(parents=True, exist_ok=True)
    written = []
    if export_ssa:
        p = outdir / f"{stem}_ssa.txt"
        with open(p, "w") as f:
            for line in ssa:
                f.write(line + "\n")
        written.append(p)
    p = outdir / f"{stem}_schedule.txt"
    with open(p, "w") as f:
        f.write(dagmod.format_schedule(dag, sched) + "\n")
    written.append(p)
    return written


def parse_hardcode(items):
    """['B=2', 'C=5'] -> {'B': 2, 'C': 5}"""
    out = {}
    for item in items or []:
        name, sep, value = item.partition("=")
        if not sep or not value.strip().isdecimal():
            raise HLSError(f"--hardcode expects NAME=VALUE with a non-negative integer, got '{item}'")
        out[name.strip()] = int(value)
    return out


def print_io(info):
    """The demo cheat sheet: which switch is which input, what sw[15:12] shows."""
    for sw, name in info["switches"]:
        print(f"  {sw:<10} -> {name}")
    for name, val in info["hardcoded"]:
        print(f"  {name} = {val} (hardcoded)")
    print("  sw[15:12] selects the displayed value:")
    for i, label in info["obs"]:
        print(f"    {i:>2}: {label}")
    for w in info["warnings"]:
        print("WARNING:", w)


# ---------------------------------------------------------------- CLI

def parse_args(argv):
    p = argparse.ArgumentParser(
        description="EC551 HLS tool: equations -> SSA -> DAG -> schedule -> datapath/FSM -> Verilog",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="scheduling modes:\n" + "\n".join(f"  {k:<7} {v}" for k, v in MODES.items()))
    p.add_argument("input", help="text file with one equation per line, e.g. 'X = A + B'")
    p.add_argument("-s", "--schedule", choices=list(MODES), default="asap",
                   help="scheduling mode (default: asap)")
    p.add_argument("--adders", type=int, help="max adders (casap/calap)")
    p.add_argument("--subs", type=int, help="max subtractors (casap/calap)")
    p.add_argument("--muls", type=int, help="max multipliers (casap/calap)")
    p.add_argument("-l", "--latency", type=int,
                   help="latency bound in control steps (alap/custom; default: critical path)")
    p.add_argument("-w", "--width", type=int, default=4, help="datapath bit width (default: 4)")
    p.add_argument("--hardcode", action="append", metavar="NAME=VALUE",
                   help="give input NAME a fixed value instead of a switch (repeatable)")
    p.add_argument("--export-ssa", action="store_true", help="also write the SSA form to <name>_ssa.txt")
    p.add_argument("--fpga", action="store_true",
                   help="build the bitstream with Vivado and program the Nexys 4 DDR")
    p.add_argument("--project", action="store_true",
                   help="also write vivado/<name>/create_project.tcl to open the design in Vivado")
    return p.parse_args(argv)


def main(argv=None):
    args = parse_args(sys.argv[1:] if argv is None else argv)
    stem = Path(args.input).stem
    limits = {"add": args.adders, "sub": args.subs, "mul": args.muls}

    try:
        hardcoded = parse_hardcode(args.hardcode)

        banner("Parts 1-2: parsing + SSA (make_ssa.py)")
        ssa, var_map = run_ssa(args.input)

        dag = build_dag(ssa, var_map)

        banner(f"Part 3: scheduling - {MODES[args.schedule]}")
        sched = run_schedule(dag, args.schedule, limits, args.latency)
        print(dagmod.format_schedule(dag, sched))

        banner("Part 4: datapath + sequencer")
        dp = dpmod.build_datapath(dag, sched, args.width)
        print(f"{len(dp.registers)} registers, {len(dp.states)} FSM states")

        banner("Part 6: Verilog generation")
        info = make_v.generate_verilog(dag, sched, dp, Path("verilog-gen") / stem, hardcoded)
        print_io(info)

        banner("Writing files")
        for p in write_reports(Path("output") / stem, stem, ssa, dag, sched, args.export_ssa) \
                + info["files"]:
            print("  ", p)

        if args.project:
            import fpga_project
            script = fpga_project.make_project(stem)
            print(f"   {script}   (Vivado: Tools -> Run Tcl Script...)")

        if args.fpga:
            banner("Part 7: FPGA build (Vivado, takes a few minutes)")
            import fpga_build
            fpga_build.build_and_program(stem, Path("verilog-gen") / stem)
        print("-----------------------------------------")
    except HLSError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
