----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2020 20:59:58
-- Design Name: 
-- Module Name: TB_UART_RX - Behavioral
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
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_UART_RX is
--  Port ( );
end TB_UART_RX;

architecture Behavioral of TB_UART_RX is
    
    signal Clk          : std_logic := '0';
    signal RX         : std_logic := '1';                                 -- Data input port should be kept high while inactive
    signal RX_Finish  : std_logic := '0';
    signal RX_Byte    : std_logic_vector(7 downto 0) := (others => 'X');
    
    signal Byte_1       : std_logic_vector(7 downto 0) := x"01";
    signal Byte_2       : std_logic_vector(7 downto 0) := x"23";
    signal Byte_3       : std_logic_vector(7 downto 0) := x"45";
    
    constant Clk_Period : time := 10 ns;
    constant Sec        : time := 1000 ms;
    constant Baud_Period: time := 8681 ns; 
    constant Baud       : natural := 115200;
     
    
    component UART_Receiver is
        generic (
            BAUD_RATE   : natural
        );
        port (
            Clk         : in std_logic;                         -- System clock
            i_RX        : in std_logic;                         -- Serial input port
            o_RX_Finish : out std_logic;                        -- Signal driven high when finished recieving data
            o_RX_Byte   : out std_logic_vector(7 downto 0)      -- Byte output
        );
    end component;
       
begin

    UUT: UART_Receiver
        generic map (
            BAUD_RATE   => Baud
        )
        port map(
            Clk         => Clk,
            i_RX        => RX,
            o_RX_Finish => RX_Finish,
            o_RX_Byte   => RX_Byte
        );

    Clocking: process
    begin
        Clk <= NOT(Clk);
        wait for Clk_Period / 2;
    end process;
    
    RX_Stimulus: process
    begin
        -- UART is little endian, so LSB arrives first! --
        
        -- Cycle through the first byte
        RX  <= '0';                         -- Start bit
        wait for Baud_Period;
        for i in 0 to 7 loop                -- Data bits
            RX <= Byte_1(i);
            wait for Baud_Period;
        end loop;
        RX <= '1';                          -- Stop bit
        wait for 3 * Baud_Period;
        
        -- Cycle through the second byte
        RX  <= '0';                         -- Start bit
        wait for Baud_Period;
        for i in 0 to 7 loop                -- Data bits
            RX <= Byte_2(i);
            wait for Baud_Period;
        end loop;
        RX <= '1';                          -- Stop bit
        wait for 3 * Baud_Period;
        
        -- Cycle through the third byte
        RX  <= '0';                         -- Start bit
        wait for Baud_Period;
        for i in 0 to 7 loop                -- Data bits
            RX <= Byte_3(i);
            wait for Baud_Period;
        end loop;
        RX <= '1';                          -- Stop bit
        
        wait;
    end process;
end Behavioral;