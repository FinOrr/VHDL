----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts/Finlay Orr 799236/772579
-- 
-- Create Date: 10.12.2018 15:33:27
-- Design Name: 
-- Module Name: Signal_Generator - Behavioral
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

entity Signal_Generator is
    generic(
        -- upper limit of the counter
        Max_Count       : natural    
    );
    port( 
        -- Inputs
        -- system clock
        i_Clk             : in  STD_LOGIC;    
        -- Outputs
        -- pulses at a set frequency defined by the user
        o_Clock_Enable   : out STD_LOGIC     
    );
end Signal_Generator;

architecture SignalGeneratorArch of Signal_Generator is
    -- counter to drive the value signal generator
    signal r_Counter        :   natural range 0 to Max_Count;  
    -- Internal driver for clock enable signal;
    signal r_Clock_Enable   :   std_logic;                     
    begin
    
    o_Clock_Enable <= r_Clock_Enable;           

    ------------------------------ Clock Divider Process ----------------------------------------
    ClockDivider: Process (i_Clk)
    begin
        -- Sync on rising edge clock
        if rising_edge(i_Clk) then   
            -- If the count limit is reached:   
            if r_Counter >= (Max_Count - 1) then 
                -- Reset the counter to 0  
                r_Counter <= 0;   
            -- Else                      
            else  
                -- Increment at normal speed                                  
                r_Counter <= r_Counter + 1;         
            end if;
        end if;
    end process ClockDivider;
     
     ---------------------------- Count Compare Process -------------------------------------
     CountCompare: Process (i_Clk)
     begin
        --Pulse Generator
        if falling_edge(i_Clk) then
            -- If value counter is max value:
            if r_Counter >= (Max_Count - 1) then   
             -- Pulse CE signal for value counter
                r_Clock_Enable     <= '1';          
                -- IF NOT
            else                                    
            -- CE signal is off
                r_Clock_Enable     <= '0';          
            end if;
        end if;
     end process CountCompare; 
     
end architecture SignalGeneratorArch;