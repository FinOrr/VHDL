----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2020 20:23:07
-- Design Name: 
-- Module Name: TB_I2C_Controller - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_I2C_ROM is
--  Port ( );
end TB_I2C_ROM;

architecture Behavioral of TB_I2C_ROM is

    component I2C_ROM is
        port (
            -- Inputs                                                                    
            Clk     : in std_logic;         -- Clock running at I2C transmit frequency   
            i_Idle  : in std_logic;                                                      
            i_Reset : in std_logic;                                                      
            -- Outputs                                                                   
            o_Start : out std_logic;                                                     
            o_Slave_Adr : out std_logic_vector(7 downto 0);                              
            o_Reg_Adr   : out std_logic_vector(15 downto 0);                             
            o_Reg_Val   : out std_logic_vector(7 downto 0)                               
        );
    end component;

    signal Clk, Idle, Reset, Start : std_logic := '0';
    signal Slave_Adr, Reg_Val : std_logic_vector(7 downto 0);
    signal Reg_Adr : std_logic_vector(15 downto 0) := (others => '0');
    
begin

    UUT: I2C_ROM
        port map (
             -- Inputs                
             Clk            => Clk,         
             i_Idle         => Idle,
             i_Reset        => Reset,
             -- Outputs                   
             o_Start        => Start,   
             o_Slave_Adr    => Slave_Adr,
             o_Reg_Adr      => Reg_Adr,
             o_Reg_Val      => Reg_Val
        );  

    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    Stimulus: process
    begin
        Idle <= '0';
        wait for 20 ns;
        Idle <= '1';
        wait for 10 ns;
    end process;
    
    
end Behavioral;