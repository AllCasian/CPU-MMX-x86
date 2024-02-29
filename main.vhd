----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2024 20:21:09
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port ( 
    clk : in STD_LOGIC;
    btn : in STD_LOGIC_VECTOR (4 downto 0);
    sw : in STD_LOGIC_VECTOR (15 downto 0);
    led : out STD_LOGIC_VECTOR (15 downto 0);
    an : out STD_LOGIC_VECTOR (3 downto 0);
    cat : out STD_LOGIC_VECTOR (6 downto 0)
    );
end main;

architecture Behavioral of main is

component iff is
    Port(
    pcsrc: in std_logic;
    brcAdr: in std_logic_vector(31 downto 0);
    en: in std_logic;
    rst: in std_logic;
    clk: in std_logic;
    pc_out: inout std_logic_vector(31 downto 0);
    instr: out std_logic_vector(31 downto 0)
    );
end component;

component instruction_decode is
    Port(
    regWrite: in std_logic;
    instr: in std_logic_vector(31 downto 0);
    regDst: in std_logic;
    clk: in std_logic;
    en: in std_logic;
    extOp: in std_logic; 
    wd: in std_logic_vector(63 downto 0);
    rd1: out std_logic_vector(63 downto 0);
    rd2: out std_logic_vector(63 downto 0);
    extImm: out std_logic_vector(63 downto 0);
    func: out std_logic_vector(5 downto 0);
    sa:out std_logic_vector(4 downto 0)
    );
end component;

component main_ctrl is
    Port ( 
    instr: in std_logic_vector(31 downto 0);
    regDst, extOp, branch, aluOp, regWrite: out std_logic
    );
end component;

component exec is
    Port ( 
    rd1: in std_logic_vector(63 downto 0);
    rd2: in std_logic_vector(63 downto 0);
    aluSrc: in std_logic;
    extImm: in std_logic_vector(63 downto 0);
    sa: in std_logic_vector(4 downto 0);
    func: in std_logic_vector(5 downto 0);
    aluOp: in std_logic;
    pc: in std_logic_vector(31 downto 0);
    zero: out std_logic;
    aluRes: out std_logic_vector(63 downto 0);
    brAddr: out std_logic_vector(31 downto 0)
    );
end component;

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in std_logic_vector(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

signal pc, branch, inst, Rd1, Rd2, extimm: std_logic_vector(31 downto 0);
signal en1, en2, clock, pcsrcc, regwrite, regdst, extop, aluop, brn, alusrc, zeroo: std_logic;
signal Func: std_logic_vector(5 downto 0);
signal Sa: std_logic_vector(4 downto 0);
signal RD_1, RD_2, ext_imm, alures, Wd, digits: std_logic_vector(63 downto 0);

begin

monopulse1: MPG port map(en2, btn(0), clk);
monopulse2: MPG port map(en1, btn(1), clk);

display: SSD port map(clk, digits(15 downto 0), an, cat);

Instruction_Fetch: iff port map(pcsrcc, branch, en2, en1, clk, pc, inst);
Instruction_Decodee: instruction_decode port map(regwrite, inst, regdst, clk, en2, extop, Wd, RD_1, RD_2, ext_imm, Func, Sa);
Main_Control: main_ctrl port map(inst, regdst, extop, brn, aluop, regwrite);
Execution_Unit: exec port map(RD_1, RD_2, alusrc, ext_imm, Sa, Func, aluop, pc, zeroo, alures, branch);

Wd <= alures;

pcsrcc <= brn and zeroo;
led(5 downto 0) <= aluop & regdst & extop & alusrc & brn & regwrite;
digits <= alures;

end Behavioral;
