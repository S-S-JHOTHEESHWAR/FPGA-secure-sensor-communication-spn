###############################################################################
# CLOCK (100 MHz PL)
###############################################################################
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 [get_ports clk]

###############################################################################
# UART TX ? ON-BOARD USB UART (W12)
###############################################################################
set_property PACKAGE_PIN W12 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property SLEW FAST [get_ports uart_tx]
set_property DRIVE 8 [get_ports uart_tx]

###############################################################################
# ULTRASONIC (PMOD JA)
###############################################################################
# TRIG ? JA1
set_property PACKAGE_PIN Y11 [get_ports trig]
set_property IOSTANDARD LVCMOS33 [get_ports trig]

# ECHO ? JA2 (via divider + pulldown)
set_property PACKAGE_PIN AA11 [get_ports echo]
set_property IOSTANDARD LVCMOS33 [get_ports echo]
set_property PULLDOWN true [get_ports echo]