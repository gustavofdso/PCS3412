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
        BitCount:   integer := 32;
        Tsub:       time := 1.25 ns
    );
    port(
        A:          in std_logic_vector(BitCount - 1 downto 0);
        B:          in std_logic_vector(BitCount - 1 downto 0);
        eq:         out std_logic;
        lt:         out std_logic;
        gt:         out std_logic;
        le:         out std_logic;
        ge:         out std_logic
    );
end Comparator;

architecture Comparator of Comparator is

begin
    eq <= '1' when (A = B)  else '0' after Tsub;
    lt <= '1' when (A < B)  else '0' after Tsub;
    gt <= '1' when (A > B)  else '0' after Tsub;
    le <= '1' when (A <= B) else '0' after Tsub;
    ge <= '1' when (A >= B) else '0' after Tsub;

end Comparator;
