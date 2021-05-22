----------------------------------------------------------------------------------
-- Company: -
-- Engineer: Fin Orr
-- 
-- Create Date:    15:48:42 03/16/2017 
-- Design Name: 	tl0.01
-- Module Name:		PBL2_Project_Bus - Behavioral 
-- Project Name:	Traffic Lights
-- Target Devices:	XCR3064XL
-- Tool versions:	//
-- Description:		Translates binary button input to unary output on the on-board led's
--
-- Dependencies:	NIL
--
-- Revision:		0.01
-- Revision 0.01 	- 	File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity PBL2_Project_Bus is
	Port ( 
		clk, reset	: in  	STD_LOGIC;
		button_bus	: in  	STD_LOGIC_VECTOR (2 downto 0);		-- [0 = Red]; [1 = Amber]; [2 = Green];
		led_bus		: out  	STD_LOGIC_VECTOR (5 downto 0));		-- _0[GreenLower,AmberLower,RedLower,GreenUpper,AmberUpper,RedUpper]_5

end PBL2_Project_Bus;

architecture Behavioral of PBL2_Project_Bus is
	signal counter		: INTEGER range 0 to 12 		:= 0;			-- Init counter signal
	signal led_bus_seq	: STD_LOGIC_VECTOR(5 downto 0)	:= "000000";	-- Init intermediate signal for seq logic
	signal led_bus_com	: STD_LOGIC_VECTOR(5 downto 0)	:=	"000000";	-- Init intermediate sig for combi logic
begin
	-- Demultiplexer sorts combi-logic from sequential logic
	led_bus		<= 	led_bus_seq when button_bus = "000" else
					led_bus_com;			
	
	--Binary to unary signal assignments
	--green lower led--
	led_bus_com(0)	<=	'1' when button_bus = "110" else
						'1' when button_bus = "101" else
						'1' when button_bus = "100" else
						'1' when button_bus = "011" else
						'1' when button_bus = "010" else 
						'1' when button_bus = "001" else '0'; 
	--amber lower led--
	led_bus_com(1)	<=	'1' when button_bus = "101" else
						'1' when button_bus = "100" else
						'1' when button_bus = "011" else
						'1' when button_bus = "010" else 
						'1' when button_bus = "001" else '0'; 
	--red lower led--
	led_bus_com(2)	<=	'1' when button_bus = "100" else
						'1' when button_bus = "011" else
						'1' when button_bus = "010" else 
						'1' when button_bus = "001" else '0'; 
	--green upper led--
	led_bus_com(3)	<=	'1' when button_bus = "011" else
						'1' when button_bus = "010" else 
						'1' when button_bus = "001" else '0'; 
	--amber upper led--
	led_bus_com(4)	<=	'1' when button_bus = "010" else 
						'1' when button_bus = "001" else '0'; 
	--red upper led--
	led_bus_com(5)	<=	'1' when button_bus = "001" else '0'; 
	
	--Sequential logic
	led_sequence: process (counter) 
    begin
        case counter is
            When 0 =>
                led_bus_seq <= "100000"; -- State 0
            When 1 =>
                led_bus_seq <= "110000"; -- State 1
            When 2 =>
                led_bus_seq <= "011000"; -- State 2
            When 3 =>
                led_bus_seq <= "001100"; -- State 3
            When 4 =>
                led_bus_seq <= "000110"; -- State 4
            When 5 =>
                led_bus_seq <= "000011"; -- State 5
            When 6 =>
                led_bus_seq <= "000001"; -- State 6
            When 7 =>
                led_bus_seq <= "000011"; -- State 7
            When 8 =>
                led_bus_seq <= "000110"; -- State 8
            When 9 =>
                led_bus_seq <= "001100"; -- State 9
            When 10 =>
                led_bus_seq <= "011000"; -- State A
            When 11 =>
                led_bus_seq <= "110000"; -- State B
			When 12 =>
				led_bus_seq <= "100000"; -- State 0 
            When others => 
                led_bus_seq <= "101010"; -- Display error
        end case;               
    end process;
	
	counter_sequence: process (clk, reset)
		begin
			if rising_edge(clk) then		
				if (counter = 11) then		-- IF end of sequence
					counter <= 0;				-- Restart the sequence
				else
					counter <= counter + 1;	-- Incremement the state counter
				end if;		-- END counter limit check
			end if;		-- END reset / rising edge check		
		end process;-- END flashing_process
end Behavioral;
