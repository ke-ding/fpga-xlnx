create_clock -name refclk_p -period 6.4 [get_ports refclk_p]
create_clock -name free_200M_clk_p -period 5 [get_ports free_200M_clk_p]

create_clock -period 8.000 -name gmii0_gtx_in [get_ports gmii0_gtx_in]
create_clock -period 8.000 -name gmii1_gtx_in [get_ports gmii1_gtx_in]
create_clock -period 8.000 -name gmii2_gtx_in [get_ports gmii2_gtx_in]

set_clock_groups -asynchronous		\
	-group refclk_p			\
	-group free_200M_clk_p		\
	-group gmii0_gtx_in		\
	-group gmii1_gtx_in		\
	-group gmii2_gtx_in
