----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2019 13:52:09
-- Design Name: 
-- Module Name: T42_M3_TB_Modulator_A - Behavioral
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


entity T42_M3_TB_Modulator_A is
--  Port ( );
end T42_M3_TB_Modulator_A;

architecture Behavioral of T42_M3_TB_Modulator_A is
    
    component Modulator_A is
    Port ( 
    -- Inputs
        i_Clk       : in STD_LOGIC;
        i_Reset     : in STD_LOGIC;
        i_CE_16Hz   : in STD_LOGIC;
        i_Symbol    : in STD_LOGIC_VECTOR (1 downto 0);
    
    -- Outputs
        o_I         : out STD_LOGIC_VECTOR (7 downto 0);
        o_Q         : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
     
     -- Constants could be moved to a package if there's time
     constant Clk_Period : time := 10 ns;
     constant CE_Period  : time := 62.5 ms;
     
     -- Test signals
     signal Clk, Reset, Clock_Enable : STD_LOGIC := '0';
     signal Symbol : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
     signal I, Q   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
     
begin

    -- Connect Modulator component to test signals
    uut: Modulator_A
    port map (
        i_Clk       => Clk,
        i_Reset     => Reset,
        i_CE_16Hz   => Clock_Enable,
        i_Symbol    => Symbol,
        o_I         => I,
        o_Q         => Q
    );
    
    -- Drive the system clock at 100MHz
    clock: process
    begin
        Clk <= '0';
        wait for Clk_Period / 2;
        Clk <= '1';
        wait for Clk_Period / 2;
    end process;
    
    -- Clock enable to be driven at 16Hz
    clock_enable_proc: process
    begin
        Clock_Enable <= '1';
        wait for Clk_Period;
        Clock_Enable <= '0';
        wait for CE_Period;
    end process;
    
    -- Input symbols will be fed in at 2Hz
    input_symbol: process
    begin
        Symbol <= "00";
        wait for 500 ms;
        
        Symbol <= "10";
        wait for 500 ms;
        
        Symbol <= "11";
        wait for 500 ms;
        
        Symbol <= "01";
        wait for 500 ms;
    end process;
    
end Behavioral;
