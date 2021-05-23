library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Decoder is
    port (
        -- Inputs
        Clk         : in std_logic;
        i_Control   : in std_logic_vector(1 downto 0);
        -- Outputs
        o_Enable    : out std_logic_vector(3 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is

    signal Control : std_logic_vector(1 downto 0);
    signal Enable  : std_logic_vector(3 downto 0);    

begin
        
    Enable(3) <= NOT Control(0) AND NOT Control(1);
    Enable(2) <= Control(0) AND NOT Control(1);
    Enable(1) <= NOT Control(0) AND Control(1);
    Enable(0) <= Control(0) AND Control(1);
    
    Decoder_Update: process(Clk)
    begin
        if rising_edge(Clk) then
            Control <= i_Control;   -- Sample inputs
            o_Enable <= Enable;     -- Drive outputs
        end if;
    end process;
    
end Behavioral;