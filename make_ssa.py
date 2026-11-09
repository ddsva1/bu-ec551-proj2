#imports
import sys
import re

#help functions
def form_ssa(equations):
    print(equations)

    version_counts = {}  # Tracks the current version number for each variable name
    var_map = {}         # Maps base variable name to its latest SSA version in scope
    ssa_equations = []   # Resulting SSA equations

    for eq in equations:
        # to ignore \n lines
        if "=" not in eq:
            continue

        #splits data into side that writes to memory and side that reads from memory
        lhs, rhs = map(str.strip, eq.split("="))
        
        # replace any variable usage with its latest SSA version
        
        # We tokenize by spaces/operators to find variable names
        tokens = re.split(r'([+\-*/()\s])', rhs)
        new_rhs_tokens = []
        
        for token in tokens:
            # check if token is variable name (alphanumeric starting with letter)
            if token.isidentifier() and not token.isdigit():
                # If the variable has a version, use it; otherwise initialize as _0
                if token in var_map:
                    new_rhs_tokens.append(var_map[token])
                else:
                    # Uninitialized variable reference gets version _0
                    var_map[token] = f"{token}_0"
                    version_counts[token] = 0
                    new_rhs_tokens.append(var_map[token])
            else:
                    new_rhs_tokens.append(token)
                    
        new_rhs = "".join(new_rhs_tokens)

        # 2. LHS: assign a new version number, bc this value is getting updated
        current_version = version_counts.get(lhs, -1) + 1
        version_counts[lhs] = current_version
        new_lhs = f"{lhs}_{current_version}"
        var_map[lhs] = new_lhs

        ssa_equations.append(f"{new_lhs}={new_rhs}")

    return [ssa_equations, var_map]


def get_file_equ(filename):
    print ("Getting equations from",filename)
    equs=[]
    print("Equations in file:")
    with open(filename, 'r') as file:
        for line in file:
            equs.append(line.replace("\n", "").replace(" ",""))
    print(equs)
    return equs
    


#the big called function
# python make_ssa.py FILENAME
def main():
    filename = sys.argv[1]
    equs = get_file_equ(filename)
    print("-----------------------------------------")
    ssa = form_ssa(equs)
    print(ssa)

main()