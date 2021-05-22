----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 14:44:39
-- Design Name: 
-- Module Name: T42_M3_Demodulator_A - Behavioral
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

entity T42_M3_Demodulator_A is
    Port ( 
            i_Clk           :   in STD_LOGIC;
            i_Clock_Enable  :   in STD_LOGIC;
            i_Reset         :   in STD_LOGIC;
            i_I             :   in STD_LOGIC_VECTOR (7 downto 0);
            i_Q             :   in STD_LOGIC_VECTOR (7 downto 0);
            o_Data          :   out STD_LOGIC;
            o_Symbol        :   out STD_LOGIC);
end T42_M3_Demodulator_A;

architecture Behavioral of T42_M3_Demodulator_A is

begin


end Behavioral;