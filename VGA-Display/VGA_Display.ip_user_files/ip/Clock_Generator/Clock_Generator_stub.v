// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Apr 12 16:38:27 2020
// Host        : LAPTOP-H7D3C67G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/user/VGA_Display/VGA_Display.srcs/sources_1/ip/Clock_Generator/Clock_Generator_stub.v
// Design      : Clock_Generator
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module Clock_Generator(o_74MHz, o_25MHz, i_XTAL)
/* synthesis syn_black_box black_box_pad_pin="o_74MHz,o_25MHz,i_XTAL" */;
  output o_74MHz;
  output o_25MHz;
  input i_XTAL;
endmodule
