create_clock -period 8.000 -name mgt0_clk_p [get_ports mgt0_in_clk_p]

create_clock -period 8.000 -name gmii0_gtx_in [get_ports gmii0_gtx_in]
create_clock -period 8.000 -name gmii1_gtx_in [get_ports gmii1_gtx_in]
create_clock -period 8.000 -name gmii2_gtx_in [get_ports gmii2_gtx_in]

#create_clock -period 40.000 -name clk_25M_out0 [get_ports {clk_25M_out0[0]}]
#create_clock -period 40.000 -name clk_25M_out1 [get_ports {clk_25M_out1[0]}]
#create_clock -period 40.000 -name clk_25M_out2 [get_ports {clk_25M_out2[0]}]
