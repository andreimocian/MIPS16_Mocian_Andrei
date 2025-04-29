----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 10:15:06 PM
-- Design Name: 
-- Module Name: CU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CU is
    Port(instr: in std_logic_vector(2 downto 0);
         reg_dest: out std_logic;
         ext_op: out std_logic;
         alu_src: out std_logic;
         branch: out std_logic;
         jump: out std_logic;
         alu_op: out std_logic_vector(2 downto 0);
         mem_write: out std_logic;
         memto_reg: out std_logic;
         reg_write: out std_logic);
end CU;

architecture Behavioral of CU is

begin

process(instr)
begin
    case (instr) is
        when "000" => -- R-type instr
            reg_dest <= '1';
            ext_op <= '0';
            alu_src <= '0';
            branch <= '0';
            jump <= '0';
            alu_op <= "000";
            mem_write <= '0';
            memto_reg <= '0';
            reg_write <= '1';
        
        when "001" => -- ADDI
            reg_dest <= '0';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jump <= '0';
            alu_op <= "001";
            mem_write <= '0';
            memto_reg <= '0';
            reg_write <= '1';
            
        when "010" => -- LW
            reg_dest <= '0';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jump <= '0';
            alu_op <= "001";
            mem_write <= '0';
            memto_reg <= '1';
            reg_write <= '1';
            
        when "011" => -- SW
            reg_dest <= 'X';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jump <= '0';
            alu_op <= "001";
            mem_write <= '1';
            memto_reg <= 'X';
            reg_write <= '0';
            
        when "100" => -- BEQ
            reg_dest <= 'X';
            ext_op <= '1';
            alu_src <= '0';
            branch <= '1';
            jump <= '0';
            alu_op <= "010";
            mem_write <= '0';
            memto_reg <= 'X';
            reg_write <= '0';
            
        when "101" => -- ANDI
            reg_dest <= 'X';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jump <= '0';
            alu_op <= "101";
            mem_write <= '0';
            memto_reg <= '0';
            reg_write <= '1';
            
        when "110" => -- ORI
            reg_dest <= '0';
            ext_op <= '1';
            alu_src <= '1';
            branch <= '0';
            jump <= '0';
            alu_op <= "110";
            mem_write <= '0';
            memto_reg <= '0';
            reg_write <= '1';
            
        when "111" => -- J
            reg_dest <= 'X';
            ext_op <= '1';
            alu_src <= 'X';
            branch <= '0';
            jump <= '1';
            alu_op <= "111";
            mem_write <= '0';
            memto_reg <= 'X';
            reg_write <= '0';
            
        when others =>
            reg_dest <= 'X';
            ext_op <= 'X';
            alu_src <= 'X';
            branch <= '0';
            jump <= '0';
            alu_op <= "000";
            mem_write <= '0';
            memto_reg <= '0';
            reg_write <= '0';
        end case;
    end process;
end Behavioral;
