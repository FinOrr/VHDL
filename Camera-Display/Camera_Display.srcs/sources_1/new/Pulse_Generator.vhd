library WORK; 
use WORK.SYSTEM_PARAMETERS.ALL;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pulse_Generator is
    generic (
        Frequency    : natural          -- User inputs the desired pulse frequency as a generic
    );
    port( 
        Clk         : in  std_logic;     -- Input system clock, 100_000_000 Hz for Basys 3
        o_Signal    : out std_logic      -- Signal pulse is output at the desired frequency
    );
end Pulse_Generator;

architecture Behavioural of Pulse_Generator is

    constant COUNT_LIMIT : natural := (SYS_XTAL_FREQ / Frequency) / 2;  -- Count limit gives the number of system clock cycles in one clock enable pulse
    signal Counter  : natural range 0 to Count_Limit := 0;              -- Counter holds the number clock cycles itereated so far in the clock enable cycles
    signal Pulse    : std_logic := '0';                                 -- Clock enable register, fed to the output
    
begin        
    
    o_Signal <= Pulse;      -- Pulse register drives the output

    Signal_Driver: Process(Clk)
    begin
        if rising_edge(Clk) then      
            if (Counter >= (COUNT_LIMIT - 1)) then  -- Check if counter has reached the upper limit
                Counter   <= 0;                     -- Reset counter when we reach the upper limit
                Pulse     <= NOT Pulse;             -- Set the pulse to true for one clock cycle
            else                                    
                Counter   <= Counter + 1;           -- Incremenet counter variable
            end if;     -- End counter upper limit check
        end if;     -- end rising clock edge check
    end process;
     
end architecture;