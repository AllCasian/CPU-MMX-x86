----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 13:33:22
-- Design Name: 
-- Module Name: main_ctrl - Behavioral
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

entity main_ctrl is
    Port ( 
    instr: in std_logic_vector(31 downto 0);
    regDst, extOp, branch, aluOp, regWrite: out std_logic
    );
end main_ctrl;

architecture Behavioral of main_ctrl is

begin

process(instr(31 downto 26))
begin
    regDst <= '0'; extOp <= '0'; branch <= '0'; regWrite <= '0'; aluOp <= '0';
    case instr(31 downto 26) is
        when "000000" =>
            regDst <= '1'; regWrite <= '1';
        when "000001" =>
            extOp <= '1'; branch <= '1'; aluOp <= '1';  
        when others => 
            regDst <= '0'; extOp <= '0'; branch <= '0'; regWrite <= '0'; aluOp <= '0';
     end case;
end process;

end Behavioral;
