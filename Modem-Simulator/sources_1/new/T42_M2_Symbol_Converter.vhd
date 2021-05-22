----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts  - 799236 
--           Finlay Orr     - 772579

-- Create Date: 01.02.2019 11:33:31
-- Design Name: 
-- Module Name: Symbol_Converter - Behavioral
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

entity Symbol_Converter is
    port (
        -- Inputs
        i_Clk   : in std_logic;
        i_Pause : in std_logic;
        i_Stop  : in std_logic;
        i_Reset : in std_logic;
        i_CE2Hz : in std_logic;
        i_Data  : in std_logic_vector(3 downto 0);
        --Outputs
        o_Symbol : out std_logic_vector(1 downto 0)
    );
end Symbol_Converter;

architecture Behavioral of Symbol_Converter is

    -- Signal Declarations
    -- System clock
    signal r_Clk     : std_logic := '0';                      
    -- 2Hz Clock enable signal
    signal r_CE      : std_logic := '0';                       
    -- Input data buffer
    signal r_Data    : std_logic_vector(3 downto 0) := x"0";    
    -- Output symbol buffer
    signal r_Active_Symbol  : std_logic_vector(1 downto 0) := "00";    
    -- Symbol 1 value 
    signal r_Symbol1 : std_logic_vector(1 downto 0) := "00";    
    -- Symbol 2 value
    signal r_Symbol2 : std_logic_vector(1 downto 0) := "00";     
    -- Multiplexer control logic
    signal r_MUX_Sel : std_logic := '1';                        
    
begin

    -- Input / Output Buffers
    r_Clk   <= i_Clk;
    r_CE    <= i_CE2Hz;
    r_Data  <= i_Data;
    o_Symbol <= r_Active_Symbol;
    
    -- Bus breakout splits input data into two 2-bit wires, Symbol1 and Symbol 2
    r_Symbol1 <= r_Data(3 downto 2);
    r_Symbol2 <= r_Data(1 downto 0);
    
    Symbol_Gen: process(r_Clk)
    begin
         -- Check for rising clock edge
        if rising_edge(r_Clk) then             
            if (i_Reset = '1') then
                r_MUX_Sel <= '0';
                -- Check for 2Hz Clock Enable
            elsif (r_CE = '1') then                
                -- If the system is paused 
                if (i_Pause = '1') or (i_Stop = '1') then         
                    -- Check for the current MUX control, to stop updating the symbol 
                    if (r_MUX_Sel = '0') then   
                        -- Keep the signal at 0
                        r_MUX_Sel <= '0';       
                    else 
                        -- If MUX_Sel is 1, then stay at 1, until system is unpaused
                        r_MUX_Sel <= '1';       
                    end if;
                else
                    -- Alternate Multiplexer Control signal (MUX_Sel) between 0 and 1 every Clock Enable
                    -- Multiplex symbol 1 and symbol 2, and alternate output               
                    case r_MUX_Sel is
                        when '0' =>
                            r_Active_Symbol <= r_Symbol1;
                            r_MUX_Sel       <= '1';
                        when '1' =>
                            r_Active_Symbol <= r_Symbol2;
                            r_MUX_Sel       <= '0';
                        when others =>
                            -- Switch to first symbol in case of error
                            r_MUX_Sel       <= '0';     
                    end case;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;