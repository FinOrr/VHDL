----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2020 20:56:55
-- Design Name: 
-- Module Name: TB_Top_Level - Behavioral
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

entity TB_Top_Level is
--  Port ( );
end TB_Top_Level;

architecture Behavioral of TB_Top_Level is

    component Top_Level is
        port (
            XTAL_100MHz   : in std_logic;
            VGA_Red       : out std_logic_vector(3 downto 0);
            VGA_Green     : out std_logic_vector(3 downto 0);
            VGA_Blue      : out std_logic_vector(3 downto 0);
            HSync         : out std_logic;
            VSync         : out std_logic
        );
    end component;
    
    signal Clk_Period : time := 10 ns;
    
    signal Clk      : std_logic := '0';
    signal VGA_Red  : std_logic_vector(3 downto 0) := (others => '0');
    signal VGA_Green : std_logic_vector(3 downto 0) := (others => '0');
    signal VGA_Blue : std_logic_vector(3 downto 0) := (others => '0');
    signal HSync    : std_logic := '0';
    signal VSync    : std_logic := '0';
        
begin

    UUT: Top_Level
        port map (
            XTAL_100MHz => Clk,
            VGA_Red     => VGA_Red,
            VGA_Green   => VGA_Green,
            VGA_Blue    => VGA_Blue,
            HSync       => HSync,
            VSync       => VSync
        );
        
    Clocking: process
    begin
        Clk <= NOT Clk;
        wait for Clk_Period / 2;
    end process;
end Behavioral;
