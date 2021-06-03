----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2020 14:58:00
-- Design Name: 
-- Module Name: TB_UART_TX - Behavioral
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
library WORK;
use WORK.SYSTEM_PARAMETERS.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity TB_UART_TX is
--  Port ( );
end TB_UART_TX;

architecture Behavioral of TB_UART_TX is
    
    
    constant Clk_Period : time := 10 ns;        -- For 100 MHz clock, the period is 10 ns
    constant Sec        : time := 1000 ms;
    constant Baud_Period: time := 8681 ns;      -- = Baud^-1 = time to process one bit of data
    constant Baud       : natural := 115200;    -- Set the test baud rate in bits per second 
   
    signal Clk_Baud  : std_logic := '0';        -- Used for simualtion/debugging; shows when the UART clock is 'ticking'
    
    signal Clk       : std_logic := '1';
    signal TX_Ready  : std_logic := '0';
    signal TX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
    signal TX_Active : std_logic := '0';
    signal TX_Serial : std_logic := '0';
    signal TX_Finish : std_logic := '0';

    component UART_Transmitter is
        generic (
            BAUD_RATE   :   natural
        );
        port (
            Clk         : in std_logic;
            i_TX_Ready  : in std_logic;
            i_TX_Byte   : in std_logic_vector(7 downto 0);
            o_TX_Active : out std_logic;
            o_TX_Serial : out std_logic;
            o_TX_Finish : out std_logic
        );
    end component;
    
begin

    UUT: UART_Transmitter
        generic map (
            BAUD_RATE   => Baud
        )
        port map (
          Clk           =>  Clk,
          i_TX_Ready    =>  TX_Ready,
          i_TX_Byte     =>  TX_Byte,
          o_TX_Active   =>  TX_Active,
          o_TX_Serial   =>  TX_Serial,
          o_TX_Finish   =>  TX_Finish
        );
        
    Clock_Stimulus: process
    begin
        Clk <= not Clk;
        wait for Clk_Period / 2;
    end process;
    
    Input_Stimulus: process
    begin
        TX_Ready    <= '0';
        wait for Clk_Period;
        
        TX_Byte     <= x"01";
        TX_Ready    <= '1';
        wait for Clk_Period;
        
        TX_Ready    <= '0';
        wait for Baud_Period * 10;
        
        TX_Byte     <= "11101101";
        TX_Ready    <= '1';
        wait for Clk_Period;
        
        TX_Ready    <= '0';
        wait;
        
    end process;
    
    Baud_Clock: process
    begin
        Clk_Baud <= NOT Clk_Baud;
        wait for Baud_Period;
    end process;
    
end Behavioral;
