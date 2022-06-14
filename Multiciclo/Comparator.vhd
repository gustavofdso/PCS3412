-------------------------------------------------------------------------------
--
-- Title       : Comparator
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic bit Comparator.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Comparator is
    generic(
        NumeroBits: integer := 8;
        Tcomp:    time := 3 ns
    );
    port(
        A:        in std_logic_vector(NumeroBits - 1 downto 0);
        B:        in std_logic_vector(NumeroBits - 1 downto 0);
        eq:       out std_logic;
        lt:       out std_logic
    );
end Comparator;

architecture Comparator of Comparator is

begin
    eq <= '1' when (A = B) else '0' after Tcomp;
    lt <= '1' when (A < B) else '0' after Tcomp;

end Comparator;
