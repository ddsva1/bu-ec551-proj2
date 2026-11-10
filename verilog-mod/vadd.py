import sys

x = sys.argv[1]

with open(f"verilog-mod/ivadd{x}.v", "w") as f:

    f.writelines("module add4 (\n")
    f.writelines("input ["+x+":0] inA,\n")
    f.writelines("input ["+x+":0] inB,\n")
    f.writelines("input cin,\n")
    f.writelines("output ["+x+":0] outX,\n")
    f.writelines("output cout\n")
    f.writelines(");\n")
    f.writelines("\n")
    f.writelines("assign {cout, sum} = inA + inB + cin;\n")
    f.writelines("\n")
    f.writelines("endmodule\n")
