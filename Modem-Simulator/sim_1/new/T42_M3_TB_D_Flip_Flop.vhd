----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 11:29:35
-- Design Name: 
-- Module Name: T42_M3_TB_D_Flip_Flop - Behavioral
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

entity T42_M3_TB_D_Flip_Flop is
--  Port ( );
end T42_M3_TB_D_Flip_Flop;

architecture Behavioral of T42_M3_TB_D_Flip_Flop is

    component D_Flip_Flop is
        port (
            -- Inputs
            i_Clk     : in    std_logic;
            i_D       : in    std_logic;
            i_Enable  : in    std_logic;
            i_Reset   : in    std_logic;
            -- Outputs
            o_Q       : out   std_logic := '0'
        );
    end component; 

    signal Clk, D, Enable, Reset, Q : std_logic := '0';
    
begin

    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    Input_Stimulus: process
    begin
        D       <= '0';
        Reset   <= '0';
        Enable  <= '1';
        wait for 10 ns;
        
        D       <= '1';
        wait for 20 ns;
        
        Reset   <= '1';
        wait for 10 ns;
        
        D       <= '0';
        Enable  <= '0';
        Reset   <= '0';
        wait for 10 ns;
        
        Enable  <= '1';
        D       <= '1';
        wait for 10 ns;
    end process;

    uut: D_Flip_Flop
        port map (
            i_Clk    => Clk,
            i_D      => D,
            i_Enable => Enable,
            i_Reset  => Reset,
            o_Q      => Q
        );
        
end Behavioral;
