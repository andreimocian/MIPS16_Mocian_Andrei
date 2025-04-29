----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 09:01:55 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDecode is
    Port(clk: in std_logic;
         reg_write: in std_logic;
         instr: in std_logic_vector(15 downto 0);
         reg_dst: in std_logic;
         ext_op: in std_logic;
         rd1: out std_logic_vector(15 downto 0);
         rd2: out std_logic_vector(15 downto 0);
         wd: in std_logic_vector(15 downto 0);
         ext_imm: out std_logic_vector(15 downto 0);
         func: out std_logic_vector(2 downto 0);
         sa: out std_logic);
end IDecode;

architecture Behavioral of IDecode is

component reg_file is
    Port (clk : in std_logic;
          ra1 : in std_logic_vector (2 downto 0);
          ra2 : in std_logic_vector (2 downto 0);
          wa : in std_logic_vector (2 downto 0);
          wd : in std_logic_vector (15 downto 0);
          wen : in std_logic;
          rd1 : out std_logic_vector (15 downto 0);
          rd2 : out std_logic_vector (15 downto 0));
end component;

signal wa_i: std_logic_vector(2 downto 0);
signal ra1: std_logic_vector(2 downto 0);
signal ra2: std_logic_vector(2 downto 0);

begin

process(reg_dst, instr)
begin
    case (reg_dst) is
        when '0' => wa_i <= instr(9 downto 7);
        when '1' => wa_i <= instr(6 downto 4);
        when others => wa_i <= wa_i;
    end case;
end process;

process(instr, ext_op)
begin
    case(ext_op) is
        when '0' => ext_imm <= b"000000000" & instr(6 downto 0);
        when others =>
            case(instr(6)) is
                when '0' => ext_imm <= b"000000000" & instr(6 downto 0);
                when others => ext_imm <= b"111111111" & instr(6 downto 0);
            end case;
    end case;
end process;

func <= instr(2 downto 0);
sa <= instr(3);

ra1 <= instr(12 downto 10);
ra2 <= instr(9 downto 7);

reg_file1: reg_file port map(clk => clk, ra1 => ra1, ra2 => ra2, wa => wa_i, wd => wd, wen => reg_write, rd1 => rd1, rd2 => rd2);

end Behavioral;
