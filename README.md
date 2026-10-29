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
[TO DO]

## Testing
[TO DO]

### Testdata Usage
[TO DO]

## AI Usage
[TO DO]