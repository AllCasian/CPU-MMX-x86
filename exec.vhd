----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 13:41:10
-- Design Name: 
-- Module Name: exec - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exec is
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
end exec;

architecture Behavioral of exec is

signal aluCtrl: std_logic_vector(2 downto 0);
signal a, b, c: std_logic_vector(63 downto 0);
signal c0, c1, c2, c3, c4, c5, c6, c7, br: std_logic_vector(7 downto 0);
signal cc0, cc1, cc2, cc3, cc4, cc5, cc6, cc7: std_logic_vector(8 downto 0);

begin

AluControl: process(aluOp, func)
begin
    case aluOp is
        when '0' =>
            case func is
                when "000000" => aluCtrl <= "000"; -- +
                when "000001" => aluCtrl <= "001"; -- -
                when "000010" => aluCtrl <= "010"; -- ^
                when "000011" => aluCtrl <= "011"; -- <<
                when "000100" => aluCtrl <= "100"; -- >>
                when others => aluCtrl <= (others => '0');
            end case;
        when '1' => aluCtrl <= "101"; -- - cmp
        when others => aluCtrl <= (others => 'X');
    end case;
end process;

process(rd2, extImm, aluSrc)
begin

    if aluSrc = '0' then
        b <= rd2;
    else
        b <= extImm;
    end if;

end process;

ALU: process(a, b, aluCtrl, sa, br)
begin

case aluCtrl is
    when "000" => cc0 <= ('0' & a(7 downto 0)) + ('0' & b(7 downto 0));
                  cc1 <= cc0(8) + ('0' & a(15 downto 8)) + ('0' & b(15 downto 8));
                  cc2 <= cc1(8) + ('0' & a(23 downto 16)) + ('0' & b(23 downto 16));
                  cc3 <= cc2(8) + ('0' & a(31 downto 24)) + ('0' & b(31 downto 24));
                  cc4 <= cc3(8) + ('0' & a(39 downto 32)) + ('0' & b(39 downto 32));
                  cc5 <= cc4(8) + ('0' & a(47 downto 40)) + ('0' & b(47 downto 40));
                  cc6 <= cc5(8) + ('0' & a(55 downto 48)) + ('0' & b(55 downto 48));
                  cc7 <= cc6(8) + ('0' & a(63 downto 56)) + ('0' & b(63 downto 56));
                  c <= cc7(7 downto 0) & cc6(7 downto 0) & cc5(7 downto 0) & cc4(7 downto 0) & cc3(7 downto 0) & cc2(7 downto 0) & cc1(7 downto 0) & cc0(7 downto 0);
        
    when "001" => c0 <= a(7 downto 0) - b(7 downto 0);
                  br <= not a(7 downto 0) and b(7 downto 0);
                  
                  c1 <= a(15 downto 8) xor b(15 downto 8) xor br;
                  br <= ((not a(15 downto 8) and b(15 downto 8)) or (b(15 downto 8) and br) or (not a(15 downto 8) and br));

                  c2 <= a(23 downto 16) xor b(23 downto 16) xor br;
                  br <= ((not a(23 downto 16) and b(23 downto 16)) or (b(23 downto 16) and br) or (not a(23 downto 16) and br));
                  
                  c3 <= a(31 downto 24) xor b(31 downto 24) xor br;
                  br <= ((not a(31 downto 24) and b(31 downto 24)) or (b(31 downto 24) and br) or (not a(31 downto 24) and br));
                  
                  c4 <= a(39 downto 32) xor b(39 downto 32) xor br;
                  br <= ((not a(39 downto 32) and b(39 downto 32)) or (b(39 downto 32) and br) or (not a(39 downto 32) and br));
                  
                  c5 <= a(47 downto 40) xor b(47 downto 40) xor br;
                  br <= ((not a(47 downto 40) and b(47 downto 40)) or (b(47 downto 40) and br) or (not a(47 downto 40) and br));
                  
                  c6 <= a(55 downto 48) xor b(55 downto 48) xor br;
                  br <= ((not a(55 downto 48) and b(55 downto 48)) or (b(55 downto 48) and br) or (not a(55 downto 48) and br));
                  
                  c7 <= a(63 downto 56) xor b(63 downto 56) xor br;
                  
                  c <= c7 & c6 & c5 & c4 & c3 & c2 & c1 & c0;
                  
    when "010" => c <= a xor b;                  
    
    when "011" => case sa is
                    when "00000" => c <= b;
                    when "00001" => c <= b(62 downto 0) & '0';
                    when "00010" => c <= b(61 downto 0) & "00";
                    when "00011" => c <= b(60 downto 0) & "000";
                    when "00100" => c <= b(59 downto 0) & "0000";
                    when "00101" => c <= b(58 downto 0) & "00000";
                    when others => c <= (others => 'X');
                  end case;
                  
    when "100" => case sa is
                    when "00001" => c(63 downto 48) <= '0' & b(63 downto 49);
                                    c(47 downto 32) <= b(48) & b(47 downto 33);
                                    c(31 downto 16) <= b(32) & b(31 downto 17);
                                    c(15 downto 0) <= b(16) & b(15 downto 1);
                    when "00010" => c(63 downto 48) <= "00" & b(63 downto 50);
                                    c(47 downto 32) <= b(49 downto 48) & b(47 downto 34);
                                    c(31 downto 16) <= b(33 downto 32) & b(31 downto 18);
                                    c(15 downto 0) <= b(17 downto 16) & b(15 downto 2);
                    when "00011" => c(63 downto 48) <= "000" & b(63 downto 51);
                                    c(47 downto 32) <= b(50 downto 48) & b(47 downto 35);
                                    c(31 downto 16) <= b(34 downto 32) & b(31 downto 19);
                                    c(15 downto 0) <= b(18 downto 16) & b(15 downto 3);
                    when others => c <= (others => '0');
                  end case;
    
    when "101" => c <= a - b;
                  
    when others => c <= (others => 'X');
end case;
end process;

process(c)
begin

    if c = x"0000000000000000" then 
        zero <= '1';
    else
        zero <= '0';
    end if;

end process;


brAddr <= extImm(31 downto 0) + pc;
aluRes <= c;
a <= rd1;

end Behavioral;
