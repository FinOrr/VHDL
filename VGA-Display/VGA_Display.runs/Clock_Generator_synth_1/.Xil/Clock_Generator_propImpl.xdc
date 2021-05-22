set_property SRC_FILE_INFO {cfile:c:/Users/user/VGA_Display/VGA_Display.srcs/sources_1/ip/Clock_Generator/Clock_Generator.xdc rfile:../../../VGA_Display.srcs/sources_1/ip/Clock_Generator/Clock_Generator.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports i_XTAL]] 0.1
