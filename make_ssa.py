#imports
import sys
import re
from pathlib import Path


#input format checking
# every non-blank line must be:  NAME = OPERAND OP OPERAND
#   NAME     variable: a letter or _ followed by letters, digits, _
#   OPERAND  variable or non-negative integer constant
#   OP       + - *
OPERAND = r"(?:[A-Za-z_]\w*|\d+)"
EQUATION = re.compile(r"^\s*[A-Za-z_]\w*\s*=\s*" + OPERAND + r"\s*[+\-*]\s*" + OPERAND + r"\s*$", re.ASCII)


class SSAFormatError(ValueError):
    """An input line is not a valid 'X = A op B' equation."""


def check_equation(line, line_no):
    """Raise SSAFormatError if a non-blank line is not 'NAME = OPERAND OP OPERAND'."""
    if line.strip() == "":
        return
    if not EQUATION.match(line):
        raise SSAFormatError(f"line {line_no}: '{line.strip()}' is not a valid equation; "
                             f"expected 'X = A op B' with op one of + - * "
                             f"(operands are variable names or non-negative integers)")


#help functions

def get_file_equ(filename):
    print ("Getting equations from",filename)
    equs=[]
    print("Equations in file:")
    with open(filename, 'r') as file:
        for line_no, line in enumerate(file, start=1):
            print(line.replace("\n", ""))
            # check the raw line, before spaces are removed, so 'X = A B + C' is caught
            check_equation(line, line_no)
            equs.append(line.replace("\n", "").replace(" ",""))
    print("Parsed Equations:",equs)
    return equs

def form_ssa(equations):
    print("Turning Equations into SSA Format")

    version_counts = {}  # Tracks the current version number for each variable name
    var_map = {}         # Maps base variable name to its latest SSA version in scope
    ssa_equations = []   # Resulting SSA equations

    for line_no, eq in enumerate(equations, start=1):
        # to ignore blank lines
        if eq.strip() == "":
            continue
        # also checked here so form_ssa never emits a malformed SSA equation,
        # even when called without get_file_equ
        check_equation(eq, line_no)

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
                    
        new_rhs = " ".join(new_rhs_tokens)

        # 2. LHS: assign a new version number, bc this value is getting updated
        current_version = version_counts.get(lhs, -1) + 1
        version_counts[lhs] = current_version
        new_lhs = f"{lhs}_{current_version}"
        var_map[lhs] = new_lhs

        ssa_equations.append(f"{new_lhs} = {new_rhs}")
    print("SSA version:",ssa_equations)
    return [ssa_equations, var_map]

def ssa_file(equations,filename):
    print("Outputting file with SSA-formatted Equations")
    print("File Location: output/"+filename)
    print(equations)

    folder_path = Path("output")
    file_path = folder_path / filename[9:]
    with open(file_path, "w") as f:
        for item in equations:
            f.write(item+"\n")


#the big called function
# python make_ssa.py FILENAME
def main():
    filename = sys.argv[1]
    equs = get_file_equ(filename)
    print("-----------------------------------------")
    ssa = form_ssa(equs)
    print("-----------------------------------------")
    if "-mf" in sys.argv:
        ssa_file(ssa[0], filename)
    else:
        print("No -mf tag, not making SSA output file")
    print("-----------------------------------------")

if __name__ == "__main__":
    main()