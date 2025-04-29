----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2025 08:25:06 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( binary: in STD_LOGIC_VECTOR(15 downto 0);
           clk: in STD_LOGIC;
           cat: out STD_LOGIC_VECTOR(6 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal count: STD_LOGIC_VECTOR(15 downto 0);
signal mux1out: STD_LOGIC_VECTOR(3 downto 0);
signal final_sum: STD_LOGIC_VECTOR(15 downto 0);
signal BCD_Digit_0: STD_LOGIC_VECTOR (3 downto 0);
signal BCD_Digit_1: STD_LOGIC_VECTOR (3 downto 0);
signal BCD_Digit_2: STD_LOGIC_VECTOR (3 downto 0);
signal BCD_Digit_3: STD_LOGIC_VECTOR (3 downto 0);
begin

    process(binary)
        variable shift_reg:STD_LOGIC_VECTOR(19 downto 0);
    begin
        shift_reg := x"00000";
        for i in 15 downto 0 loop
            if shift_reg(19 downto 16) > 4 then
                shift_reg(19 downto 16) := shift_reg(19 downto 16) + "0011";
            end if;
            if shift_reg(15 downto 12) > 4 then
                shift_reg(15 downto 12) := shift_reg(15 downto 12) + "0011";
            end if;
            if shift_reg(11 downto 8) > 4 then
                shift_reg(11 downto 8) := shift_reg(11 downto 8) + "0011";
            end if;
            if shift_reg(7 downto 4) > 4 then
                shift_reg(7 downto 4) := shift_reg(7 downto 4) + "0011";
            end if;
            if shift_reg(3 downto 0) > 4 then
                shift_reg(3 downto 0) := shift_reg(3 downto 0) + "0011";
            end if;
            
            shift_reg := shift_reg(18 downto 0) & binary(i);
            
        end loop;
        
        BCD_Digit_0 <= shift_reg(3 downto 0);
        BCD_Digit_1 <= shift_reg(7 downto 4);
        BCD_Digit_2 <= shift_reg(11 downto 8);
        BCD_Digit_3 <= shift_reg(15 downto 12);
        
    end process;

    --binary <= BCD_Digit_3 & BCD_Digit_2 & BCD_Digit_1 & BCD_Digit_0;

    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;
    
    process(binary, count)
    begin
        case count(15 downto 14) is
             when "00" => mux1out <= binary(3 downto 0);
             when "01" => mux1out <= binary(7 downto 4);
             when "10" => mux1out <= binary(11 downto 8);
             when "11" => mux1out <= binary(15 downto 12);
             when others => mux1out <= "0000";
        end case;
        
        case count(15 downto 14) is
            when "00" => an <= "1110";
            when "01" => an <= "1101";
            when "10" => an <= "1011";
            when "11" => an <= "0111";
            when others => an <= "0000";
        end case;
        
        case mux1out is
            when "0001" => cat <= "1111001"; -- 1
            when "0010" => cat <= "0100100"; -- 2
            when "0011" => cat <= "0110000"; -- 3
            when "0100" => cat <= "0011001"; -- 4
            when "0101" => cat <= "0010010"; -- 5
            when "0110" => cat <= "0000010"; -- 6
            when "0111" => cat <= "1111000"; -- 7
            when "1000" => cat <= "0000000"; -- 8
            when "1001" => cat <= "0010000"; -- 9
            when "1010" => cat <= "0001000"; -- A
            when "1011" => cat <= "0000011"; -- B
            when "1100" => cat <= "1000110"; -- C
            when "1101" => cat <= "0100001"; -- D
            when "1110" => cat <= "0000110"; -- E
            when "1111" => cat <= "0001110"; -- F
            when others => cat <= "1000000"; --0
        end case;
    end process;

end Behavioral;
