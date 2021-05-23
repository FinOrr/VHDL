library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder is
    port (
        -- Inputs
        Clk         : in std_logic;
        i_A         : in std_logic;
        i_B         : in std_logic;
        i_Carry     : in std_logic;
        i_Enable    : in std_logic;
        -- Outputs
        o_Carry     : out std_logic;
        o_Sum       : out std_logic
    );
end Full_Adder;

architecture Behavioral of Full_Adder is

    signal A, B, Enable, Carry_In, Carry_Out, Sum : std_logic;
    
begin

    Carry_Out   <= (A AND B AND Enable) OR ((A XOR B) AND Carry_In AND Enable);
    Sum         <= Enable AND ((A XOR B) XOR Carry_In);
    
    Adder_Control: process(Clk)
    begin
        if rising_edge(Clk) then
            -- Sample input ports to local registers
            A <= i_A;
            B <= i_B;
            Enable <= i_Enable;
            Carry_In <= i_Carry;
            -- Drive output ports
            o_Carry <= Carry_Out;
            o_Sum <= Sum;
        end if;
    end process;
end Behavioral;