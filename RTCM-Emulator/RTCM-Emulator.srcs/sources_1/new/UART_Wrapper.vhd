----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2020 20:58:25
-- Design Name: 
-- Module Name: Top_Level - Behavioral
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

entity UART_Wrapper is
    port (
        Clk_100MHZ  : in std_logic;
        UART_In     : in std_logic;
        Switch      : in std_logic_vector(2 downto 0);
        LED         : out std_logic;
        UART_Out    : out std_logic
    );
end UART_Wrapper;

architecture Behavioral of UART_Wrapper is

    component Switch_Debounce
        generic (
            Clk_Frequency   : natural;
            Hold_Time       : natural
        );
        port (
            Clk         : in std_logic;
            i_Reset     : in std_logic;
            i_Signal    : in std_logic;
            o_Signal    : out std_logic
        );
    end component;

    component Pulse_Generator
        generic (
            Frequency    : natural          -- User inputs the desired pulse frequency as a generic
        );
        port( 
            Clk         : in  std_logic;     -- Input system clock, 100_000_000 for Basys 
            o_Signal    : out std_logic      -- Signal pulse is output at the desired frequency
        );
    end component;

    component UART_Receiver
        generic (
            BAUD_RATE : natural
        );
        port (
            Clk         : in std_logic;                         -- System clock
            i_RX        : in std_logic;                         -- Serial input port
            o_RX_Finish : out std_logic;                        -- Signal driven high when finished recieving data
            o_RX_Byte   : out std_logic_vector(7 downto 0)      -- Byte output
        );
    end component;
    
    component UART_Transmitter is
        generic (
            BAUD_RATE : natural
        );
        port (
            Clk         : in std_logic;                     -- System clock input
            i_TX_Ready  : in std_logic;                     -- High when data has been loaded to TX_Byte
            i_TX_Byte   : in std_logic_vector(7 downto 0);  -- Byte to be transmitted serially
            o_TX_Active : out std_logic;                    -- Active infers tri-state buffer, as communications only use 1 wire
            o_TX_Serial : out std_logic;                    -- Serial data output port
            o_TX_Finish : out std_logic                     -- Signal that byte has been transmitted
        );
    end component;
    
    signal RX_Finish    : std_logic;
    signal RX_Byte      : std_logic_vector(7 downto 0);
    signal TX_Ready     : std_logic;
    signal TX_Byte      : std_logic_vector(7 downto 0);
    signal TX_Active    : std_logic;
    signal TX_Finish    : std_logic;
    signal LED_Flag     : std_logic;
    signal TX_Enable    : std_logic;
    signal CE_1Hz       : std_logic;
    
begin
    
    LED <= LED_Flag;
    TX_Enable <= Switch(0);
        
    CE_Generator: Pulse_Generator
        generic map (
            Frequency   => 1
        )
        port map (
            Clk         => Clk_100MHz,
            o_Signal    => CE_1Hz
        );

    UART_RX: UART_Receiver
        generic map (
            BAUD_RATE   => BAUD_RATE
        )
        port map (
            Clk         => Clk_100MHZ,      -- System clock
            i_RX        => UART_In,     -- Serial input port
            o_RX_Finish => RX_Finish,     -- Signal driven high when finished recieving data
            o_RX_Byte   => RX_Byte     -- Byte output
        );
        
    UART_TX: UART_Transmitter
        generic map (
            BAUD_RATE   => BAUD_RATE
        )
        port map (
            Clk         => Clk_100MHZ,
            i_TX_Ready  => TX_Ready,
            i_TX_Byte   => TX_Byte,
            o_TX_Active => TX_Active,
            o_TX_Serial => UART_Out,
            o_TX_Finish => TX_Finish
        );
           
end Behavioral;