----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2025 08:23:48 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is
    Port ( binary: in STD_LOGIC_VECTOR(15 downto 0);
           clk: in STD_LOGIC;
           cat: out STD_LOGIC_VECTOR(6 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0));
end component;

component IFetch is
    Port(clk: in std_logic;
         arst: in std_logic;
         branch_address: in std_logic_vector(15 downto 0);
         jmp_address: in std_logic_vector(15 downto 0);
         jmp: in std_logic;
         pc_src: in std_logic;
         instruction: out std_logic_vector(15 downto 0);
         pc_inc: out std_logic_vector(15 downto 0));
end component;

component IDecode is
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
end component;

component CU is
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
end component;

component EU is
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
end component;

component MemUnit is
    Port(clk: in std_logic;
         mem_write: in std_logic;
         alu_res: in std_logic_vector(15 downto 0);
         rd2: in std_logic_vector(15 downto 0);
         mem_data: out std_logic_vector(15 downto 0);
         alu_res_out: out std_logic_vector(15 downto 0)); 
end component;

signal clk_i: std_logic;
signal arst_i: std_logic;

signal branch_i: std_logic;
signal jump_i: std_logic;
signal reg_write_i: std_logic;

signal pc_inc_i: std_logic_vector(15 downto 0);
signal reg_dst_i: std_logic;
signal rd1_i: std_logic_vector(15 downto 0);
signal rd2_i: std_logic_vector(15 downto 0);
signal wd_i: std_logic_vector(15 downto 0);
signal instr_i: std_logic_vector(15 downto 0);
signal ext_op_i: std_logic;
signal mem_write_i: std_logic;
signal alu_src_i: std_logic;
signal sa_i: std_logic;
signal alu_op_i: std_logic_vector(2 downto 0);
signal alu_res_i: std_logic_vector(15 downto 0);

signal ext_imm_i: std_logic_vector(15 downto 0);
signal func_i: std_logic_vector(2 downto 0);
signal branch_address_i: std_logic_vector(15 downto 0);


signal branch_address: std_logic_vector(15 downto 0) := x"0003";
signal jmp_addr_i: std_logic_vector(15 downto 0);

signal display_mux: std_logic_vector(15 downto 0);

signal pc_src_i: std_logic;
signal zero_i: std_logic;

signal mem_data_i: std_logic_vector(15 downto 0);
signal alu_res_out_i: std_logic_vector(15 downto 0);

signal memto_reg_i: std_logic;

begin

mpg_clk0: mpg port map(btn => btn(0), clk => clk, enable => clk_i);
mpg_clk1: mpg port map(btn => btn(1), clk => clk, enable => arst_i);

if1: IFetch port map(
    clk => clk_i,
    arst => arst_i,
    branch_address => branch_address_i,
    jmp_address => jmp_addr_i,
    jmp => jump_i,
    pc_src => pc_src_i,
    instruction => instr_i,
    pc_inc => pc_inc_i);
    
id1: IDecode port map(
    clk => clk_i,
    reg_write => reg_write_i,
    instr => instr_i,
    reg_dst => reg_dst_i,
    ext_op => ext_op_i,
    rd1 => rd1_i,
    rd2 => rd2_i,
    wd => wd_i,
    ext_imm => ext_imm_i,
    func => func_i,
    sa => sa_i);

cu1: CU port map(
    instr => instr_i(15 downto 13),
    reg_dest => reg_dst_i,
    ext_op => ext_op_i,
    alu_src => alu_src_i,
    branch => branch_i,
    jump => jump_i,
    alu_op => alu_op_i,
    mem_write => mem_write_i,
    memto_reg => memto_reg_i,
    reg_write => reg_write_i);
    
  
ssd1: SSD port map(
    binary => display_mux,
    clk => clk,
    cat => cat,
    an => an);
  
eu1: EU port map(
    pc_inc => pc_inc_i,
    rd1 => rd1_i,
    rd2 => rd2_i,
    ext_imm => ext_imm_i,
    alu_src => alu_src_i,
    sa => sa_i,
    func => func_i,
    alu_op => alu_op_i,
    branch_addr => branch_address_i,
    alu_res => alu_res_i,
    zero => zero_i);


mem1: MemUnit port map(
    clk => clk_i,
    mem_write => mem_write_i,
    alu_res => alu_res_i,
    rd2 => rd2_i,
    mem_data => mem_data_i,
    alu_res_out => alu_res_out_i); 
    
process(memto_reg_i, alu_res_out_i, mem_data_i)
begin
    case memto_reg_i is
        when '0' => wd_i <= alu_res_out_i;
        when '1' => wd_i <= mem_data_i;
    end case;
end process;
  
pc_src_i <= zero_i and branch_i;
jmp_addr_i <= pc_inc_i(15 downto 13) & instr_i(12 downto 0);

process(sw(7 downto 5), instr_i, pc_inc_i, rd1_i, rd2_i, ext_imm_i, alu_res_i, mem_data_i, wd_i)
begin
    case sw(7 downto 5) is
        when "000" => display_mux <= instr_i;
        when "001" => display_mux <= pc_inc_i;
        when "010" => display_mux <= rd1_i;
        when "011" => display_mux <= rd2_i;
        when "100" => display_mux <= ext_imm_i;
        when "101" => display_mux <= alu_res_i;
        when "110" => display_mux <= mem_data_i;
        when "111" => display_mux <= wd_i;
    end case;
end process;

process(sw, reg_dst_i, ext_op_i, alu_src_i, branch_i, jump_i, mem_write_i, memto_reg_i, reg_write_i, alu_op_i)
begin
    case sw(0) is
        when '0' =>
            led(7) <= reg_dst_i;
            led(6) <= ext_op_i;
            led(5) <= alu_src_i;
            led(4) <= branch_i;
            led(3) <= jump_i;
            led(2) <= mem_write_i;
            led(1) <= memto_reg_i;
            led(0) <= reg_write_i;
        when '1' =>
            led(2 downto 0) <= alu_op_i;
            led(7 downto 3) <= "00000";
    end case;
end process;

end Behavioral;
