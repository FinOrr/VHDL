library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TB_I2C_Controller is
--  Port ( );
end TB_I2C_Controller;

architecture Behavioral of TB_I2C_Controller is

    component I2C_Controller is
        port (
        -- Inputs
        Clk         : in std_logic;                         -- Serial clock input
        i_Reset     : in std_logic;                         -- Pulses high to signal system reset condition
        i_Start     : in std_logic;                         -- Pulses high when inputs are loaded with data to be transmitted
        i_Slave_Adr : in std_logic_vector(7 downto 0);      -- Device ID and R/W bit
        i_Reg_Adr   : in std_logic_vector(15 downto 0);     -- Camera register address, the OV5642 uses 16-bit address registers (read from ROM)
        i_Reg_Val   : in std_logic_vector(7 downto 0);      -- Camera register data value (read from ROM)
        -- Outputs
        o_Idle      : out std_logic;                        -- Signals when the sender is idle
        o_SDA       : out std_logic;                        -- Serial Data Line output to the camera module
        o_SCL       : out std_logic                         -- Serial Clock Line output to the camera module
    );
    end component;

    signal Clk, Reset, Start, Idle, SDA, SCL : std_logic := '0';
    signal Slave_Adr, Reg_Val : std_logic_vector(7 downto 0) := (others => 'Z');
    signal Reg_Adr : std_logic_vector(15 downto 0) := (others => 'Z');
    
    
    component I2C_ROM is
        port (
        -- Inputs
        Clk     : in std_logic;         -- Clock running at I2C transmit frequency
        i_Idle  : in std_logic;
        i_Reset : in std_logic;
        -- Outputs
        o_Start : out std_logic;
        o_Slave_Adr : out std_logic_vector(7 downto 0);
        o_Reg_Adr   : out std_logic_vector(15 downto 0);
        o_Reg_Val   : out std_logic_vector(7 downto 0)
        );
    end component;
    
begin

    UUT: I2C_Controller
        port map (
            Clk         => Clk,
            i_Reset     => Reset,
            i_Start     => Start,
            i_Slave_Adr => Slave_Adr,
            i_Reg_Adr   => Reg_Adr,
            i_Reg_Val   => Reg_Val,
            o_Idle      => Idle,
            o_SDA       => SDA,
            o_SCL       => SCL
        );

    ROM: I2C_ROM
        port map (
            Clk         => Clk,
            i_Idle      => Idle,
            i_Reset     => Reset,
            o_Start     => Start,
            o_Slave_Adr => Slave_Adr,
            o_Reg_Adr   => Reg_Adr,
            o_Reg_Val   => Reg_Val
        );
    Clocking: process
    begin
        Clk <= not Clk;
        wait for 5 ns;
    end process;
    
    
end Behavioral;