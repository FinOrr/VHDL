----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2021 11:03:48
-- Design Name: 
-- Module Name: Switch_Debounce - Behavioral
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

entity Switch_Debounce is
    generic (
        Clk_Frequency   : natural;  -- Input clock frequency
        Hold_Time       : natural   -- Time input signal must be stable for (in ms)
    );
    port(
        Clk         : in std_logic;
        i_Reset     : in std_logic;
        i_Signal    : in std_logic;
        o_Signal    : out std_logic   
    );
end Switch_Debounce;

architecture Behavioral of Switch_Debounce is
    signal r_FF             : std_logic_vector(1 downto 0);
    signal r_Counter_Ctrl   : std_logic;
    signal r_Counter        : integer range 0 to (Clk_Frequency * Hold_Time)/1000;
begin

    D_Flip_Flop: process(Clk)
    begin
        if (rising_edge(Clk)) then
            if (i_Reset = '1') then
                r_FF <= "00";
                o_Signal <= '0';
            else
                r_FF(0) <= i_Signal;
                r_FF(1) <= r_FF(0);
                if (r_Counter_Ctrl = '1') then
                    r_Counter <= 0;
                elsif(r_Counter < (Clk_Frequency * Hold_Time)/1000) then
                    r_Counter <= r_Counter + 1;
                else
                    o_Signal <= r_FF(1);
                end if;  
            end if;
        end if;
    end process;
    
end Behavioral;