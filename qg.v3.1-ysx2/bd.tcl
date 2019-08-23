# vim: sts=4 sw=4 et
set design_name QG_pl_eth

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

    set gmii0 [                                         \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:gmii_rtl:1.0     \
        gmii0 ]
    set gmii1 [                                         \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:gmii_rtl:1.0     \
        gmii1 ]
    set gmii2 [                                         \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:gmii_rtl:1.0     \
        gmii2 ]

    set mdio0 [                                         \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:mdio_rtl:1.0     \
        mdio0 ]
    set mdio1 [                                         \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:mdio_rtl:1.0     \
        mdio1 ]
    set mdio2 [                                         \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:mdio_rtl:1.0     \
        mdio2 ]

    set sfp0 [                                          \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:sfp_rtl:1.0      \
        sfp0 ]

    set sfp1 [                                          \
        create_bd_intf_port                             \
            -mode Master                                \
            -vlnv xilinx.com:interface:sfp_rtl:1.0      \
        sfp1 ]

    set phy_rst_n0 [                                    \
        create_bd_port                                  \
            -dir O                                      \
            -type rst                                   \
        phy_rst_n0 ]
    set phy_rst_n1 [                                    \
        create_bd_port                                  \
            -dir O                                      \
            -type rst                                   \
        phy_rst_n1 ]
    set phy_rst_n2 [                                    \
        create_bd_port                                  \
            -dir O                                      \
            -type rst                                   \
        phy_rst_n2 ]

    set gmii0_gtx_in [                                  \
        create_bd_port                                  \
            -dir I                                      \
            -type clk                                   \
        gmii0_gtx_in ]
    set_property CONFIG.FREQ_HZ 125000000 $gmii0_gtx_in
    set gmii1_gtx_in [                                  \
        create_bd_port                                  \
            -dir I                                      \
            -type clk                                   \
        gmii1_gtx_in ]
    set_property CONFIG.FREQ_HZ 125000000 $gmii1_gtx_in
    set gmii2_gtx_in [                                  \
        create_bd_port                                  \
            -dir I                                      \
            -type clk                                   \
        gmii2_gtx_in ]
    set_property CONFIG.FREQ_HZ 125000000 $gmii2_gtx_in

    set mgt0_in [                                       \
        create_bd_intf_port                             \
            -mode Slave                                 \
            -vlnv xilinx.com:interface:diff_clock_rtl:1.0 \
        mgt0_in ]

    #set mgt1_in [                                       \
        create_bd_intf_port                             \
            -mode Slave                                 \
            -vlnv xilinx.com:interface:diff_clock_rtl:1.0 \
        mgt1_in ]

    # Create a const val '1'
    set const_val1 [                                    \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:xlconstant:1.1          \
        xlconstant_val1 ]

    create_bd_port -dir O -type data clk_25M_out0
    create_bd_port -dir O -type data clk_25M_out1
    create_bd_port -dir O -type data clk_25M_out2

    # Create instance: clk_wiz & counter
    set clk_wiz_50M [                                   \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:clk_wiz:6.0             \
        clk_wiz_50M ]
    set_property -dict [                                \
        list    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50}  \
                CONFIG.USE_LOCKED {false}               \
                CONFIG.USE_RESET {false}                \
                CONFIG.MMCM_DIVCLK_DIVIDE {1}           \
                CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000}   \
                CONFIG.CLKOUT1_JITTER {151.636}]        \
        $clk_wiz_50M 

    set counter_25M [                                   \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:c_counter_binary:12.0   \
        counter_25M ]
    set_property CONFIG.Output_Width {1} $counter_25M

    connect_bd_net                                      \
        [get_bd_pins clk_wiz_50M/clk_out1]              \
        [get_bd_pins counter_25M/CLK]
    connect_bd_net                                      \
        [get_bd_pins counter_25M/Q]                     \
        [get_bd_ports clk_25M_out0]                     \
        [get_bd_ports clk_25M_out1]                     \
        [get_bd_ports clk_25M_out2]

    # Create a const val '1'
    set const2_val0 [                                    \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:xlconstant:1.1          \
        xlconstant2_val0 ]
    set_property CONFIG.CONST_VAL {0} $const2_val0

    create_bd_port -dir O -type data sfp0_disable_out
    create_bd_port -dir O -type data sfp1_disable_out

    connect_bd_net                                      \
        [get_bd_pins xlconstant2_val0/dout]             \
        [get_bd_ports sfp0_disable_out]                      \
        [get_bd_ports sfp1_disable_out]

    # Create instance: RESET_BLOCK
    create_hier_cell_RESET_BLOCK [current_bd_instance .] RESET_BLOCK

    # Create instance: gmii_dma, and set properties
    set gmii_dma0 [                                      \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_dma:7.1             \
        gmii_dma0 ]
    set_property -dict [                                \
        list    CONFIG.c_include_mm2s_dre {1}           \
                CONFIG.c_include_s2mm_dre {1}           \
                CONFIG.c_sg_use_stsapp_length {1} ]     \
        $gmii_dma0
    set gmii_dma1 [                                      \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_dma:7.1             \
        gmii_dma1 ]
    set_property -dict [                                \
        list    CONFIG.c_include_mm2s_dre {1}           \
                CONFIG.c_include_s2mm_dre {1}           \
                CONFIG.c_sg_use_stsapp_length {1} ]     \
        $gmii_dma1
    set gmii_dma2 [                                      \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_dma:7.1             \
        gmii_dma2 ]
    set_property -dict [                                \
        list    CONFIG.c_include_mm2s_dre {1}           \
                CONFIG.c_include_s2mm_dre {1}           \
                CONFIG.c_sg_use_stsapp_length {1} ]     \
        $gmii_dma2

    set sfp_dma0 [                                      \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_dma:7.1             \
        sfp_dma0 ]
    set_property -dict [                                \
        list    CONFIG.c_include_mm2s_dre {1}           \
                CONFIG.c_include_s2mm_dre {1}           \
                CONFIG.c_sg_use_stsapp_length {1} ]     \
        $sfp_dma0
    set sfp_dma1 [                                      \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_dma:7.1             \
        sfp_dma1 ]
    set_property -dict [                                \
        list    CONFIG.c_include_mm2s_dre {1}           \
                CONFIG.c_include_s2mm_dre {1}           \
                CONFIG.c_sg_use_stsapp_length {1} ]     \
        $sfp_dma1

    # Create instance: axi_eth_gmii/sfp, and set properties
    set axi_eth_gmii0 [                                 \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_ethernet:7.1        \
        axi_eth_gmii0 ]
    set_property -dict [                                \
        list    CONFIG.PHY_TYPE {GMII}                  \
                CONFIG.RXCSUM {Full}                    \
                CONFIG.RXMEM {16k}                      \
                CONFIG.TXCSUM {Full}                    \
                CONFIG.TXMEM {16k}                      \
                CONFIG.SupportLevel {0} ]               \
        $axi_eth_gmii0
    set axi_eth_gmii1 [                                 \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_ethernet:7.1        \
        axi_eth_gmii1 ]
    set_property -dict [                                \
        list    CONFIG.PHY_TYPE {GMII}                  \
                CONFIG.RXCSUM {Full}                    \
                CONFIG.RXMEM {16k}                      \
                CONFIG.TXCSUM {Full}                    \
                CONFIG.TXMEM {16k}                      \
                CONFIG.SupportLevel {0} ]               \
        $axi_eth_gmii1
    set axi_eth_gmii2 [                                 \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_ethernet:7.1        \
        axi_eth_gmii2 ]
    set_property -dict [                                \
        list    CONFIG.PHY_TYPE {GMII}                  \
                CONFIG.RXCSUM {Full}                    \
                CONFIG.RXMEM {16k}                      \
                CONFIG.TXCSUM {Full}                    \
                CONFIG.TXMEM {16k}                      \
                CONFIG.SupportLevel {0} ]               \
        $axi_eth_gmii2

    set axi_eth_sfp0 [                                  \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_ethernet:7.1        \
        axi_eth_sfp0 ]
    set_property -dict [                                \
        list    CONFIG.PHY_TYPE {1000BaseX}             \
                CONFIG.SupportLevel {1}]                \
        $axi_eth_sfp0
    set axi_eth_sfp1 [                                  \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_ethernet:7.1        \
        axi_eth_sfp1 ]
    set_property -dict [                                \
        list    CONFIG.PHY_TYPE {1000BaseX}             \
                CONFIG.SupportLevel {0}]                \
        $axi_eth_sfp1

    # Create instance: gmii_ic_HP & sfp_ic_HP, and set properties
    set gmii_ic_HP [                                     \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_interconnect:2.1    \
        gmii_ic_HP ]
    set_property -dict [                                \
        list    CONFIG.NUM_MI {1}                       \
                CONFIG.NUM_SI {9}                       \
                CONFIG.STRATEGY {2} ]                   \
        $gmii_ic_HP
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

    # Create instance: gmii_ic_GP & sfp_ic_GP, and set properties
    set gmii_ic_GP [                                     \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:axi_interconnect:2.1    \
        gmii_ic_GP ]
    set_property CONFIG.NUM_MI {6} $gmii_ic_GP
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
    set_property CONFIG.NUM_PORTS {15} $concat_intr

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
                CONFIG.PCW_USE_S_AXI_HP0 {1}            \
                CONFIG.PCW_USE_S_AXI_HP1 {1}            \
                CONFIG.PCW_USE_M_AXI_GP0 {1}            \
                CONFIG.PCW_USE_M_AXI_GP1 {1}            \
                CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V}   \
                CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}   \
                CONFIG.PCW_NAND_PERIPHERAL_ENABLE {1}   \
                CONFIG.PCW_NAND_CYCLES_T_RR {25}        \
                CONFIG.PCW_NAND_CYCLES_T_AR {15}        \
                CONFIG.PCW_NAND_CYCLES_T_CLR {15}       \
                CONFIG.PCW_NAND_CYCLES_T_WP {30}        \
                CONFIG.PCW_NAND_CYCLES_T_REA {20}       \
                CONFIG.PCW_NAND_CYCLES_T_WC {50}        \
                CONFIG.PCW_NAND_CYCLES_T_RC {50}        \
                CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1}   \
                CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51}  \
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

    # create axi_eth_idelay_ctrl
    set idelay_ctrl1 [                                  \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:util_idelay_ctrl:1.0    \
        idelay_ctrl1 ]
    # create NOT gate
    set not_gate1 [                                     \
        create_bd_cell                                  \
            -type ip                                    \
            -vlnv xilinx.com:ip:util_vector_logic:2.0   \
        not_gate1]
    set_property -dict [                                \
        list    CONFIG.C_SIZE {1}                       \
                CONFIG.C_OPERATION {not}                \
                CONFIG.LOGO_FILE {data/sym_notgate.png}]\
        $not_gate1
    connect_bd_net                                      \
        [get_bd_pins not_gate1/Op1]                     \
        [get_bd_pins RESET_BLOCK/ic_aresetn1]
    connect_bd_net                                      \
        [get_bd_pins not_gate1/Res]                     \
        [get_bd_pins idelay_ctrl1/rst]

    # Create interface connections
    #PLGE0
    connect_bd_intf_net -intf_net gmii_dma0_m_axi_sg     \
        [get_bd_intf_pins gmii_dma0/M_AXI_SG]            \
        [get_bd_intf_pins gmii_ic_HP/S00_AXI]
    connect_bd_intf_net -intf_net gmii_dma0_m_axi_mm2s   \
        [get_bd_intf_pins gmii_dma0/M_AXI_MM2S]          \
        [get_bd_intf_pins gmii_ic_HP/S01_AXI]
    connect_bd_intf_net -intf_net gmii_dma0_m_axi_s2mm   \
        [get_bd_intf_pins gmii_dma0/M_AXI_S2MM]          \
        [get_bd_intf_pins gmii_ic_HP/S02_AXI]
    connect_bd_intf_net -intf_net gmii_dma0_m_axis_mm2s  \
        [get_bd_intf_pins gmii_dma0/M_AXIS_MM2S]         \
        [get_bd_intf_pins axi_eth_gmii0/s_axis_txd]
    connect_bd_intf_net -intf_net gmii_dma0_m_axis_cntrl \
        [get_bd_intf_pins gmii_dma0/M_AXIS_CNTRL]        \
        [get_bd_intf_pins axi_eth_gmii0/s_axis_txc]

    connect_bd_intf_net -intf_net axi_eth_gmii0_axis_rxd\
        [get_bd_intf_pins axi_eth_gmii0/m_axis_rxd]     \
        [get_bd_intf_pins gmii_dma0/S_AXIS_S2MM]
    connect_bd_intf_net -intf_net axi_eth_gmii0_axis_rxs\
        [get_bd_intf_pins axi_eth_gmii0/m_axis_rxs]     \
        [get_bd_intf_pins gmii_dma0/S_AXIS_STS]
    connect_bd_intf_net -intf_net axi_eth_gmii0_gmii    \
        [get_bd_intf_pins axi_eth_gmii0/gmii]           \
        $gmii0
    connect_bd_intf_net -intf_net axi_eth_gmii0_mdio    \
        [get_bd_intf_pins axi_eth_gmii0/mdio]           \
        $mdio0

    #PLGE1
    connect_bd_intf_net -intf_net gmii_dma1_m_axi_sg     \
        [get_bd_intf_pins gmii_dma1/M_AXI_SG]            \
        [get_bd_intf_pins gmii_ic_HP/S03_AXI]
    connect_bd_intf_net -intf_net gmii_dma1_m_axi_mm2s   \
        [get_bd_intf_pins gmii_dma1/M_AXI_MM2S]          \
        [get_bd_intf_pins gmii_ic_HP/S04_AXI]
    connect_bd_intf_net -intf_net gmii_dma1_m_axi_s2mm   \
        [get_bd_intf_pins gmii_dma1/M_AXI_S2MM]          \
        [get_bd_intf_pins gmii_ic_HP/S05_AXI]
    connect_bd_intf_net -intf_net gmii_dma1_m_axis_mm2s  \
        [get_bd_intf_pins gmii_dma1/M_AXIS_MM2S]         \
        [get_bd_intf_pins axi_eth_gmii1/s_axis_txd]
    connect_bd_intf_net -intf_net gmii_dma1_m_axis_cntrl \
        [get_bd_intf_pins gmii_dma1/M_AXIS_CNTRL]        \
        [get_bd_intf_pins axi_eth_gmii1/s_axis_txc]

    connect_bd_intf_net -intf_net axi_eth_gmii1_axis_rxd\
        [get_bd_intf_pins axi_eth_gmii1/m_axis_rxd]     \
        [get_bd_intf_pins gmii_dma1/S_AXIS_S2MM]
    connect_bd_intf_net -intf_net axi_eth_gmii1_axis_rxs\
        [get_bd_intf_pins axi_eth_gmii1/m_axis_rxs]     \
        [get_bd_intf_pins gmii_dma1/S_AXIS_STS]
    connect_bd_intf_net -intf_net axi_eth_gmii1_gmii    \
        [get_bd_intf_pins axi_eth_gmii1/gmii]           \
        $gmii1
    connect_bd_intf_net -intf_net axi_eth_gmii1_mdio    \
        [get_bd_intf_pins axi_eth_gmii1/mdio]           \
        $mdio1

    #PLGE2
    connect_bd_intf_net -intf_net gmii_dma2_m_axi_sg     \
        [get_bd_intf_pins gmii_dma2/M_AXI_SG]            \
        [get_bd_intf_pins gmii_ic_HP/S06_AXI]
    connect_bd_intf_net -intf_net gmii_dma2_m_axi_mm2s   \
        [get_bd_intf_pins gmii_dma2/M_AXI_MM2S]          \
        [get_bd_intf_pins gmii_ic_HP/S07_AXI]
    connect_bd_intf_net -intf_net gmii_dma2_m_axi_s2mm   \
        [get_bd_intf_pins gmii_dma2/M_AXI_S2MM]          \
        [get_bd_intf_pins gmii_ic_HP/S08_AXI]
    connect_bd_intf_net -intf_net gmii_dma2_m_axis_mm2s  \
        [get_bd_intf_pins gmii_dma2/M_AXIS_MM2S]         \
        [get_bd_intf_pins axi_eth_gmii2/s_axis_txd]
    connect_bd_intf_net -intf_net gmii_dma2_m_axis_cntrl \
        [get_bd_intf_pins gmii_dma2/M_AXIS_CNTRL]        \
        [get_bd_intf_pins axi_eth_gmii2/s_axis_txc]

    connect_bd_intf_net -intf_net axi_eth_gmii2_axis_rxd\
        [get_bd_intf_pins axi_eth_gmii2/m_axis_rxd]     \
        [get_bd_intf_pins gmii_dma2/S_AXIS_S2MM]
    connect_bd_intf_net -intf_net axi_eth_gmii2_axis_rxs\
        [get_bd_intf_pins axi_eth_gmii2/m_axis_rxs]     \
        [get_bd_intf_pins gmii_dma2/S_AXIS_STS]
    connect_bd_intf_net -intf_net axi_eth_gmii2_gmii    \
        [get_bd_intf_pins axi_eth_gmii2/gmii]           \
        $gmii2
    connect_bd_intf_net -intf_net axi_eth_gmii2_mdio    \
        [get_bd_intf_pins axi_eth_gmii2/mdio]           \
        $mdio2

    #SFP0
    connect_bd_intf_net -intf_net sfp_dma0_m_axi_sg     \
        [get_bd_intf_pins sfp_dma0/M_AXI_SG]            \
        [get_bd_intf_pins sfp_ic_HP/S00_AXI]
    connect_bd_intf_net -intf_net sfp_dma0_m_axi_mm2s   \
        [get_bd_intf_pins sfp_dma0/M_AXI_MM2S]          \
        [get_bd_intf_pins sfp_ic_HP/S01_AXI]
    connect_bd_intf_net -intf_net sfp_dma0_m_axi_s2mm   \
        [get_bd_intf_pins sfp_dma0/M_AXI_S2MM]          \
        [get_bd_intf_pins sfp_ic_HP/S02_AXI]
    connect_bd_intf_net -intf_net sfp_dma0_m_axis_mm2s  \
        [get_bd_intf_pins sfp_dma0/M_AXIS_MM2S]         \
        [get_bd_intf_pins axi_eth_sfp0/s_axis_txd]
    connect_bd_intf_net -intf_net sfp_dma0_m_axis_cntrl \
        [get_bd_intf_pins sfp_dma0/M_AXIS_CNTRL]        \
        [get_bd_intf_pins axi_eth_sfp0/s_axis_txc]

    connect_bd_intf_net -intf_net axi_eth_sfp0_axis_rxd \
        [get_bd_intf_pins axi_eth_sfp0/m_axis_rxd] \
        [get_bd_intf_pins sfp_dma0/S_AXIS_S2MM]
    connect_bd_intf_net -intf_net axi_eth_sfp0_axis_rxs \
        [get_bd_intf_pins axi_eth_sfp0/m_axis_rxs] \
        [get_bd_intf_pins sfp_dma0/S_AXIS_STS]
    connect_bd_intf_net -intf_net axi_eth_sfp0_sfp   \
        [get_bd_intf_ports sfp0]                        \
        [get_bd_intf_pins axi_eth_sfp0/sfp]
    connect_bd_net -net xlconstant_val1_dout            \
        [get_bd_pins axi_eth_sfp0/signal_detect]   \
        [get_bd_pins xlconstant_val1/dout]

    #SFP1
    connect_bd_intf_net -intf_net sfp_dma1_m_axi_sg     \
        [get_bd_intf_pins sfp_dma1/M_AXI_SG]            \
        [get_bd_intf_pins sfp_ic_HP/S03_AXI]
    connect_bd_intf_net -intf_net sfp_dma1_m_axi_mm2s   \
        [get_bd_intf_pins sfp_dma1/M_AXI_MM2S]          \
        [get_bd_intf_pins sfp_ic_HP/S04_AXI]
    connect_bd_intf_net -intf_net sfp_dma1_m_axi_s2mm   \
        [get_bd_intf_pins sfp_dma1/M_AXI_S2MM]          \
        [get_bd_intf_pins sfp_ic_HP/S05_AXI]
    connect_bd_intf_net -intf_net sfp_dma1_m_axis_mm2s  \
        [get_bd_intf_pins sfp_dma1/M_AXIS_MM2S]         \
        [get_bd_intf_pins axi_eth_sfp1/s_axis_txd]
    connect_bd_intf_net -intf_net sfp_dma1_m_axis_cntrl \
        [get_bd_intf_pins sfp_dma1/M_AXIS_CNTRL]        \
        [get_bd_intf_pins axi_eth_sfp1/s_axis_txc]

    connect_bd_intf_net -intf_net axi_eth_sfp1_axis_rxd \
        [get_bd_intf_pins axi_eth_sfp1/m_axis_rxd]      \
        [get_bd_intf_pins sfp_dma1/S_AXIS_S2MM]
    connect_bd_intf_net -intf_net axi_eth_sfp1_axis_rxs \
        [get_bd_intf_pins axi_eth_sfp1/m_axis_rxs]      \
        [get_bd_intf_pins sfp_dma1/S_AXIS_STS]
    connect_bd_intf_net -intf_net axi_eth_sfp1_sfp      \
        [get_bd_intf_ports sfp1]                        \
        [get_bd_intf_pins axi_eth_sfp1/sfp]
    connect_bd_net -net xlconstant_val1_dout            \
        [get_bd_pins axi_eth_sfp1/signal_detect]        \
        [get_bd_pins xlconstant_val1/dout]

    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/mmcm_locked_out]      \
        [get_bd_pins axi_eth_sfp1/mmcm_locked]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/rxuserclk_out]        \
        [get_bd_pins axi_eth_sfp1/rxuserclk]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/rxuserclk2_out]       \
        [get_bd_pins axi_eth_sfp1/rxuserclk2]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/pma_reset_out]        \
        [get_bd_pins axi_eth_sfp1/pma_reset]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/userclk_out]          \
        [get_bd_pins axi_eth_sfp1/userclk]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/userclk2_out]         \
        [get_bd_pins axi_eth_sfp1/userclk2]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/gt0_qplloutclk_out]   \
        [get_bd_pins axi_eth_sfp1/gt0_qplloutclk_in]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/gt0_qplloutrefclk_out]\
        [get_bd_pins axi_eth_sfp1/gt0_qplloutrefclk_in]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/gtref_clk_out]        \
        [get_bd_pins axi_eth_sfp1/gtref_clk]
    connect_bd_net                                      \
        [get_bd_pins axi_eth_sfp0/gtref_clk_buf_out]    \
        [get_bd_pins axi_eth_sfp1/gtref_clk_buf]

    # ic_HP Master ports
    connect_bd_intf_net -intf_net gmii_ic_HP_M00_AXI     \
        [get_bd_intf_pins gmii_ic_HP/M00_AXI]            \
        [get_bd_intf_pins processing_system7/S_AXI_HP0]
    connect_bd_intf_net -intf_net sfp_ic_HP_M00_AXI     \
        [get_bd_intf_pins sfp_ic_HP/M00_AXI]            \
        [get_bd_intf_pins processing_system7/S_AXI_HP1]


    #gmii_ic_GP
    connect_bd_intf_net -intf_net gmii_ic_GP_M00_AXI     \
        [get_bd_intf_pins gmii_ic_GP/M00_AXI]            \
        [get_bd_intf_pins gmii_dma0/S_AXI_LITE]
    connect_bd_intf_net -intf_net gmii_ic_GP_M01_AXI     \
        [get_bd_intf_pins gmii_ic_GP/M01_AXI]            \
        [get_bd_intf_pins axi_eth_gmii0/s_axi]
    connect_bd_intf_net -intf_net gmii_ic_GP_M02_AXI     \
        [get_bd_intf_pins gmii_ic_GP/M02_AXI]            \
        [get_bd_intf_pins gmii_dma1/S_AXI_LITE]
    connect_bd_intf_net -intf_net gmii_ic_GP_M03_AXI     \
        [get_bd_intf_pins gmii_ic_GP/M03_AXI]            \
        [get_bd_intf_pins axi_eth_gmii1/s_axi]
    connect_bd_intf_net -intf_net gmii_ic_GP_M04_AXI     \
        [get_bd_intf_pins gmii_ic_GP/M04_AXI]            \
        [get_bd_intf_pins gmii_dma2/S_AXI_LITE]
    connect_bd_intf_net -intf_net gmii_ic_GP_M05_AXI     \
        [get_bd_intf_pins gmii_ic_GP/M05_AXI]            \
        [get_bd_intf_pins axi_eth_gmii2/s_axi]
    #sfp_ic_GP
    connect_bd_intf_net -intf_net sfp_ic_GP_M00_AXI     \
        [get_bd_intf_pins sfp_ic_GP/M00_AXI]            \
        [get_bd_intf_pins sfp_dma0/S_AXI_LITE]
    connect_bd_intf_net -intf_net sfp_ic_GP_M01_AXI     \
        [get_bd_intf_pins sfp_ic_GP/M01_AXI]            \
        [get_bd_intf_pins axi_eth_sfp0/s_axi]
    connect_bd_intf_net -intf_net sfp_ic_GP_M02_AXI     \
        [get_bd_intf_pins sfp_ic_GP/M02_AXI]            \
        [get_bd_intf_pins sfp_dma1/S_AXI_LITE]
    connect_bd_intf_net -intf_net sfp_ic_GP_M03_AXI     \
        [get_bd_intf_pins sfp_ic_GP/M03_AXI]            \
        [get_bd_intf_pins axi_eth_sfp1/s_axi]

    # ARM processor
    connect_bd_intf_net -intf_net processing_system7_1_ddr          \
        [get_bd_intf_ports DDR]                                     \
        [get_bd_intf_pins processing_system7/DDR]
    connect_bd_intf_net -intf_net processing_system7_1_fixed_io     \
        [get_bd_intf_ports FIXED_IO]                                \
        [get_bd_intf_pins processing_system7/FIXED_IO]
    connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp0    \
        [get_bd_intf_pins processing_system7/M_AXI_GP0]             \
        [get_bd_intf_pins gmii_ic_GP/S00_AXI]
    connect_bd_intf_net -intf_net processing_system7_1_m_axi_gp1    \
        [get_bd_intf_pins processing_system7/M_AXI_GP1]             \
        [get_bd_intf_pins sfp_ic_GP/S00_AXI]

    # interrupts
    connect_bd_net -net gmii_dma0_s2mm_introut           \
        [get_bd_pins gmii_dma0/s2mm_introut]             \
        [get_bd_pins concat_intr/In0]
    connect_bd_net -net gmii_dma0_mm2s_introut           \
        [get_bd_pins gmii_dma0/mm2s_introut]             \
        [get_bd_pins concat_intr/In1]
    connect_bd_net -net axi_eth_gmii0_interrupt         \
        [get_bd_pins axi_eth_gmii0/interrupt]           \
        [get_bd_pins concat_intr/In2]

    connect_bd_net -net gmii_dma1_s2mm_introut           \
        [get_bd_pins gmii_dma1/s2mm_introut]             \
        [get_bd_pins concat_intr/In3]
    connect_bd_net -net gmii_dma1_mm2s_introut           \
        [get_bd_pins gmii_dma1/mm2s_introut]             \
        [get_bd_pins concat_intr/In4]
    connect_bd_net -net axi_eth_gmii1_interrupt         \
        [get_bd_pins axi_eth_gmii1/interrupt]           \
        [get_bd_pins concat_intr/In5]

    connect_bd_net -net gmii_dma2_s2mm_introut           \
        [get_bd_pins gmii_dma2/s2mm_introut]             \
        [get_bd_pins concat_intr/In6]
    connect_bd_net -net gmii_dma2_mm2s_introut           \
        [get_bd_pins gmii_dma2/mm2s_introut]             \
        [get_bd_pins concat_intr/In7]
    connect_bd_net -net axi_eth_gmii2_interrupt         \
        [get_bd_pins axi_eth_gmii2/interrupt]           \
        [get_bd_pins concat_intr/In8]

    connect_bd_net -net sfp_dma0_s2mm_introut           \
        [get_bd_pins sfp_dma0/s2mm_introut]             \
        [get_bd_pins concat_intr/In9]
    connect_bd_net -net sfp_dma0_mm2s_introut           \
        [get_bd_pins sfp_dma0/mm2s_introut]             \
        [get_bd_pins concat_intr/In10]
    connect_bd_net -net axi_eth_sfp0_interrupt          \
        [get_bd_pins axi_eth_sfp0/interrupt]            \
        [get_bd_pins concat_intr/In11]

    connect_bd_net -net sfp_dma1_s2mm_introut           \
        [get_bd_pins sfp_dma1/s2mm_introut]             \
        [get_bd_pins concat_intr/In12]
    connect_bd_net -net sfp_dma1_mm2s_introut           \
        [get_bd_pins sfp_dma1/mm2s_introut]             \
        [get_bd_pins concat_intr/In13]
    connect_bd_net -net axi_eth_sfp1_interrupt          \
        [get_bd_pins axi_eth_sfp1/interrupt]            \
        [get_bd_pins concat_intr/In14]

    # RESET
    connect_bd_net -net gmii_dma0_mm2s_prmry_reset_out_n \
        [get_bd_pins gmii_dma0/mm2s_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_gmii0/axi_txd_arstn]
    connect_bd_net -net gmii_dma0_mm2s_cntrl_reset_out_n \
        [get_bd_pins gmii_dma0/mm2s_cntrl_reset_out_n]   \
        [get_bd_pins axi_eth_gmii0/axi_txc_arstn]
    connect_bd_net -net gmii_dma0_s2mm_prmry_reset_out_n \
        [get_bd_pins gmii_dma0/s2mm_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_gmii0/axi_rxd_arstn]
    connect_bd_net -net gmii_dma0_s2mm_sts_reset_out_n   \
        [get_bd_pins gmii_dma0/s2mm_sts_reset_out_n]     \
        [get_bd_pins axi_eth_gmii0/axi_rxs_arstn]

    connect_bd_net -net gmii_dma1_mm2s_prmry_reset_out_n \
        [get_bd_pins gmii_dma1/mm2s_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_gmii1/axi_txd_arstn]
    connect_bd_net -net gmii_dma1_mm2s_cntrl_reset_out_n \
        [get_bd_pins gmii_dma1/mm2s_cntrl_reset_out_n]   \
        [get_bd_pins axi_eth_gmii1/axi_txc_arstn]
    connect_bd_net -net gmii_dma1_s2mm_prmry_reset_out_n \
        [get_bd_pins gmii_dma1/s2mm_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_gmii1/axi_rxd_arstn]
    connect_bd_net -net gmii_dma1_s2mm_sts_reset_out_n   \
        [get_bd_pins gmii_dma1/s2mm_sts_reset_out_n]     \
        [get_bd_pins axi_eth_gmii1/axi_rxs_arstn]

    connect_bd_net -net gmii_dma2_mm2s_prmry_reset_out_n \
        [get_bd_pins gmii_dma2/mm2s_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_gmii2/axi_txd_arstn]
    connect_bd_net -net gmii_dma2_mm2s_cntrl_reset_out_n \
        [get_bd_pins gmii_dma2/mm2s_cntrl_reset_out_n]   \
        [get_bd_pins axi_eth_gmii2/axi_txc_arstn]
    connect_bd_net -net gmii_dma2_s2mm_prmry_reset_out_n \
        [get_bd_pins gmii_dma2/s2mm_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_gmii2/axi_rxd_arstn]
    connect_bd_net -net gmii_dma2_s2mm_sts_reset_out_n   \
        [get_bd_pins gmii_dma2/s2mm_sts_reset_out_n]     \
        [get_bd_pins axi_eth_gmii2/axi_rxs_arstn]

    connect_bd_net -net sfp_dma0_mm2s_prmry_reset_out_n \
        [get_bd_pins sfp_dma0/mm2s_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_sfp0/axi_txd_arstn]
    connect_bd_net -net sfp_dma0_mm2s_cntrl_reset_out_n \
        [get_bd_pins sfp_dma0/mm2s_cntrl_reset_out_n]   \
        [get_bd_pins axi_eth_sfp0/axi_txc_arstn]
    connect_bd_net -net sfp_dma0_s2mm_prmry_reset_out_n \
        [get_bd_pins sfp_dma0/s2mm_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_sfp0/axi_rxd_arstn]
    connect_bd_net -net sfp_dma0_s2mm_sts_reset_out_n   \
        [get_bd_pins sfp_dma0/s2mm_sts_reset_out_n]     \
        [get_bd_pins axi_eth_sfp0/axi_rxs_arstn]

    connect_bd_net -net sfp_dma1_mm2s_prmry_reset_out_n \
        [get_bd_pins sfp_dma1/mm2s_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_sfp1/axi_txd_arstn]
    connect_bd_net -net sfp_dma1_mm2s_cntrl_reset_out_n \
        [get_bd_pins sfp_dma1/mm2s_cntrl_reset_out_n]   \
        [get_bd_pins axi_eth_sfp1/axi_txc_arstn]
    connect_bd_net -net sfp_dma1_s2mm_prmry_reset_out_n \
        [get_bd_pins sfp_dma1/s2mm_prmry_reset_out_n]   \
        [get_bd_pins axi_eth_sfp1/axi_rxd_arstn]
    connect_bd_net -net sfp_dma1_s2mm_sts_reset_out_n   \
        [get_bd_pins sfp_dma1/s2mm_sts_reset_out_n]     \
        [get_bd_pins axi_eth_sfp1/axi_rxs_arstn]

    connect_bd_net -net processing_system7_FCLK_RESET0_N\
        [get_bd_pins processing_system7/FCLK_RESET0_N]  \
        [get_bd_pins RESET_BLOCK/ext_reset_in]
    connect_bd_net -net RESET_BLOCK_ic_aresetn          \
        [get_bd_pins RESET_BLOCK/ic_aresetn]            \
        [get_bd_pins gmii_ic_HP/ARESETN]                \
        [get_bd_pins gmii_ic_HP/M00_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S00_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S01_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S02_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S03_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S04_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S05_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S06_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S07_ARESETN]            \
        [get_bd_pins gmii_ic_HP/S08_ARESETN]            \
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
        [get_bd_pins gmii_dma0/axi_resetn]              \
        [get_bd_pins axi_eth_gmii0/s_axi_lite_resetn]   \
        [get_bd_pins gmii_dma1/axi_resetn]              \
        [get_bd_pins axi_eth_gmii1/s_axi_lite_resetn]   \
        [get_bd_pins gmii_dma2/axi_resetn]              \
        [get_bd_pins axi_eth_gmii2/s_axi_lite_resetn]   \
        [get_bd_pins sfp_dma0/axi_resetn]               \
        [get_bd_pins axi_eth_sfp0/s_axi_lite_resetn]    \
        [get_bd_pins sfp_dma1/axi_resetn]               \
        [get_bd_pins axi_eth_sfp1/s_axi_lite_resetn]    \
        [get_bd_pins gmii_ic_GP/ARESETN]                \
        [get_bd_pins gmii_ic_GP/S00_ARESETN]            \
        [get_bd_pins gmii_ic_GP/M00_ARESETN]            \
        [get_bd_pins gmii_ic_GP/M01_ARESETN]            \
        [get_bd_pins gmii_ic_GP/M02_ARESETN]            \
        [get_bd_pins gmii_ic_GP/M03_ARESETN]            \
        [get_bd_pins gmii_ic_GP/M04_ARESETN]            \
        [get_bd_pins gmii_ic_GP/M05_ARESETN]            \
        [get_bd_pins sfp_ic_GP/ARESETN]                 \
        [get_bd_pins sfp_ic_GP/S00_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M00_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M01_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M02_ARESETN]             \
        [get_bd_pins sfp_ic_GP/M03_ARESETN]

    connect_bd_net -net concat_intr_dout                \
        [get_bd_pins concat_intr/dout]                  \
        [get_bd_pins processing_system7/IRQ_F2P]
    connect_bd_net -net phy_rst_n0                      \
        [get_bd_ports phy_rst_n0]                       \
        [get_bd_pins axi_eth_gmii0/phy_rst_n]
    connect_bd_net -net phy_rst_n1                      \
        [get_bd_ports phy_rst_n1]                       \
        [get_bd_pins axi_eth_gmii1/phy_rst_n]
    connect_bd_net -net phy_rst_n2                      \
        [get_bd_ports phy_rst_n2]                       \
        [get_bd_pins axi_eth_gmii2/phy_rst_n]

    # clock
    connect_bd_net -net processing_system7_1_fclk_clk0  \
        [get_bd_pins processing_system7/FCLK_CLK0]      \
        [get_bd_pins processing_system7/S_AXI_HP0_ACLK] \
        [get_bd_pins processing_system7/S_AXI_HP1_ACLK] \
        [get_bd_pins RESET_BLOCK/slowest_sync_clk]      \
        [get_bd_pins gmii_dma0/m_axi_sg_aclk]           \
        [get_bd_pins gmii_dma0/m_axi_mm2s_aclk]         \
        [get_bd_pins gmii_dma0/m_axi_s2mm_aclk]         \
        [get_bd_pins axi_eth_gmii0/axis_clk]            \
        [get_bd_pins gmii_dma1/m_axi_sg_aclk]           \
        [get_bd_pins gmii_dma1/m_axi_mm2s_aclk]         \
        [get_bd_pins gmii_dma1/m_axi_s2mm_aclk]         \
        [get_bd_pins axi_eth_gmii1/axis_clk]            \
        [get_bd_pins gmii_dma2/m_axi_sg_aclk]           \
        [get_bd_pins gmii_dma2/m_axi_mm2s_aclk]         \
        [get_bd_pins gmii_dma2/m_axi_s2mm_aclk]         \
        [get_bd_pins axi_eth_gmii2/axis_clk]            \
        [get_bd_pins sfp_dma0/m_axi_sg_aclk]            \
        [get_bd_pins sfp_dma0/m_axi_mm2s_aclk]          \
        [get_bd_pins sfp_dma0/m_axi_s2mm_aclk]          \
        [get_bd_pins axi_eth_sfp0/axis_clk]             \
        [get_bd_pins sfp_dma1/m_axi_sg_aclk]            \
        [get_bd_pins sfp_dma1/m_axi_mm2s_aclk]          \
        [get_bd_pins sfp_dma1/m_axi_s2mm_aclk]          \
        [get_bd_pins axi_eth_sfp1/axis_clk]             \
        [get_bd_pins gmii_ic_HP/ACLK]                   \
        [get_bd_pins gmii_ic_HP/M00_ACLK]               \
        [get_bd_pins gmii_ic_HP/S00_ACLK]               \
        [get_bd_pins gmii_ic_HP/S01_ACLK]               \
        [get_bd_pins gmii_ic_HP/S02_ACLK]               \
        [get_bd_pins gmii_ic_HP/S03_ACLK]               \
        [get_bd_pins gmii_ic_HP/S04_ACLK]               \
        [get_bd_pins gmii_ic_HP/S05_ACLK]               \
        [get_bd_pins gmii_ic_HP/S06_ACLK]               \
        [get_bd_pins gmii_ic_HP/S07_ACLK]               \
        [get_bd_pins gmii_ic_HP/S08_ACLK]               \
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
        [get_bd_pins processing_system7/M_AXI_GP0_ACLK] \
        [get_bd_pins processing_system7/M_AXI_GP1_ACLK] \
        [get_bd_pins RESET_BLOCK/slowest_sync_clk1]     \
        [get_bd_pins gmii_ic_GP/ACLK]                   \
        [get_bd_pins gmii_ic_GP/S00_ACLK]               \
        [get_bd_pins gmii_ic_GP/M00_ACLK]               \
        [get_bd_pins gmii_ic_GP/M01_ACLK]               \
        [get_bd_pins gmii_ic_GP/M02_ACLK]               \
        [get_bd_pins gmii_ic_GP/M03_ACLK]               \
        [get_bd_pins gmii_ic_GP/M04_ACLK]               \
        [get_bd_pins gmii_ic_GP/M05_ACLK]               \
        [get_bd_pins sfp_ic_GP/ACLK]                    \
        [get_bd_pins sfp_ic_GP/S00_ACLK]                \
        [get_bd_pins sfp_ic_GP/M00_ACLK]                \
        [get_bd_pins sfp_ic_GP/M01_ACLK]                \
        [get_bd_pins sfp_ic_GP/M02_ACLK]                \
        [get_bd_pins sfp_ic_GP/M03_ACLK]                \
        [get_bd_pins gmii_dma0/s_axi_lite_aclk]         \
        [get_bd_pins axi_eth_gmii0/s_axi_lite_clk]      \
        [get_bd_pins gmii_dma1/s_axi_lite_aclk]         \
        [get_bd_pins axi_eth_gmii1/s_axi_lite_clk]      \
        [get_bd_pins gmii_dma2/s_axi_lite_aclk]         \
        [get_bd_pins axi_eth_gmii2/s_axi_lite_clk]      \
        [get_bd_pins sfp_dma0/s_axi_lite_aclk]          \
        [get_bd_pins axi_eth_sfp0/s_axi_lite_clk]       \
        [get_bd_pins sfp_dma1/s_axi_lite_aclk]          \
        [get_bd_pins axi_eth_sfp1/s_axi_lite_clk]       \
        [get_bd_pins clk_wiz_50M/clk_in1]
    connect_bd_net -net processing_system7_1_fclk_clk2  \
        [get_bd_pins processing_system7/FCLK_CLK2]      \
        [get_bd_pins axi_eth_sfp0/ref_clk]              \
        [get_bd_pins axi_eth_sfp1/ref_clk]              \
        [get_bd_pins idelay_ctrl1/ref_clk]
    connect_bd_net -net gmii0_gtx_in                    \
        [get_bd_ports gmii0_gtx_in]                     \
        [get_bd_pins axi_eth_gmii0/gtx_clk]
    connect_bd_net -net gmii1_gtx_in                    \
        [get_bd_ports gmii1_gtx_in]                     \
        [get_bd_pins axi_eth_gmii1/gtx_clk]
    connect_bd_net -net gmii2_gtx_in                    \
        [get_bd_ports gmii2_gtx_in]                     \
        [get_bd_pins axi_eth_gmii2/gtx_clk]
    connect_bd_intf_net -intf_net mgt0_in_clk           \
        [get_bd_intf_ports mgt0_in]                     \
        [get_bd_intf_pins axi_eth_sfp0/mgt_clk]
    #connect_bd_intf_net -intf_net mgt1_in_clk           \
        [get_bd_intf_ports mgt1_in]                     \
        [get_bd_intf_pins axi_eth_sfp1/mgt_clk]

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


