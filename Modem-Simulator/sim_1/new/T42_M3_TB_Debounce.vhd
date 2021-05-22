----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 12:06:36
-- Design Name: 
-- Module Name: T42_M3_TB_Debounce - Behavioral
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


entity T42_M3_TB_Debounce is
--  Port ( );
end T42_M3_TB_Debounce;

architecture Behavioral of T42_M3_TB_Debounce is

    component Debounce is
        port (
            -- Inputs
            i_Clk     :   in  std_logic;
            i_Input   :   in  std_logic;
            -- Output
            o_Output  :   out std_logic
        );
    end component;

    signal Clk, Input, Output : std_logic := '0';
    
begin

    uut: Debounce
        port map (
            i_Clk    => Clk,
            i_Input  => Input,
            o_Output => Output
        );
        
    clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    -- Simulate switch bounce
    Input_Stimulus: process
    begin
        Input <= '1';
        wait for 2 ms;
        Input <= '0';
        wait for 4 ms;
        Input <= '1';
        wait for 8 ms;
        Input <= '0';
        wait for 16 ms;
        Input <= '1';
        wait for 32 ms;
    end process;

end Behavioral;