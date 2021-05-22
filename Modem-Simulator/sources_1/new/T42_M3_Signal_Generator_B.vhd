
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Signal_Generator_B is
generic(
    CE_Frequency    : natural           -- User inputs the desired frequency as a generic
);
port( 
    -- Inputs
    Clk             : in  std_logic;    -- Input system clock, 100_000_000 for Basys 3
    -- Outputs
    Clock_Enable    : out std_logic     -- Clock enable signal is output at the desired frequency
);
end Signal_Generator_B;

architecture SignalGeneratorArch of Signal_Generator_B is

    -- Signal declarations
    constant Count_Limit : natural := 100_000_000 / CE_Frequency;   -- Count limit gives the number of system clock cycles in one clock enable pulse
    signal Counter       : natural range 0 to Count_Limit := 0;     -- Counter holds the number clock cycles itereated so far in the clock enable cycles
    
begin        

    CE_Driver: Process(Clk)
    begin
        if rising_edge(Clk) then      
            if Counter >= (Count_Limit - 1) then    -- Check if counter has reached the upper limit
                Counter <= 0;                       -- Reset counter when we reach the upper limit
                Clock_Enable <= '1';                -- Set the clock enable to true for one clock cycle
            else                                    
                Counter <= Counter + 1;             -- Incremenet counter variable
                Clock_Enable <= '0';                -- Clock enable disabled by default
            end if; -- End counter upper limit check
        end if; -- end rising clock edge check
    end process CE_Driver;
     
end architecture SignalGeneratorArch;