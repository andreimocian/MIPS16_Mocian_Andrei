----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 11:03:34 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    Port(clk: in std_logic;
         arst: in std_logic;
         branch_address: in std_logic_vector(15 downto 0);
         jmp_address: in std_logic_vector(15 downto 0);
         jmp: in std_logic;
         pc_src: in std_logic;
         instruction: out std_logic_vector(15 downto 0);
         pc_inc: out std_logic_vector(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is

type rom_type is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom: rom_type := (
    b"001_000_001_0000101",
    b"001_000_010_0001010",
    b"000_001_010_011_0_000",
    b"000_011_001_011_0_001",
    b"000_001_010_011_0_100",
    b"000_001_010_011_0_101",
    b"000_011_001_010_0_110",
    b"000_011_001_100_0_111",
    b"000_001_001_011_1_010",
    b"000_001_001_011_1_011",
    b"101_001_011_0001111",
    b"110_010_011_0000101",
    b"011_001_011_0000000",
    b"010_001_010_0000000",
    b"100_011_010_0000001",
    b"001_000_011_1111011",
    b"111_0000000000000",
    others => x"0000");

signal pc_count: std_logic_vector(15 downto 0);
signal pc_inc_i: std_logic_vector(15 downto 0);
signal out1: std_logic_vector(15 downto 0);
signal addr1: std_logic_vector(15 downto 0);

begin

process(branch_address, pc_src, pc_inc_i)
begin
    case(pc_src) is
        when '0' => out1 <= pc_inc_i;
        when '1' => out1 <= branch_address;
        when others => out1 <= x"0000";
    end case;
end process;

process(jmp, out1, jmp_address)
begin
    case(jmp) is
        when '0' => addr1 <= out1;
        when '1' => addr1 <= jmp_address;
    end case;
end process;

process(clk, arst)
begin
    if arst = '1' then
        pc_count <= x"0000";
    elsif rising_edge(clk) then
        pc_count <= addr1;
    end if;
end process;

instruction <= rom(conv_integer(pc_count(7 downto 0)));

pc_inc_i <= pc_count + 1;

pc_inc <= pc_inc_i;

end Behavioral;
