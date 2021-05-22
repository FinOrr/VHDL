----------------------------------------------------------------------------------
-- Team: 42
-- Engineer: Connor Crofts/Finlay Orr 799236/772579
-- 
-- Create Date: 10.12.2018 15:33:27
-- Design Name: 
-- Module Name: Debounce - Behavioral
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

entity Debounce is
    port (
        -- Inputs
        i_Clk     :   in  std_logic;
        i_Input   :   in  std_logic;
        -- Output
        o_Output  :   out std_logic
    );
end Debounce;

architecture Behavioral of Debounce is
    
    -- Counter keeps track of number of system clock cycles
    signal r_Counter    : integer range 0 to 2_000_000;
    
    -- Pulses high when counter reaches limit (20ms)
    signal r_Strobe     : std_logic;
    
    -- Input buffer
    signal r_Input      : std_logic;
    
    -- Output buffer
    signal r_Output     : std_logic;
    
    -- Output from flip flop 0
    signal r_FF0_Q          : std_logic;
    
    -- Output from flip flop 1
    signal r_FF1_Q          : std_logic;
    
    -- Counter reset signal, true if flip flop values are different
    signal r_Counter_Clr    : std_logic;
    
    -- Signal to enable output flip flop, goes high when signal has been stable for generic time
    signal r_Output_En      : std_logic;
    
    component D_Flip_Flop
        port(
            -- Inputs
            i_Clk     : in    std_logic;
            i_D       : in    std_logic;
            i_Enable  : in    std_logic;
            i_Reset   : in    std_logic := '0';
            -- Outputs
            o_Q       : out   std_logic := '0'   
        );
    end component;
    
begin
    
    FF1: D_Flip_Flop
        port map(
            i_Clk     =>  i_Clk,
            i_D       =>  r_Input,
            i_Enable  =>  '1',
            i_Reset   =>  open,
            o_Q       =>  r_FF0_Q
        );
        
    FF2: D_Flip_Flop
        port map(
            i_Clk     =>  i_Clk,
            i_D       =>  r_FF0_Q,
            i_Enable  =>  '1',
            i_Reset   =>  open,
            o_Q       =>  r_FF1_Q
        );
        
    FF3: D_Flip_Flop
        port map(
            i_Clk     =>  i_Clk,
            i_D       =>  r_FF1_Q,
            i_Enable  =>  r_Output_En,
            i_Reset   =>  open,
            o_Q       =>  r_Output
        );
    
    -- If input state is not steady, pulse counter clear    
    r_Counter_Clr <= r_FF0_Q XOR r_FF1_Q;
    
    -- I/O Buffers
    r_Input <= i_Input;
    o_Output  <= r_Output;
   
    -- Connect output buffer with FF Enable 
    r_Output_En  <= r_Strobe;
         
    Counter_Process:  Process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            if (r_Counter = 2000000 -1) then
                r_Counter <= 0;
                r_Strobe <= '1';
            -- If counter within valid range, increment counter and clear enable signal
            else
                r_Strobe <= '0';
                r_Counter <= r_Counter + 1;
            end if;
        end if;
    end process;  

end Behavioral;