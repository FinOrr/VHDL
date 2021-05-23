library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    generic (
        DATA_WIDTH : natural := 64      -- Size of the ALU in bits (64-bit by default)
    );
    port (
        Clk         : in std_logic;
        A           : in std_logic_vector(DATA_WIDTH-1 downto 0);
        Inv_A       : in std_logic;
        En_A        : in std_logic;
        B           : in std_logic_vector(DATA_WIDTH-1 downto 0);
        En_B        : in std_logic;
        F           : in std_logic_vector(1 downto 0);
        Increment   : in std_logic;
        Result      : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end ALU;

architecture Behavioral of ALU is

    signal Carry_In_Pipe    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal Carry_Out_Pipe   : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    component Bit_Slice is
        port (
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
    end component;

begin

    Carry_In_Pipe(0) <= Increment;
    
    BITSLICE: for slice in DATA_WIDTH-1 downto 0 generate
        ALU: Bit_Slice
            port map(
                Clk         => Clk,
                i_Inv_A     => Inv_A,
                i_A         => A(slice),
                i_En_A      => En_A,
                i_B         => B(slice),
                i_En_B      => En_B,
                i_Carry     => Carry_In_Pipe(slice), 
                i_F         => F,
                O_Carry     => Carry_Out_Pipe(slice),
                O_Result    => Result(slice)
            );
    end generate;
        
end Behavioral;