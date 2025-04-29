----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 10:57:45 PM
-- Design Name: 
-- Module Name: EU - Behavioral
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

entity EU is
    Port( pc_inc: in std_logic_vector(15 downto 0);
          rd1: in std_logic_vector(15 downto 0);
          rd2: in std_logic_vector(15 downto 0);
          ext_imm: in std_logic_vector(15 downto 0);
          alu_src: in std_logic;
          sa: in std_logic;
          func: in std_logic_vector (2 downto 0);
          alu_op: in std_logic_vector (2 downto 0);
          branch_addr: out std_logic_vector(15 downto 0);
          alu_res: out std_logic_vector(15 downto 0);
          zero: out std_logic);
end EU;

architecture Behavioral of EU is

signal alu_ctrl: std_logic_vector(3 downto 0);
signal alu_in_2: std_logic_vector(15 downto 0);
signal alu_res_i: std_logic_vector(15 downto 0);
signal zero_i: std_logic;

begin

process(alu_src)
begin
    case alu_src is
        when '0' => alu_in_2 <= rd2;
        when '1' => alu_in_2 <= ext_imm;
    end case;
end process;

process(alu_op, func)
begin
    case alu_op is
        when "000" => 
            case func is
                when "000" =>  alu_ctrl <= "0000"; --add
                when "001" => alu_ctrl <= "0001"; --sub
                when "010" => alu_ctrl <= "0010"; --sll
                when "011" => alu_ctrl <= "0011"; --srl
                when "100" => alu_ctrl <= "0100"; --and
                when "101" => alu_ctrl <= "0101"; --or
                when "110" => alu_ctrl <= "0110"; --xor
                when "111" => alu_ctrl <= "0111"; --nor
                when others => alu_ctrl <= "0000";
            end case;
        when "001" => alu_ctrl <= "0000"; --addi
        when "010" => alu_ctrl <= "0001"; --beq
        when "101" => alu_ctrl <= "0100"; --andi
        when "110" => alu_ctrl <= "0101"; --ori
        when "111" => alu_ctrl <= "1000"; --jmp
        when others => alu_ctrl <= "0000";
    end case;
end process;

process(rd1, alu_in_2, alu_ctrl, sa)
begin
    case alu_ctrl is
        when "0000" => alu_res_i <= rd1 + alu_in_2;
        when "0001" => alu_res_i <= rd1 - alu_in_2;
        when "0010" => 
            case sa is
                when '0' => alu_res_i <= rd1;
                when '1' => alu_res_i <= rd1(14 downto 0) & '0';
            end case;
        when "0011" => 
            case sa is
                when '0' => alu_res_i <= rd1;
                when '1' => alu_res_i <= '0' & rd1(14 downto 0);
            end case;
        when "0100" => alu_res_i <= rd1 and alu_in_2;
        when "0101" => alu_res_i <= rd1 or alu_in_2;
        when "0111" => alu_res_i <= rd1 nor alu_in_2;
        when "0110" => alu_res_i <= rd1 xor alu_in_2;
        when "1000" => alu_res_i <= x"0000";
        when others => alu_res_i <= x"0000";
    end case;
end process;

process(alu_res_i)
begin
    case alu_res_i is
        when x"0000" => zero_i <= '1';
        when others => zero_i <= '0';
    end case;
end process;

branch_addr <= pc_inc + ext_imm;
zero <= zero_i;
alu_res <= alu_res_i;

end Behavioral;
