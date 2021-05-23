library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Bit_Slice is
    port (
        -- Inputs
        Clk     : in std_logic;
        i_Inv_A : in std_logic;                         -- Control bit will NOT A when high
        i_A     : in std_logic;                         -- A input
        i_En_A  : in std_logic;                         -- Enable A
        i_B     : in std_logic;                         -- B input
        i_En_B  : in std_logic;                         -- Enable B
        i_Carry : in std_logic;                         -- Carry in bit
        i_F     : in std_logic_vector(1 downto 0);      -- Decoder control signals
        -- Outputs
        O_Carry : out std_logic;                        -- Carry out bit from the full adder
        O_Result: out std_logic                         -- Output bit of bit slice
    );
end Bit_Slice;

architecture Behavioral of Bit_Slice is

    -- Input signals must be combined into just A and B inputs
    signal Inv_A    : std_logic;
    signal A        : std_logic;
    signal En_A     : std_logic;
    signal B        : std_logic;
    signal En_B     : std_logic;
    -- The A and B inputs to the Logical Unit are:
    signal Logical_A        : std_logic;
    signal Logical_B        : std_logic;
    -- The Logical Unit output is:
    signal Logical_Output   : std_logic_vector(2 downto 0);
    
    -- Full Adder interface
    signal Adder_A      : std_logic;
    signal Adder_B      : std_logic;
    signal Adder_Sum    : std_logic;
    
    -- Decoder interface
    signal Enable_Bus   : std_logic_vector(3 downto 0);     -- The decoder output signals (3:1) enable the logical unit, output(0) enables the adder
    
    -- ALU Output
    signal ALU_Out  : std_logic;
    
    component Decoder is
        port (
            -- Inputs
            Clk         : in std_logic;
            i_Control   : in std_logic_vector(1 downto 0);
            -- Outputs
            o_Enable    : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component Full_Adder is
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
    end component;
    
    component Logical_Unit is
        port (
            -- Inputs
            Clk     : in std_logic;
            i_A     : in std_logic;
            i_B     : in std_logic;
            i_Enable: in std_logic_vector(2 downto 0);
            -- Outputs
            o_Result: out std_logic_vector(2 downto 0)
        );
    end component;
    
begin

    Output_Driver: process(Adder_Sum, Logical_Output)
    begin
        for i in 2 downto 0 loop
            o_Result <= Adder_Sum OR Logical_Output(i);
        end loop;
    end process;
    
    -- Interface Logical Unit with IO
    Logical_A <= (i_A AND i_EN_A) XOR i_Inv_A;
    Logical_B <= i_B AND i_En_B;
    
    Logic_Unit: Logical_Unit
        port map (
            Clk => Clk,
            i_A => Logical_A,
            i_B => Logical_B,
            i_Enable(2 downto 0) => Enable_Bus(3 downto 1),
            o_Result => Logical_Output
        );
    
    Decoder_Unit: Decoder
        port map (
            Clk => Clk,
            i_Control(1 downto 0) => i_F(1 downto 0),
            o_Enable(3 downto 0) => Enable_Bus(3 downto 0)  
        );
        
    Adder_Unit: Full_Adder
        port map (
            Clk => Clk,
            i_A => Logical_A,
            i_B => Logical_B,
            i_Carry => i_Carry,
            i_Enable => Enable_Bus(0),
            o_Carry => o_Carry,
            o_Sum => Adder_Sum
        );
end Behavioral;