----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts  - 799236
-- Engineer: Finlay Orr     - 772579
--
-- Create Date: 01.02.2019 15:27:22
-- Module Name: Display_Driver
-- Description: Controls the value to be fed to the anodes and cathodes.  
--              Feeds a 4 bit binary value to the 7 seg decoder, and sets the anode
--              states. Triggers on a 250 CE pulse.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Display_Driver is
    port (
        -- Inputs
        i_Clk       :   in  std_logic;                      -- Global system clock, 100MHz
        i_Stop      :   in  std_logic;                      -- Stop signal, mapped to BTN Centre
        i_Symbol    :   in  std_logic;                      -- 2 symbol to be displayed on 7 seg
        i_DS        :   in  std_logic_vector(2 downto 0);   -- Data select value generated from switches position
        i_Data      :   in  std_logic;                      -- data value 
        i_CE_4Hz    :   in  std_logic;                      -- 4Hz clock enable 
        i_CE_250Hz  :   in  std_logic;                      -- Clock enable, pulses at 250Hz
        -- Outputs
        o_Cathode_Value  : out std_logic_vector(3 downto 0); -- 4 Bit binary value to be sent to 7 seg decoder
        o_Anode_Control  : out std_logic_vector(3 downto 0)  -- Anode control bits illuminate the 7 seg
    );
end Display_Driver;

architecture Behavioral of Display_Driver is

    -- Output buffer
    signal r_Anode_Control  : std_logic_vector(3 downto 0) := x"0"; -- Register holds the anode control bits
    signal r_Cathode_Value  : std_logic_vector(3 downto 0) := x"0"; -- 4 bit binary value stored in register
    signal r_Symbol_0       : std_logic_vector(1 downto 0) := "00"; -- 2 bit symbol 0 value to be displayed
    signal r_Symbol_1       : std_logic_vector(1 downto 0) := "00"; -- 2 bit symbol 1 value to be displayed
    signal r_Data_Packet    : std_logic_vector(3 downto 0) := x"0"; -- 4 bit data value to be displayed
    
    -- Control signals
    signal r_MUX_Sel    : integer range 0 to 3  := 3;       -- Control signal for the multiplexer that selects active anode
    signal r_Counter    : integer range 0 to 3  := 3;       -- Counter tracks the incoming serial bits
    
begin
    
    -- Connect I/O to internal registers
    o_Anode_Control <= r_Anode_Control;
    o_Cathode_Value  <= r_Cathode_Value;
    
    -- Data and symbol builder
    Packet_Builder: process (i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            if (i_CE_4Hz = '1') then
                r_Data_Packet(r_Counter) <= i_Data;
                case r_Counter is
                when 3 =>
                    r_Symbol_1(1)   <= i_Symbol;
                when 2 =>
                    r_Symbol_1(0)   <= i_Symbol;
                when 1 =>
                    r_Symbol_0(1)   <= i_Symbol;
                when 0 =>
                    r_Symbol_0(0)   <= i_Symbol;
                when others =>
                    r_Data_Packet(r_Counter) <= i_Data;
                end case;
                
                -- Counter control
                if (r_Counter = 0) then
                    r_Counter <= 3;
                else
                    r_Counter <= r_Counter - 1;
                end if;
                
            end if; -- clock enable check
        end if; -- rising edge check
    end process;  
    

    -- Symbol Packet builder
    Symbol_Builder: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            if (i_CE_4Hz = '1') then
                
            end if; -- clock enable
        end if; -- rising edge
    end process;   
     
    -- MUX controls output to the 7-seg decoder
    Display_Multiplexer: process (i_Clk)
    begin
        if (rising_edge(i_Clk)) then                            -- Sync to global system clock
            if (i_Stop = '1') then                              -- If the stop button is pressed
                r_Cathode_Value <= (others => '0');             -- Output 0000 on the display
            else        
                case (r_MUX_Sel) is                             -- Multiplexer is controlled by r_MUX_Sel
                when 3 =>                                   -- Anode 3 active (left digit on seven seg display)
                    r_Cathode_Value <= "0"  & i_DS;         -- Output the Data Select value, pad 0 to match into 7 seg decoder input bus width
                when 2 =>                                   -- Anode 2 active (second from left on 7 seg)
                    r_Cathode_Value <= r_Data_Packet;       -- Output the relevant data (e.g count value, random number, student number etc)
                when 1 =>                                   -- Anode 1 active (second from right anode)
                    r_Cathode_Value <= "000" & i_Symbol;    -- Output the left bit of the synbol
                when 0 =>                                   -- Anode 0 active (right end digit) 
                    r_Cathode_Value <= "000" & i_Symbol;    -- Display the right bit of the symbol on the anode to the right
                when others =>                              -- Others case to catch errors
                    r_Cathode_Value <= "0000";              -- Display 0000 in case of error
                end case;              
            end if;
        end if;
    end process;
    
    -- Cycle through the MUX inputs ( DATA SELECT VAL, DATA, SYMBOL BIT 1, SYMBOL BIT 0 )
    MUX_Controller: process (i_Clk)
    begin
        if (rising_edge(i_Clk)) then            -- Sync to global clock
            if (i_CE_250Hz = '1') then           -- Refresh the 7 seg 250 times per sec
                if (r_MUX_Sel = 0) then         -- If we're displaying the last anode on the 7 seg
                    r_MUX_Sel <= 3;             -- Loop back to the first anode
                else
                    r_MUX_Sel <= r_MUX_Sel -1;  -- Else move to the next anode
                end if;
            end if;
        end if;
    end process;
    
    with r_MUX_Sel select   
        r_Anode_Control <=  "1110" when 0,               -- if anode0 is selected set anode0 on the seven segment to low 
                            "1101" when 1,               -- if anode1 is selected set anode1 on the seven segment to low 
                            "1011" when 2,               -- if anode2 is selected set anode2 on the seven segment to low 
                            "0111" when 3,               -- if anode3 is selected set anode3 on the seven segment to low 
                            "0000" when others;          -- if multiplexor signal is outside of range set all anodes to low 
             
end Behavioral;