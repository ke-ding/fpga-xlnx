#PL_SFP0
set_property LOC AC8 [get_ports mgt0_in_clk_p]
set_property LOC AC7 [get_ports mgt0_in_clk_n]
create_clock -name mgt0_clk_p -period 8.0 [get_ports mgt0_in_clk_p]

set_property LOC W4 [get_ports sfp_txp]
set_property LOC W3 [get_ports sfp_txn]
set_property LOC Y6 [get_ports sfp_rxp]
set_property LOC Y5 [get_ports sfp_rxn]

set_property LOC AA18 [get_ports sfp_tx_disable_out]
set_property IOSTANDARD LVCMOS33 [get_ports sfp_tx_disable_out]
