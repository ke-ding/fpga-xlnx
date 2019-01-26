# Vivado Launch Script
set impl_const "qg.xdc"
set device xc7z100ffg900-2 
set design_top qg_v3_eval
set proj_dir ../build/${design_top}_design

create_project -name ${design_top} -force -dir "${proj_dir}" -part ${device}

# Project Settings

set_property top ${design_top} [current_fileset]

add_files -fileset constrs_1 -norecurse ./${impl_const}
set_property used_in_synthesis true [get_files ./${impl_const}]

# Source the block diagram TCL
source bd.tcl
# Create wrapper file for BD
#
make_wrapper \
	-files [get_files ${proj_dir}/${design_top}.srcs/sources_1/bd/QG_pl_eth/QG_pl_eth.bd] \
	-top

# Add wrapper file to project to complete design hierarchy
import_files -force -norecurse ${proj_dir}/${design_top}.srcs/sources_1/bd/QG_pl_eth/hdl/QG_pl_eth_wrapper.v

# Top level HDL instantiating clocking components
set_property top ${design_top} [current_fileset]
update_compile_order -fileset sources_1

regenerate_bd_layout
validate_bd_design
save_bd_design
close_bd_design QG_pl_eth 

open_bd_design \
	${proj_dir}/${design_top}.srcs/sources_1/bd/QG_pl_eth/QG_pl_eth.bd

