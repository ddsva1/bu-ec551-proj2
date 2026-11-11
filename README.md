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
[TO DO]

## Architecture
[TO DO]

## Folder Structure

```
bu-ec551-proj2/
├── EC551_Program2_Rev2.pdf   Project specifications document by Prof Densmore
├── DEMO                      Contains files used for/during demo
│   ├── 30-MINUTE-DEMO-PLAN   Required submission document describing what we plan to show
│   └── scans.pdf             Scanned copies of prepped hand-drawn diagrams (proof of correctness)
├── hls.py                    High-level main function, calls all others
├── make_ssa.py               parses equations text file, converts to SSA format, optionally creates SSA output
├── dag.py                    Creates DAG from SSA equations
├── datapath.py               Creates Datapath using DAG, SSA
├── verilog_gen/              Program-generated output files
│   └── verilog outputs       Folders containing verilog output files used to demonstrate and test outputs
│       ├── hls_core.v        FSM (sequencer) driving mux selects and register write enables. Registers at the cycle boundaries, input muxes, and exactly the number of adders/subtractors/multipliers the schedule needs
│       ├── hls_top.v         top level - button stepping (clock enable), inputs from switches or hardcoded, and the observability mux (which output is shown)
│       └── testbench.v       self-checking simulation of hls_core and hls_top
├── verilog_mod/
│   ├── adder.v               basic verilog block adder
│   ├── multiplier.v          basic verilog block multiplier
│   ├── step_pulse.v          basic verilog block step-pulse (for clock step-through)
│   └── subtractor.v          basic verilog block subtractor
├── fpga/                     hand-written board files (same for every design)
│   ├── top_nexys4ddr.v       wrapper module "top", Digilent Nexys 4 DDR
│   └── nexys4ddr.xdc         pin constraints, Digilent Nexys 4 DDR
├── testdata/                 example input files (.txt)
└── output/                   generated .txt files of intermediate SSA equations.
```

## Running on the FPGA
*Code reused/adapted from https://github.com/ddsva1/bu-ec551-proj1*
1. Generate the Verilog: [TO DO]
2. In Vivado: **Create Project → RTL Project**, then choose the Nexys 4 DDR part:
   `xc7a100tcsg324-1`.
3. Add design source: [TO DO] and the board
   wrapper `fpga/top_nexys4ddr.v`.
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
