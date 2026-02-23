library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin16_to_bcd_4x7seg is
    Port ( 
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           seg3    : out STD_LOGIC_VECTOR (6 downto 0); -- Thousands
           seg2    : out STD_LOGIC_VECTOR (6 downto 0); -- Hundreds
           seg1    : out STD_LOGIC_VECTOR (6 downto 0); -- Tens
           seg0    : out STD_LOGIC_VECTOR (6 downto 0)  -- Ones
         );
end bin16_to_bcd_4x7seg;

architecture Behavioral of bin16_to_bcd_4x7seg is

    -- Function to decode a 4-bit BCD number to 7-segment logic (Active-Low)
    function decode_7seg(bcd: unsigned(3 downto 0)) return STD_LOGIC_VECTOR is
        variable seg : STD_LOGIC_VECTOR(6 downto 0);
    begin
        case bcd is
            when "0000" => seg := "1000000"; -- 0
            when "0001" => seg := "1111001"; -- 1
            when "0010" => seg := "0100100"; -- 2
            when "0011" => seg := "0110000"; -- 3
            when "0100" => seg := "0011001"; -- 4
            when "0101" => seg := "0010010"; -- 5
            when "0110" => seg := "0000010"; -- 6
            when "0111" => seg := "1111000"; -- 7
            when "1000" => seg := "0000000"; -- 8
            when "1001" => seg := "0010000"; -- 9
            when others => seg := "1111111"; -- Blank if invalid
        end case;
        return seg;
    end decode_7seg;

begin

    process(data_in)
        -- We need a 36-bit variable for the shift register:
        -- 16 bits for the binary input + 20 bits for 5 BCD digits (5 x 4 bits)
        variable shift_reg : unsigned(35 downto 0);
    begin
        -- 1. Initialize the entire register to zeros
        shift_reg := (others => '0');
        
        -- 2. Load the binary input into the bottom 16 bits
        shift_reg(15 downto 0) := unsigned(data_in);

        -- 3. Execute the Double Dabble shift-and-add algorithm 16 times
        for i in 0 to 15 loop
            -- Check if any BCD column is >= 5. If it is, add 3.
            if shift_reg(19 downto 16) >= 5 then
                shift_reg(19 downto 16) := shift_reg(19 downto 16) + 3;
            end if;
            
            if shift_reg(23 downto 20) >= 5 then
                shift_reg(23 downto 20) := shift_reg(23 downto 20) + 3;
            end if;
            
            if shift_reg(27 downto 24) >= 5 then
                shift_reg(27 downto 24) := shift_reg(27 downto 24) + 3;
            end if;
            
            if shift_reg(31 downto 28) >= 5 then
                shift_reg(31 downto 28) := shift_reg(31 downto 28) + 3;
            end if;
            
            if shift_reg(35 downto 32) >= 5 then
                shift_reg(35 downto 32) := shift_reg(35 downto 32) + 3;
            end if;

            -- Shift the entire 36-bit register left by 1 bit
            shift_reg := shift_reg(34 downto 0) & '0';
        end loop;

        -- 4. Pass the calculated BCD blocks into the 7-segment decoder function
        -- (Bits 35 downto 32 contain the ten-thousands digit, which is left disconnected)
        seg3 <= decode_7seg(shift_reg(31 downto 28));
        seg2 <= decode_7seg(shift_reg(27 downto 24));
        seg1 <= decode_7seg(shift_reg(23 downto 20));
        seg0 <= decode_7seg(shift_reg(19 downto 16));

    end process;

end Behavioral;