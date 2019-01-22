# CHANGE DESIGN NAME HERE
set design_name QG_pl_eth

puts "INFO: Currently there is no design <$design_name> in project, so creating one..."
create_bd_design $design_name

puts "INFO: Making design <$design_name> as current_bd_design."
current_bd_design $design_name

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: RESET_BLOCK
proc create_hier_cell_RESET_BLOCK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_RESET_BLOCK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
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
  set_property -dict [ list CONFIG.C_AUX_RST_WIDTH {1} CONFIG.C_EXT_RST_WIDTH {1}  ] $proc_sys_reset_0

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
  set_property -dict [ list CONFIG.C_AUX_RST_WIDTH {1} CONFIG.C_EXT_RST_WIDTH {1}  ] $proc_sys_reset_1

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

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  #set mgt_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mgt_clk ]
  set gmii1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii1 ]
  set gmii2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii2 ]
  set gmii3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii3 ]
  set gmii4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii4 ]
#  set gmii5 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gmii_rtl:1.0 gmii5 ]
  set mdio1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio1 ]
  set mdio2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio2 ]
  set mdio3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio3 ]
  set mdio4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio4 ]
#  set mdio5 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio5 ]
  set sfp0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sfp_rtl:1.0 sfp0 ]
  set phy_rst_n1 [ create_bd_port -dir O -type rst phy_rst_n1]
  set phy_rst_n2 [ create_bd_port -dir O -type rst phy_rst_n2]
  set phy_rst_n3 [ create_bd_port -dir O -type rst phy_rst_n3]
  set phy_rst_n4 [ create_bd_port -dir O -type rst phy_rst_n4]
#  set phy_rst_n5 [ create_bd_port -dir O -type rst phy_rst_n5]
  set gmii1_gtx_in [ create_bd_port -dir I -type clk gmii1_gtx_in]
  set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports gmii1_gtx_in]
  set gmii2_gtx_in [ create_bd_port -dir I -type clk gmii2_gtx_in]
  set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports gmii2_gtx_in]
  set gmii3_gtx_in [ create_bd_port -dir I -type clk gmii3_gtx_in]
  set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports gmii3_gtx_in]
  set gmii4_gtx_in [ create_bd_port -dir I -type clk gmii4_gtx_in]
  set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports gmii4_gtx_in]
#  set gmii5_gtx_in [ create_bd_port -dir I -type clk gmii5_gtx_in]
#  set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports gmii5_gtx_in]

  # Create a const val '1'
  set const_val1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_val1 ]

  set mgt0_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mgt0_in ]


  create_bd_port -dir O -type data clk_25M_out1
  create_bd_port -dir O -type data clk_25M_out2
  create_bd_port -dir O -type data clk_25M_out3
  create_bd_port -dir O -type data clk_25M_out4
#  create_bd_port -dir O -type data clk_25M_out5

  # Create instance: clk_wiz & counter
  set clk_wiz_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_50M ]
  set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} CONFIG.CLKOUT1_JITTER {151.636}] $clk_wiz_50M 

  set counter_25M [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 counter_25M ]
  set_property -dict [list CONFIG.Output_Width {1}] $counter_25M

  connect_bd_net [get_bd_pins clk_wiz_50M/clk_out1] [get_bd_pins counter_25M/CLK]
#  connect_bd_net [get_bd_pins counter_25M/Q] [get_bd_ports clk_25M_out1] [get_bd_ports clk_25M_out2] [get_bd_ports clk_25M_out3] [get_bd_ports clk_25M_out4] [get_bd_ports clk_25M_out5]
  connect_bd_net [get_bd_pins counter_25M/Q] [get_bd_ports clk_25M_out1] [get_bd_ports clk_25M_out2] [get_bd_ports clk_25M_out3] [get_bd_ports clk_25M_out4]


  # Create ports
  #set ref_clk [ create_bd_port -dir I -type clk ref_clk ]
  #set_property -dict [ list CONFIG.CLK_DOMAIN {design_pl_eth_ref_clk} CONFIG.FREQ_HZ {100000000} CONFIG.PHASE {0.000}  ] $ref_clk

  # Create instance: RESET_BLOCK
  create_hier_cell_RESET_BLOCK [current_bd_instance .] RESET_BLOCK
  create_bd_port -dir O -from 0 -to 0 -type rst resetn
  connect_bd_net [get_bd_pins /RESET_BLOCK/ic_aresetn1] [get_bd_ports resetn]

  # Create instance: axi_dma, and set properties
  set axi_dma1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma1 ]
  set_property -dict [ list CONFIG.c_include_mm2s_dre {1} CONFIG.c_include_s2mm_dre {1} CONFIG.c_sg_use_stsapp_length {1}  ] $axi_dma1
  set axi_dma2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma2 ]
  set_property -dict [ list CONFIG.c_include_mm2s_dre {1} CONFIG.c_include_s2mm_dre {1} CONFIG.c_sg_use_stsapp_length {1}  ] $axi_dma2
  set axi_dma3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma3 ]
  set_property -dict [ list CONFIG.c_include_mm2s_dre {1} CONFIG.c_include_s2mm_dre {1} CONFIG.c_sg_use_stsapp_length {1}  ] $axi_dma3
  set axi_dma4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma4 ]
  set_property -dict [ list CONFIG.c_include_mm2s_dre {1} CONFIG.c_include_s2mm_dre {1} CONFIG.c_sg_use_stsapp_length {1}  ] $axi_dma4
  set axi_dma5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma5 ]
  set_property -dict [ list CONFIG.c_include_mm2s_dre {1} CONFIG.c_include_s2mm_dre {1} CONFIG.c_sg_use_stsapp_length {1}  ] $axi_dma5

  # Create instance: axi_ethernet, and set properties
  set axi_ethernet1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet1 ]
  set_property -dict [ list CONFIG.PHY_TYPE {GMII} CONFIG.RXCSUM {Full} CONFIG.RXMEM {16k} CONFIG.TXCSUM {Full} CONFIG.TXMEM {16k} CONFIG.SupportLevel {0} ] $axi_ethernet1
  set axi_ethernet2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet2 ]
  set_property -dict [ list CONFIG.PHY_TYPE {GMII} CONFIG.RXCSUM {Full} CONFIG.RXMEM {16k} CONFIG.TXCSUM {Full} CONFIG.TXMEM {16k} CONFIG.SupportLevel {0} ] $axi_ethernet2
  set axi_ethernet3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet3 ]
  set_property -dict [ list CONFIG.PHY_TYPE {GMII} CONFIG.RXCSUM {Full} CONFIG.RXMEM {16k} CONFIG.TXCSUM {Full} CONFIG.TXMEM {16k} CONFIG.SupportLevel {0} ] $axi_ethernet3
  set axi_ethernet4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet4 ]
  set_property -dict [ list CONFIG.PHY_TYPE {GMII} CONFIG.RXCSUM {Full} CONFIG.RXMEM {16k} CONFIG.TXCSUM {Full} CONFIG.TXMEM {16k} CONFIG.SupportLevel {0} ] $axi_ethernet4
  set axi_ethernet_sfp0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_sfp0 ]
  set_property -dict [list CONFIG.PHY_TYPE {1000BaseX} CONFIG.SupportLevel {1}]  $axi_ethernet_sfp0

  # Create instance: axi_ic_HP, and set properties
  set axi_ic_HP [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_HP ]
  set_property -dict [ list CONFIG.NUM_MI {1} CONFIG.NUM_SI {15} CONFIG.STRATEGY {2}  ] $axi_ic_HP
  #set axi_ic_HP2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_HP2 ]
  #set_property -dict [ list CONFIG.NUM_MI {1} CONFIG.NUM_SI {3} CONFIG.STRATEGY {2}  ] $axi_ic_HP2

  # Create instance: axi_ic_GP, and set properties
  set axi_ic_GP [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_GP ]
  set_property -dict [list CONFIG.NUM_MI {10}] $axi_ic_GP

  # Create instance: concat_intr, and set properties
  set concat_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_intr ]
  set_property -dict [ list CONFIG.NUM_PORTS {15} ] $concat_intr

  # Create instance: processing_system7, and set properties
  set processing_system7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7 ]
  set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_EN_CLK2_PORT {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {75} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} CONFIG.PCW_IMPORT_BOARD_PRESET {None} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1}  CONFIG.PCW_USE_S_AXI_HP0 {1}] $processing_system7
  set_property -dict [ list CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_NAND_PERIPHERAL_ENABLE {1} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M8 HX-15E} ]  $processing_system7
  set_property -dict [ list CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} CONFIG.PCW_SD0_GRP_CD_ENABLE {1} CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} CONFIG.PCW_SD0_GRP_WP_ENABLE {1} CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} ] $processing_system7
  create_bd_port -dir O -type clk ref_clk

  # make PSGE0/MDIO0 port external
  #make_bd_intf_pins_external  [get_bd_intf_pins processing_system7/GMII_ETHERNET_0]
  #set_property name PSGE0 [get_bd_intf_ports GMII_ETHERNET_0_0]
  #make_bd_intf_pins_external  [get_bd_intf_pins processing_system7/MDIO_ETHERNET_0]
  #set_property name PSMDIO0 [get_bd_intf_ports MDIO_ETHERNET_0_0]

  # Create interface connections
  #PLGE1
  connect_bd_intf_net -intf_net axi_dma1_m_axi_sg [get_bd_intf_pins axi_dma1/M_AXI_SG] [get_bd_intf_pins axi_ic_HP/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma1_m_axi_mm2s [get_bd_intf_pins axi_dma1/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma1_m_axi_s2mm [get_bd_intf_pins axi_dma1/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP/S02_AXI]
  connect_bd_intf_net -intf_net axi_dma1_m_axis_mm2s [get_bd_intf_pins axi_dma1/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet1/s_axis_txd]
  connect_bd_intf_net -intf_net axi_dma1_m_axis_cntrl [get_bd_intf_pins axi_dma1/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet1/s_axis_txc]

  connect_bd_intf_net -intf_net axi_ethernet1_axis_rxd [get_bd_intf_pins axi_ethernet1/m_axis_rxd] [get_bd_intf_pins axi_dma1/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet1_axis_rxs [get_bd_intf_pins axi_ethernet1/m_axis_rxs] [get_bd_intf_pins axi_dma1/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet1_gmii [get_bd_intf_pins axi_ethernet1/gmii] $gmii1
  connect_bd_intf_net -intf_net axi_ethernet1_mdio [get_bd_intf_pins axi_ethernet1/mdio] $mdio1

  #PLGE2
  connect_bd_intf_net -intf_net axi_dma2_m_axi_sg [get_bd_intf_pins axi_dma2/M_AXI_SG] [get_bd_intf_pins axi_ic_HP/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma2_m_axi_mm2s [get_bd_intf_pins axi_dma2/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP/S04_AXI]
  connect_bd_intf_net -intf_net axi_dma2_m_axi_s2mm [get_bd_intf_pins axi_dma2/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP/S05_AXI]
  connect_bd_intf_net -intf_net axi_dma2_m_axis_mm2s [get_bd_intf_pins axi_dma2/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet2/s_axis_txd]
  connect_bd_intf_net -intf_net axi_dma2_m_axis_cntrl [get_bd_intf_pins axi_dma2/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet2/s_axis_txc]

  connect_bd_intf_net -intf_net axi_ethernet2_axis_rxd [get_bd_intf_pins axi_ethernet2/m_axis_rxd] [get_bd_intf_pins axi_dma2/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet2_axis_rxs [get_bd_intf_pins axi_ethernet2/m_axis_rxs] [get_bd_intf_pins axi_dma2/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet2_gmii [get_bd_intf_pins axi_ethernet2/gmii] $gmii2
  connect_bd_intf_net -intf_net axi_ethernet2_mdio [get_bd_intf_pins axi_ethernet2/mdio] $mdio2

  #PLGE3
  connect_bd_intf_net -intf_net axi_dma3_m_axi_sg [get_bd_intf_pins axi_dma3/M_AXI_SG] [get_bd_intf_pins axi_ic_HP/S06_AXI]
  connect_bd_intf_net -intf_net axi_dma3_m_axi_mm2s [get_bd_intf_pins axi_dma3/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP/S07_AXI]
  connect_bd_intf_net -intf_net axi_dma3_m_axi_s2mm [get_bd_intf_pins axi_dma3/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP/S08_AXI]
  connect_bd_intf_net -intf_net axi_dma3_m_axis_mm2s [get_bd_intf_pins axi_dma3/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet3/s_axis_txd]
  connect_bd_intf_net -intf_net axi_dma3_m_axis_cntrl [get_bd_intf_pins axi_dma3/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet3/s_axis_txc]

  connect_bd_intf_net -intf_net axi_ethernet3_axis_rxd [get_bd_intf_pins axi_ethernet3/m_axis_rxd] [get_bd_intf_pins axi_dma3/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet3_axis_rxs [get_bd_intf_pins axi_ethernet3/m_axis_rxs] [get_bd_intf_pins axi_dma3/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet3_gmii [get_bd_intf_pins axi_ethernet3/gmii] $gmii3
  connect_bd_intf_net -intf_net axi_ethernet3_mdio [get_bd_intf_pins axi_ethernet3/mdio] $mdio3

  #PLGE4
  connect_bd_intf_net -intf_net axi_dma4_m_axi_sg [get_bd_intf_pins axi_dma4/M_AXI_SG] [get_bd_intf_pins axi_ic_HP/S09_AXI]
  connect_bd_intf_net -intf_net axi_dma4_m_axi_mm2s [get_bd_intf_pins axi_dma4/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP/S10_AXI]
  connect_bd_intf_net -intf_net axi_dma4_m_axi_s2mm [get_bd_intf_pins axi_dma4/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP/S11_AXI]
  connect_bd_intf_net -intf_net axi_dma4_m_axis_mm2s [get_bd_intf_pins axi_dma4/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet4/s_axis_txd]
  connect_bd_intf_net -intf_net axi_dma4_m_axis_cntrl [get_bd_intf_pins axi_dma4/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet4/s_axis_txc]

  connect_bd_intf_net -intf_net axi_ethernet4_axis_rxd [get_bd_intf_pins axi_ethernet4/m_axis_rxd] [get_bd_intf_pins axi_dma4/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet4_axis_rxs [get_bd_intf_pins axi_ethernet4/m_axis_rxs] [get_bd_intf_pins axi_dma4/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet4_gmii [get_bd_intf_pins axi_ethernet4/gmii] $gmii4
  connect_bd_intf_net -intf_net axi_ethernet4_mdio [get_bd_intf_pins axi_ethernet4/mdio] $mdio4

  #PLGE5
  connect_bd_intf_net -intf_net axi_dma5_m_axi_sg [get_bd_intf_pins axi_dma5/M_AXI_SG] [get_bd_intf_pins axi_ic_HP/S12_AXI]
  connect_bd_intf_net -intf_net axi_dma5_m_axi_mm2s [get_bd_intf_pins axi_dma5/M_AXI_MM2S] [get_bd_intf_pins axi_ic_HP/S13_AXI]
  connect_bd_intf_net -intf_net axi_dma5_m_axi_s2mm [get_bd_intf_pins axi_dma5/M_AXI_S2MM] [get_bd_intf_pins axi_ic_HP/S14_AXI]
  connect_bd_intf_net -intf_net axi_dma5_m_axis_mm2s [get_bd_intf_pins axi_dma5/M_AXIS_MM2S] [get_bd_intf_pins axi_ethernet_sfp0/s_axis_txd]
  connect_bd_intf_net -intf_net axi_dma5_m_axis_cntrl [get_bd_intf_pins axi_dma5/M_AXIS_CNTRL] [get_bd_intf_pins axi_ethernet_sfp0/s_axis_txc]

  connect_bd_intf_net -intf_net axi_ethernet_sfp0_axis_rxd [get_bd_intf_pins axi_ethernet_sfp0/m_axis_rxd] [get_bd_intf_pins axi_dma5/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet_sfp0_axis_rxs [get_bd_intf_pins axi_ethernet_sfp0/m_axis_rxs] [get_bd_intf_pins axi_dma5/S_AXIS_STS]
#  connect_bd_intf_net -intf_net axi_ethernet_sfp0_gmii [get_bd_intf_pins axi_ethernet_sfp0/gmii] $gmii5
#  connect_bd_intf_net -intf_net axi_ethernet_sfp0_mdio [get_bd_intf_pins axi_ethernet_sfp0/mdio] $mdio5
  connect_bd_intf_net -intf_net axi_ethernet5_sfp0 [get_bd_intf_ports sfp0] [get_bd_intf_pins axi_ethernet_sfp0/sfp]
  connect_bd_net -net xlconstant_val1_dout [get_bd_pins axi_ethernet_sfp0/signal_detect] [get_bd_pins xlconstant_val1/dout]

  # ic_HP Master port
  connect_bd_intf_net -intf_net axi_ic_HP_M00_AXI [get_bd_intf_pins axi_ic_HP/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP0]

  #axi_ic_GP
  connect_bd_intf_net -intf_net axi_ic_GP_M00_AXI [get_bd_intf_pins axi_ic_GP/M00_AXI] [get_bd_intf_pins axi_dma1/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_GP_M01_AXI [get_bd_intf_pins axi_ic_GP/M01_AXI] [get_bd_intf_pins axi_ethernet1/s_axi]
  connect_bd_intf_net -intf_net axi_ic_GP_M02_AXI [get_bd_intf_pins axi_ic_GP/M02_AXI] [get_bd_intf_pins axi_dma2/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_GP_M03_AXI [get_bd_intf_pins axi_ic_GP/M03_AXI] [get_bd_intf_pins axi_ethernet2/s_axi]
  connect_bd_intf_net -intf_net axi_ic_GP_M04_AXI [get_bd_intf_pins axi_ic_GP/M04_AXI] [get_bd_intf_pins axi_dma3/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_GP_M05_AXI [get_bd_intf_pins axi_ic_GP/M05_AXI] [get_bd_intf_pins axi_ethernet3/s_axi]
  connect_bd_intf_net -intf_net axi_ic_GP_M06_AXI [get_bd_intf_pins axi_ic_GP/M06_AXI] [get_bd_intf_pins axi_dma4/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_GP_M07_AXI [get_bd_intf_pins axi_ic_GP/M07_AXI] [get_bd_intf_pins axi_ethernet4/s_axi]
  connect_bd_intf_net -intf_net axi_ic_GP_M08_AXI [get_bd_intf_pins axi_ic_GP/M08_AXI] [get_bd_intf_pins axi_dma5/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_GP_M09_AXI [get_bd_intf_pins axi_ic_GP/M09_AXI] [get_bd_intf_pins axi_ethernet_sfp0/s_axi]

  # ARM processor
  connect_bd_intf_net -intf_net processing_system7_1_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7/DDR]
  connect_bd_intf_net -intf_net processing_system7_1_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp0 [get_bd_intf_pins axi_ic_GP/S00_AXI] [get_bd_intf_pins processing_system7/M_AXI_GP0]

  # interrupts
  connect_bd_net -net axi_dma1_s2mm_introut [get_bd_pins axi_dma1/s2mm_introut] [get_bd_pins concat_intr/In0]
  connect_bd_net -net axi_dma1_mm2s_introut [get_bd_pins axi_dma1/mm2s_introut] [get_bd_pins concat_intr/In1]
  connect_bd_net -net axi_ethernet1_interrupt [get_bd_pins axi_ethernet1/interrupt] [get_bd_pins concat_intr/In2]

  connect_bd_net -net axi_dma2_s2mm_introut [get_bd_pins axi_dma2/s2mm_introut] [get_bd_pins concat_intr/In3]
  connect_bd_net -net axi_dma2_mm2s_introut [get_bd_pins axi_dma2/mm2s_introut] [get_bd_pins concat_intr/In4]
  connect_bd_net -net axi_ethernet2_interrupt [get_bd_pins axi_ethernet2/interrupt] [get_bd_pins concat_intr/In5]

  connect_bd_net -net axi_dma3_s2mm_introut [get_bd_pins axi_dma3/s2mm_introut] [get_bd_pins concat_intr/In6]
  connect_bd_net -net axi_dma3_mm2s_introut [get_bd_pins axi_dma3/mm2s_introut] [get_bd_pins concat_intr/In7]
  connect_bd_net -net axi_ethernet3_interrupt [get_bd_pins axi_ethernet3/interrupt] [get_bd_pins concat_intr/In8]

  connect_bd_net -net axi_dma4_s2mm_introut [get_bd_pins axi_dma4/s2mm_introut] [get_bd_pins concat_intr/In9]
  connect_bd_net -net axi_dma4_mm2s_introut [get_bd_pins axi_dma4/mm2s_introut] [get_bd_pins concat_intr/In10]
  connect_bd_net -net axi_ethernet4_interrupt [get_bd_pins axi_ethernet4/interrupt] [get_bd_pins concat_intr/In11]

  connect_bd_net -net axi_dma5_s2mm_introut [get_bd_pins axi_dma5/s2mm_introut] [get_bd_pins concat_intr/In12]
  connect_bd_net -net axi_dma5_mm2s_introut [get_bd_pins axi_dma5/mm2s_introut] [get_bd_pins concat_intr/In13]
  connect_bd_net -net axi_ethernet_sfp0_interrupt [get_bd_pins axi_ethernet_sfp0/interrupt] [get_bd_pins concat_intr/In14]

  # RESET
  connect_bd_net -net axi_dma1_mm2s_prmry_reset_out_n [get_bd_pins axi_dma1/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet1/axi_txd_arstn]
  connect_bd_net -net axi_dma1_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma1/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet1/axi_txc_arstn]
  connect_bd_net -net axi_dma1_s2mm_prmry_reset_out_n [get_bd_pins axi_dma1/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet1/axi_rxd_arstn]
  connect_bd_net -net axi_dma1_s2mm_sts_reset_out_n [get_bd_pins axi_dma1/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet1/axi_rxs_arstn]

  connect_bd_net -net axi_dma2_mm2s_prmry_reset_out_n [get_bd_pins axi_dma2/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet2/axi_txd_arstn]
  connect_bd_net -net axi_dma2_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma2/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet2/axi_txc_arstn]
  connect_bd_net -net axi_dma2_s2mm_prmry_reset_out_n [get_bd_pins axi_dma2/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet2/axi_rxd_arstn]
  connect_bd_net -net axi_dma2_s2mm_sts_reset_out_n [get_bd_pins axi_dma2/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet2/axi_rxs_arstn]

  connect_bd_net -net axi_dma3_mm2s_prmry_reset_out_n [get_bd_pins axi_dma3/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet3/axi_txd_arstn]
  connect_bd_net -net axi_dma3_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma3/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet3/axi_txc_arstn]
  connect_bd_net -net axi_dma3_s2mm_prmry_reset_out_n [get_bd_pins axi_dma3/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet3/axi_rxd_arstn]
  connect_bd_net -net axi_dma3_s2mm_sts_reset_out_n [get_bd_pins axi_dma3/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet3/axi_rxs_arstn]

  connect_bd_net -net axi_dma4_mm2s_prmry_reset_out_n [get_bd_pins axi_dma4/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet4/axi_txd_arstn]
  connect_bd_net -net axi_dma4_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma4/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet4/axi_txc_arstn]
  connect_bd_net -net axi_dma4_s2mm_prmry_reset_out_n [get_bd_pins axi_dma4/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet4/axi_rxd_arstn]
  connect_bd_net -net axi_dma4_s2mm_sts_reset_out_n [get_bd_pins axi_dma4/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet4/axi_rxs_arstn]

  connect_bd_net -net axi_dma5_mm2s_prmry_reset_out_n [get_bd_pins axi_dma5/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet_sfp0/axi_txd_arstn]
  connect_bd_net -net axi_dma5_mm2s_cntrl_reset_out_n [get_bd_pins axi_dma5/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet_sfp0/axi_txc_arstn]
  connect_bd_net -net axi_dma5_s2mm_prmry_reset_out_n [get_bd_pins axi_dma5/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet_sfp0/axi_rxd_arstn]
  connect_bd_net -net axi_dma5_s2mm_sts_reset_out_n [get_bd_pins axi_dma5/s2mm_sts_reset_out_n] [get_bd_pins axi_ethernet_sfp0/axi_rxs_arstn]

  connect_bd_net -net processing_system7_FCLK_RESET0_N [get_bd_pins processing_system7/FCLK_RESET0_N] [get_bd_pins RESET_BLOCK/ext_reset_in]
  connect_bd_net -net RESET_BLOCK_ic_aresetn [get_bd_pins RESET_BLOCK/ic_aresetn] [get_bd_pins axi_ic_HP/ARESETN] [get_bd_pins axi_ic_HP/M00_ARESETN] [get_bd_pins axi_ic_HP/S00_ARESETN] [get_bd_pins axi_ic_HP/S01_ARESETN] [get_bd_pins axi_ic_HP/S02_ARESETN] [get_bd_pins axi_ic_HP/S03_ARESETN] [get_bd_pins axi_ic_HP/S04_ARESETN] [get_bd_pins axi_ic_HP/S05_ARESETN] [get_bd_pins axi_ic_HP/S06_ARESETN] [get_bd_pins axi_ic_HP/S07_ARESETN] [get_bd_pins axi_ic_HP/S08_ARESETN] [get_bd_pins axi_ic_HP/S09_ARESETN] [get_bd_pins axi_ic_HP/S10_ARESETN] [get_bd_pins axi_ic_HP/S11_ARESETN] [get_bd_pins axi_ic_HP/S12_ARESETN] [get_bd_pins axi_ic_HP/S13_ARESETN] [get_bd_pins axi_ic_HP/S14_ARESETN]
  connect_bd_net -net RESET_BLOCK_ic_aresetn1 [get_bd_pins RESET_BLOCK/ic_aresetn1] [get_bd_pins axi_dma1/axi_resetn] [get_bd_pins axi_ethernet1/s_axi_lite_resetn] [get_bd_pins axi_dma2/axi_resetn] [get_bd_pins axi_ethernet2/s_axi_lite_resetn] [get_bd_pins axi_dma3/axi_resetn] [get_bd_pins axi_ethernet3/s_axi_lite_resetn] [get_bd_pins axi_dma4/axi_resetn] [get_bd_pins axi_ethernet4/s_axi_lite_resetn] [get_bd_pins axi_dma5/axi_resetn] [get_bd_pins axi_ethernet_sfp0/s_axi_lite_resetn] [get_bd_pins axi_ic_GP/ARESETN] [get_bd_pins axi_ic_GP/S00_ARESETN] [get_bd_pins axi_ic_GP/M00_ARESETN] [get_bd_pins axi_ic_GP/M01_ARESETN] [get_bd_pins axi_ic_GP/M02_ARESETN] [get_bd_pins axi_ic_GP/M03_ARESETN] [get_bd_pins axi_ic_GP/M04_ARESETN] [get_bd_pins axi_ic_GP/M05_ARESETN] [get_bd_pins axi_ic_GP/M06_ARESETN] [get_bd_pins axi_ic_GP/M07_ARESETN] [get_bd_pins axi_ic_GP/M08_ARESETN] [get_bd_pins axi_ic_GP/M09_ARESETN]

  connect_bd_net -net concat_intr_dout [get_bd_pins concat_intr/dout] [get_bd_pins processing_system7/IRQ_F2P]
  connect_bd_net -net phy_rst_n1 [get_bd_ports phy_rst_n1] [get_bd_pins axi_ethernet1/phy_rst_n]
  connect_bd_net -net phy_rst_n2 [get_bd_ports phy_rst_n2] [get_bd_pins axi_ethernet2/phy_rst_n]
  connect_bd_net -net phy_rst_n3 [get_bd_ports phy_rst_n3] [get_bd_pins axi_ethernet3/phy_rst_n]
  connect_bd_net -net phy_rst_n4 [get_bd_ports phy_rst_n4] [get_bd_pins axi_ethernet4/phy_rst_n]
#  connect_bd_net -net phy_rst_n5 [get_bd_ports phy_rst_n5] [get_bd_pins axi_ethernet_sfp0/phy_rst_n]

  # clock
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_pins RESET_BLOCK/slowest_sync_clk] [get_bd_pins axi_dma1/m_axi_sg_aclk] [get_bd_pins axi_dma1/m_axi_mm2s_aclk] [get_bd_pins axi_dma1/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet1/axis_clk] [get_bd_pins axi_dma2/m_axi_sg_aclk] [get_bd_pins axi_dma2/m_axi_mm2s_aclk] [get_bd_pins axi_dma2/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet2/axis_clk] [get_bd_pins axi_dma3/m_axi_sg_aclk] [get_bd_pins axi_dma3/m_axi_mm2s_aclk] [get_bd_pins axi_dma3/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet3/axis_clk] [get_bd_pins axi_dma4/m_axi_sg_aclk] [get_bd_pins axi_dma4/m_axi_mm2s_aclk] [get_bd_pins axi_dma4/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet4/axis_clk] [get_bd_pins axi_dma5/m_axi_sg_aclk] [get_bd_pins axi_dma5/m_axi_mm2s_aclk] [get_bd_pins axi_dma5/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet_sfp0/axis_clk] [get_bd_pins axi_ic_HP/ACLK] [get_bd_pins axi_ic_HP/M00_ACLK] [get_bd_pins axi_ic_HP/S00_ACLK] [get_bd_pins axi_ic_HP/S01_ACLK] [get_bd_pins axi_ic_HP/S02_ACLK] [get_bd_pins axi_ic_HP/S03_ACLK] [get_bd_pins axi_ic_HP/S04_ACLK] [get_bd_pins axi_ic_HP/S05_ACLK] [get_bd_pins axi_ic_HP/S06_ACLK] [get_bd_pins axi_ic_HP/S07_ACLK] [get_bd_pins axi_ic_HP/S08_ACLK] [get_bd_pins axi_ic_HP/S09_ACLK] [get_bd_pins axi_ic_HP/S10_ACLK] [get_bd_pins axi_ic_HP/S11_ACLK] [get_bd_pins axi_ic_HP/S12_ACLK] [get_bd_pins axi_ic_HP/S13_ACLK] [get_bd_pins axi_ic_HP/S14_ACLK] [get_bd_pins processing_system7/S_AXI_HP0_ACLK]
  connect_bd_net -net processing_system7_1_fclk_clk1 [get_bd_pins processing_system7/FCLK_CLK1] [get_bd_pins RESET_BLOCK/slowest_sync_clk1] [get_bd_pins axi_ic_GP/ACLK] [get_bd_pins axi_ic_GP/S00_ACLK] [get_bd_pins axi_ic_GP/M00_ACLK] [get_bd_pins axi_ic_GP/M01_ACLK] [get_bd_pins axi_ic_GP/M02_ACLK] [get_bd_pins axi_ic_GP/M03_ACLK] [get_bd_pins axi_ic_GP/M04_ACLK] [get_bd_pins axi_ic_GP/M05_ACLK] [get_bd_pins axi_ic_GP/M06_ACLK] [get_bd_pins axi_ic_GP/M07_ACLK] [get_bd_pins axi_ic_GP/M08_ACLK] [get_bd_pins axi_ic_GP/M09_ACLK] [get_bd_pins axi_dma1/s_axi_lite_aclk] [get_bd_pins axi_ethernet1/s_axi_lite_clk] [get_bd_pins axi_dma2/s_axi_lite_aclk] [get_bd_pins axi_ethernet2/s_axi_lite_clk] [get_bd_pins axi_dma3/s_axi_lite_aclk] [get_bd_pins axi_ethernet3/s_axi_lite_clk] [get_bd_pins axi_dma4/s_axi_lite_aclk] [get_bd_pins axi_ethernet4/s_axi_lite_clk] [get_bd_pins axi_dma5/s_axi_lite_aclk] [get_bd_pins axi_ethernet_sfp0/s_axi_lite_clk] [get_bd_pins processing_system7/M_AXI_GP0_ACLK] [get_bd_pins clk_wiz_50M/clk_in1]
  #connect_bd_net -net processing_system7_1_fclk_clk2 [get_bd_pins processing_system7/FCLK_CLK2] [get_bd_pins axi_ethernet1/ref_clk] [get_bd_pins axi_ethernet2/ref_clk] [get_bd_pins axi_ethernet3/ref_clk] [get_bd_pins axi_ethernet4/ref_clk] [get_bd_pins axi_ethernet_sfp0/ref_clk] [get_bd_ports ref_clk]
  connect_bd_net -net processing_system7_1_fclk_clk2 [get_bd_pins processing_system7/FCLK_CLK2] [get_bd_ports ref_clk] [get_bd_pins axi_ethernet_sfp0/ref_clk]
  connect_bd_net -net gmii1_gtx_in [get_bd_ports gmii1_gtx_in] [get_bd_pins axi_ethernet1/gtx_clk]
  connect_bd_net -net gmii2_gtx_in [get_bd_ports gmii2_gtx_in] [get_bd_pins axi_ethernet2/gtx_clk]
  connect_bd_net -net gmii3_gtx_in [get_bd_ports gmii3_gtx_in] [get_bd_pins axi_ethernet3/gtx_clk]
  connect_bd_net -net gmii4_gtx_in [get_bd_ports gmii4_gtx_in] [get_bd_pins axi_ethernet4/gtx_clk]
#  connect_bd_net -net gmii5_gtx_in [get_bd_ports gmii5_gtx_in] [get_bd_pins axi_ethernet_sfp0/gtx_clk]
  connect_bd_intf_net -intf_net mgt0_in_clk [get_bd_intf_ports mgt0_in] [get_bd_intf_pins axi_ethernet_sfp0/mgt_clk]

  # Create address segments
  assign_bd_address
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


