-------------------------------------------------------------------------------
--
-- Title       : ImmediateGenerator
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Immediate Generator.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;

entity ImmediateGenerator is
  generic(
       Tsel : time := 3 ns;
       Tdata : time := 2 ns
  );
  port(
       ri:      in std_logic_vector(31 downto 0);
       ImmSel:  in std_logic_vector(1 downto 0);
       immed:   out std_logic_vector(31 downto 0)
  );
end ImmediateGenerator;

architecture ImmediateGenerator of ImmediateGenerator is

begin

Gen:
process (ImmSel)

begin
	case ImmSel is
        -- R-Type
		when "00" =>
            immed(31 downto 0) <= (others => '0')                       after Tsel;
        -- I-Type
        when "01" =>
            immed(11 downto 0) <= ri(31 downto 20)                      after Tsel;
            immed(31 downto 12)<= (others => ri(31))                    after Tsel;
        -- S-Type
        when "10" =>
            immed(10 downto 0) <= ri(31 downto 25) & ri(11 downto 7)    after Tsel;
            immed(31 downto 11) <= (others => ri(31))                   after Tsel;
        -- U-Type
        when "11" =>
            immed(19 downto 0) <= ri(31 downto 12)                      after Tsel;
            immed(31 downto 20) <= (others => ri(31))                   after Tsel;
		when others => immed <= (others => 'X')                         after Tsel;
	end case;

end process;

end ImmediateGenerator;