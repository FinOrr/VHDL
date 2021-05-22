library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel is
    Port (
        Clk : in std_logic;
        Key : in std_logic_vector(1 downto 0);
        LED : out std_logic_vector(1 downto 0)   
    );
end TopLevel;

architecture Behavioral of TopLevel is
    
    constant COUNT_LIMIT    : natural := 100_000_000;
    signal r_Counter        : natural := 0;
    signal r_LED_Ctrl       : unsigned(1 downto 0) := "00";
    
    signal r_Pause  : std_logic := '0';
    signal r_Reset  : std_logic := '0';
    
begin
    
    LED <= std_logic_vector(r_LED_Ctrl);
    r_Pause <= Key(0);
    r_Reset <= Key(1);

    LED_Control: process(clk)
    begin
        if (rising_edge(clk)) then
            if (r_Reset = '1') then
                r_Counter <= 0;
                r_LED_Ctrl <= "00";
            else
                if (r_Pause = '0') then
                    if (r_Counter >= (COUNT_LIMIT - 1)) then
                        r_Counter   <= 0;
                        if (r_LED_Ctrl = "11") then
                            r_LED_Ctrl <= "00";
                        else
                            r_LED_Ctrl <= r_LED_Ctrl + 1;
                        end if;
                    else
                        r_Counter <= r_Counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
