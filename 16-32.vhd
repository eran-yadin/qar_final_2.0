library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pad_16_to_32 is
    Port ( 
           data_in  : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0)
         );
end pad_16_to_32;

architecture Dataflow of pad_16_to_32 is
begin
    -- This sticks the 16-bit input on the left (Most Significant Bits) 
    -- and adds 16 zeros to the end/right (Least Significant Bits).
    data_out <=  "0000000000000000" & data_in ;
    
    -- NOTE: If you instead meant to add zeros to the front (left side) 
    -- to keep the same mathematical value (Zero-Extension), 
    -- delete the line above and use this line instead:
    -- data_out <= "0000000000000000" & data_in;
    
end Dataflow;