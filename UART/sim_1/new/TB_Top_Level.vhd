----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2020 21:46:02
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_Top_Level is
--  Port ( );
end TB_Top_Level;

architecture Behavioral of TB_Top_Level is

    component Top_Level is
        port (
            Clk_100MHZ  : in std_logic;
            UART_INPUT  : in std_logic;
            LED         : out std_logic;
            UART_OUTPUT : out std_logic
        );
    end component;

    constant Clk_Period : time      := 10 ns;        -- For 100 MHz clock, the period is 10 ns    
    constant Sec        : time      := 1000 ms;
    constant Baud       : natural   := 115200;    -- Set the test baud rate in bits per second 
    constant Baud_Period: time      := 8681 ns;      -- = Baud^-1 = time to process one bit of data

    signal Clk          : std_logic := '0';
    signal UART_Input   : std_logic := '1';
    signal LED          : std_logic := '0';
    signal UART_Output  : std_logic := '1';
    
    signal Test_Vector  : std_logic_vector(9 downto 0) := "0101101111";
    
begin

    UUT: Top_Level
        port map (
            Clk_100MHZ  => Clk,
            UART_INPUT  => UART_Input,
            LED         => LED,
            UART_OUTPUT => UART_OUTPUT
        );
        
    Clocking: process
    begin
        Clk <= NOT Clk;
        wait for Clk_Period / 2;
    end process;
    
    Input_Stimulus: process
    begin
        wait for 100 us;
        for i in 9 downto 0 loop
            UART_Input <= Test_Vector(i);
            wait for Baud_Period;
        end loop;
        wait;
    end process;
end Behavioral;
