//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
//Date        : Tue Jan 22 14:44:09 2019
//Host        : milows.home running 64-bit unknown
//Command     : generate_target QG_pl_eth_wrapper.bd
//Design      : QG_pl_eth_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module QG_pl_eth_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    clk_25M_out1,
    clk_25M_out2,
    clk_25M_out3,
    clk_25M_out4,
    gmii1_gtx_clk,
    gmii1_gtx_in,
    gmii1_rx_clk,
    gmii1_rx_dv,
    gmii1_rx_er,
    gmii1_rxd,
    gmii1_tx_clk,
    gmii1_tx_en,
    gmii1_tx_er,
    gmii1_txd,
    gmii2_gtx_clk,
    gmii2_gtx_in,
    gmii2_rx_clk,
    gmii2_rx_dv,
    gmii2_rx_er,
    gmii2_rxd,
    gmii2_tx_clk,
    gmii2_tx_en,
    gmii2_tx_er,
    gmii2_txd,
    gmii3_gtx_clk,
    gmii3_gtx_in,
    gmii3_rx_clk,
    gmii3_rx_dv,
    gmii3_rx_er,
    gmii3_rxd,
    gmii3_tx_clk,
    gmii3_tx_en,
    gmii3_tx_er,
    gmii3_txd,
    gmii4_gtx_clk,
    gmii4_gtx_in,
    gmii4_rx_clk,
    gmii4_rx_dv,
    gmii4_rx_er,
    gmii4_rxd,
    gmii4_tx_clk,
    gmii4_tx_en,
    gmii4_tx_er,
    gmii4_txd,
    mdio1_mdc,
    mdio1_mdio_io,
    mdio2_mdc,
    mdio2_mdio_io,
    mdio3_mdc,
    mdio3_mdio_io,
    mdio4_mdc,
    mdio4_mdio_io,
    mgt0_in_clk_n,
    mgt0_in_clk_p,
    phy_rst_n1,
    phy_rst_n2,
    phy_rst_n3,
    phy_rst_n4,
    sfp0_rxn,
    sfp0_rxp,
    sfp0_txn,
    sfp0_txp);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [0:0]clk_25M_out1;
  output [0:0]clk_25M_out2;
  output [0:0]clk_25M_out3;
  output [0:0]clk_25M_out4;
  output gmii1_gtx_clk;
  input gmii1_gtx_in;
  input gmii1_rx_clk;
  input gmii1_rx_dv;
  input gmii1_rx_er;
  input [7:0]gmii1_rxd;
  input gmii1_tx_clk;
  output gmii1_tx_en;
  output gmii1_tx_er;
  output [7:0]gmii1_txd;
  output gmii2_gtx_clk;
  input gmii2_gtx_in;
  input gmii2_rx_clk;
  input gmii2_rx_dv;
  input gmii2_rx_er;
  input [7:0]gmii2_rxd;
  input gmii2_tx_clk;
  output gmii2_tx_en;
  output gmii2_tx_er;
  output [7:0]gmii2_txd;
  output gmii3_gtx_clk;
  input gmii3_gtx_in;
  input gmii3_rx_clk;
  input gmii3_rx_dv;
  input gmii3_rx_er;
  input [7:0]gmii3_rxd;
  input gmii3_tx_clk;
  output gmii3_tx_en;
  output gmii3_tx_er;
  output [7:0]gmii3_txd;
  output gmii4_gtx_clk;
  input gmii4_gtx_in;
  input gmii4_rx_clk;
  input gmii4_rx_dv;
  input gmii4_rx_er;
  input [7:0]gmii4_rxd;
  input gmii4_tx_clk;
  output gmii4_tx_en;
  output gmii4_tx_er;
  output [7:0]gmii4_txd;
  output mdio1_mdc;
  inout mdio1_mdio_io;
  output mdio2_mdc;
  inout mdio2_mdio_io;
  output mdio3_mdc;
  inout mdio3_mdio_io;
  output mdio4_mdc;
  inout mdio4_mdio_io;
  input mgt0_in_clk_n;
  input mgt0_in_clk_p;
  output [0:0]phy_rst_n1;
  output [0:0]phy_rst_n2;
  output [0:0]phy_rst_n3;
  output [0:0]phy_rst_n4;
  input sfp0_rxn;
  input sfp0_rxp;
  output sfp0_txn;
  output sfp0_txp;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [0:0]clk_25M_out1;
  wire [0:0]clk_25M_out2;
  wire [0:0]clk_25M_out3;
  wire [0:0]clk_25M_out4;
  wire gmii1_gtx_clk;
  wire gmii1_gtx_in;
  wire gmii1_rx_clk;
  wire gmii1_rx_dv;
  wire gmii1_rx_er;
  wire [7:0]gmii1_rxd;
  wire gmii1_tx_clk;
  wire gmii1_tx_en;
  wire gmii1_tx_er;
  wire [7:0]gmii1_txd;
  wire gmii2_gtx_clk;
  wire gmii2_gtx_in;
  wire gmii2_rx_clk;
  wire gmii2_rx_dv;
  wire gmii2_rx_er;
  wire [7:0]gmii2_rxd;
  wire gmii2_tx_clk;
  wire gmii2_tx_en;
  wire gmii2_tx_er;
  wire [7:0]gmii2_txd;
  wire gmii3_gtx_clk;
  wire gmii3_gtx_in;
  wire gmii3_rx_clk;
  wire gmii3_rx_dv;
  wire gmii3_rx_er;
  wire [7:0]gmii3_rxd;
  wire gmii3_tx_clk;
  wire gmii3_tx_en;
  wire gmii3_tx_er;
  wire [7:0]gmii3_txd;
  wire gmii4_gtx_clk;
  wire gmii4_gtx_in;
  wire gmii4_rx_clk;
  wire gmii4_rx_dv;
  wire gmii4_rx_er;
  wire [7:0]gmii4_rxd;
  wire gmii4_tx_clk;
  wire gmii4_tx_en;
  wire gmii4_tx_er;
  wire [7:0]gmii4_txd;
  wire mdio1_mdc;
  wire mdio1_mdio_i;
  wire mdio1_mdio_io;
  wire mdio1_mdio_o;
  wire mdio1_mdio_t;
  wire mdio2_mdc;
  wire mdio2_mdio_i;
  wire mdio2_mdio_io;
  wire mdio2_mdio_o;
  wire mdio2_mdio_t;
  wire mdio3_mdc;
  wire mdio3_mdio_i;
  wire mdio3_mdio_io;
  wire mdio3_mdio_o;
  wire mdio3_mdio_t;
  wire mdio4_mdc;
  wire mdio4_mdio_i;
  wire mdio4_mdio_io;
  wire mdio4_mdio_o;
  wire mdio4_mdio_t;
  wire mgt0_in_clk_n;
  wire mgt0_in_clk_p;
  wire [0:0]phy_rst_n1;
  wire [0:0]phy_rst_n2;
  wire [0:0]phy_rst_n3;
  wire [0:0]phy_rst_n4;
  wire ref_clk;
  wire [0:0]resetn;
  wire sfp0_rxn;
  wire sfp0_rxp;
  wire sfp0_txn;
  wire sfp0_txp;

  IDELAYCTRL #(
       .SIM_DEVICE ( "7SERIES" )
  ) axi_ethernet_idelay_ctrl
       (.RDY    (),
        .REFCLK (ref_clk),
        .RST    (!resetn));

  QG_pl_eth QG_pl_eth_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .clk_25M_out1(clk_25M_out1),
        .clk_25M_out2(clk_25M_out2),
        .clk_25M_out3(clk_25M_out3),
        .clk_25M_out4(clk_25M_out4),
        .gmii1_gtx_clk(gmii1_gtx_clk),
        .gmii1_gtx_in(gmii1_gtx_in),
        .gmii1_rx_clk(gmii1_rx_clk),
        .gmii1_rx_dv(gmii1_rx_dv),
        .gmii1_rx_er(gmii1_rx_er),
        .gmii1_rxd(gmii1_rxd),
        .gmii1_tx_clk(gmii1_tx_clk),
        .gmii1_tx_en(gmii1_tx_en),
        .gmii1_tx_er(gmii1_tx_er),
        .gmii1_txd(gmii1_txd),
        .gmii2_gtx_clk(gmii2_gtx_clk),
        .gmii2_gtx_in(gmii2_gtx_in),
        .gmii2_rx_clk(gmii2_rx_clk),
        .gmii2_rx_dv(gmii2_rx_dv),
        .gmii2_rx_er(gmii2_rx_er),
        .gmii2_rxd(gmii2_rxd),
        .gmii2_tx_clk(gmii2_tx_clk),
        .gmii2_tx_en(gmii2_tx_en),
        .gmii2_tx_er(gmii2_tx_er),
        .gmii2_txd(gmii2_txd),
        .gmii3_gtx_clk(gmii3_gtx_clk),
        .gmii3_gtx_in(gmii3_gtx_in),
        .gmii3_rx_clk(gmii3_rx_clk),
        .gmii3_rx_dv(gmii3_rx_dv),
        .gmii3_rx_er(gmii3_rx_er),
        .gmii3_rxd(gmii3_rxd),
        .gmii3_tx_clk(gmii3_tx_clk),
        .gmii3_tx_en(gmii3_tx_en),
        .gmii3_tx_er(gmii3_tx_er),
        .gmii3_txd(gmii3_txd),
        .gmii4_gtx_clk(gmii4_gtx_clk),
        .gmii4_gtx_in(gmii4_gtx_in),
        .gmii4_rx_clk(gmii4_rx_clk),
        .gmii4_rx_dv(gmii4_rx_dv),
        .gmii4_rx_er(gmii4_rx_er),
        .gmii4_rxd(gmii4_rxd),
        .gmii4_tx_clk(gmii4_tx_clk),
        .gmii4_tx_en(gmii4_tx_en),
        .gmii4_tx_er(gmii4_tx_er),
        .gmii4_txd(gmii4_txd),
        .mdio1_mdc(mdio1_mdc),
        .mdio1_mdio_i(mdio1_mdio_i),
        .mdio1_mdio_o(mdio1_mdio_o),
        .mdio1_mdio_t(mdio1_mdio_t),
        .mdio2_mdc(mdio2_mdc),
        .mdio2_mdio_i(mdio2_mdio_i),
        .mdio2_mdio_o(mdio2_mdio_o),
        .mdio2_mdio_t(mdio2_mdio_t),
        .mdio3_mdc(mdio3_mdc),
        .mdio3_mdio_i(mdio3_mdio_i),
        .mdio3_mdio_o(mdio3_mdio_o),
        .mdio3_mdio_t(mdio3_mdio_t),
        .mdio4_mdc(mdio4_mdc),
        .mdio4_mdio_i(mdio4_mdio_i),
        .mdio4_mdio_o(mdio4_mdio_o),
        .mdio4_mdio_t(mdio4_mdio_t),
        .mgt0_in_clk_n(mgt0_in_clk_n),
        .mgt0_in_clk_p(mgt0_in_clk_p),
        .phy_rst_n1(phy_rst_n1),
        .phy_rst_n2(phy_rst_n2),
        .phy_rst_n3(phy_rst_n3),
        .phy_rst_n4(phy_rst_n4),
        .ref_clk(ref_clk),
        .resetn(resetn),
        .sfp0_rxn(sfp0_rxn),
        .sfp0_rxp(sfp0_rxp),
        .sfp0_txn(sfp0_txn),
        .sfp0_txp(sfp0_txp));
  IOBUF mdio1_mdio_iobuf
       (.I(mdio1_mdio_o),
        .IO(mdio1_mdio_io),
        .O(mdio1_mdio_i),
        .T(mdio1_mdio_t));
  IOBUF mdio2_mdio_iobuf
       (.I(mdio2_mdio_o),
        .IO(mdio2_mdio_io),
        .O(mdio2_mdio_i),
        .T(mdio2_mdio_t));
  IOBUF mdio3_mdio_iobuf
       (.I(mdio3_mdio_o),
        .IO(mdio3_mdio_io),
        .O(mdio3_mdio_i),
        .T(mdio3_mdio_t));
  IOBUF mdio4_mdio_iobuf
       (.I(mdio4_mdio_o),
        .IO(mdio4_mdio_io),
        .O(mdio4_mdio_i),
        .T(mdio4_mdio_t));
endmodule
