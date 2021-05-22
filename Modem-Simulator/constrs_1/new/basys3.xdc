# Clock signal
set_property PACKAGE_PIN W5         [get_ports Clk]
set_property IOSTANDARD LVCMOS33    [get_ports Clk]
# defining clock signal, period is in ns: name must be different from port, waveform 50:50 duty cycle and assign to same entity port
create_clock -add -period 10.000 -name C100MHz_pin -waveform {0.000 5.000} [get_ports Clk]


# Fast: SW0
set_property PACKAGE_PIN V17 [get_ports {i_Fast_Sw}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Fast_Sw}]
	
## Display Select : SW8 -> SW10
set_property PACKAGE_PIN V2 [get_ports {i_Display_Select_Sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Display_Select_Sw[0]}]
set_property PACKAGE_PIN T3 [get_ports {i_Display_Select_Sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Display_Select_Sw[1]}]
set_property PACKAGE_PIN T2 [get_ports {i_Display_Select_Sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Display_Select_Sw[2]}]
	
## Error select : SW11 -> SW12
set_property PACKAGE_PIN R3 [get_ports {i_Error_Select_Sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Error_Select_Sw[0]}]
set_property PACKAGE_PIN W2 [get_ports {i_Error_Select_Sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Error_Select_Sw[1]}]

## Data select : SW13 -> SW15
set_property PACKAGE_PIN U1 [get_ports {i_Data_Select_Sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Data_Select_Sw[0]}]
set_property PACKAGE_PIN T1 [get_ports {i_Data_Select_Sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Data_Select_Sw[1]}]
set_property PACKAGE_PIN R2 [get_ports {i_Data_Select_Sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {i_Data_Select_Sw[2]}]
 

# LEDs
set_property PACKAGE_PIN P3 [get_ports {o_LED[0]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {o_LED[0]}]
set_property PACKAGE_PIN N3 [get_ports {o_LED[1]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {o_LED[1]}]
set_property PACKAGE_PIN P1 [get_ports {o_LED[2]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {o_LED[2]}]
set_property PACKAGE_PIN L1 [get_ports {o_LED[3]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {o_LED[3]}]
    
# Seven-segment display
# Cathode A
set_property PACKAGE_PIN W7         [get_ports {o_Segment_Cathodes[6]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[6]}]
# CB
set_property PACKAGE_PIN W6         [get_ports {o_Segment_Cathodes[5]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[5]}]
# CC
set_property PACKAGE_PIN U8         [get_ports {o_Segment_Cathodes[4]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[4]}]
# CD
set_property PACKAGE_PIN V8         [get_ports {o_Segment_Cathodes[3]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[3]}]
# CE
set_property PACKAGE_PIN U5         [get_ports {o_Segment_Cathodes[2]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[2]}]
# CF
set_property PACKAGE_PIN V5         [get_ports {o_Segment_Cathodes[1]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[1]}]
# CG
set_property PACKAGE_PIN U7         [get_ports {o_Segment_Cathodes[0]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Cathodes[0]}]

# Anodes
set_property PACKAGE_PIN U2         [get_ports {o_Segment_Anodes[0]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Anodes[0]}]
set_property PACKAGE_PIN U4         [get_ports {o_Segment_Anodes[1]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Anodes[1]}]
set_property PACKAGE_PIN V4         [get_ports {o_Segment_Anodes[2]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Anodes[2]}]
set_property PACKAGE_PIN W4         [get_ports {o_Segment_Anodes[3]}]
set_property IOSTANDARD LVCMOS33    [get_ports {o_Segment_Anodes[3]}]

# Buttons
#BTND - down button - start / stop system
set_property PACKAGE_PIN U17        [get_ports i_Stop_Btn]
set_property IOSTANDARD LVCMOS33    [get_ports i_Stop_Btn]
#BTNU - up button - Reset system
set_property PACKAGE_PIN T18        [get_ports i_Reset_Btn]
set_property IOSTANDARD LVCMOS33    [get_ports i_Reset_Btn]

# Bitstream configuration 
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
