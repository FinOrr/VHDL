----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts/Finlay Orr 799236/772579 
-- 
-- Create Date: 14.11.2018 16:05:44
-- Design Name: 
-- Module Name: SevenSegmentDecoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Seven_Segment_Decoder is
    port (
        -- Inputs
        i_Cathode_Value     :   in  std_logic_vector(3 downto 0);       -- binary value of number to be displayed on seven segment 
        -- Outputs
        o_Seg_Cathodes      :   out std_logic_vector(6 downto 0)        -- bits corresponding to seven segment anodes (active low)
    );
end Seven_Segment_Decoder;

architecture Seven_Segment_Decoder_Arch of Seven_Segment_Decoder is
    
    -- IO Signals
    signal r_Cathode_Value   :   std_logic_vector(3 downto 0);
    signal r_Seg_Cathodes    :   std_logic_vector(6 downto 0);
    
begin
    
    -- Buffer IO
    r_Cathode_Value <= i_Cathode_Value;
    o_Seg_Cathodes  <= r_Seg_Cathodes;

    with r_Cathode_Value select
        r_Seg_Cathodes   <= "0000001" when "0000",      -- display 0 if input is 0
                            "1001111" when "0001",      -- display 1 if input is 1
                            "0010010" when "0010",      -- display 2 if input is 2
                            "0000110" when "0011",      -- display 3 if input is 3
                            "1001100" when "0100",      -- display 4 if input is 4
                            "0100100" when "0101",      -- display 5 if input is 5
                            "0100000" when "0110",      -- display 6 if input is 6
                            "0001111" when "0111",      -- display 7 if input is 7
                            "0000000" when "1000",      -- display 8 if input is 8
                            "0000100" when "1001",      -- display 9 if input is 9
                            "0001000" when "1010",      -- display A if input is 10
                            "1100000" when "1011",      -- display B if input is 11
                            "0110001" when "1100",      -- display C if input is 12
                            "1000010" when "1101",      -- display D if input is 13
                            "0110000" when "1110",      -- display E if input is 14
                            "0111000" when "1111",      -- display F if input is 15
                            "1000010" when others;  
                             
end Seven_Segment_Decoder_Arch;