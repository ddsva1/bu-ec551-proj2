import sys
from pathlib import Path

#not actually used
def get_file_ssa(filename):
    print ("Getting SSA equations made from",filename)
    equs=[]
    print("Equations in file:")
    with open(filename, 'r') as file:
        for line in file:
            print(line.replace("\n", ""))
            equs.append(line.replace("\n", "").replace(" ",""))
    return equs


def get_inputs(ssa):
    print("Making Verilog File: Inputs")
    inputs = []
    for item in ssa[1]:
        inputs.append(str(item)+"_0")
    print("Initial Inputs:",inputs)
    return inputs

def get_outputs(ssa):
    print("Making Verilog File: Outputs")
    lhs = []
    for item in ssa[0]:
        lhs.append(item.split(" ")[0])
    print("Variables on lhs of equations:",lhs)

    finaldict = []
    for value in ssa[1]:
        finaldict.append(ssa[1][value])
    print("Final iterations of variables:", finaldict)

    both = []
    for item in lhs:
        if item in finaldict:
            both.append(item)
    print("both (meaning variable is output from block):", both)

    return both
        
def get_temps(ssa, inputs, outputs):
    print("Making Verilog File: Internal Connections")
    temps = []
    print(ssa[0])
    print(ssa[1])
    return temps

def make_v (ssa):
    filename = sys.argv[1]
    modulename = "ssa"+sys.argv[2]
    #get_file_ssa(filename)
    inputs = get_inputs(ssa)
    print("-----------------------------------------")
    outputs = get_outputs(ssa)
    print("-----------------------------------------")
    temps = get_temps(ssa, inputs, outputs)
    print("-----------------------------------------")
    print("Making Verilog file: Syntax")
    x=str(filename[9:-4])
    with open(f"verilog-gen/main{x}.v", "w") as f:

        f.writelines("module "+modulename+" (\n")

        f.writelines("input "+inputs[0])#add input variable names
        count = 1
        while count<len(inputs):
            f.writelines(",\ninput "+inputs[count])
            count=count+1

        f.writelines("\n")

        f.writelines("output reg "+outputs[0])#add output variable names
        count = 1
        while count<len(outputs):
            f.writelines(",\noutput reg "+outputs[count])
            count=count+1

        f.writelines("\n);\n")
        f.writelines("\n")#add temp variable names
        f.writelines("\n")
        f.writelines("\n")#instantiate module for each element in ssa[0]
        f.writelines("\n")
        f.writelines("endmodule\n")
    print("-----------------------------------------")
