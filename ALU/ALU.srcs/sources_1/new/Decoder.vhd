library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoder is
    port (
        -- Inputs
        i_Control   : in std_logic_vector(1 downto 0);
        -- Outputs
        o_Enable    : out std_logic_vector(3 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is

    signal Control : std_logic_vector(1 downto 0) := (others => '0');
    signal Enable  : std_logic_vector(3 downto 0) := (others => '0');    

begin

    Control <= i_Control;
    o_Enable <= Enable;
    
    Enable(0) <= NOT Control(0) AND NOT Control(1);
    Enable(1) <= NOT Control(0) AND Control(1);
    Enable(2) <= Control(0) AND NOT Control(1);
    Enable(3) <= Control(0) AND Control(1);
    
end Behavioral;
