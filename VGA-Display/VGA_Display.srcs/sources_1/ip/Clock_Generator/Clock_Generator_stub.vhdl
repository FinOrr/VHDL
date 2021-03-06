-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Sun Apr 12 16:38:27 2020
-- Host        : LAPTOP-H7D3C67G running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/user/VGA_Display/VGA_Display.srcs/sources_1/ip/Clock_Generator/Clock_Generator_stub.vhdl
-- Design      : Clock_Generator
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clock_Generator is
  Port ( 
    o_74MHz : out STD_LOGIC;
    o_25MHz : out STD_LOGIC;
    i_XTAL : in STD_LOGIC
  );

end Clock_Generator;

architecture stub of Clock_Generator is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "o_74MHz,o_25MHz,i_XTAL";
begin
end;
