
################################################################
# This is a generated script based on design: design_pl_eth
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_pl_eth_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_pl_eth

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_ethernet:7.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: RESET_BLOCK
proc create_hier_cell_RESET_BLOCK { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_RESET_BLOCK() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst ic_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst ic_aresetn1
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir I -type clk slowest_sync_clk1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RST_WIDTH {1} \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $proc_sys_reset_0

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RST_WIDTH {1} \
   CONFIG.C_EXT_RST_WIDTH {1} \
 ] $proc_sys_reset_1

  # Create port connections
  connect_bd_net -net RESET_ic_aresetn [get_bd_pins ic_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net RESET_ic_aresetn1 [get_bd_pins ic_aresetn1] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins slowest_sync_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins slowest_sync_clk1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net processing_system7_FCLK_RESET0_N [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set PSGE0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 PSGE0 ]
  set PSMDIO0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 PSMDIO0 ]
  set gmii1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii1 ]
  set gmii2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii2 ]
  set mdio1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio1 ]
  set mdio2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio2 ]

  # Create ports
  set PSGE0_RX_CLK [ create_bd_port -dir I -type clk PSGE0_RX_CLK ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {cnt_clr:clr25} \
   CONFIG.FREQ_HZ {125000000} \
 ] $PSGE0_RX_CLK
  set PSGE0_TX_CLK [ create_bd_port -dir I -type clk PSGE0_TX_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $PSGE0_TX_CLK
  set PSGE0_TX_CLK_PHY [ create_bd_port -dir I -type clk PSGE0_TX_CLK_PHY ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {25000000} \
 ] $PSGE0_TX_CLK_PHY
  set PSGE0_gtxclk [ create_bd_port -dir O -type clk PSGE0_gtxclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $PSGE0_gtxclk
  set cnt25 [ create_bd_port -dir O -from 15 -to 0 -type data cnt25 ]
  set cnt125 [ create_bd_port -dir O -from 15 -to 0 -type data cnt125 ]
  set cnt_clr [ create_bd_port -dir I -type rst cnt_clr ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $cnt_clr
  set phy_rst_n1 [ create_bd_port -dir O -from 0 -to 0 -type rst phy_rst_n1 ]
  set phy_rst_n2 [ create_bd_port -dir O -from 0 -to 0 -type rst phy_rst_n2 ]
  set ref_clk [ create_bd_port -dir O -type clk ref_clk ]
  set resetn [ create_bd_port -dir O -from 0 -to 0 -type rst resetn ]

  # Create instance: RESET_BLOCK
  create_hier_cell_RESET_BLOCK [current_bd_instance .] RESET_BLOCK

  # Create instance: axi_dma1, and set properties
  set axi_dma1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma1 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_use_stsapp_length {1} \
 ] $axi_dma1

  # Create instance: axi_dma2, and set properties
  set axi_dma2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma2 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_use_stsapp_length {1} \
 ] $axi_dma2

  # Create instance: axi_ethernet1, and set properties
  set axi_ethernet1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet1 ]
  set_property -dict [ list \
   CONFIG.PHY_TYPE {GMII} \
   CONFIG.RXCSUM {Full} \
   CONFIG.RXMEM {16k} \
   CONFIG.SupportLevel {0} \
   CONFIG.TXCSUM {Full} \
   CONFIG.TXMEM {16k} \
 ] $axi_ethernet1

  set_property -dict [ list \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.ADDR_WIDTH {18} \
 ] [get_bd_intf_pins /axi_ethernet1/s_axi]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet1/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet1/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet1/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet1/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet1/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet1/gtx_clk]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet1/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet1/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet1/phy_rst_n]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet1/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet1/s_axi_lite_resetn]

  # Create instance: axi_ethernet2, and set properties
  set axi_ethernet2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet2 ]
  set_property -dict [ list \
   CONFIG.PHY_TYPE {GMII} \
   CONFIG.RXCSUM {Full} \
   CONFIG.RXMEM {16k} \
   CONFIG.SupportLevel {0} \
   CONFIG.TXCSUM {Full} \
   CONFIG.TXMEM {16k} \
 ] $axi_ethernet2

  set_property -dict [ list \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.ADDR_WIDTH {18} \
 ] [get_bd_intf_pins /axi_ethernet2/s_axi]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet2/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet2/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet2/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet2/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet2/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet2/gtx_clk]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet2/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet2/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet2/phy_rst_n]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet2/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet2/s_axi_lite_resetn]

  # Create instance: axi_ic_GP, and set properties
  set axi_ic_GP [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_GP ]
  set_property -dict [ list \
   CONFIG.NUM_MI {6} \
 ] $axi_ic_GP

  # Create instance: axi_ic_HP1, and set properties
  set axi_ic_HP1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_HP1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {3} \
   CONFIG.STRATEGY {2} \
 ] $axi_ic_HP1

  # Create instance: axi_ic_HP2, and set properties
  set axi_ic_HP2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_HP2 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {3} \
   CONFIG.STRATEGY {2} \
 ] $axi_ic_HP2

  # Create instance: clk_wiz0, and set properties
  set clk_wiz0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.PRIM_IN_FREQ {200} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz0

  # Create instance: clk_wiz1, and set properties
  set clk_wiz1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz1 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.PRIM_IN_FREQ {200} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz1

  # Create instance: clk_wiz2, and set properties
  set clk_wiz2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz2 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.PRIM_IN_FREQ {200} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz2

  # Create instance: cnt125M, and set properties
  set cnt125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 cnt125M ]
  set_property -dict [ list \
   CONFIG.SCLR {true} \
 ] $cnt125M

  # Create instance: cnt25M, and set properties
  set cnt25M [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 cnt25M ]
  set_property -dict [ list \
   CONFIG.SCLR {true} \
 ] $cnt25M

  # Create instance: concat_intr, and set properties
  set concat_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_intr ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $concat_intr

  # Create instance: processing_system7, and set properties
  set processing_system7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {128.571426} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {75.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {128571426} \
   CONFIG.PCW_CLK1_FREQ {75000000} \
   CONFIG.PCW_CLK2_FREQ {200000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_ENET0_ENET0_IO {EMIO} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {EMIO} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 22} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_EMIO_ENET0 {1} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SMC {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {14} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {4} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {3} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {75} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {54} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1800.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_0_DIRECTION {out} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {inout} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {inout} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {in} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {inout} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {inout} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {inout} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {out} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {inout} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {inout} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {inout} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {inout} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {inout} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {inout} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {out} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {inout} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {inout} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {inout} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {out} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {inout} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {inout} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {inout} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {NAND Flash#GPIO#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#GPIO#GPIO#GPIO#UART 0#UART 0#GPIO#GPIO#ENET Reset#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#GPIO#UART 1#UART 1#GPIO#GPIO#GPIO#GPIO} \
   CONFIG.PCW_MIO_TREE_SIGNALS {cs#gpio[1]#ale#we_b#data[2]#data[0]#data[1]#cle#re_b#data[4]#data[5]#data[6]#data[7]#data[3]#busy#gpio[15]#gpio[16]#gpio[17]#rx#tx#gpio[20]#gpio[21]#reset#gpio[23]#gpio[24]#gpio[25]#gpio[26]#gpio[27]#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#clk#cmd#data[0]#data[1]#data[2]#data[3]#gpio[46]#gpio[47]#tx#rx#gpio[50]#gpio[51]#gpio[52]#gpio[53]} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_NAND_IO {MIO 0 2.. 14} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {9} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 18 .. 19} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {2048 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-187E} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {50.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {37.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {50.625} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
 ] $processing_system7

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma1_m_axi_mm2s [get_bd_intf_pins axi_dma1/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP1/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma1_m_axi_s2mm [get_bd_intf_pins axi_dma1/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP1/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma1_m_axi_sg [get_bd_intf_pins axi_dma1/M_AXI_SG] [get_bd_intf_pins axi_ic_HP1/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma1_m_axis_cntrl [get_bd_intf_pins axi_dma1/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet1/s_axis_txc]
  connect_bd_intf_net -intf_net axi_dma1_m_axis_mm2s [get_bd_intf_pins axi_dma1/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet1/s_axis_txd]
  connect_bd_intf_net -intf_net axi_dma2_m_axi_mm2s [get_bd_intf_pins axi_dma2/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP2/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma2_m_axi_s2mm [get_bd_intf_pins axi_dma2/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP2/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma2_m_axi_sg [get_bd_intf_pins axi_dma2/M_AXI_SG] [get_bd_intf_pins axi_ic_HP2/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma2_m_axis_cntrl [get_bd_intf_pins axi_dma2/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet2/s_axis_txc]
  connect_bd_intf_net -intf_net axi_dma2_m_axis_mm2s [get_bd_intf_pins axi_dma2/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet2/s_axis_txd]
  connect_bd_intf_net -intf_net axi_ethernet1_axis_rxd [get_bd_intf_pins axi_dma1/S_AXIS_S2MM] [get_bd_intf_pins axi_ethernet1/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet1_axis_rxs [get_bd_intf_pins axi_dma1/S_AXIS_STS] [get_bd_intf_pins axi_ethernet1/m_axis_rxs]
  connect_bd_intf_net -intf_net axi_ethernet1_gmii [get_bd_intf_ports gmii1] [get_bd_intf_pins axi_ethernet1/gmii]
  connect_bd_intf_net -intf_net axi_ethernet1_mdio [get_bd_intf_ports mdio1] [get_bd_intf_pins axi_ethernet1/mdio]
  connect_bd_intf_net -intf_net axi_ethernet2_axis_rxd [get_bd_intf_pins axi_dma2/S_AXIS_S2MM] [get_bd_intf_pins axi_ethernet2/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet2_axis_rxs [get_bd_intf_pins axi_dma2/S_AXIS_STS] [get_bd_intf_pins axi_ethernet2/m_axis_rxs]
  connect_bd_intf_net -intf_net axi_ethernet2_gmii [get_bd_intf_ports gmii2] [get_bd_intf_pins axi_ethernet2/gmii]
  connect_bd_intf_net -intf_net axi_ethernet2_mdio [get_bd_intf_ports mdio2] [get_bd_intf_pins axi_ethernet2/mdio]
  connect_bd_intf_net -intf_net axi_ic_GP_M02_AXI [get_bd_intf_pins axi_dma1/S_AXI_LITE] [get_bd_intf_pins axi_ic_GP/M02_AXI]
  connect_bd_intf_net -intf_net axi_ic_GP_M03_AXI [get_bd_intf_pins axi_ethernet1/s_axi] [get_bd_intf_pins axi_ic_GP/M03_AXI]
  connect_bd_intf_net -intf_net axi_ic_GP_M04_AXI [get_bd_intf_pins axi_dma2/S_AXI_LITE] [get_bd_intf_pins axi_ic_GP/M04_AXI]
  connect_bd_intf_net -intf_net axi_ic_GP_M05_AXI [get_bd_intf_pins axi_ethernet2/s_axi] [get_bd_intf_pins axi_ic_GP/M05_AXI]
  connect_bd_intf_net -intf_net axi_ic_HP1_M00_AXI [get_bd_intf_pins axi_ic_HP1/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_ic_HP2_M00_AXI [get_bd_intf_pins axi_ic_HP2/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP2]
  connect_bd_intf_net -intf_net processing_system7_1_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7/DDR]
  connect_bd_intf_net -intf_net processing_system7_1_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp0 [get_bd_intf_pins axi_ic_GP/S00_AXI] [get_bd_intf_pins processing_system7/M_AXI_GP0]
  connect_bd_intf_net -intf_net processing_system7_GMII_ETHERNET_0 [get_bd_intf_ports PSGE0] [get_bd_intf_pins processing_system7/GMII_ETHERNET_0]
  connect_bd_intf_net -intf_net processing_system7_MDIO_ETHERNET_0 [get_bd_intf_ports PSMDIO0] [get_bd_intf_pins processing_system7/MDIO_ETHERNET_0]

  # Create port connections
  connect_bd_net -net CLK_0_1 [get_bd_ports PSGE0_RX_CLK] [get_bd_pins cnt25M/CLK] [get_bd_pins processing_system7/ENET0_GMII_RX_CLK]
  connect_bd_net -net ENET0_GMII_TX_CLK_0_1 [get_bd_ports PSGE0_TX_CLK] [get_bd_pins processing_system7/ENET0_GMII_TX_CLK]
  connect_bd_net -net RESET_BLOCK_ic_aresetn [get_bd_pins RESET_BLOCK/ic_aresetn] [get_bd_pins axi_ic_HP1/ARESETN] [get_bd_pins axi_ic_HP1/M00_ARESETN] [get_bd_pins axi_ic_HP1/S00_ARESETN] [get_bd_pins axi_ic_HP1/S01_ARESETN] [get_bd_pins axi_ic_HP1/S02_ARESETN] [get_bd_pins axi_ic_HP2/ARESETN] [get_bd_pins axi_ic_HP2/M00_ARESETN] [get_bd_pins axi_ic_HP2/S00_ARESETN] [get_bd_pins axi_ic_HP2/S01_ARESETN] [get_bd_pins axi_ic_HP2/S02_ARESETN]
  connect_bd_net -net RESET_BLOCK_ic_aresetn1 [get_bd_ports resetn] [get_bd_pins RESET_BLOCK/ic_aresetn1] [get_bd_pins axi_dma1/axi_resetn] [get_bd_pins axi_dma2/axi_resetn] [get_bd_pins axi_ethernet1/s_axi_lite_resetn] [get_bd_pins axi_ethernet2/s_axi_lite_resetn] [get_bd_pins axi_ic_GP/ARESETN] [get_bd_pins axi_ic_GP/M00_ARESETN] [get_bd_pins axi_ic_GP/M01_ARESETN] [get_bd_pins axi_ic_GP/M02_ARESETN] [get_bd_pins axi_ic_GP/M03_ARESETN] [get_bd_pins axi_ic_GP/M04_ARESETN] [get_bd_pins axi_ic_GP/M05_ARESETN] [get_bd_pins axi_ic_GP/S00_ARESETN]
  connect_bd_net -net SCLR_0_1 [get_bd_ports cnt_clr] [get_bd_pins cnt125M/SCLR] [get_bd_pins cnt25M/SCLR]
  connect_bd_net -net axi_dma1_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma1/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet1/axi_txc_arstn]
  connect_bd_net -net axi_dma1_mm2s_introut [get_bd_pins axi_dma1/mm2s_introut] [get_bd_pins concat_intr/In1]
  connect_bd_net -net axi_dma1_mm2s_prmry_reset_out_n [get_bd_pins axi_dma1/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet1/axi_txd_arstn]
  connect_bd_net -net axi_dma1_s2mm_introut [get_bd_pins axi_dma1/s2mm_introut] [get_bd_pins concat_intr/In0]
  connect_bd_net -net axi_dma1_s2mm_prmry_reset_out_n [get_bd_pins axi_dma1/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet1/axi_rxd_arstn]
  connect_bd_net -net axi_dma1_s2mm_sts_reset_out_n [get_bd_pins axi_dma1/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet1/axi_rxs_arstn]
  connect_bd_net -net axi_dma2_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma2/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet2/axi_txc_arstn]
  connect_bd_net -net axi_dma2_mm2s_introut [get_bd_pins axi_dma2/mm2s_introut] [get_bd_pins concat_intr/In4]
  connect_bd_net -net axi_dma2_mm2s_prmry_reset_out_n [get_bd_pins axi_dma2/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet2/axi_txd_arstn]
  connect_bd_net -net axi_dma2_s2mm_introut [get_bd_pins axi_dma2/s2mm_introut] [get_bd_pins concat_intr/In3]
  connect_bd_net -net axi_dma2_s2mm_prmry_reset_out_n [get_bd_pins axi_dma2/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet2/axi_rxd_arstn]
  connect_bd_net -net axi_dma2_s2mm_sts_reset_out_n [get_bd_pins axi_dma2/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet2/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet1_interrupt [get_bd_pins axi_ethernet1/interrupt] [get_bd_pins concat_intr/In2]
  connect_bd_net -net axi_ethernet2_interrupt [get_bd_pins axi_ethernet2/interrupt] [get_bd_pins concat_intr/In5]
  connect_bd_net -net clk_wiz0_clk_out1 [get_bd_ports PSGE0_gtxclk] [get_bd_pins clk_wiz0/clk_out1] [get_bd_pins cnt125M/CLK]
  connect_bd_net -net clk_wiz1_clk_out_125M [get_bd_pins axi_ethernet1/gtx_clk] [get_bd_pins clk_wiz1/clk_out1]
  connect_bd_net -net clk_wiz2_clk_out_125M [get_bd_pins axi_ethernet2/gtx_clk] [get_bd_pins clk_wiz2/clk_out1]
  connect_bd_net -net cnt125M_Q [get_bd_ports cnt125] [get_bd_pins cnt125M/Q]
  connect_bd_net -net cnt25M_Q [get_bd_ports cnt25] [get_bd_pins cnt25M/Q]
  connect_bd_net -net concat_intr_dout [get_bd_pins concat_intr/dout] [get_bd_pins processing_system7/IRQ_F2P]
  connect_bd_net -net phy_rst_n1 [get_bd_ports phy_rst_n1] [get_bd_pins axi_ethernet1/phy_rst_n]
  connect_bd_net -net phy_rst_n2 [get_bd_ports phy_rst_n2] [get_bd_pins axi_ethernet2/phy_rst_n]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins RESET_BLOCK/slowest_sync_clk] [get_bd_pins axi_dma1/m_axi_mm2s_aclk] [get_bd_pins axi_dma1/m_axi_s2mm_aclk] [get_bd_pins axi_dma1/m_axi_sg_aclk] [get_bd_pins axi_dma2/m_axi_mm2s_aclk] [get_bd_pins axi_dma2/m_axi_s2mm_aclk] [get_bd_pins axi_dma2/m_axi_sg_aclk] [get_bd_pins axi_ethernet1/axis_clk] [get_bd_pins axi_ethernet2/axis_clk] [get_bd_pins axi_ic_HP1/ACLK] [get_bd_pins axi_ic_HP1/M00_ACLK] [get_bd_pins axi_ic_HP1/S00_ACLK] [get_bd_pins axi_ic_HP1/S01_ACLK] [get_bd_pins axi_ic_HP1/S02_ACLK] [get_bd_pins axi_ic_HP2/ACLK] [get_bd_pins axi_ic_HP2/M00_ACLK] [get_bd_pins axi_ic_HP2/S00_ACLK] [get_bd_pins axi_ic_HP2/S01_ACLK] [get_bd_pins axi_ic_HP2/S02_ACLK] [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_pins processing_system7/S_AXI_HP1_ACLK] [get_bd_pins processing_system7/S_AXI_HP2_ACLK]
  connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins RESET_BLOCK/slowest_sync_clk1] [get_bd_pins axi_dma1/s_axi_lite_aclk] [get_bd_pins axi_dma2/s_axi_lite_aclk] [get_bd_pins axi_ethernet1/s_axi_lite_clk] [get_bd_pins axi_ethernet2/s_axi_lite_clk] [get_bd_pins axi_ic_GP/ACLK] [get_bd_pins axi_ic_GP/M00_ACLK] [get_bd_pins axi_ic_GP/M01_ACLK] [get_bd_pins axi_ic_GP/M02_ACLK] [get_bd_pins axi_ic_GP/M03_ACLK] [get_bd_pins axi_ic_GP/M04_ACLK] [get_bd_pins axi_ic_GP/M05_ACLK] [get_bd_pins axi_ic_GP/S00_ACLK] [get_bd_pins processing_system7/FCLK_CLK1] [get_bd_pins processing_system7/M_AXI_GP0_ACLK]
  connect_bd_net -net processing_system7_1_fclk_clk2 [get_bd_ports ref_clk] [get_bd_pins clk_wiz0/clk_in1] [get_bd_pins clk_wiz1/clk_in1] [get_bd_pins clk_wiz2/clk_in1] [get_bd_pins processing_system7/FCLK_CLK2]
  connect_bd_net -net processing_system7_FCLK_RESET0_N [get_bd_pins RESET_BLOCK/ext_reset_in] [get_bd_pins processing_system7/FCLK_RESET0_N]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma1/Data_SG] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma1/Data_MM2S] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma1/Data_S2MM] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma2/Data_SG] [get_bd_addr_segs processing_system7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma2/Data_MM2S] [get_bd_addr_segs processing_system7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_dma2/Data_S2MM] [get_bd_addr_segs processing_system7/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs axi_dma1/S_AXI_LITE/Reg] SEG_axi_dma1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs axi_dma2/S_AXI_LITE/Reg] SEG_axi_dma2_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x41000000 [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs axi_ethernet1/s_axi/Reg0] SEG_axi_ethernet1_Reg0
  create_bd_addr_seg -range 0x00040000 -offset 0x41040000 [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs axi_ethernet2/s_axi/Reg0] SEG_axi_ethernet2_Reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


