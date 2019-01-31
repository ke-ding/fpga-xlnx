# vim: sts=4 sw=4 et
set design_name QG_sfp_eth

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
    set proc_sys_reset_0 [                          \
        create_bd_cell                              \
            -type ip                                \
            -vlnv xilinx.com:ip:proc_sys_reset:5.0  \
        proc_sys_reset_0 ]
    set_property -dict                              \
        [ list  CONFIG.C_AUX_RST_WIDTH {1}          \
                CONFIG.C_EXT_RST_WIDTH {1} ]        \
        $proc_sys_reset_0

    # Create instance: proc_sys_reset_1, and set properties
    set proc_sys_reset_1 [                          \
        create_bd_cell                              \
            -type ip                                \
            -vlnv xilinx.com:ip:proc_sys_reset:5.0  \
        proc_sys_reset_1 ]
    set_property -dict                              \
        [ list  CONFIG.C_AUX_RST_WIDTH {1}          \
                CONFIG.C_EXT_RST_WIDTH {1} ]        \
        $proc_sys_reset_1

    # Create port connections
    connect_bd_net -net RESET_ic_aresetn                        \
        [get_bd_pins ic_aresetn]                                \
        [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
    connect_bd_net -net RESET_ic_aresetn1                       \
        [get_bd_pins ic_aresetn1]                               \
        [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
    connect_bd_net -net processing_system7_1_fclk_clk0          \
        [get_bd_pins slowest_sync_clk]                          \
        [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
    connect_bd_net -net processing_system7_1_fclk_clk1          \
        [get_bd_pins slowest_sync_clk1]                         \
        [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
    connect_bd_net -net processing_system7_FCLK_RESET0_N        \
        [get_bd_pins ext_reset_in]                              \
        [get_bd_pins proc_sys_reset_0/ext_reset_in]             \
        [get_bd_pins proc_sys_reset_1/ext_reset_in]

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
    set DDR [                                           \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:ddrx_rtl:1.0     \
        DDR ]
    set FIXED_IO [                                      \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 \
        FIXED_IO ]

    set sfp [                                          \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:sfp_rtl:1.0      \
        sfp ]

    set mgt_in [                                       \
        create_bd_intf_port                             \
            -mode Slave                                 \
            -vlnv xilinx.com:interface:diff_clock_rtl:1.0 \
        mgt_in ]

    # Create a const val '1'
    set const_val1 [                                    \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:xlconstant:1.1          \
        xlconstant_val1 ]

    # Create a const val '0'
    set const2_val0 [                                   \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:xlconstant:1.1          \
        xlconstant2_val0 ]
    set_property CONFIG.CONST_VAL {0} $const2_val0

    create_bd_port -dir O -type data sfp_tx_disable_out

    connect_bd_net                                      \
        [get_bd_pins xlconstant2_val0/dout]             \
        [get_bd_ports sfp_tx_disable_out]

    # Create instance: RESET_BLOCK
    create_hier_cell_RESET_BLOCK [current_bd_instance .] RESET_BLOCK

    set sfp_dma [                                      \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_dma:7.1             \
        sfp_dma ]
    set_property -dict [                                \
        list    CONFIG.c_include_mm2s_dre {1}           \
                CONFIG.c_include_s2mm_dre {1}           \
                CONFIG.c_sg_use_stsapp_length {1} ]     \
        $sfp_dma

    # Create instance: axi_ethernet, and set properties
    set axi_ethernet_sfp [                             \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_ethernet:7.1        \
        axi_ethernet_sfp ]
    set_property -dict [                                \
        list    CONFIG.PHY_TYPE {1000BaseX}             \
                CONFIG.SupportLevel {1}]                \
        $axi_ethernet_sfp

    # Create instance: sfp_ic_HP, and set properties
    set sfp_ic_HP [                                     \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_interconnect:2.1    \
        sfp_ic_HP ]
    set_property -dict [                                \
        list    CONFIG.NUM_MI {1}                       \
                CONFIG.NUM_SI {6}                       \
                CONFIG.STRATEGY {2} ]                   \
        $sfp_ic_HP

    # Create instance: sfp_ic_GP, and set properties
    set sfp_ic_GP [                                     \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_interconnect:2.1    \
        sfp_ic_GP ]
    set_property CONFIG.NUM_MI {4} $sfp_ic_GP

    # Create instance: concat_intr, and set properties
    set concat_intr [                                   \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:xlconcat:2.1            \
        concat_intr ]
    set_property CONFIG.NUM_PORTS {12} $concat_intr

    # Create instance: processing_system7, and set properties
    set processing_system7 [                            \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:processing_system7:5.5  \
        processing_system7 ]
    set_property -dict [                                \
        list    CONFIG.PCW_EN_CLK1_PORT {1}             \
                CONFIG.PCW_EN_CLK2_PORT {1}             \
                CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125}       \
                CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {75}        \
                CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200}       \
                CONFIG.PCW_IMPORT_BOARD_PRESET {None}   \
                CONFIG.PCW_IRQ_F2P_INTR {1}             \
                CONFIG.PCW_USE_FABRIC_INTERRUPT {1}     \
                CONFIG.PCW_USE_S_AXI_HP0 {0}            \
                CONFIG.PCW_USE_S_AXI_HP1 {1}            \
                CONFIG.PCW_USE_M_AXI_GP0 {0}            \
                CONFIG.PCW_USE_M_AXI_GP1 {1}            \
                CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}   \
                CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}   \
                CONFIG.PCW_NAND_PERIPHERAL_ENABLE {1}   \
                CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1}  \
                CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1}    \
                CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1}    \
                CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M8 HX-15E} \
                CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27}        \
                CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53}     \
                CONFIG.PCW_SD0_GRP_CD_ENABLE {1}        \
                CONFIG.PCW_SD0_GRP_CD_IO {MIO 47}       \
                CONFIG.PCW_SD0_GRP_WP_ENABLE {1}        \
                CONFIG.PCW_SD0_GRP_WP_IO {MIO 46}       \
                CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0}  \
                CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} ]\
        $processing_system7

    # Create interface connections
    #SFP_ETH0
    connect_bd_intf_net -intf_net sfp_dma_m_axi_sg     \
        [get_bd_intf_pins sfp_dma/M_AXI_SG]            \
        [get_bd_intf_pins sfp_ic_HP/S00_AXI]
    connect_bd_intf_net -intf_net sfp_dma_m_axi_mm2s   \
        [get_bd_intf_pins sfp_dma/M_AXI_MM2S]          \
        [get_bd_intf_pins sfp_ic_HP/S01_AXI]
    connect_bd_intf_net -intf_net sfp_dma_m_axi_s2mm   \
        [get_bd_intf_pins sfp_dma/M_AXI_S2MM]          \
        [get_bd_intf_pins sfp_ic_HP/S02_AXI]
    connect_bd_intf_net -intf_net sfp_dma_m_axis_mm2s  \
        [get_bd_intf_pins sfp_dma/M_AXIS_MM2S]         \
        [get_bd_intf_pins axi_ethernet_sfp/s_axis_txd]
    connect_bd_intf_net -intf_net sfp_dma_m_axis_cntrl \
        [get_bd_intf_pins sfp_dma/M_AXIS_CNTRL]        \
        [get_bd_intf_pins axi_ethernet_sfp/s_axis_txc]

    connect_bd_intf_net -intf_net axi_ethernet_sfp_axis_rxd \
        [get_bd_intf_pins axi_ethernet_sfp/m_axis_rxd] \
        [get_bd_intf_pins sfp_dma/S_AXIS_S2MM]
    connect_bd_intf_net -intf_net axi_ethernet_sfp_axis_rxs \
        [get_bd_intf_pins axi_ethernet_sfp/m_axis_rxs] \
        [get_bd_intf_pins sfp_dma/S_AXIS_STS]
    connect_bd_intf_net -intf_net axi_ethernet5_sfp    \
        [get_bd_intf_ports sfp]                        \
        [get_bd_intf_pins axi_ethernet_sfp/sfp]
    connect_bd_net -net xlconstant_val1_dout            \
        [get_bd_pins axi_ethernet_sfp/signal_detect]   \
        [get_bd_pins xlconstant_val1/dout]

    # ic_HP Master ports
    connect_bd_intf_net -intf_net sfp_ic_HP_M00_AXI     \
        [get_bd_intf_pins sfp_ic_HP/M00_AXI]            \
        [get_bd_intf_pins processing_system7/S_AXI_HP1]

    #sfp_ic_GP
    connect_bd_intf_net -intf_net sfp_ic_GP_M00_AXI     \
        [get_bd_intf_pins sfp_ic_GP/M00_AXI]            \
        [get_bd_intf_pins sfp_dma/S_AXI_LITE]
    connect_bd_intf_net -intf_net sfp_ic_GP_M01_AXI     \
        [get_bd_intf_pins sfp_ic_GP/M01_AXI]            \
        [get_bd_intf_pins axi_ethernet_sfp/s_axi]

    # ARM processor
    connect_bd_intf_net -intf_net processing_system7_1_ddr          \
        [get_bd_intf_ports DDR]                                     \
        [get_bd_intf_pins processing_system7/DDR]
    connect_bd_intf_net -intf_net processing_system7_1_fixed_io     \
        [get_bd_intf_ports FIXED_IO]                                \
        [get_bd_intf_pins processing_system7/FIXED_IO]
    connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp1    \
        [get_bd_intf_pins processing_system7/M_AXI_GP1]             \
        [get_bd_intf_pins sfp_ic_GP/S00_AXI]

    # interrupts
    connect_bd_net -net sfp_dma_s2mm_introut           \
        [get_bd_pins sfp_dma/s2mm_introut]             \
        [get_bd_pins concat_intr/In6]
    connect_bd_net -net sfp_dma_mm2s_introut           \
        [get_bd_pins sfp_dma/mm2s_introut]             \
        [get_bd_pins concat_intr/In7]
    connect_bd_net -net axi_ethernet_sfp_interrupt     \
        [get_bd_pins axi_ethernet_sfp/interrupt]       \
        [get_bd_pins concat_intr/In8]

    # RESET
    connect_bd_net -net sfp_dma_mm2s_prmry_reset_out_n \
        [get_bd_pins sfp_dma/mm2s_prmry_reset_out_n]   \
        [get_bd_pins axi_ethernet_sfp/axi_txd_arstn]
    connect_bd_net -net sfp_dma_mm2s_cntrl_reset_out_n \
        [get_bd_pins sfp_dma/mm2s_cntrl_reset_out_n]   \
        [get_bd_pins axi_ethernet_sfp/axi_txc_arstn]
    connect_bd_net -net sfp_dma_s2mm_prmry_reset_out_n \
        [get_bd_pins sfp_dma/s2mm_prmry_reset_out_n]   \
        [get_bd_pins axi_ethernet_sfp/axi_rxd_arstn]
    connect_bd_net -net sfp_dma_s2mm_sts_reset_out_n   \
        [get_bd_pins sfp_dma/s2mm_sts_reset_out_n]     \
        [get_bd_pins axi_ethernet_sfp/axi_rxs_arstn]

    connect_bd_net -net processing_system7_FCLK_RESET0_N\
        [get_bd_pins processing_system7/FCLK_RESET0_N]  \
        [get_bd_pins RESET_BLOCK/ext_reset_in]
    connect_bd_net -net RESET_BLOCK_ic_aresetn          \
        [get_bd_pins RESET_BLOCK/ic_aresetn]            \
        [get_bd_pins sfp_ic_HP/ARESETN]                 \
        [get_bd_pins sfp_ic_HP/M00_ARESETN]             \
        [get_bd_pins sfp_ic_HP/S00_ARESETN]             \
        [get_bd_pins sfp_ic_HP/S01_ARESETN]             \
        [get_bd_pins sfp_ic_HP/S02_ARESETN]             \
        [get_bd_pins sfp_ic_HP/S03_ARESETN]             \
        [get_bd_pins sfp_ic_HP/S04_ARESETN]             \
        [get_bd_pins sfp_ic_HP/S05_ARESETN]
    connect_bd_net -net RESET_BLOCK_ic_aresetn1         \
        [get_bd_pins RESET_BLOCK/ic_aresetn1]           \
        [get_bd_pins sfp_dma/axi_resetn]               \
        [get_bd_pins axi_ethernet_sfp/s_axi_lite_resetn] \
        [get_bd_pins sfp_ic_GP/ARESETN]                 \
        [get_bd_pins sfp_ic_GP/S00_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M00_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M01_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M02_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M03_ARESETN]

    connect_bd_net -net concat_intr_dout                \
        [get_bd_pins concat_intr/dout]                  \
        [get_bd_pins processing_system7/IRQ_F2P]

    # clock
    connect_bd_net -net processing_system7_1_fclk_clk0  \
        [get_bd_pins processing_system7/FCLK_CLK0]      \
        [get_bd_pins processing_system7/S_AXI_HP1_ACLK] \
        [get_bd_pins RESET_BLOCK/slowest_sync_clk]      \
        [get_bd_pins sfp_dma/m_axi_sg_aclk]             \
        [get_bd_pins sfp_dma/m_axi_mm2s_aclk]           \
        [get_bd_pins sfp_dma/m_axi_s2mm_aclk]           \
        [get_bd_pins axi_ethernet_sfp/axis_clk]         \
        [get_bd_pins sfp_ic_HP/ACLK]                    \
        [get_bd_pins sfp_ic_HP/M00_ACLK]                \
        [get_bd_pins sfp_ic_HP/S00_ACLK]                \
        [get_bd_pins sfp_ic_HP/S01_ACLK]                \
        [get_bd_pins sfp_ic_HP/S02_ACLK]                \
        [get_bd_pins sfp_ic_HP/S03_ACLK]                \
        [get_bd_pins sfp_ic_HP/S04_ACLK]                \
        [get_bd_pins sfp_ic_HP/S05_ACLK]
    connect_bd_net -net processing_system7_1_fclk_clk1  \
        [get_bd_pins processing_system7/FCLK_CLK1]      \
        [get_bd_pins processing_system7/M_AXI_GP1_ACLK] \
        [get_bd_pins RESET_BLOCK/slowest_sync_clk1]     \
        [get_bd_pins sfp_ic_GP/ACLK]                    \
        [get_bd_pins sfp_ic_GP/S00_ACLK]                \
        [get_bd_pins sfp_ic_GP/M00_ACLK]                \
        [get_bd_pins sfp_ic_GP/M01_ACLK]                \
        [get_bd_pins sfp_ic_GP/M02_ACLK]                \
        [get_bd_pins sfp_ic_GP/M03_ACLK]                \
        [get_bd_pins sfp_dma/s_axi_lite_aclk]           \
        [get_bd_pins axi_ethernet_sfp/s_axi_lite_clk]
    connect_bd_net -net processing_system7_1_fclk_clk2  \
        [get_bd_pins processing_system7/FCLK_CLK2]      \
        [get_bd_pins axi_ethernet_sfp/ref_clk]
    connect_bd_intf_net -intf_net mgt_in_clk            \
        [get_bd_intf_ports mgt_in]                      \
        [get_bd_intf_pins axi_ethernet_sfp/mgt_clk]

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


