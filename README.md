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
Each equation consists of two arguments using either addition (+), multiplication (*), or subtraction (-).
Accepts no more than 20 lines of equations. 
No results/partial results that evaluate to negative numbers.
Each argument and +-* symbol in line separated by a space.

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
[TO DO]

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

### Testdata Usage
[TO DO]

## AI Usage
[TO DO]