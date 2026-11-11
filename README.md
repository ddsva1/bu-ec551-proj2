# bu-ec551-proj2 — Hardware Synthesis Tool

EC551 Programming Assignment 2 (Fall 2026); a tool that:
1. Accepts a series of equations from a text file
2. Parses the equations
3. Creates an Intermediate Representation (IR) Directed Acyclic Graph (DAG)
4. Performs resource-constrained scheduling
5. Generates synthesized Verilog RTL (Datapath + Control FSM).

## Quick Start
```
python hls.py testdata/provided.txt
python hls.py testdata/provided.txt --schedule casap --adders 1 --muls 1
python hls.py testdata/provided.txt --schedule custom --latency 4 --export-ssa
python hls.py testdata/provided.txt --hardcode B=2 --fpga
```
## Input Format
Reads from a text file containing a series of equations, one equation per line.
Each equation consists of two arguments using either addition (+), multiplication (\*), or subtraction (-).
Accepts no more than 20 lines of equations. 
No results/partial results that evaluate to negative numbers.
Each argument and +-\* symbol in line separated by a space.

Example provided:
```
X = A + B 
Y = X + A 
Z = X - B 
Q = B * Z 
```

## Commands
```
python hls.py <input.txt> [options]
```

| Option | Description |
|---|---|
| `input` | Text file with one equation per line, e.g. `X = A + B` (required) |
| `-s`, `--schedule MODE` | Scheduling mode: `asap`, `alap`, `casap`, `calap`, `custom` (default: `asap`) |
| `--adders N` | Max adders (`casap`/`calap` only; unlimited if omitted) |
| `--subs N` | Max subtractors (`casap`/`calap` only; unlimited if omitted) |
| `--muls N` | Max multipliers (`casap`/`calap` only; unlimited if omitted) |
| `-l`, `--latency N` | Latency bound in control steps (`alap`/`custom` only; default: critical path) |
| `-w`, `--width N` | Datapath bit width (default: 4, matching the 4-bit switch fields) |
| `--hardcode NAME=VALUE` | Give input `NAME` a fixed value instead of a switch (repeatable) |
| `--export-ssa` | Also write the SSA equations to `output/<name>/<name>_ssa.txt` |
| `--project` | Also write `vivado/<name>/` with all sources and `create_project.tcl` |
| `--fpga` | Build the bitstream with Vivado and program the Nexys 4 DDR (`build/<name>.bit`) |
| `-h`, `--help` | Show usage and the list of scheduling modes |

Scheduling modes:

| Mode | Algorithm |
|---|---|
| `asap` | As Soon As Possible, unconstrained |
| `alap` | As Late As Possible, unconstrained, working back from the latency bound |
| `casap` | Resource-constrained ASAP (list scheduling, ASAP step as priority) |
| `calap` | Resource-constrained ALAP (reverse list scheduling, ALAP step as priority) |
| `custom` | Force-directed scheduling (Paulin & Knight): minimises functional units for a given latency bound |

Every run writes:
- `output/<name>/<name>_schedule.txt` (the schedule, plus `<name>_ssa.txt` with `--export-ssa`)
- `verilog-gen/<name>/hls_core.v`, `hls_top.v`, `testbench.v`

It also prints which switches drive which inputs, the hardcoded values, and the `sw[15:12]` observability table for the demo.


## Architecture
```
equations.txt
     │  make_ssa.py   get_file_equ, form_ssa
     ▼
SSA equations (X_0 = A_0 + B_0, ...)
     │  dag.py        parse_ssa, DAG
     ▼
DAG (ops = nodes, data dependencies = edges, inputs/outputs/constants)
     │  dag.py        run_scheduler (asap / alap / casap / calap / custom)
     ▼
Schedule (op -> control step, latency)
     │  datapath.py   build_datapath
     ▼
Datapath + controller (registers, FUs, muxes, control words per state)
     │  make_v.py     generate_verilog
     ▼
verilog-gen/<name>/  hls_core.v  hls_top.v  testbench.v
     │  fpga_project.py / fpga_build.py   (optional)
     ▼
vivado/<name>/ project  or  build/<name>.bit on the board
```

**1. Parsing + SSA (`make_ssa.py`).** Reads the equation file, strips whitespace, and renames every assignment to a new version (`X` → `X_0`, `X_1`, ...) so each value is written exactly once. `var_map` records the latest version of each variable, which later decides the design's outputs.

**2. DAG (`dag.py`).** Each SSA equation becomes an `Op` node (`add`, `sub` or `mul`). Edges connect the op that produces a value to the ops that read it. Values that are read but never written are primary inputs, integer operands are constants, and the final version of each assigned variable is an output. The DAG rejects values assigned twice or read before they are computed.

**3. Scheduling (`dag.py`).** Assigns each op a 1-based control step:
- `asap`/`alap` compute each op's earliest and latest time frame from its predecessors and successors.
- `casap`/`calap` are list schedulers. Each step fills up to the resource limit, in priority order, with ops whose dependencies are met. `calap` runs backwards from the outputs and is then flipped.
- `custom` (force-directed) builds a distribution graph of expected busy units per step and type, then repeatedly fixes the (op, step) pair with the lowest force until every op is placed.
The number of each FU type to build is the peak number of that type used in any one step.

**4. Datapath + sequencer (`datapath.py`).**
- *Register allocation*: computes each value's lifetime (birth step to last read; outputs live to the end), then shares registers with the left-edge algorithm.
- *FU binding*: assigns each op to a free unit of its type, picking the unit (and, for `+`/`*`, the operand order) that adds the fewest new mux inputs.
- *Mux generation*: collects the sources of every FU input port and every register input.
- *Controller*: one control word per FSM state, holding mux selects and register write enables. `IDLE` loads the inputs when `start` is high, `S1`–`SL` run the scheduled ops, and `DONE` raises `done`.

**5. Verilog generation (`make_v.py`).**
- `hls_core.v` contains `hls_controller` (the FSM) and `hls_core` (registers, input muxes, and instances of the hand-written `verilog-mod/` adder/subtractor/multiplier blocks).
- `hls_top.v` handles button stepping (a clock enable from `step_pulse`) and loads up to 3 inputs from `sw[3:0]`, `sw[7:4]` and `sw[11:8]`. Other inputs are hardcoded (`--hardcode`, default 1). `sw[15:12]` selects one of up to 16 observable values (FU outputs and design outputs).
- `testbench.v` is self-checking. A Python reference model (`evaluate`) computes the expected value of every SSA name at the datapath width and checks it against the simulation.

**6. FPGA (`fpga/`, `fpga_project.py`, `fpga_build.py`).** `fpga/top_nexys4ddr.v` is the board wrapper shared by every design:
- BTNC steps the FSM, CPU_RESETN resets it.
- The 7-segment display shows the selected index, the FSM state and the selected value.
- The LEDs mirror the input switches, and `led[15]` shows `done`.

`fpga_project.py` copies all sources into a self-contained `vivado/<name>/` folder with a `create_project.tcl`. `fpga_build.py` runs Vivado in batch mode with `fpga/build.tcl` to synthesise, implement, write the bitstream and program the board.

## Folder Structure

```
bu-ec551-proj2/
├── EC551_Program2_Rev2.pdf   Project specifications document by Prof Densmore
├── DEMO/                     Contains files used for/during demo
│   ├── 30-MINUTE-DEMO-PLAN   Required submission document describing what we plan to show
│   └── scans.pdf             Scanned copies of prepped hand-drawn diagrams (proof of correctness)
├── hls.py                    High-level main function, calls all others
├── make_ssa.py               parses equations text file, converts to SSA format, optionally creates SSA output
├── dag.py                    Creates DAG from SSA equations, runs the schedulers
├── datapath.py               Creates Datapath (registers, FU binding, muxes) and FSM control words from DAG + schedule
├── make_v.py                 Generates the Verilog files in verilog-gen/<name>/
├── fpga_project.py           Creates a self-contained Vivado project folder in vivado/<name>/
├── fpga_build.py             Builds the bitstream with Vivado (batch mode) and programs the board
├── verilog-gen/              Program-generated output files
│   └── <name>/               One folder per input file, used to demonstrate and test outputs
│       ├── hls_core.v        FSM (sequencer) driving mux selects and register write enables. Registers at the cycle boundaries, input muxes, and exactly the number of adders/subtractors/multipliers the schedule needs
│       ├── hls_top.v         top level - button stepping (clock enable), inputs from switches or hardcoded, and the observability mux (which output is shown)
│       └── testbench.v       self-checking simulation of hls_core and hls_top
├── verilog-mod/
│   ├── adder.v               basic verilog block adder
│   ├── multiplier.v          basic verilog block multiplier
│   ├── step_pulse.v          basic verilog block step-pulse (for clock step-through)
│   └── subtractor.v          basic verilog block subtractor
├── fpga/                     hand-written board files (same for every design)
│   ├── top_nexys4ddr.v       wrapper module "top", Digilent Nexys 4 DDR
│   ├── sevenseg.v            7-segment display driver
│   ├── Nexys4DDR_Master.xdc  pin constraints, Digilent Nexys 4 DDR
│   └── build.tcl             Vivado batch script used by fpga_build.py
├── vivado/<name>/            Generated Vivado project folders (--project / fpga_project.py)
├── build/                    Generated bitstreams and Vivado logs (--fpga, not committed)
├── testdata/                 example input files (.txt)
├── xtestdata/                malformed input files for error-handling tests
└── output/<name>/            generated .txt files: schedule, and SSA equations with --export-ssa
```

## Running on the FPGA
*Code reused/adapted from https://github.com/ddsva1/bu-ec551-proj1*
**Option A: automatic build (Vivado installed locally)**
```
python hls.py testdata/provided.txt --fpga
```
This generates the Verilog, runs synthesis, implementation and bitstream generation in Vivado batch mode, and programs the connected board. The bitstream and log are copied to `build/`. If Vivado is not at `C:\AMDDesignTools\2025.2\Vivado\bin\vivado.bat`, edit `VIVADO` at the top of `fpga_build.py`.

**Option B: open the project in Vivado**
1. Generate the Verilog and the project folder:
   `python hls.py testdata/provided.txt --project`
   (or `python fpga_project.py provided` for a design already in `verilog-gen/provided/`).
2. In Vivado: **Tools → Run Tcl Script...** → `vivado/provided/create_project.tcl`.
   This creates the project for the Nexys 4 DDR part `xc7a100tcsg324-1` with every source already added.
3. Generate Bitstream → Open Hardware Manager → Program Device.

**Option C: manual project**
1. Generate the Verilog: `python hls.py testdata/provided.txt`.
2. In Vivado: **Create Project → RTL Project**, then choose the Nexys 4 DDR part:
   `xc7a100tcsg324-1`.
3. Add design sources: `verilog-gen/<name>/hls_core.v`, `verilog-gen/<name>/hls_top.v`, all of `verilog-mod/*.v`, and the board files
   `fpga/top_nexys4ddr.v` and `fpga/sevenseg.v`.
4. Add the constraints: `fpga/Nexys4DDR_Master.xdc`.
5. Generate Bitstream → Open Hardware Manager → Program Device.

## Testing

| Case Tested | Command |
|---|---|
|Provided Case|provided.txt|
|Small Cases|1.txt, 2.txt|
|Maximal Cases|3.txt, 4.txt, 5.txt|
|Block-Test Cases|6.txt, 7.txt, 8.txt|
|Good example of scheduling|9.txt|
|Error Handling Case|x1.txt, 4.txt|


## AI Usage
[TO COMPLETE]

- No AI used for make_ssa.py seed code
- No AI used for make_v.py seed code
- No AI used for test input data creation
- No AI used for README file's summary, input format, folder structure diagram, testing, AI usage.

- AI used for fpga folder
- AI used to refactor code, including seed code from above
