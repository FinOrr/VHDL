----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts/Finlay Orr 799236/772579
-- 
-- Create Date: 04.02.2019 13:41:15
-- Design Name: 
-- Module Name: T42_M2_Toggle_Switch - Behavioral

-- Tool Versions: 
-- Description: 
-- 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Toggle_Switch is
    port (
        -- Input
        i_Set   : in std_logic;     -- Input to be toggle on/off
        -- Output
        o_Q     : out std_logic     -- Output of the latch
    );
end Toggle_Switch;

architecture Behavioral of Toggle_Switch is

    signal r_Toggle : std_logic := '0'; -- Holds the current state of the switch 
    
begin

    o_Q <= r_Toggle;    -- Connect the register to the output
    
    Latch_Input: process(i_Set)
    begin
        if (rising_edge(i_Set)) then    -- If button is pressed
            r_Toggle <= not r_Toggle;   -- Toggle the output
        end if;
    end process;
    
end Behavioral;