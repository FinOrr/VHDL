--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:56:44 03/16/2017
-- Design Name:   
-- Module Name:   C:/Users/Fin/Documents/University/ENG 531/PLB2_Project_Bus/TB_PLB2_Project_Bus.vhd
-- Project Name:  PLB2_Project_Bus
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PBL2_Project_Bus
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_PLB2_Project_Bus IS
END TB_PLB2_Project_Bus;
 
ARCHITECTURE behavior OF TB_PLB2_Project_Bus IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PBL2_Project_Bus
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         button_bus : IN  std_logic_vector(2 downto 0);
         led_bus : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal button_bus : std_logic_vector(2 downto 0) := (others => '0');
	signal temp	: integer range 0 to 13 := 0;

 	--Outputs
   signal led_bus : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 500 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PBL2_Project_Bus PORT MAP (
          clk => clk,
          reset => reset,
          button_bus => button_bus,
          led_bus => led_bus
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

	-- Stimulus process
	stim_proc: process
	begin		
		loop
		-- insert stimulus here 
			button_bus <= "111";
			wait for clk_period;
			button_bus <= "110";
			wait for clk_period;
			button_bus <= "101";
			wait for clk_period;
			button_bus <= "100";
			wait for clk_period;
			button_bus <= "011";
			wait for clk_period;
			button_bus <= "010";
			wait for clk_period;
			button_bus <= "001";
			wait for clk_period;
			button_bus <= "000";
			wait for 10000 ms;
			
		end loop;
      wait;
   end process;

END;
