----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2019 13:03:06
-- Design Name: 
-- Module Name: Modulator_A - Behavioral
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


entity Modulator_A is
    Port ( 
    -- Inputs
        i_Clk       : in STD_LOGIC;
        i_Reset     : in STD_LOGIC;
        i_CE_16Hz   : in STD_LOGIC;
        i_Symbol    : in STD_LOGIC_VECTOR (1 downto 0);
    
    -- Outputs
        o_I         : out STD_LOGIC_VECTOR (7 downto 0);
        o_Q         : out STD_LOGIC_VECTOR (7 downto 0)
    );
                
end Modulator_A;


architecture Behavioral of Modulator_A is

    -- Registers hold sample amplitudes for each of the 8 points on the wave
    signal r_I_Sample : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal r_Q_Sample : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
    -- Each waveform point is modelled as a state in the FSM
    -- Each waveform has 8 samples represented by S7 -> S0
    type State_Type IS (S7, S6, S5, S4, S3, S2, S1, S0);
    signal State : State_Type;

begin
    
    -- Connect registers to output
    o_I <= r_I_Sample;
    o_Q <= r_Q_Sample;
    
    -- FSM state control process
    State_Ctrl : process(i_Clk)
    begin  
        if(rising_edge(i_Clk)) then
            if(i_Reset = '1') then 
                State <= S7;
            elsif (i_CE_16Hz = '1') then
                -- Switch between FSM states using case statement
                case State is                
                    -- First sample 
                    when S7 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when "10" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when "11" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when "01" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S6;
                    
                    -- Second sample
                    when S6 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"A0";
                            when "10" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"A0";
                            when "11" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"60";
                            when "01" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"60";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S5;
                        
                    -- Third sample
                    when S5 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"C0";
                                r_Q_Sample <= x"C0";
                            when "10" =>
                                r_I_Sample <= x"40";
                                r_Q_Sample <= x"C0";
                            when "11" =>
                                r_I_Sample <= x"40";
                                r_Q_Sample <= x"40";
                            when "01" =>
                                r_I_Sample <= x"C0";
                                r_Q_Sample <= x"40";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S4;
                        
                    -- Fourth sample
                    when S4 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"A0";
                            when "10" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"A0";
                            when "11" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"60";
                            when "01" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"60";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S3;
                        
                    -- Fifth sample
                    when S3 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when "10" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when "11" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when "01" =>
                                r_I_Sample <= x"80";
                                r_Q_Sample <= x"80";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S2;
                        
                    -- Sixth sample
                    when S2 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"60";
                            when "10" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"60";
                            when "11" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"A0";
                            when "01" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"A0";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S1;
                        
                    -- Seventh sample
                    when S1 =>
                        case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"40";
                                r_Q_Sample <= x"40";
                            when "10" =>
                                r_I_Sample <= x"C0";
                                r_Q_Sample <= x"40";
                            when "11" =>
                                r_I_Sample <= x"C0";
                                r_Q_Sample <= x"C0";
                            when "01" =>
                                r_I_Sample <= x"40";
                                r_Q_Sample <= x"C0";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S0;
                        
                    -- Eighth sample
                    when S0 =>
                       case i_Symbol is
                            when "00" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"60";
                            when "10" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"60";
                            when "11" =>
                                r_I_Sample <= x"A0";
                                r_Q_Sample <= x"A0";
                            when "01" =>
                                r_I_Sample <= x"60";
                                r_Q_Sample <= x"A0";
                            when others =>
                                r_I_Sample <= (others => '0');
                                r_Q_Sample <= (others => '0');
                        end case;
                        State <= S7;
                        
                    -- Reset to start if error
                    when others =>
                        State <= S7;    
                end case;
            end if;
        end if;
    end process;
end Behavioral;
