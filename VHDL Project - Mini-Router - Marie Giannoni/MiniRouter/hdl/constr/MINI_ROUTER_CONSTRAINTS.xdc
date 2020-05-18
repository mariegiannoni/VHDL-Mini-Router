create_clock -period 8.000 -name clk125 -waveform {0.000 4.000}

set_property PACKAGE_PIN L16 [get_ports clk]
set_property PACKAGE_PIN T16 [get_ports data1]
set_property PACKAGE_PIN W13 [get_ports data2]
set_property PACKAGE_PIN D18 [get_ports data_out]
set_property PACKAGE_PIN G14 [get_ports grant1]
set_property PACKAGE_PIN M15 [get_ports grant2]
set_property PACKAGE_PIN M14 [get_ports valid]
set_property PACKAGE_PIN R18 [get_ports rst]
set_property PACKAGE_PIN P15 [get_ports req1]
set_property PACKAGE_PIN G15 [get_ports req2]

