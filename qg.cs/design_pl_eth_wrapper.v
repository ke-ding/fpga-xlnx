//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
//Date        : Thu Sep  6 03:36:36 2018
//Host        : centos-ws running 64-bit unknown
//Command     : generate_target design_pl_eth_wrapper.bd
//Design      : design_pl_eth_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_pl_eth_wrapper
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
    PSGE0_rx_clk,
    PSGE0_TX_CLK_PHY,
    PSGE0_gtxclk,
    PSGE0_rx_dv,
    PSGE0_rx_er,
    PSGE0_rxd,
    PSGE0_tx_en,
    PSGE0_tx_er,
    PSGE0_txd,
    PSMDIO0_mdc,
    PSMDIO0_mdio_io,
    gmii1_gtx_clk,
    gmii1_rx_clk,
    gmii1_rx_dv,
    gmii1_rx_er,
    gmii1_rxd,
    gmii1_tx_clk,
    gmii1_tx_en,
    gmii1_tx_er,
    gmii1_txd,
    gmii2_gtx_clk,
    gmii2_rx_clk,
    gmii2_rx_dv,
    gmii2_rx_er,
    gmii2_rxd,
    gmii2_tx_clk,
    gmii2_tx_en,
    gmii2_tx_er,
    gmii2_txd,
    mdio1_mdc,
    mdio1_mdio_io,
    mdio2_mdc,
    mdio2_mdio_io,
    phy_rst_n1,
    phy_rst_n2);
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
  input PSGE0_rx_clk;
  input PSGE0_TX_CLK_PHY;
  output PSGE0_gtxclk;
  input PSGE0_rx_dv;
  input PSGE0_rx_er;
  input [7:0]PSGE0_rxd;
  output [0:0]PSGE0_tx_en;
  output [0:0]PSGE0_tx_er;
  output [7:0]PSGE0_txd;
  output PSMDIO0_mdc;
  inout PSMDIO0_mdio_io;
  output gmii1_gtx_clk;
  input gmii1_rx_clk;
  input gmii1_rx_dv;
  input gmii1_rx_er;
  input [7:0]gmii1_rxd;
  input gmii1_tx_clk;
  output gmii1_tx_en;
  output gmii1_tx_er;
  output [7:0]gmii1_txd;
  output gmii2_gtx_clk;
  input gmii2_rx_clk;
  input gmii2_rx_dv;
  input gmii2_rx_er;
  input [7:0]gmii2_rxd;
  input gmii2_tx_clk;
  output gmii2_tx_en;
  output gmii2_tx_er;
  output [7:0]gmii2_txd;
  output mdio1_mdc;
  inout mdio1_mdio_io;
  output mdio2_mdc;
  inout mdio2_mdio_io;
  output [0:0]phy_rst_n1;
  output [0:0]phy_rst_n2;

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
  wire PSGE0_rx_clk;
  wire PSGE0_tx_clk;
  wire PSGE0_TX_CLK_PHY;
  wire PSGE0_col;
  wire PSGE0_crs;
  wire PSGE0_gtxclk;
  wire PSGE0_rx_dv;
  wire PSGE0_rx_er;
  wire [7:0]PSGE0_rxd;
  wire [0:0]PSGE0_tx_en;
  wire [0:0]PSGE0_tx_er;
  wire [7:0]PSGE0_txd;
  wire PSMDIO0_mdc;
  wire PSMDIO0_mdio_i;
  wire PSMDIO0_mdio_io;
  wire PSMDIO0_mdio_o;
  wire PSMDIO0_mdio_t;
  wire [15:0]cnt125;
  wire [15:0]cnt25;
  wire cnt_clr;
  wire gmii1_gtx_clk;
  wire gmii1_rx_clk;
  wire gmii1_rx_dv;
  wire gmii1_rx_er;
  wire [7:0]gmii1_rxd;
  wire gmii1_tx_clk;
  wire gmii1_tx_en;
  wire gmii1_tx_er;
  wire [7:0]gmii1_txd;
  wire gmii2_gtx_clk;
  wire gmii2_rx_clk;
  wire gmii2_rx_dv;
  wire gmii2_rx_er;
  wire [7:0]gmii2_rxd;
  wire gmii2_tx_clk;
  wire gmii2_tx_en;
  wire gmii2_tx_er;
  wire [7:0]gmii2_txd;
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
  wire [0:0]phy_rst_n1;
  wire [0:0]phy_rst_n2;
  wire ref_clk;
  wire [0:0]resetn;
  
  reg clear_reg;
  reg sel_reg;
  reg [7:0]clear_cnt_reg;

  (* LOC = "IDELAYCTRL_X1Y1" *) IDELAYCTRL #(
       .SIM_DEVICE ( "7SERIES" )
  ) axi_ethernet_idelay_ctrl
       (.RDY    (),
        .REFCLK (ref_clk),
        .RST    (!resetn));
  (* LOC = "IDELAYCTRL_X1Y0" *) IDELAYCTRL #(
       .SIM_DEVICE ( "7SERIES" )
  ) axi_ethernet_idelay_ctrl2
       (.RDY    (),
        .REFCLK (ref_clk),
        .RST    (!resetn));
  BUFGMUX txbuf_mux
       (.I0(PSGE0_TX_CLK_PHY),
        .I1(PSGE0_gtxclk),
        .O(PSGE0_tx_clk),
        .S(sel_reg));

  always @(posedge PSGE0_gtxclk)
  begin
    if (resetn == 1'b0) begin
      clear_reg <= 0;
      sel_reg <= 0;
      clear_cnt_reg <= 0;
    end
    else begin
      if (cnt125[15] && !clear_reg) begin
        if (cnt25[15] || cnt25[14])
          sel_reg <= 1;
        else
          sel_reg <= 0;
        clear_reg <= 1;
        clear_cnt_reg <= 200;
      end // if
      if (clear_reg) begin
        clear_cnt_reg <= clear_cnt_reg - 1;
        if (clear_cnt_reg == 0)
          clear_reg <= 0;
      end
    end // else
  end
  assign cnt_clr = clear_reg;
        
  IOBUF PSMDIO0_mdio_iobuf
       (.I(PSMDIO0_mdio_o),
        .IO(PSMDIO0_mdio_io),
        .O(PSMDIO0_mdio_i),
        .T(PSMDIO0_mdio_t));
  design_pl_eth design_pl_eth_i
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
        .PSGE0_rx_clk(PSGE0_rx_clk),
        .PSGE0_tx_clk(PSGE0_tx_clk),
        .PSGE0_TX_CLK_PHY(PSGE0_TX_CLK_PHY),
        .PSGE0_col(PSGE0_col),
        .PSGE0_crs(PSGE0_crs),
        .PSGE0_gtxclk(PSGE0_gtxclk),
        .PSGE0_rx_dv(PSGE0_rx_dv),
        .PSGE0_rx_er(PSGE0_rx_er),
        .PSGE0_rxd(PSGE0_rxd),
        .PSGE0_tx_en(PSGE0_tx_en),
        .PSGE0_tx_er(PSGE0_tx_er),
        .PSGE0_txd(PSGE0_txd),
        .PSMDIO0_mdc(PSMDIO0_mdc),
        .PSMDIO0_mdio_i(PSMDIO0_mdio_i),
        .PSMDIO0_mdio_o(PSMDIO0_mdio_o),
        .PSMDIO0_mdio_t(PSMDIO0_mdio_t),
        .cnt125(cnt125),
        .cnt25(cnt25),
        .cnt_clr(cnt_clr),
        .gmii1_gtx_clk(gmii1_gtx_clk),
        .gmii1_rx_clk(gmii1_rx_clk),
        .gmii1_rx_dv(gmii1_rx_dv),
        .gmii1_rx_er(gmii1_rx_er),
        .gmii1_rxd(gmii1_rxd),
        .gmii1_tx_clk(gmii1_tx_clk),
        .gmii1_tx_en(gmii1_tx_en),
        .gmii1_tx_er(gmii1_tx_er),
        .gmii1_txd(gmii1_txd),
        .gmii2_gtx_clk(gmii2_gtx_clk),
        .gmii2_rx_clk(gmii2_rx_clk),
        .gmii2_rx_dv(gmii2_rx_dv),
        .gmii2_rx_er(gmii2_rx_er),
        .gmii2_rxd(gmii2_rxd),
        .gmii2_tx_clk(gmii2_tx_clk),
        .gmii2_tx_en(gmii2_tx_en),
        .gmii2_tx_er(gmii2_tx_er),
        .gmii2_txd(gmii2_txd),
        .mdio1_mdc(mdio1_mdc),
        .mdio1_mdio_i(mdio1_mdio_i),
        .mdio1_mdio_o(mdio1_mdio_o),
        .mdio1_mdio_t(mdio1_mdio_t),
        .mdio2_mdc(mdio2_mdc),
        .mdio2_mdio_i(mdio2_mdio_i),
        .mdio2_mdio_o(mdio2_mdio_o),
        .mdio2_mdio_t(mdio2_mdio_t),
        .phy_rst_n1(phy_rst_n1),
        .phy_rst_n2(phy_rst_n2),
        .ref_clk(ref_clk),
        .resetn(resetn));
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
endmodule
