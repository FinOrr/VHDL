----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2019 14:19:04
-- Design Name: 
-- Module Name: T42_M3_TB_Channel_Block_A - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity T42_M3_TB_Channel_Block_A is
--  Port ( );
end T42_M3_TB_Channel_Block_A;

architecture Behavioral of T42_M3_TB_Channel_Block_A is

    component T42_M3_Channel_Block_A is
        port (
        -- Inputs
            i_Clk           :   in STD_LOGIC;
            i_Reset         :   in STD_LOGIC;
            i_Clock_Enable  :   in STD_LOGIC;
            i_Error_Select  :   in STD_LOGIC_VECTOR (1 downto 0);
            i_I             :   in STD_LOGIC_VECTOR (7 downto 0);
            i_Q             :   in STD_LOGIC_VECTOR (7 downto 0);
     
        -- Outputs        
            o_I             :   out STD_LOGIC_VECTOR (7 downto 0);
            o_Q             :   out STD_LOGIC_VECTOR (7 downto 0)
         );
    end component;
    
    signal Clk, Reset, CE : std_logic;
    signal Error_Select : std_logic_vector(1 downto 0);
    signal I_RX, Q_RX, I_TX, Q_TX : std_logic_vector(7 downto 0);
    
begin

    clock: process
    begin
        Reset <= '0';
        Clk <= '1';
        wait for 5 ns;
        Clk <= '0';
        wait for 5 ns;
    end process;
    
    clock_enable: process
    begin
        CE <= '1';
        wait for 10 ns;
        CE <= '0';
        wait for 62.5 ms;
    end process;
    
    Error_Sel: process
    begin
        Error_Select <= "00";
        wait for 1000 ms;
        Error_Select <= "01";
        wait for 1000 ms;
        Error_Select <= "10";
        wait for 1000 ms;
        Error_Select <= "11";
        wait for 1000 ms;
    end process;
    
    input_wave_sim: process
    begin
    
    -- First Symbol Waveform: 00
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        I_RX <= x"C0";
        Q_RX <= x"C0";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"60";
        wait for 62.5 ms;
        I_RX <= x"40";
        Q_RX <= x"40";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"60";
        wait for 62.5 ms;
        
    -- Second Symbol Waveform: 10
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        I_RX <= x"40";
        Q_RX <= x"C0";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"60";
        wait for 62.5 ms;
        I_RX <= x"C0";
        Q_RX <= x"40";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"60";
        wait for 62.5 ms;
    
    -- Third Symbol Waveform: 11
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"60";
        wait for 62.5 ms;
        I_RX <= x"40";
        Q_RX <= x"40";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"60";
        wait for 62.5 ms;
        
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        I_RX <= x"C0";
        Q_RX <= x"C0";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"A0";
        wait for 62.5 ms;
            
    -- Fourth Symbol Waveform: 01
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"60";
        wait for 62.5 ms;
        I_RX <= x"C0";
        Q_RX <= x"40";
        wait for 62.5 ms;
        I_RX <= x"A0";
        Q_RX <= x"60";
        wait for 62.5 ms;
        
        I_RX <= x"80";
        Q_RX <= x"80";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        I_RX <= x"40";
        Q_RX <= x"C0";
        wait for 62.5 ms;
        I_RX <= x"60";
        Q_RX <= x"A0";
        wait for 62.5 ms;
        
    end process;
    
    uut: T42_M3_Channel_Block_A
        port map (
            i_Clk           => Clk,          
            i_Reset         => Reset,
            i_Clock_Enable  => CE,
            i_Error_Select  => Error_Select,
            i_I             => I_RX,
            i_Q             => Q_RX,
            o_I             => I_TX,
            o_Q             => Q_TX
        );

end Behavioral;
