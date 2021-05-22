----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 11:50:10
-- Design Name: 
-- Module Name: T42_M3_TB_Pulse_Generator - Behavioral
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


entity T42_M3_TB_Pulse_Generator is
--  Port ( );
end T42_M3_TB_Pulse_Generator;

architecture Behavioral of T42_M3_TB_Pulse_Generator is

    component Pulse_Generator is
        generic(
            Frequency    : natural          -- User inputs the desired pulse frequency as a generic
        );
        port( 
            -- Input
            i_Clk       : in  std_logic;     -- Input system clock, 100_000_000 for Basys 3
            
            -- Output
            o_Strobe    : out std_logic      -- Strobe signal is output at the desired frequency
        );
    end component;
    
    signal Clk, Strobe : std_logic := '0';
    
begin

    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    uut: Pulse_Generator
        generic map (
            Frequency => 250
        )
        port map (
            i_Clk    => Clk,
            o_Strobe => Strobe
        );

end Behavioral;
