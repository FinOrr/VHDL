library WORK; 
use WORK.SYSTEM_PARAMETERS.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pulse_Generator is
    generic (
        Frequency    : natural          -- User inputs the desired pulse frequency as a generic
    );
    port( 
        -- Input
        Clk         : in  std_logic;     -- Input system clock, 100_000_000 for Basys 
        -- Output
        o_Signal    : out std_logic      -- Signal pulse is output at the desired frequency
    );
end Pulse_Generator;

architecture Behavioural of Pulse_Generator is

    ---- Signal declarations ----
    constant COUNT_LIMIT : natural := (SYS_XTAL_FREQ / Frequency) / 2;  -- Count limit gives the number of system clock cycles in one clock enable pulse
    signal r_Counter     : natural range 0 to Count_Limit := 0;         -- Counter holds the number clock cycles itereated so far in the clock enable cycles
    signal r_Pulse       : std_logic := '0';                            -- Clock enable register, fed to the output
    
begin        
    
    o_Signal <= r_Pulse;                            -- Pulse register drives the output

    Sig_Driver: Process(Clk)
    begin
        if rising_edge(Clk) then      
            if (r_Counter >= (COUNT_LIMIT - 1)) then    -- Check if counter has reached the upper limit
                r_Counter   <= 0;                       -- Reset counter when we reach the upper limit
                r_Pulse     <= not r_Pulse;             -- Set the pulse to true for one clock cycle
            else                                    
                r_Counter   <= r_Counter + 1;           -- Incremenet counter variable
            end if; -- End counter upper limit check
        end if; -- end rising clock edge check
    end process;
     
end architecture;