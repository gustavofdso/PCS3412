-------------------------------------------------------------------------------
--
-- Title       : Mux4
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic 8x1 Multiplexer.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;

entity Mux4 is
     generic(
          BitCount: integer := 32;
          Tsel:     time := 0.5 ns;
          Tdata:    time := 0.25 ns
     );
     port(
          I0:       in std_logic_vector(BitCount - 1 downto 0);
          I1:       in std_logic_vector(BitCount - 1 downto 0);
          I2:       in std_logic_vector(BitCount - 1 downto 0);
          I3:       in std_logic_vector(BitCount - 1 downto 0);
          I4:       in std_logic_vector(BitCount - 1 downto 0);
          I5:       in std_logic_vector(BitCount - 1 downto 0);
          I6:       in std_logic_vector(BitCount - 1 downto 0);
          I7:       in std_logic_vector(BitCount - 1 downto 0);
          Sel:      in std_logic_vector(2 downto 0);
          O:        out std_logic_vector(BitCount - 1 downto 0)
     );
end Mux4;

architecture Mux4 of Mux4 is

begin

     process (I0, I1, I2, I3, I4, I5, I6, I7, Sel)
     begin
          case Sel is
               when "000" => O <= I0 	               after Tsel;
               when "001" => O <= I1 	               after Tsel;
               when "010" => O <= I2		          after Tsel;
               when "011" => O <= I3		          after Tsel;
               when "100" => O <= I4 	               after Tsel;
               when "101" => O <= I5 	               after Tsel;
               when "110" => O <= I6		          after Tsel;
               when "111" => O <= I7		          after Tsel;
               when others => O <= (others => 'X')     after Tsel;
          end case;
     end process;

end Mux4;