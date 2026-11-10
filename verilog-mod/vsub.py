import sys

x = sys.argv[1]

with open(f"verilog-mod/isub{x}.v", "w") as f:

    f.writelines("module add4 (\n")
    f.writelines("input ["+x+":0] inA,\n")
    f.writelines("input ["+x+":0] inB,\n")
    f.writelines("output ["+x+":0] outX,\n")
    f.writelines(");\n")
    f.writelines("\n")
    f.writelines("always @(*) begin\n")
    f.writelines("if (inA < inB) begin\n")
    f.writelines("outX = 4'b0000;\n")
    f.writelines("end else begin\n")
    f.writelines("outX = inA - inB;\n")
    f.writelines("end\n")
    f.writelines("end\n")
    f.writelines("\n")
    f.writelines("endmodule\n")
