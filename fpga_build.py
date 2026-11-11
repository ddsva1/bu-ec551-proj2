"""
Part 7 -- build the bitstream and program the Nexys 4 DDR.
Adapted from fpga_build.py in bu-ec551-proj1.

Called by `python hls.py <file> --fpga` after the Verilog has been generated:
    1. copy the files Vivado needs into a work folder
         verilog-mod/*.v                FU blocks + step_pulse
         verilog-gen/<name>/hls_core.v  generated design
         verilog-gen/<name>/hls_top.v
         fpga/top_nexys4ddr.v, fpga/sevenseg.v, fpga/Nexys4DDR_Master.xdc, fpga/build.tcl
    2. run Vivado in batch mode with fpga/build.tcl: synthesis, implementation,
       bitstream, then program the connected board
    3. copy the bitstream and Vivado's log to build/
"""

import shutil
import subprocess
import tempfile
from pathlib import Path

from dag import HLSError

VIVADO = Path(r"C:\AMDDesignTools\2025.2\Vivado\bin\vivado.bat")
PART = "xc7a100tcsg324-1"
WORK_DIR = Path(tempfile.gettempdir()) / "ec551_proj2_fpga_build"
XDC = Path("fpga/Nexys4DDR_Master.xdc")
BOARD_FILES = [Path("fpga/top_nexys4ddr.v"), Path("fpga/sevenseg.v")]


def build_and_program(stem, verilog_dir):
    if not VIVADO.exists():
        raise HLSError(f"Vivado not found at {VIVADO}; edit VIVADO at the top of fpga_build.py")

    sources = sorted(Path("verilog-mod").glob("*.v"))
    sources += [Path(verilog_dir) / "hls_core.v", Path(verilog_dir) / "hls_top.v"]
    sources += BOARD_FILES

    shutil.rmtree(WORK_DIR, ignore_errors=True)
    WORK_DIR.mkdir(parents=True)
    for f in sources + [XDC, Path("fpga/build.tcl")]:
        shutil.copy(f, WORK_DIR)

    bitfile = f"{stem}.bit"
    command = [str(VIVADO), "-mode", "batch", "-nojournal", "-log", "vivado.log",
               "-source", "build.tcl", "-tclargs", PART, bitfile, XDC.name]
    command += [f.name for f in sources]
    result = subprocess.run(command, cwd=WORK_DIR)

    Path("build").mkdir(exist_ok=True)
    for name in (bitfile, "vivado.log"):
        if (WORK_DIR / name).exists():
            shutil.copy(WORK_DIR / name, Path("build") / name)
    if result.returncode != 0:
        if (WORK_DIR / bitfile).exists():
            raise HLSError(f"build/{bitfile} was built, but programming the board failed "
                           f"(see the message above)")
        raise HLSError("Vivado stopped with an error; see build/vivado.log")
    print(f"Done: build/{bitfile} is on the board")
