library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Logical_Unit is
    port (
        -- Inputs
        Clk     : in std_logic;
        i_A     : in std_logic;
        i_B     : in std_logic;
        i_Enable: in std_logic_vector(2 downto 0); -- Enable(2) = AB;   Enable(1) = A+B;    Enable(0) = NOT-B. Signals driven by the decoder unit
        -- Outputs
        o_Result: out std_logic_vector(2 downto 0)  -- This bus contains the AB / A+B / NOT-B logic status using wires (2:0)
    );
end Logical_Unit;

architecture Behavioral of Logical_Unit is

    signal A, B : std_logic;
    signal Enable, Result : std_logic_vector(2 downto 0);
    
begin
    
    Result(2) <= (A AND B) AND Enable(2);  
    Result(1) <= (A OR B) AND Enable(1);
    Result(0) <= (NOT B) AND Enable(0);
    
    Logic_Control: process(Clk)
    begin
        if rising_edge(Clk) then
            -- Sample the input ports to local registers
            A <= i_A;
            B <= i_B;
            Enable(2 downto 0) <= i_Enable(2 downto 0);
            -- Drive output ports from local registers
            o_Result(2 downto 0) <= Result(2 downto 0);
        end if;
    end process;
end Behavioral;