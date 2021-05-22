----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2019 18:32:24
-- Design Name: 
-- Module Name: T42_M3_TB_Signal_Generator - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity T42_M3_TB_Signal_Generator is
--  Port ( );
end T42_M3_TB_Signal_Generator;

architecture Behavioral of T42_M3_TB_Signal_Generator is

component Signal_Generator_B is
generic (
    CE_Frequency : natural
);
port (
    -- Inputs
    Clk          : in  std_logic;
    -- Outputs
    Clock_Enable : out std_logic
);
end component;

-- Signal declaration
signal Clk          : std_logic := '0';
signal Clock_Enable : std_logic := '0';

begin

uut: Signal_Generator_B
generic map (
    CE_Frequency => 16
)
port map (
    Clk          => Clk,
    Clock_Enable => Clock_Enable
);

Clocking: process
begin
    Clk <= not Clk;
    wait for 5 ns;
end process;

end Behavioral;