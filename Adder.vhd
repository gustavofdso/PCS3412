-------------------------------------------------------------------------------
--
-- Title       : Adder
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic bit Adder.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Adder is
     generic(
          BitCount: integer := 32;
          Tadd:     time := 1 ns
     );
     port(
          cin:      in std_logic;
          A:        in std_logic_vector(BitCount - 1 downto 0);
          B:        in std_logic_vector(BitCount - 1 downto 0);
          sum:      out std_logic_vector(BitCount - 1 downto 0)
     );
end Adder;

architecture Adder of Adder is

begin
     sum <= (A + B + cin) after Tadd;

end Adder;
