----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2019 17:54:48
-- Design Name: 
-- Module Name: T42_M3_TB_Scheme_B - Behavioral
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


entity T42_M3_TB_Scheme_B is
--  Port ( );
end T42_M3_TB_Scheme_B;

architecture Behavioral of T42_M3_TB_Scheme_B is

    component Scheme_B is
        port (    
            -- Inputs
            i_Clk           :   in  std_logic;
            i_CE_2Hz        :   in  std_logic;
            i_CE_16Hz       :   in  std_logic;
            i_Reset         :   in  std_logic;  
            i_Symbol_RX     :   in  std_logic_vector(1 downto 0);
            i_Error_Select  :   in  std_logic_vector(1 downto 0);
            
            -- Outputs
            o_Data            :   out std_logic;
            o_Symbol          :   out std_logic
        );
    end component;

    signal Clk, Reset, CE2, CE16, Data, Symbol : std_logic := '0';
    signal Symbol_RX, Error_Sel : std_logic_vector(1 downto 0) := "00";
   
begin

    uut: Scheme_B
        port map (
            i_Clk           => Clk,
            i_CE_2Hz        => CE2,
            i_CE_16Hz       => CE16,
            i_Reset         => Reset,
            i_Symbol_RX     => Symbol_RX,
            i_Error_Select  => Error_Sel,
            o_Data          => Data,
            o_Symbol        => Symbol
        );
    
    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    Clock_Enable_2: process
    begin
        CE2 <= '1';
        wait for 10 ns;
        CE2 <= '0';
        wait for 250 ms;
    end process;
    
    Clock_Enable_16: process
    begin
        CE16 <= '1';
        wait for 10 ns;
        CE16 <= '0';
        wait for 31250 us;
    end process;
    
    Input_Stimulus: process
    begin
        Symbol_RX <= "00";
        wait for 1000 ms;
        
        Error_Sel <= "01";
        wait for 1000 ms;
        
        Error_Sel <= "10";
        wait for 1000 ms;
        
        Error_Sel <= "11";
        wait for 1000 ms;
    end process;

end Behavioral;