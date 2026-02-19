## Basys 3 Clock (100 MHz)
set_property PACKAGE_PIN W5 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports {clk}]

## Reset button (btnC)
set_property PACKAGE_PIN U18 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]
set_property PULLDOWN true [get_ports {rst}]

## UART TX to on-board USB-UART
set_property PACKAGE_PIN B16 [get_ports {tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {tx}]
