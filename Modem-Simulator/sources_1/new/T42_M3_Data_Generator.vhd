----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts  - 799236
-- Engineer: Finlay Orr     - 772579
--
-- Create Date: 18.01.2019 12:54:00
-- Module Name: Data_Generator
-- Project Name: Milestone_2

-- Description: Controls data generation depending on data select values
--              Updates at 1Hz using a clock enable signal
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Data_Generator is
    port (
        -- Inputs
        i_Clk          : in std_logic;                      -- System clock input (100MHz)
        i_Stop         : in std_logic;                      -- Start stop switch       
        i_Clock_Enable : in std_logic;                      -- 1 Hz Clock enable signal
        i_Data_Select  : in std_logic_vector(2 downto 0);   -- 3 Bit data select input, corresponding to switches 
        i_Reset        : in std_logic;                      -- Global reset
        -- Outputs
        o_Data         : out std_logic_vector(3 downto 0)   -- Data output to the Symbol Converter module
    );
end Data_Generator;

architecture Behavioral of Data_Generator is
    
    -- FSM Controls data output    
    type t_DS_State is (STOP, DS0, DS1, DS2, DS3, DS4, DS5, DS6, DS7, DS8);     -- Data select modelled as FSM

    signal r_Data           : std_logic_vector(3 downto 0);                 -- Data value to be output
    signal r_Count          : natural range 0 to 15 := 0;                   -- Counter used to count 0->F, value is output when Data Select = 4
    signal r_Bit_Index      : natural range 23 downto 0 := 23;              -- Holds the index of the student student number symbol to send [e.g. 7 or 9 or 9 or 2 or 3 or 6]
    signal r_Student1       : std_logic_vector(23 downto 0) := x"772579";   -- Student number for student 1 = 772579, consists of 24 bits [23 downto 19 = 7, etc]
    signal r_Student2       : std_logic_vector(23 downto 0) := x"799236";   -- Student number for student 2 = 799236
    signal r_State          : t_DS_State := STOP;                           -- Register to hold the current state of the FSM    
    signal r_State_Cache    : t_DS_State := STOP;                           -- Cache holds the previous state of FSM, is used when system is stopped
    signal r_LFSR           : std_logic_vector(32 downto 1) := x"5ef7370b"; -- Linear feedback shift register contents, seed of 5ef7370b
    signal r_XNOR           : std_logic := '0';                             -- XNOR value is shifted into LFSR to generate new values
    
begin

    -- Output Buffer
    o_Data <= r_Data;
    
    ------ Finite state machine updates states once per second depending on Data Select input ------ 
    State_Control: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then                    -- Sync on clock edge
            if (i_Stop = '1') then                      -- Check if system is stopped
                r_State <= r_State_Cache;               -- Hold current state
            else
                case i_Data_Select is                   -- Check the data select input, and set the corresponding state
                    when "000" =>
                        r_State <= DS0;
                    when "001" =>
                        r_State <= DS1;
                    when "010" =>
                        r_State <= DS2; 
                    when "011" =>
                        r_State <= DS3;
                    when "100" =>
                        r_State <= DS4;
                    when "101" =>
                        r_State <= DS5;
                    when "110" =>
                        r_State <= DS6;
                    when "111" =>
                        r_State <= DS7;
                    when others =>
                        r_State <= STOP;
                end case;
            end if;
        end if;
    end process;
    
    
    ------ Output of the FSM controls the bits to be displayed on the 7 segment ------
    Data_Output_Control: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then 
            r_State_Cache <= r_State;                               -- Store the current data value in a cache, in case the stop button is pressed
            if ((i_Reset = '1') or (r_State /= r_State_Cache)) then -- Check for the reset, or if there's been a change in state
                r_Bit_Index <= 23;                                  -- Start the student number from the first digit
                r_Data <= x"0";                                     -- Reset the output data register
                r_Count <= 0;                                       -- Reset the 0-F counter to 0 when you change states
                
            elsif (i_Clock_Enable = '1') then                       -- Check for 1Hz clock enable            
                if (i_Stop = '1') then                              -- Check if STOP button pressed and we're in STOP state
                    r_Data <= r_Data;                               -- If stop is set, keep the output constant
                else 
                    -- 0->F COUNTER CONTROL --
                    if (r_Count = 15) then                          -- Check if the 0-F counter is at upper limit (F)
                        r_Count <= 0;                               -- Reset the counter signal if true    
                    else
                        r_Count <= r_Count + 1;                     -- Increment the 0->F counter once per second if within limit
                    end if;
                    -- STUDENT NUMBER CONTROL --
                    if (r_Bit_Index <= 3) then                      -- If we're outputting the final digit
                        r_Bit_Index <= 23;                          -- Loop back to the first digit of the student number
                    else
                        r_Bit_Index <= r_Bit_Index - 4;             -- Move the bit index to the next byte
                    end if;
                end if;
            end if;
            
            -- Case statement used to switch output values depending on the active state in the FSM
            case r_State is
            
                when STOP =>
                    r_Data <= x"0";     -- Output 0000 when STOP button pressed
                    r_Bit_Index <= 0;   
                    
                when DS0 =>
                    r_Data <= x"1";     -- Output 0001 when Data_Select = 0
                
                when DS1 => 
                    r_Data <= x"7";     -- Output 0111 when Data_Select = 1
                
                when DS2 =>
                    r_Data <= x"E";     -- Output 1110 when Data_Select = 2
                
                when DS3 => 
                    r_Data <= x"8";     -- Output 1000 when Data_Select = 3
                
                when DS4 =>
                    r_Data <= std_logic_vector(to_unsigned(r_Count, 4));        -- Convert 0->F counter value to SLV, and output it
                
                when DS5 =>
                    r_Data <= r_LFSR(27 downto 26) & r_LFSR(18 downto 17);   -- Output the random value from the LFSR
                                        
                when DS6 =>
                    r_Data <= r_Student1(r_Bit_Index downto r_Bit_Index - 3); -- Output the first student number, digit by digit
                
                when DS7 =>
                    r_Data <= r_Student2(r_Bit_Index downto r_Bit_Index - 3); -- Output the second student number, digit by digit
                    
                when others =>      
                    r_Data <= x"F";     -- Output 1111 when error
                
            end case; -- State case
        end if;
    end process;
                
    ------ Linear Feedback Shift Register generates pseudo random number sequence ------
    LFSR: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then                                                        -- Sync to system clock
            if (i_Reset = '1') then                                                         -- Check for synchronous reset
                r_LFSR <= x"5ef7370b";                                                      -- If reset true, reset the LFSR to initial seed
            elsif (i_Clock_Enable = '1') then                                               -- Else check for 1Hz CE
                if (i_Stop = '0') then                                                      -- Keep LFSR value constant if we stop, otherwise:
                    r_XNOR <= r_LFSR(32) xnor r_LFSR(22) xnor r_LFSR(2) xnor r_LFSR(1);     -- Generate new bit for LFSR by XNOR'ing bits
                    r_LFSR <= r_LFSR(r_LFSR'high-1 downto 1) & r_XNOR;                      -- Shift new bit into the LFSR
                end if;
            end if;
        end if;
    end process;

end Behavioral;