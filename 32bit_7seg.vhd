library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin32_to_bcd_switchable is
    Port ( 
           -- 32-bit input bus
           data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           
           -- The switch to choose which half to display (0 = Lower 4 digits, 1 = Upper 4 digits)
           sel     : in  STD_LOGIC; 
           
           -- The four 7-segment displays (Active-Low)
           seg3    : out STD_LOGIC_VECTOR (6 downto 0); 
           seg2    : out STD_LOGIC_VECTOR (6 downto 0);
           seg1    : out STD_LOGIC_VECTOR (6 downto 0);
           seg0    : out STD_LOGIC_VECTOR (6 downto 0)  
         );
end bin32_to_bcd_switchable;

architecture Behavioral of bin32_to_bcd_switchable is

    -- Function to decode 4-bit BCD into 7-segment logic
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

    process(data_in, sel)
        -- We need a 72-bit register: 
        -- 32 bits for binary input + 40 bits for 10 BCD digits (10 digits x 4 bits)
        variable shift_reg : unsigned(71 downto 0);
        variable current_bcd : unsigned(15 downto 0);
    begin
        -- Initialize the register to all zeros
        shift_reg := (others => '0');
        
        -- Load the 32-bit binary input into the bottom 32 bits
        shift_reg(31 downto 0) := unsigned(data_in);

        -- Execute the Double Dabble algorithm 32 times
        for i in 0 to 31 loop
            -- Check all 10 BCD columns. If >= 5, add 3.
            if shift_reg(35 downto 32) >= 5 then shift_reg(35 downto 32) := shift_reg(35 downto 32) + 3; end if;
            if shift_reg(39 downto 36) >= 5 then shift_reg(39 downto 36) := shift_reg(39 downto 36) + 3; end if;
            if shift_reg(43 downto 40) >= 5 then shift_reg(43 downto 40) := shift_reg(43 downto 40) + 3; end if;
            if shift_reg(47 downto 44) >= 5 then shift_reg(47 downto 44) := shift_reg(47 downto 44) + 3; end if;
            
            if shift_reg(51 downto 48) >= 5 then shift_reg(51 downto 48) := shift_reg(51 downto 48) + 3; end if;
            if shift_reg(55 downto 52) >= 5 then shift_reg(55 downto 52) := shift_reg(55 downto 52) + 3; end if;
            if shift_reg(59 downto 56) >= 5 then shift_reg(59 downto 56) := shift_reg(59 downto 56) + 3; end if;
            if shift_reg(63 downto 60) >= 5 then shift_reg(63 downto 60) := shift_reg(63 downto 60) + 3; end if;
            
            if shift_reg(67 downto 64) >= 5 then shift_reg(67 downto 64) := shift_reg(67 downto 64) + 3; end if;
            if shift_reg(71 downto 68) >= 5 then shift_reg(71 downto 68) := shift_reg(71 downto 68) + 3; end if;

            -- Shift the entire 72-bit register left by 1 bit
            shift_reg := shift_reg(70 downto 0) & '0';
        end loop;

        -- MULTIPLEXER LOGIC:
        if sel = '0' then
            -- Grab the Lower 4 Decimal Digits (Bits 47 down to 32)
            current_bcd := shift_reg(47 downto 32);
        else
            -- Grab the Upper 4 Decimal Digits (Bits 63 down to 48)
            current_bcd := shift_reg(63 downto 48);
        end if;

        -- Feed the chosen 4 digits into the displays
        seg3 <= decode_7seg(current_bcd(15 downto 12));
        seg2 <= decode_7seg(current_bcd(11 downto 8));
        seg1 <= decode_7seg(current_bcd(7 downto 4));
        seg0 <= decode_7seg(current_bcd(3 downto 0));

    end process;

end Behavioral;