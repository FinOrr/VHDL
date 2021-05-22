library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Capture_Logic is
    port (
    -- Inputs
        Clk             : in std_logic;
        i_Pixel_Data    : in std_logic_vector(7 downto 0);
        i_VSync         : in std_logic;
        i_HSync         : in std_logic;
     -- Outputs
        o_Pixel_Data    : out std_logic_vector(7 downto 0);
        o_Ready         : out std_logic  
    );
end Capture_Logic;

architecture Behavioral of Capture_Logic is

    signal Y_Buffer : std_logic_vector(7 downto 0);
    signal U_Buffer : std_logic_vector(7 downto 0);
    signal V_Buffer : std_logic_vector(7 downto 0);
    signal Byte_Counter : unsigned(1 downto 0);         -- Each pixeL is output by the camera as 3 consecutive bytes (Y,U,V); byte counter tracks which one is active
    
    signal Pixel_Input  : std_logic_vector(7 downto 0); -- The byte output by the camera is stored in this register
    signal VSync        : std_logic;                    -- The Vertical Sync signal (output by the camera) is stored in this VSync register
    signal HSync        : std_logic;                    -- The Horizontal Sync signal (output by the camera) is stored in this HSync register
    
begin

    Counter: process(Clk)
    begin
        if (rising_edge(Clk)) then
            if (HSync = '1') then
                if (Byte_Counter = "10") then
                    Byte_Counter <= "00";
                else   
                    Byte_Counter <= Byte_Counter + 1;
                end if;
            else
                Byte_Counter <= "00";-- Reset the 
            end if;
        end if;
    end process;
    
    
    
end Behavioral;