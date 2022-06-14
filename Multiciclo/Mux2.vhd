-------------------------------------------------------------------------------
--
-- Title       : Mux2
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic 2x1 Multiplexer.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;

entity Mux2 is
     generic(
          NB:       integer := 8;
          Tsel:     time := 3 ns
     );
     port(
          Sel:      in std_logic;
          I0:       in std_logic_vector(NB-1 downto 0);
          I1:       in std_logic_vector(NB-1 downto 0);
          O:        out std_logic_vector(NB-1 downto 0)
     );
end Mux2;

architecture Mux2 of Mux2 is

begin

     Mux2:
     process (I0, I1, Sel)

     begin
          Case Sel is
               when '0' => O <= I0                     after Tsel;
               when '1' => O <= I1                     after Tsel;
               when others => O <= (others => 'X')     after Tsel;
          end case;
     end process;

end Mux2;