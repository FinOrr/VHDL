
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pulse_Generator is
    generic(
        Frequency    : natural          -- User inputs the desired pulse frequency as a generic
    );
    port( 
        -- Input
        i_Clk       : in  std_logic;     -- Input system clock, 100_000_000 for Basys 3
        
        -- Output
        o_Strobe    : out std_logic      -- Strobe signal is output at the desired frequency
    );
end Pulse_Generator;

architecture Pulse_Generator_Arch of Pulse_Generator is

    ---- Signal declarations ----
    constant COUNT_LIMIT : natural := 100_000_000 / Frequency;     -- Count limit gives the number of system clock cycles in one clock enable pulse
    signal r_Counter     : natural range 0 to Count_Limit := 0;    -- Counter holds the number clock cycles itereated so far in the clock enable cycles
    signal r_Pulse       : std_logic := '0';                       -- Clock enable register, fed to the output
    
begin        
    
    o_Strobe <= r_Pulse;                            -- Pulse register drives the output

    CE_Driver: Process(i_Clk)
    begin
        if rising_edge(i_Clk) then      
            if r_Counter >= (COUNT_LIMIT - 1) then  -- Check if counter has reached the upper limit
                r_Counter   <= 0;                   -- Reset counter when we reach the upper limit
                r_Pulse     <= '1';                 -- Set the pulse to true for one clock cycle
            else                                    
                r_Counter   <= r_Counter + 1;       -- Incremenet counter variable
                r_Pulse     <= '0';                 -- Strobe disabled by default
            end if; -- End counter upper limit check
        end if; -- end rising clock edge check
    end process CE_Driver;
     
end architecture Pulse_Generator_Arch;