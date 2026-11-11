"""
Part 6 -- Verilog generation.

Turns the datapath + controller from datapath.py into Verilog. Writes three
files to the output folder:

    hls_core.v    hls_controller : the FSM (sequencer) driving mux selects and
                                   register write enables
                  hls_core       : the datapath - registers at the cycle
                                   boundaries, input muxes, and exactly the
                                   number of adders/subtractors/multipliers
                                   the schedule needs
    hls_top.v     hls_top        : top level - button stepping (clock enable),
                                   inputs from switches or hardcoded, and the
                                   observability mux (which FU/output is shown)
    testbench.v   testbench      : self-checking simulation of hls_core and
                                   hls_top

The FU modules (adder, subtractor, multiplier) and step_pulse are hand-written
in verilog-mod/.
"""

import random
from pathlib import Path

from dag import OP_TYPES, FU_MODULE, HLSError, base_name
from datapath import sel_width

SWITCH_FIELDS = 3    # inputs on sw[3:0], sw[7:4], sw[11:8]
OBS_ENTRIES = 16     # sw[15:12] selects one of 16 observable values
DEFAULT_HARDCODE = 1


# --------------------------------------------------------------------------
# reference model (expected values for the testbench)
# --------------------------------------------------------------------------

def evaluate(dag, input_values, width):
    """Value of every SSA name, computed the way the hardware does it."""
    mask = (1 << width) - 1
    env = {k: v & mask for k, v in input_values.items()}

    def val(x):
        return x & mask if isinstance(x, int) else env[x]

    for o in dag.ops:
        a, b = val(o.a), val(o.b)
        if o.op == "add":
            r = a + b
        elif o.op == "sub":
            r = 0 if a < b else a - b      # same clamp as verilog-mod/subtractor.v
        else:
            r = a * b
        env[o.dest] = r & mask
    return env


# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------

def rng(width):
    """'[3:0] ' for width 4, '' for width 1."""
    return "" if width == 1 else f"[{width - 1}:0] "


def src_expr(src, width):
    """Verilog expression for a mux source."""
    kind, x = src
    if kind == "reg":
        return x
    if kind == "const":
        return f"{width}'d{x & ((1 << width) - 1)}"
    if kind == "in":
        return f"in_{base_name(x)}"
    return f"fu_{x}_y"


def select_signals(dp):
    """[(name, width)] of every mux select line (muxes with 2+ inputs)."""
    sigs = []
    for fu in dp.fu_type:
        for p in ("a", "b"):
            n = len(dp.fu_port_src[fu][p])
            if n > 1:
                sigs.append((f"sel_{fu}_{p}", sel_width(n)))
    for r in dp.registers:
        n = len(dp.reg_src[r])
        if n > 1:
            sigs.append((f"sel_{r}", sel_width(n)))
    return sigs


def mux_block(target, sel, srcs, width):
    """Combinational mux driving `target`; a plain assignment for one source."""
    if len(srcs) == 1:
        return [f"    always @(*) {target} = {src_expr(srcs[0], width)};"]
    w = sel_width(len(srcs))
    lines = ["    always @(*)", f"        case ({sel})"]
    for i, s in enumerate(srcs):
        lines.append(f"            {w}'d{i}: {target} = {src_expr(s, width)};")
    lines.append(f"            default: {target} = {{W{{1'b0}}}};")
    lines.append("        endcase")
    return lines


def state_width(dp):
    return max(1, sel_width(len(dp.states)))


def port_list(ports, indent=4):
    return ",\n".join(" " * indent + p for p in ports)


# --------------------------------------------------------------------------
# hls_core.v : controller + datapath
# --------------------------------------------------------------------------

def gen_controller(dag, sched, dp):
    sw = state_width(dp)
    sels = select_signals(dp)
    ports = ["input clk", "input rst", "input en", "input start",
             f"output reg {rng(sw)}state", "output reg done"]
    ports += [f"output reg {rng(w)}{n}" for n, w in sels]
    ports += [f"output reg we_{r}" for r in dp.registers]

    L = [
        "// Controller / sequencer: one state per control step.",
        "// The state only advances when en=1 (one button press on the board).",
        "module hls_controller (",
        port_list(ports),
        ");",
    ]
    for st in dp.states:
        L.append(f"    localparam ST_{st['name']} = {sw}'d{st['code']};")
    L.append("")

    # next-state logic
    L += ["    always @(posedge clk) begin",
          "        if (rst)",
          "            state <= ST_IDLE;",
          "        else if (en)",
          "            case (state)"]
    for st in dp.states:
        nxt = st["next"]
        if "start" in nxt:
            L.append(f"                ST_{st['name']}: if (start) state <= ST_{nxt['start']};")
        else:
            L.append(f"                ST_{st['name']}: state <= ST_{nxt['default']};")
    L += ["                default: state <= ST_IDLE;",
          "            endcase",
          "    end", ""]

    # control word of each state
    L += ["    always @(*) begin", "        done = 1'b0;"]
    L += [f"        {n} = {w}'d0;" for n, w in sels]
    L += [f"        we_{r} = 1'b0;" for r in dp.registers]
    L.append("        case (state)")
    for st in dp.states:
        body = []
        for fu, sel in st["fu_sel"].items():
            for p in ("a", "b"):
                n = len(dp.fu_port_src[fu][p])
                if sel[p] is not None and n > 1:
                    body.append(f"sel_{fu}_{p} = {sel_width(n)}'d{sel[p]};")
        for r in dp.registers:
            if st["reg_we"][r]:
                body.append(f"we_{r} = 1'b1;")
                n = len(dp.reg_src[r])
                if n > 1:
                    body.append(f"sel_{r} = {sel_width(n)}'d{st['reg_sel'][r]};")
        if st["done"]:
            body.append("done = 1'b1;")

        if st["name"] == "IDLE":
            L.append("            ST_IDLE: if (start) begin   // load the primary inputs")
        else:
            L.append(f"            ST_{st['name']}: begin")
        if st["name"].startswith("S"):
            t = st["code"]
            for o in sched.ops_in_step(dag, t):
                L.append(f"                // {o.id}: {o.text()}  on {dp.binding[o.id]['fu']}")
        L += [f"                {b}" for b in body]
        L.append("            end")
    L += ["            default: ;", "        endcase", "    end", "endmodule", ""]
    return L


def gen_core(dag, sched, dp):
    W = dp.width
    sw = state_width(dp)
    sels = select_signals(dp)

    ports = ["input clk", "input rst", "input en", "input start"]
    ports += [f"input  {rng(W)}in_{base_name(v)}" for v in dag.inputs]
    ports += [f"output {rng(W)}out_{base_name(v)}" for v in dp.output_regs]
    ports += [f"output {rng(W)}fu_{fu}_y" for fu in dp.fu_type]
    ports += [f"output {rng(sw)}state", "output done"]

    counts = ", ".join(f"{len(dp.fus[t])} {FU_MODULE[t]}(s)" for t in OP_TYPES)
    L = [
        "// Datapath generated from the schedule:",
        f"//   {counts}, {len(dp.registers)} registers, {len(dp.states)} FSM states",
        "// Registers sit at the cycle boundaries; muxes route registers/constants",
        "// to the shared functional units and FU outputs back to the registers.",
        "module hls_core (",
        port_list(ports),
        ");",
        f"    localparam W = {W};",
        "",
        "    // control signals",
    ]
    L += [f"    wire {rng(w)}{n};" for n, w in sels]
    L += [f"    wire we_{r};" for r in dp.registers]
    conns = [".clk(clk)", ".rst(rst)", ".en(en)", ".start(start)", ".state(state)", ".done(done)"]
    conns += [f".{n}({n})" for n, _ in sels] + [f".we_{r}(we_{r})" for r in dp.registers]
    L += ["", "    hls_controller ctrl (", port_list(conns, 8), "    );", ""]

    L.append("    // registers")
    L.append("    reg [W-1:0] " + ", ".join(dp.registers) + ";")
    L.append("")

    L.append("    // functional units and their input muxes")
    for t in OP_TYPES:
        for fu in dp.fus[t]:
            L.append(f"    reg [W-1:0] {fu}_a, {fu}_b;")
            L += mux_block(f"{fu}_a", f"sel_{fu}_a", dp.fu_port_src[fu]["a"], W)
            L += mux_block(f"{fu}_b", f"sel_{fu}_b", dp.fu_port_src[fu]["b"], W)
            L.append(f"    {FU_MODULE[t]} #(.W(W)) u_{fu} (.a({fu}_a), .b({fu}_b), .y(fu_{fu}_y));")
            L.append("")

    L.append("    // register input muxes")
    for r in dp.registers:
        L.append(f"    reg [W-1:0] {r}_d;")
        L += mux_block(f"{r}_d", f"sel_{r}", dp.reg_src[r], W)
    L.append("")

    L += ["    always @(posedge clk) begin",
          "        if (rst) begin"]
    L += [f"            {r} <= {{W{{1'b0}}}};" for r in dp.registers]
    L += ["        end else if (en) begin"]
    L += [f"            if (we_{r}) {r} <= {r}_d;" for r in dp.registers]
    L += ["        end", "    end", ""]

    L.append("    // outputs (valid in state DONE)")
    L += [f"    assign out_{base_name(v)} = {r};   // {v}" for v, r in dp.output_regs.items()]
    L += ["endmodule", ""]
    return L


# --------------------------------------------------------------------------
# hls_top.v : board-independent top level
# --------------------------------------------------------------------------

def plan_io(dag, dp, hardcoded):
    """Decide which inputs come from switches, which are hardcoded, and the
    observability table. Returns (switch_inputs, fixed_inputs, obs, warnings)."""
    mask = (1 << dp.width) - 1
    by_base = {base_name(v): v for v in dag.inputs}
    for name, val in hardcoded.items():
        if name not in by_base:
            raise HLSError(f"--hardcode {name}: '{name}' is not a primary input "
                           f"(inputs: {', '.join(by_base) or 'none'})")
        if val > mask:
            raise HLSError(f"--hardcode {name}={val}: value does not fit in the "
                           f"{dp.width}-bit datapath (max {mask})")
    free = [v for v in dag.inputs if base_name(v) not in hardcoded]
    switch_inputs = free[:SWITCH_FIELDS]
    fixed = {v: hardcoded.get(base_name(v), DEFAULT_HARDCODE) & mask
             for v in dag.inputs if v not in switch_inputs}

    obs = [(f"fu_{fu}_y", f"{fu} ({FU_MODULE[dp.fu_type[fu]]}) output") for fu in dp.fu_type]
    obs += [(f"out_{base_name(v)}", f"output {base_name(v)} ({v})") for v in dp.output_regs]
    warnings = []
    if len(obs) > OBS_ENTRIES:
        warnings.append(f"{len(obs)} observable values but sw[15:12] selects only {OBS_ENTRIES}; "
                        f"{', '.join(label for _, label in obs[OBS_ENTRIES:])} cannot be shown")
        obs = obs[:OBS_ENTRIES]
    if dp.width != 4:
        warnings.append(f"width is {dp.width}, but the switch fields are 4 bits wide")
    return switch_inputs, fixed, obs, warnings


def switch_slice(k, width):
    lo = 4 * k
    if width >= 4:
        s = f"sw[{lo + 3}:{lo}]"
        return s if width == 4 else f"{{{width - 4}'d0, {s}}}"
    return f"sw[{lo + width - 1}:{lo}]"


def gen_top(dag, dp, switch_inputs, fixed, obs):
    W = dp.width
    sw = state_width(dp)

    hdr = ["// Top level of the synthesized design (board independent).",
           "//   btn_step : each press advances the FSM by one state (clock enable)",
           "//   btn_rst  : back to IDLE",
           "//   inputs   : loaded from the switches when leaving IDLE"]
    for k, v in enumerate(switch_inputs):
        hdr.append(f"//     sw[{4 * k + 3}:{4 * k}]  -> {base_name(v)}")
    for v, val in fixed.items():
        hdr.append(f"//     {base_name(v)} = {val} (hardcoded)")
    hdr.append("//   sw[15:12] selects obs_val:")
    for i, (_, label) in enumerate(obs):
        hdr.append(f"//     {i:>2}: {label}")

    L = hdr + [
        "module hls_top #(parameter DEBOUNCE = 1_000_000) (",
        port_list(["input clk", "input btn_rst", "input btn_step", "input [15:0] sw",
                   "output reg [7:0] obs_val", "output [7:0] state", "output done"]),
        ");",
        f"    localparam W = {W};",
        "",
        "    // reset synchronizer and debounced step pulse",
        "    reg [1:0] rst_sync = 2'b11;",
        "    always @(posedge clk) rst_sync <= {rst_sync[0], btn_rst};",
        "    wire rst = rst_sync[1];",
        "    wire step;",
        "    step_pulse #(.DEBOUNCE(DEBOUNCE)) u_step (.clk(clk), .btn(btn_step), .pulse(step));",
        "",
        "    // primary inputs",
    ]
    for k, v in enumerate(switch_inputs):
        L.append(f"    wire [W-1:0] in_{base_name(v)} = {switch_slice(k, W)};")
    for v, val in fixed.items():
        L.append(f"    wire [W-1:0] in_{base_name(v)} = {W}'d{val};")

    L += ["", "    wire [W-1:0] " + ", ".join(
        [f"out_{base_name(v)}" for v in dp.output_regs] + [f"fu_{fu}_y" for fu in dp.fu_type]) + ";",
          f"    wire {rng(sw)}core_state;"]
    conns = [".clk(clk)", ".rst(rst)", ".en(step)", ".start(1'b1)"]
    conns += [f".in_{base_name(v)}(in_{base_name(v)})" for v in dag.inputs]
    conns += [f".out_{base_name(v)}(out_{base_name(v)})" for v in dp.output_regs]
    conns += [f".fu_{fu}_y(fu_{fu}_y)" for fu in dp.fu_type]
    conns += [".state(core_state)", ".done(done)"]
    L += ["    hls_core u_core (", port_list(conns, 8), "    );", ""]

    L.append("    assign state = core_state;")
    L += ["", "    // observability: which FU output / result is shown",
          "    always @(*)", "        case (sw[15:12])"]
    for i, (sig, label) in enumerate(obs):
        L.append(f"            4'd{i}: obs_val = {sig};   // {label}")
    L += ["            default: obs_val = 8'd0;", "        endcase", "endmodule", ""]
    return L


# --------------------------------------------------------------------------
# testbench.v
# --------------------------------------------------------------------------

def gen_testbench(dag, sched, dp, switch_inputs, fixed, obs, seed=551):
    W = dp.width
    sw = state_width(dp)
    mask = (1 << W) - 1
    lat = sched.latency
    rnd = random.Random(seed)

    vectors = [{v: 0 for v in dag.inputs}, {v: mask for v in dag.inputs},
               {v: (k + 1) & mask for k, v in enumerate(dag.inputs)}]
    vectors += [{v: rnd.randint(0, mask) for v in dag.inputs} for _ in range(17)]

    L = ["// Self-checking testbench, generated together with hls_core.v / hls_top.v.",
         "//   part 1: hls_core with en=1, one run per input vector, every output checked",
         "//   part 2: hls_top stepped with the button; state advance and the",
         "//           observability mux are checked",
         "module testbench;",
         f"    localparam W = {W};",
         f"    localparam LATENCY = {lat};",
         "    reg clk = 1'b0;",
         "    always #5 clk = ~clk;",
         "    integer errors = 0;",
         "",
         "    task check(input [8*40-1:0] what, input [31:0] got, input [31:0] expected);",
         "        if (got !== expected) begin",
         "            $display(\"FAIL %0s: got %0d, expected %0d\", what, got, expected);",
         "            errors = errors + 1;",
         "        end",
         "    endtask",
         "",
         "    // ---- device under test 1: hls_core",
         "    reg rst = 1'b1, en = 1'b1, start = 1'b0;"]
    L += [f"    reg  [W-1:0] in_{base_name(v)} = 0;" for v in dag.inputs]
    L += [f"    wire [W-1:0] out_{base_name(v)};" for v in dp.output_regs]
    L += [f"    wire {rng(sw)}state;", "    wire done;"]
    conns = [".clk(clk)", ".rst(rst)", ".en(en)", ".start(start)"]
    conns += [f".in_{base_name(v)}(in_{base_name(v)})" for v in dag.inputs]
    conns += [f".out_{base_name(v)}(out_{base_name(v)})" for v in dp.output_regs]
    conns += [f".fu_{fu}_y()" for fu in dp.fu_type]
    conns += [".state(state)", ".done(done)"]
    L += ["    hls_core dut (", port_list(conns, 8), "    );", ""]

    L += ["    // ---- device under test 2: hls_top (fast debounce for simulation)",
          "    reg t_rst = 1'b1, t_step = 1'b0;",
          "    reg [15:0] sw = 16'd0;",
          "    wire [7:0] obs_val, t_state;",
          "    wire t_done;",
          "    hls_top #(.DEBOUNCE(2)) top_dut (.clk(clk), .btn_rst(t_rst), .btn_step(t_step), .sw(sw),",
          "                                    .obs_val(obs_val), .state(t_state), .done(t_done));",
          "",
          "    task press;",
          "        begin",
          "            t_step = 1'b1; repeat (8) @(posedge clk); #1;",
          "            t_step = 1'b0; repeat (8) @(posedge clk); #1;",
          "        end",
          "    endtask",
          "",
          "    initial begin",
          "        #1;"]

    # part 1
    for k, vec in enumerate(vectors):
        exp = evaluate(dag, vec, W)
        desc = " ".join(f"{base_name(v)}={vec[v]}" for v in dag.inputs)
        L.append(f"        // vector {k}: {desc}")
        L.append("        " + " ".join(f"in_{base_name(v)} = {W}'d{vec[v]};" for v in dag.inputs))
        L += ["        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;",
              "        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded"]
        if lat > 1:
            L.append(f"        repeat ({lat - 1}) @(posedge clk); #1;")
        L += [f"        check(\"v{k}: done must be 0 in last step\", done, 0);",
              "        @(posedge clk); #1;",
              f"        check(\"v{k}: done after {lat + 1} cycles\", done, 1);"]
        for v in dp.output_regs:
            L.append(f"        check(\"v{k}: out_{base_name(v)}\", out_{base_name(v)}, {exp[v]});")
    L.append("")

    # part 2
    vec = dict(fixed)
    for k, v in enumerate(switch_inputs):
        vec[v] = (3 - k) & mask if (3 - k) > 0 else 1
    exp = evaluate(dag, vec, W)
    obs_index = {sig: i for i, (sig, _) in enumerate(obs)}
    L.append("        // ---- hls_top: " + " ".join(f"{base_name(v)}={vec[v]}" for v in dag.inputs))
    for k, v in enumerate(switch_inputs):
        L.append(f"        sw[{4 * k + 3}:{4 * k}] = 4'd{vec[v] & 15};")
    L += ["        repeat (4) @(posedge clk); #1 t_rst = 1'b0;",
          "        repeat (4) @(posedge clk); #1;",
          "        check(\"top: state after reset\", t_state, 0);",
          "        repeat (30) @(posedge clk); #1;",
          "        check(\"top: state holds without a press\", t_state, 0);"]
    for t in range(1, lat + 2):
        L += ["        press;", f"        check(\"top: state after press {t}\", t_state, {t});"]
        if t <= lat:
            for o in sched.ops_in_step(dag, t):
                sig = f"fu_{dp.binding[o.id]['fu']}_y"
                if sig in obs_index:
                    L += [f"        sw[15:12] = 4'd{obs_index[sig]}; #1;",
                          f"        check(\"top: S{t} {sig} ({o.dest})\", obs_val, {exp[o.dest] & 255});"]
    L.append("        check(\"top: done\", t_done, 1);")
    for v in dp.output_regs:
        sig = f"out_{base_name(v)}"
        if sig in obs_index:
            L += [f"        sw[15:12] = 4'd{obs_index[sig]}; #1;",
                  f"        check(\"top: observe {sig}\", obs_val, {exp[v] & 255});"]

    L += ["",
          "        if (errors == 0) $display(\"ALL TESTS PASSED\");",
          "        else $display(\"%0d FAILURES\", errors);",
          "        $finish;",
          "    end",
          "endmodule", ""]
    return L


# --------------------------------------------------------------------------
# entry point
# --------------------------------------------------------------------------

def generate_verilog(dag, sched, dp, outdir, hardcoded=None):
    """Write hls_core.v, hls_top.v and testbench.v. Returns a summary dict
    (files, switch map, hardcoded inputs, observability table, warnings)."""
    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    switch_inputs, fixed, obs, warnings = plan_io(dag, dp, hardcoded or {})

    files = {
        "hls_core.v": gen_controller(dag, sched, dp) + gen_core(dag, sched, dp),
        "hls_top.v": gen_top(dag, dp, switch_inputs, fixed, obs),
        "testbench.v": gen_testbench(dag, sched, dp, switch_inputs, fixed, obs),
    }
    written = []
    for name, lines in files.items():
        path = outdir / name
        with open(path, "w") as f:
            f.write("\n".join(lines))
        written.append(path)

    return {
        "files": written,
        "switches": [(f"sw[{4 * k + 3}:{4 * k}]", base_name(v)) for k, v in enumerate(switch_inputs)],
        "hardcoded": [(base_name(v), val) for v, val in fixed.items()],
        "obs": [(i, label) for i, (_, label) in enumerate(obs)],
        "warnings": warnings,
    }
