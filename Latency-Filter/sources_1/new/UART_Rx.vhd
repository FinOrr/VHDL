library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity UART_Receiver is
    generic (
        -- The frequency of the input clock, in Hertz. For 100MHz system clock, input = 100_000_000
        Sys_Freq  : natural;            
        -- The baud rate of the serial input. For a 38400 bits per second serial, input = 38_400
        Baud_Rate : natural             
    );
    port (
        -- System clock
        Clk         : in std_logic;                         
        -- Serial input port
        i_RX        : in std_logic;                         
        -- Signal driven high when finished recieving data
        o_RX_Finish : out std_logic;                        
        -- Byte output
        o_RX_Byte   : out std_logic_vector(7 downto 0)      
    );
end UART_Receiver;

architecture Behavioral of UART_Receiver is
    -- Number of system clock cycles per UART clock cycle
    constant CLKS_PER_BIT : natural := (Sys_Freq / Baud_Rate);     
    -- UART modelled as FSM
    type t_UART_SM is (IDLE, START_BIT, DATA_BIT, STOP_BIT, RESET);     
    -- Active state stored in register 'STATE'
    signal State : t_UART_SM := IDLE;                                   
    -- Buffer the input RX bit
    signal RX_Data_Buffer   : std_logic := '0';                         
    -- Register holds the double-flopped input bit
    signal RX_Data          : std_logic := '0';                         
    -- Clock edge counter, used to find the middle of the data bit
    signal Clk_Counter  : natural range 0 to CLKS_PER_BIT - 1 := 0;     
    -- Little endian goes from LSB -> MSB
    signal Bit_Index    : natural range 0 to 7 := 0;                    
    -- Output byte register
    signal RX_Byte      : std_logic_vector(7 downto 0) := x"00";        
    -- Finish signal register
    signal RX_Finish    : std_logic := '0';                             
begin
    -- Connect finish register to output
    o_RX_Finish <= RX_Finish;       
    -- Connect built byte register to output
    o_RX_Byte <= RX_Byte;           
    
    -- Double flop RX input to prevent metastability
    Double_Flop: process(Clk)               
    begin
        if (rising_edge(Clk)) then
            -- Feed the input into a buffer flip-flop
            RX_Data_Buffer <= i_RX;         
            -- Read buffer into active RX register
            RX_Data <= RX_Data_Buffer;      
        end if;
    end process;
    
    RX: process(Clk)
    begin
        if (rising_edge(Clk)) then
            case State is
                -- Idle is waiting for the start bit
                when IDLE =>            
                    -- Finish signal is false
                    RX_Finish <= '0';   
                    -- Reset clock edge counter
                    Clk_Counter <= 0;   
                    -- Reset bit index counter
                    Bit_Index <= 0;     
                    -- Check for line pulled low, this is the start bit
                    if (RX_Data = '0') then     
                        -- If start bit detected, change to start bit state
                        STATE <= START_BIT;     
                    else
                        -- If no start bit is detected, the line is still idle
                        STATE <= IDLE;          
                    end if;
                -- Sample start bit and confirm it is still low
                when START_BIT =>                                       
                    -- Wait until the middle of the bit
                    if (Clk_Counter = (Clks_Per_Bit - 1) / 2) then      
                        -- If the start bit is still low
                        if (RX_Data = '0') then                         
                            -- Reset clock counter, now for each Clks_Per_Bit period, 
                            -- the middle of the data bit is sampled
                            Clk_Counter <= 0;                           
                            -- Start bit is detected, move to reading data bit
                            STATE <= DATA_BIT;                          
                        else
                            -- The stop bit was not steady, reset to idle state
                            STATE <= IDLE;                              
                        end if;
                    -- If not in the middle of the bit yet
                    else                                                
                        -- Increment the clock counter
                        Clk_Counter <= Clk_Counter + 1;                 
                        -- Stay in START_BIT state until middle of bit sample
                        STATE <= START_BIT;                             
                    end if;
                    
                when DATA_BIT =>
                    -- If the system is NOT in the middle of the data bit
                    if (Clk_Counter < Clks_Per_Bit - 1) then            
                        -- Increment the clock edge counter
                        Clk_Counter <= Clk_Counter + 1;                 
                        -- Stay in the DATA BIT sampling state
                        STATE <= DATA_BIT;                              
                    -- ELSE the current clock cycle is in the middle of the data bit
                    else                                                
                        -- Reset the clock counter
                        Clk_Counter <= 0;                               
                        -- Sample the relevant bit into the RX_Byte register
                        RX_Byte(Bit_Index) <= RX_Data;                  
                        -- Check if whole byte HAS been sampled
                        if (Bit_Index = 7) then                         
                            -- Reset bit counter
                            Bit_Index <= 0;                             
                            -- Move to next state, STOP_BIT
                            STATE <= STOP_BIT;                          
                        -- If the whole byte HAS NOT been sampled
                        else                                            
                            -- Move to next bit index
                            Bit_Index <= Bit_Index + 1;                 
                            -- Stay in DATA_BIT sampling state
                            STATE <= DATA_BIT;                          
                        end if;
                    end if;
                    
                when STOP_BIT =>
                    -- Check if whole bit period HAS NOT passed
                    if (Clk_Counter < Clks_Per_Bit - 1) then            
                        -- Increment the clock counter
                        Clk_Counter <= Clk_Counter + 1;                 
                        -- Stay in the STOP_BIT state
                        STATE <= STOP_BIT;                              
                    -- If bit period is complete
                    else                                                
                        -- Signal end of byte, so RX_Byte can be read
                        RX_Finish <= '1';                               
                        -- Reset clock counter
                        Clk_Counter <= 0;                               
                        -- Move to reset state
                        STATE <= RESET;                                 
                    end if;
                    
                when RESET =>
                    -- Clear the FINISH output
                    RX_Finish <= '0';                                   
                    -- Move to the IDLE state
                    STATE <= IDLE;     
                                                     
                -- Catch errors
                when others =>                                          
                    -- Reset state to idle
                    STATE <= IDLE;     
                                                     
            end case;
        end if;
    end process;
end Behavioral;
