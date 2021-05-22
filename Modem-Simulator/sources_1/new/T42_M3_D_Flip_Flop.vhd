----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts/Finlay Orr 799236/772579
-- 
-- Create Date: 10.12.2018 15:33:27
-- Design Name: 
-- Module Name: D_Flip_Flop - Behavioral
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

entity D_Flip_Flop is
    port (
        -- Inputs
        i_Clk     : in    std_logic;
        i_D       : in    std_logic;
        i_Enable  : in    std_logic;
        i_Reset   : in    std_logic;
        -- Outputs
        o_Q       : out   std_logic := '0'
    );
end entity D_Flip_Flop;

architecture D_Flip_Flop_Arch of D_Flip_Flop is

    signal r_Output : std_logic := '0';
        
begin
    
    -- Output Buffer
    o_Q     <= r_Output;
    
    FF_Register : process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            -- if reset is pressed
            if (i_Reset = '1') then
                -- clear the output
                r_Output   <=  '0';
            -- otherwise
            else
                -- if enable is high
                if (i_Enable = '1') then
                    -- store input in register
                    r_Output   <=  i_D;
                end if;
            end if;
        end if;
    end process;
end architecture D_Flip_Flop_Arch;