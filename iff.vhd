----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 19:06:54
-- Design Name: 
-- Module Name: if - Behavioral
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

entity iff is
    Port(
    pcsrc: in std_logic;
    brcAdr: in std_logic_vector(31 downto 0);
    en: in std_logic;
    rst: in std_logic;
    clk: in std_logic;
    pc_out: inout std_logic_vector(31 downto 0);
    instr: out std_logic_vector(31 downto 0)
    );
end iff;

architecture Behavioral of iff is

type t_mem is array(0 to 255) of std_logic_vector(31 downto 0);
signal mem : t_mem :=( --aici introducem instructiunile
    B"000000_00001_00010_00011_00000_000000",  --paddb $3, $1, $2
    B"000000_00001_00100_00011_00000_000000",  --paddb $3, $1, $4
    B"000000_00101_00110_00011_00000_000000",  --paddb $3, $5, $6
    B"000000_00001_00010_00011_00000_000001",  --psubb $3, $1, $2
    B"000000_00001_00100_00011_00000_000001",  --psubb $3, $1, $4
    B"000000_00110_00010_00011_00000_000001",  --psubb $3, $6, $2
    B"000000_00110_00111_00011_00000_000001",  --psubb $3, $6, $7
    B"000000_00001_00010_00011_00000_000010",  --pxor $3, $1, $2
    B"000000_00000_00001_00011_00010_000011",  --psllq $3, $1, 2
    B"000000_00000_00110_00011_00001_000011",  --psllq $3, $6, 1
    B"000000_00000_00010_00011_00010_000100",  --psrlw $3, $2, 2
    B"000000_00000_00101_00011_00001_000100",  --psrlw $3, $5, 1
    B"000001_00010_00011_0000000000000001",  --pcmpeqd $2, $3, 2
    
    others => X"00000000"
    
);

signal mux1: std_logic_vector(31 downto 0);
signal q: std_logic_vector(31 downto 0);
signal aux: std_logic_vector(31 downto 0);

begin

process(clk)  
begin 
    if rising_edge(clk) then 
        if rst = '1' then 
            q <= x"00000000";
        elsif en = '1' then 
            q <= mux1;
        end if;
    end if;
end process;


process(brcAdr, aux, pcsrc) 
begin
    if pcsrc = '1' then 
        mux1 <= brcAdr;
    else 
        mux1 <= aux;
    end if;
end process;

pc_out <= aux;
aux <= q + 1;

instr <= mem(conv_integer(q(4 downto 0)));

end Behavioral;
