# bu-ec551-proj2 — Hardware Synthesis Tool

EC551 Programming Assignment 2 (Fall 2026); a tool that:
1. Accepts a series of equations from a text file
2. Parses the equations
3. Creates an Intermediate Representation (IR) Directed Acyclic Graph (DAG)
4. Performs resource-constrained scheduling
5. Generates synthesized Verilog RTL (Datapath + Control FSM).

## Quick Start
[TO DO]

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
```
py make_ssa.py <testdata/filename.txt> #converts provided equations to SSA format
py make_ssa.py <testdata/filename.txt> -mf #same as above, additionally creates file with resulting SSA equations

py dag.py [TO DO; need to populate and comment] #COMMENT TO DO

py vadd.py <number larger than 0, using numeric values> #creates verilog adder for <number>-wide inputs
py vsub.py <number larger than 0, using numeric values> #creates verilog subtracter for <number>-wide inputs
py vmult.py <number larger than 0, using numeric values> #creates verilog multiplier for <number>-wide inputs
```

## Architecture
[TO DO]

## Folder Structure
[TO COMPLETE]

```
bu-ec551-proj2/
├── EC551_Program2_Rev2.pdf project specifications document by Prof Densmore
├── make_ssa.py             parses equations text file, converts to SSA format, optionally creates SSA output
├── dag.py                  [TO DESCRIBE]
├── verilog_gen/            basic block Verilog generation files (v*.py), default verilog block files (v*.v), program-created verilog files (iv*.v)
├── fpga/                   hand-written board files (same for every design)
│   ├── top_nexys4ddr.v     wrapper module "top", Digilent Nexys 4 DDR
│   └── nexys4ddr.xdc       pin constraints, Digilent Nexys 4 DDR
├── testdata/               example input files (.txt)
└── output/                 generated .txt files of intermediate SSA equations.
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
[TO DO]
[TO DO ALSO: Add test 20 lines long, 1 line long, max variables, min variables]

| Case Tested | Command |
|---|---|
|Provided Case|provided.txt|
|Minimal Cases|1.txt, 2.txt|
|Maximal Cases|3.txt, 4.txt, 5.txt|
|Error Handling Cases|x1.txt|


## AI Usage
[TO COMPLETE]

- No AI used for make_ssa.py
- No AI used for test input data creation
- No AI used for verilog-gen folder
- No AI used for README file

- AI used for fpga folder (code adapted from project 1)