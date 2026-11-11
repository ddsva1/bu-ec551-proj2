"""
Datapath and sequencer (control FSM) generation.

"""

from dataclasses import dataclass

from dag import OP_TYPES, COMMUTATIVE, HLSError, resource_usage


def sel_width(n_sources):
    """Select-line width for an n-input mux (0 means a plain wire)."""
    return max(0, (n_sources - 1).bit_length())


@dataclass
class Datapath:
    width: int
    fus: dict                    # type -> [fu names]
    fu_type: dict                # fu name -> type
    values: dict                 # value -> {"birth", "death", "reg"}
    registers: list              # register names
    fu_port_src: dict            # fu -> {"a": [src...], "b": [src...]}
    reg_src: dict                # reg -> [src...]
    states: list                 # control words, see build_controller()
    output_regs: dict            # output value -> reg
    binding: dict                # op id -> {"fu", "src_a", "src_b", "dest_reg"}


# --------------------------------------------------------------------------
# 1. register allocation
# --------------------------------------------------------------------------

def compute_lifetimes(dag, sched):
    L = sched.latency
    values = {}
    for name in dag.inputs:
        values[name] = {"birth": 0}
    for o in dag.ops:
        values[o.dest] = {"birth": sched.steps[o.id]}
    for name, v in values.items():
        readers = dag.consumers.get(name, [])
        if name in dag.outputs:
            death = L + 1
        else:
            death = max((sched.steps[r] for r in readers), default=0)
        # a value nobody reads still occupies its register for one state
        v["death"] = max(death, v["birth"] + 1)
    return values


def allocate_registers(dag, sched):
    """Left-edge register allocation. Returns (values, registers)."""
    values = compute_lifetimes(dag, sched)
    registers, free_at = [], {}
    for name in sorted(values, key=lambda n: values[n]["birth"]):   # stable sort keeps SSA order
        v = values[name]
        for r in registers:
            if free_at[r] <= v["birth"]:
                break
        else:
            r = f"r{len(registers)}"
            registers.append(r)
        v["reg"] = r
        free_at[r] = v["death"]
    return values, registers


# --------------------------------------------------------------------------
# 2. FU binding + 3. mux generation
# --------------------------------------------------------------------------

def bind(dag, sched, values, registers):
    usage = resource_usage(dag, sched)
    fus = {t: [f"{t}{i}" for i in range(usage[t])] for t in OP_TYPES}
    fu_type = {fu: t for t in OP_TYPES for fu in fus[t]}
    fu_port_src = {fu: {"a": [], "b": []} for fu in fu_type}
    reg_src = {r: [] for r in registers}

    # inputs are written from the input ports in IDLE
    for name in dag.inputs:
        reg_src[values[name]["reg"]].append(("in", name))

    def operand_src(x):
        return ("const", x) if isinstance(x, int) else ("reg", values[x]["reg"])

    binding = {}   # op id -> {"fu", "src_a", "src_b", "dest_reg"}
    for step in range(1, sched.latency + 1):
        busy = set()
        for o in sched.ops_in_step(dag, step):
            sa, sb = operand_src(o.a), operand_src(o.b)
            dest_reg = values[o.dest]["reg"]
            orients = [(sa, sb)]
            if o.op in COMMUTATIVE and sa != sb:
                orients.append((sb, sa))
            best = None
            for idx, fu in enumerate(fus[o.op]):
                if fu in busy:
                    continue
                for x, y in orients:
                    # number of new mux inputs this choice would add
                    cost = (x not in fu_port_src[fu]["a"]) + (y not in fu_port_src[fu]["b"]) + \
                           (("fu", fu) not in reg_src[dest_reg])
                    if best is None or (cost, idx) < best[0]:
                        best = ((cost, idx), fu, x, y)
            _, fu, x, y = best
            busy.add(fu)
            for port, s in (("a", x), ("b", y)):
                if s not in fu_port_src[fu][port]:
                    fu_port_src[fu][port].append(s)
            if ("fu", fu) not in reg_src[dest_reg]:
                reg_src[dest_reg].append(("fu", fu))
            binding[o.id] = {"fu": fu, "src_a": x, "src_b": y, "dest_reg": dest_reg}
    return fus, fu_type, binding, fu_port_src, reg_src


# --------------------------------------------------------------------------
# 4. controller / sequencer
# --------------------------------------------------------------------------

def build_controller(dag, sched, values, registers, binding, fu_type, fu_port_src, reg_src):
    """
    One control word per state:
        fu_sel  : fu -> {"a": select index, "b": select index}  (None = FU idle)
        reg_we  : reg -> 0/1 write enable
        reg_sel : reg -> select index of the register's input mux (None = not written)
        next    : {"start": state if start=1, "default": state otherwise}
    """
    L = sched.latency

    def blank(name, code):
        return {
            "name": name, "code": code,
            "fu_sel": {fu: {"a": None, "b": None} for fu in fu_type},
            "reg_we": {r: 0 for r in registers},
            "reg_sel": {r: None for r in registers},
            "done": 0,
            "next": {},
        }

    states = []
    idle = blank("IDLE", 0)
    for name in dag.inputs:
        r = values[name]["reg"]
        idle["reg_we"][r] = 1
        idle["reg_sel"][r] = reg_src[r].index(("in", name))
    idle["condition"] = "register writes happen only when start=1"
    idle["next"] = {"start": "S1", "default": "IDLE"}
    states.append(idle)

    for t in range(1, L + 1):
        st = blank(f"S{t}", t)
        for o in sched.ops_in_step(dag, t):
            b = binding[o.id]
            fu = b["fu"]
            st["fu_sel"][fu] = {"a": fu_port_src[fu]["a"].index(b["src_a"]),
                                "b": fu_port_src[fu]["b"].index(b["src_b"])}
            r = b["dest_reg"]
            st["reg_we"][r] = 1
            st["reg_sel"][r] = reg_src[r].index(("fu", fu))
        st["next"] = {"default": f"S{t + 1}" if t < L else "DONE"}
        states.append(st)

    done = blank("DONE", L + 1)
    done["done"] = 1
    done["next"] = {"start": "IDLE", "default": "DONE"}
    states.append(done)
    return states


def build_datapath(dag, sched, width=8):
    if width < 1:
        raise HLSError("bit width must be at least 1")
    values, registers = allocate_registers(dag, sched)
    fus, fu_type, binding, fu_port_src, reg_src = bind(dag, sched, values, registers)
    states = build_controller(dag, sched, values, registers, binding, fu_type, fu_port_src, reg_src)
    output_regs = {v: values[v]["reg"] for v in dag.outputs}
    return Datapath(width, fus, fu_type, values, registers, fu_port_src, reg_src, states,
                    output_regs, binding)
