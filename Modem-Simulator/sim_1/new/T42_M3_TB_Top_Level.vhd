----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2019 17:41:15
-- Design Name: 
-- Module Name: T42_M3_TB_Top_Level - Behavioral
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

entity T42_M3_TB_Top_Level is
--  Port ( );
end T42_M3_TB_Top_Level;

architecture Behavioral of T42_M3_TB_Top_Level is
    component Top_Level is
        port (
            -- Inputs
            Clk                 : in  std_logic;
            i_Fast_Sw           : in  std_logic;
            i_Stop_Btn          : in  std_logic;
            i_Reset_Btn         : in  std_logic;
            i_Error_Select_Sw   : in  std_logic_vector(1 downto 0);
            i_Data_Select_Sw    : in  std_logic_vector(2 downto 0);
            i_Display_Select_Sw : in  std_logic_vector(2 downto 0);
            
            -- Outputs
            o_LED               : out std_logic_vector(3 downto 0);
            o_Segment_Cathodes  : out std_logic_vector(6 downto 0);
            o_Segment_Anodes    : out std_logic_vector(3 downto 0)            
        );
    end component;

    signal Clk, Fast, Stop, Reset : std_logic := '0';
    signal Error_Sel    : std_logic_vector(1 downto 0) := "00";
    signal Data_Sel     : std_logic_vector(2 downto 0) := "000";
    signal Display_Sel  : std_logic_vector(2 downto 0) := "000";
    signal LED          : std_logic_vector(3 downto 0) := "0000";
    signal Cathodes     : std_logic_vector(6 downto 0) := "0000000";
    signal Anodes       : std_logic_vector(3 downto 0) := x"0";
    
begin

    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    Err_Sel_Driver:  process
    begin
        Error_Sel <= "00";
        wait for 5000 ms;
        Error_Sel <= "01";
        wait for 5000 ms;
        Error_Sel <= "10";
        wait for 5000 ms;
        Error_Sel <= "11";
        wait for 5000 ms;
    end process;
    
    Data_Sel_Driver: process
    begin
        Stop <= '1';
        Data_Sel <= "001";
        wait for 5000 ms;
        Data_Sel <= "101";
        wait for 5000 ms;
        Data_Sel <= "000";
        wait for 5000 ms;
        Stop <= '0';
        wait for 5000 ms;
    end process;
    
    uut: Top_Level
        port map (
            Clk                 => Clk,
            i_Fast_Sw           => Fast,
            i_Stop_Btn          => Stop,
            i_Reset_Btn         => Reset,
            i_Error_Select_Sw   => Error_Sel,
            i_Data_Select_Sw    => Data_Sel,
            i_Display_Select_Sw => Display_Sel,
            o_LED               => LED,
            o_Segment_Cathodes  => Cathodes,
            o_Segment_Anodes    => Anodes
        );
end Behavioral;
