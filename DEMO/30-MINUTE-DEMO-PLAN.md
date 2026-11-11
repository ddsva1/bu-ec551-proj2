## Demo Prep:
- Make 9.txt ASAP and ALAP scheduling diagrams

## Pre-Demo Setup:
- **Dill Computer:** showing README
- **Alex Computer:** Demo Plan
- **PC:** Code open + Vivado open + 9.txt (ASAP version) files loaded in and run

## Start Demo.
### 0-1:
- Introduce ourselves
- Show him project loaded onto FPGA
- Tell him which switches correspond to which lights

### 1-7:
- Basic description of how program works
    - **Dill Computer:** Architecture open on README
    - Walk through path of operations: (1 per minute)
        - text file input
        - main
        - make_ssa
        - dag.py
        - datapath.py
        - make_v
        - fpga linkage

### 8-15:
- Pause for questions, explain portions of code further

### 15-18:
- Walk through tests in basic detail (pause and demonstrate if interested, just on computer)
    - **provided:** his example
    - **1-2:** basic examples
    - **3-5:** mean examples - maximum requirements
    - **6-8:** basic verilog block testing
    - **9 onwards:** less basic examples
- While talking, Alex load up 9.txt but the ALAP variant - demonstrate visible difference.
- While talking, Dill find handdrawn proof of correctness.

### 19-28:
- Enter and run his three Live Examples

### 29-30:
- Answer questions on how we worked as a team, who did what, etc etc etc.
