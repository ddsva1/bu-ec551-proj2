# Creates and opens the Vivado project for design "provided" on the Nexys 4 DDR.
#   Tools -> Run Tcl Script... -> select this file
#   (or in the Tcl Console:  source <path to this file>)
# Then: Generate Bitstream -> Open Hardware Manager -> Program Device.
# Run Simulation -> Run Behavioral Simulation runs testbench.v.

set here [file dirname [file normalize [info script]]]

# Vivado cannot write its project cache inside a OneDrive-synced folder, so in
# that case the project goes to <home>/vivado_projects/ (sources stay here).
set proj_dir $here/project
if {[string match -nocase "*OneDrive*" $here]} {
    set proj_dir [file join [file normalize ~] vivado_projects provided_nexys]
    puts "NOTE: this folder is in OneDrive; creating the project in $proj_dir"
}
create_project provided_nexys $proj_dir -part xc7a100tcsg324-1 -force

# design sources (FU blocks, generated hls_core / hls_top, board wrapper)
# [list ...] keeps paths with spaces (e.g. "EC 551") in one piece
add_files -norecurse [list $here/adder.v $here/multiplier.v $here/step_pulse.v $here/subtractor.v $here/hls_core.v $here/hls_top.v $here/top_nexys4ddr.v $here/sevenseg.v]
set_property top top [current_fileset]

# pin constraints
add_files -fileset constrs_1 -norecurse [list $here/Nexys4DDR_Master.xdc]

# simulation: the generated self-checking testbench
add_files -fileset sim_1 -norecurse [list $here/testbench.v]
set_property top testbench [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
