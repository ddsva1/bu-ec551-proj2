import sys

x = sys.argv[1]

with open(f"verilog-mod/imult{x}.v", "w") as f:

    f.writelines("module add4 (\n")
    f.writelines("input ["+x+":0] inA,\n")
    f.writelines("input ["+x+":0] inB,\n")
    f.writelines("output ["+x+":0] outX,\n")
    f.writelines(");\n")
    f.writelines("\n")
    f.writelines("assign outX = inA * inB;\n")
    f.writelines("\n")
    f.writelines("endmodule\n")
