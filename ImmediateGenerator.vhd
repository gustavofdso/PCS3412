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
        Tsel : time := 0.5 ns
    );
    port(
        ri:      in std_logic_vector(31 downto 0);
        ImmSel:  in std_logic_vector(1 downto 0);
        immed:   out std_logic_vector(31 downto 0)
    );
end ImmediateGenerator;

architecture ImmediateGenerator of ImmediateGenerator is

begin

    process (ImmSel)
    begin
        case ImmSel is
            -- I-Type
            when "00" =>
                immed(10 downto 0) <= ri(30 downto 20)                      after Tsel;
                immed(31 downto 11) <= (others => ri(31))                   after Tsel;
            -- S-Type
            when "01" =>
                immed(10 downto 0) <= ri(30 downto 25) & ri(11 downto 7)    after Tsel;
                immed(31 downto 11) <= (others => ri(31))                   after Tsel;
            -- B-Type
            when "10" =>
                immed(12 downto 0)  <= ri(7) & ri(30 downto 25) & ri(11 downto 8) & "00"      after Tsel;
                immed(31 downto 13) <= (others => ri(31))                   after Tsel;
			   -- J-Type
            when "11" =>
                immed(20 downto 0) <= ri(19 downto 12) & ri(20) & ri(30 downto 21) & "00"     after Tsel;	
					 immed(31 downto 21) <= (others => ri(31))                    after Tsel;
					 
            when others => immed <= (others => 'X')                          after Tsel;
        end case;
    end process;

end ImmediateGenerator;