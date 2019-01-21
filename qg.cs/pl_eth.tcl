# Vivado Launch Script
set impl_const pl_eth_gmii.xdc
set device xc7z020clg484-2 
set design_top pl_eth_gmii
set proj_dir ../build/pl_eth_design
#set ui_name bd_ce610cd7.ui 

create_project -name ${design_top} -force -dir "${proj_dir}" -part ${device}

# Project Settings

set_property top ${design_top} [current_fileset]

add_files -fileset constrs_1 -norecurse ./${impl_const}
set_property used_in_synthesis true [get_files ./${impl_const}]

# Source the block diagram TCL
source pl_eth_bd.tcl
# Create wrapper file for BD
#
make_wrapper -files [get_files ${proj_dir}/${design_top}.srcs/sources_1/bd/design_pl_eth/design_pl_eth.bd] -top
# Add wrapper file to project to complete design hierarchy
import_files -force -norecurse ./design_pl_eth_wrapper.v

# Top level HDL instantiating clocking components
#add_files -norecurse -force hdl/${design_top}.v
set_property top ${design_top} [current_fileset]
update_compile_order -fileset sources_1

set_property verilog_define { {GMII=1} } [get_filesets sources_1]

regenerate_bd_layout
validate_bd_design
save_bd_design
close_bd_design design_pl_eth 

#file mkdir ../../runs_pl_eth/pl_eth_sfp.srcs/sources_1/bd/design_pl_eth/ui
# apply UI file
#file copy -force ${ui_name} ../../runs_pl_eth/pl_eth_sfp.srcs/sources_1/bd/design_pl_eth/ui/${ui_name}

open_bd_design ${proj_dir}/${design_top}.srcs/sources_1/bd/design_pl_eth/design_pl_eth.bd

#Setting Sythesis options
set_property flow {Vivado Synthesis 2018} [get_runs synth_1]

#Setting Implementation options
set_property flow {Vivado Implementation 2018} [get_runs impl_1]
