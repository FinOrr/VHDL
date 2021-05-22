----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2019 11:29:17
-- Design Name: 
-- Module Name: T42_M3_TB_Demodulator_B - Behavioral
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

entity T42_M3_TB_Demodulator_B is
--  Port ( );
end T42_M3_TB_Demodulator_B;

architecture Behavioral of T42_M3_TB_Demodulator_B is

    component Demodulator_B is
        port (
            -- Inputs
            Clk      :   in  std_logic;
            Clock_En :   in  std_logic;
            Reset    :   in  std_logic;
            I_RX     :   in  std_logic_vector(7 downto 0);
            Q_RX     :   in  std_logic_vector(7 downto 0);
            
            -- Outputs
            Data     :   out std_logic;
            Symbol   :   out std_logic
        );
    end component;

    signal Clk, Clock_En, Reset, Data, Symbol : std_logic := '0';
    signal I_RX, Q_RX : std_logic_vector(7 downto 0) := x"0";

begin
    
    clocking: process
    begin
        Clk <= NOT Clk;
        wait for 5 ns;
    end process;
    
    Clock_Enable: process
    begin
        Clock_En <= not Clock_En;
        wait for 5 ns;
        Clock_En <= not Clock_En;
        wait for 10 ns;
    end process;
    
    uut: Demodulator_B
        port map (
            Clk         => Clk,
            Clock_En    => Clock_En,
            Reset       => Reset,
            I_RX        => I_RX,
            Q_RX        => Q_RX,
            Data        => Data,
            Symbol      => Symbol
        );
        
    Input_Stimulus: process
    begin
        I_RX <= x"4000";
        Q_RX <= x"4000";
        wait for 20 ns;
        
        I_RX <= x"4000";
        Q_RX <= x"4000";
        wait for 20 ns;
        
        I_RX <= x"6184";
        Q_RX <= x"4F00";
        wait for 20 ns;
        
        I_RX <= x"9000";
        Q_RX <= x"6000";
        wait for 20 ns;
        
        I_RX <= x"6184";
        Q_RX <= x"4F00";
        wait for 20 ns;
        
        I_RX <= x"4000";
        Q_RX <= x"4000";
        wait for 20 ns;
        
        I_RX <= x"2400";
        Q_RX <= x"3000";
        wait for 20 ns;
        
        I_RX <= x"1000";
        Q_RX <= x"2000";
        wait for 20 ns;
        
        I_RX <= x"2400";
        Q_RX <= x"3000";
        wait for 20 ns;
        
    end process;
end Behavioral;
