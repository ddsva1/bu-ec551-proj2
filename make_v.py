import sys
from pathlib import Path

def get_file_ssa(filename):
    print ("Getting SSA equations made from",filename)
    equs=[]
    print("Equations in file:")
    with open(filename, 'r') as file:
        for line in file:
            print(line.replace("\n", ""))
            equs.append(line.replace("\n", "").replace(" ",""))
    return equs


def make_v (ssa):
    filename = sys.argv[1]
    modulename = "ssa"+sys.argv[2]
    #get_file_ssa(filename)
    print(ssa[0])
    print(ssa[1])
    x=str(filename[9:-4])
    with open(f"verilog-gen/main{x}.v", "w") as f:

        f.writelines("module "+modulename+" (\n")
        f.writelines("\n")#add input variable names
        f.writelines("\n")#add output variable names
        f.writelines(");\n")
        f.writelines("\n")#add temp variable names
        f.writelines("\n")
        f.writelines("\n")#instantiate module for each element in ssa[0]
        f.writelines("\n")
        f.writelines("endmodule\n")
