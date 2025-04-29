----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 01:16:46 PM
-- Design Name: 
-- Module Name: MemUnit - Behavioral
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

entity MemUnit is
    Port(clk: in std_logic;
         mem_write: in std_logic;
         alu_res: in std_logic_vector(15 downto 0);
         rd2: in std_logic_vector(15 downto 0);
         mem_data: out std_logic_vector(15 downto 0);
         alu_res_out: out std_logic_vector(15 downto 0)); 
end MemUnit;

architecture Behavioral of MemUnit is

signal addr: std_logic_vector(15 downto 0);

type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM:ram_type := (others => x"0000");

begin

alu_res_out <= alu_res;

process(clk)
begin
    if rising_edge(clk) then
        if mem_write = '1' then
            RAM(conv_integer(addr)) <= rd2;
        end if;
    end if;
    mem_data <= RAM(conv_integer(addr));
end process;

addr <= alu_res;

end Behavioral;
