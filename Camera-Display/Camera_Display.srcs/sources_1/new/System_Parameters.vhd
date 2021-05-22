library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;

package System_Parameters is
    
-- Camera Parameters
    constant I2C_SCL_FREQ : natural := 100_000; -- Serial clock frequency (Hz) for camera communications bus
    constant CAMERA_WRITE_ID : std_logic_vector(7 downto 0) := x"78"; -- Camera's I2C write address, can be found in datasheet
    
    
end package;
