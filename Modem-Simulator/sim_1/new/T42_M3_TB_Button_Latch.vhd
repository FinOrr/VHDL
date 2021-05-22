----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 11:15:40
-- Design Name: 
-- Module Name: T42_M3_TB_Button_Latch - Behavioral
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


entity T42_M3_TB_Button_Latch is
--  Port ( );
end T42_M3_TB_Button_Latch;

architecture Behavioral of T42_M3_TB_Button_Latch is
    
    component Button_Latch is
        port (
            -- Input
            i_Set   : in std_logic;     -- Input to be toggle on/off
            -- Output
            o_Latch : out std_logic     -- Output of the latch
        );
    end component;
    
    signal Set, Latch : std_logic := '0';
    
begin

    uut: Button_Latch
        port map (
            i_Set   => Set,
            o_Latch => Latch
        );
    
    -- Toggle the input every 20 ms, to simulate pressing a button at regular intervals
    Input_Stimulus: process
    begin
        Set <= not Set;
        wait for 20 ns;
    end process;
    
end Behavioral;