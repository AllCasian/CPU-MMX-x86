----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 12:57:56
-- Design Name: 
-- Module Name: instruction_decode - Behavioral
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

entity instruction_decode is
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
end instruction_decode;

architecture Behavioral of instruction_decode is

signal mux: std_logic_vector(4 downto 0);
signal instrExt: std_logic_vector(63 downto 0);


type t_rf is array(0 to 7) of std_logic_vector(63 downto 0);
signal rf : t_rf := (x"0000000000000000", -- 0
                     x"0000000000000111", -- 1
                     x"0000000000000100", -- 2
                     x"0000000000000100", -- 3
                     x"0000000000000111", -- 4
                     x"0000000000001010", -- 5
                     x"0000000000000101", -- 6
                     x"0000000000000110" -- 7
        );

begin

process(instr(20 downto 16), instr(15 downto 11), regDst)
begin
    if regDst = '1' then
        mux <= instr(15 downto 11);
    else
        mux <= instr(20 downto 16);
    end if;
end process;

instrExt(15 downto 0) <= instr(15 downto 0); 
    with extOp select
        instrExt(63 downto 16) <= (others => instr(15)) when '1',
                                (others => '0') when '0',
                                (others => '0') when others;


process(clk)
begin
    if rising_edge(clk) then 
        if en = '1' and regWrite = '1' then
            rf(conv_integer(mux)) <= wd; 
        end if;
    end if;        
end process; 
rd1 <= rf(conv_integer(instr(25 downto 21)));
rd2 <= rf(conv_integer(instr(20 downto 16)));

func <= instr(5 downto 0);
sa <= instr(10 downto 6);
extImm <= instrExt;

end Behavioral;
