library WORK;
use WORK.SYSTEM_PARAMETERS.ALL;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Level is
    port (
        XTAL_100MHz   : in std_logic;
        VGA_Red       : out std_logic_vector(3 downto 0);
        VGA_Green     : out std_logic_vector(3 downto 0);
        VGA_Blue      : out std_logic_vector(3 downto 0);
        HSync         : out std_logic;
        VSync         : out std_logic
    );
end Top_Level;

architecture Behavioral of Top_Level is
    
    component Clock_Generator is
        Port (
            i_XTAL : in std_logic;
            o_25MHz : out std_logic;
            o_74MHz : out std_logic
        );
    end component;
    
    component VGA_Controller is
        generic (
            Pixel_Clk_Freq : natural
        );
        port (
            -- Inputs
            Clk          : in std_logic;
            i_Pixel_Data : in std_logic_vector(BPP-1 downto 0);
            -- Outputs
            o_Adr        : out std_logic_vector(FB_ADR_BUS_WIDTH-1 downto 0);
            o_HSync      : out std_logic;
            o_VSync      : out std_logic;
            o_Red        : out std_logic_vector(3 downto 0);
            o_Blue       : out std_logic_vector(3 downto 0);
            o_Green      : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- IO Buffer
    signal Pixel_Data   : unsigned(7 downto 0) := (others => '0');
    signal Clk_25MHz    : std_logic := '0';
    signal Clk_74MHz    : std_logic := '0';
--    signal Pixel_Cntr : unsigned(1 downto 0) := (others => '0');
--    signal Quadrant   : unsigned(3 downto 0) := (others => '0');
    
    begin
    
    Clocking: Clock_Generator
        port map (
            i_XTAL      => XTAL_100MHz,
            o_25MHz     => Clk_25MHz,
            o_74MHz     => Clk_74MHz
        );

    VGA_Driver: VGA_Controller
        generic map (
            Pixel_Clk_Freq => VGA_PXL_CLK_FREQ
        )
        port map (
            -- Inputs
            Clk          => Clk_74MHz,
            i_Pixel_Data => x"AA",
            -- Outputs   
            o_Adr        => open,
            o_HSync      => HSync,
            o_VSync      => VSync,
            o_Red        => VGA_Red,
            o_Green      => VGA_Green,
            o_Blue       => VGA_Blue
        );
        
end Behavioral;