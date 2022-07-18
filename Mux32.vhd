-------------------------------------------------------------------------------
--
-- Title       : Mux32
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic 32x1 Multiplexer.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;

entity Mux32 is
     generic (
          BitCount: integer := 32;
          Tsel:     time := 0.5 ns;
          Tdata:    time := 0.25 ns
     );
     port (
          I0:       in std_logic_vector(BitCount - 1 downto 0);
          I1:       in std_logic_vector(BitCount - 1 downto 0);
          I2:       in std_logic_vector(BitCount - 1 downto 0);
          I3:       in std_logic_vector(BitCount - 1 downto 0);
          I4:       in std_logic_vector(BitCount - 1 downto 0);
          I5:       in std_logic_vector(BitCount - 1 downto 0);
          I6:       in std_logic_vector(BitCount - 1 downto 0);
          I7:       in std_logic_vector(BitCount - 1 downto 0);
          I8:       in std_logic_vector(BitCount - 1 downto 0);
          I9:       in std_logic_vector(BitCount - 1 downto 0);
          I10:      in std_logic_vector(BitCount - 1 downto 0);
          I11:      in std_logic_vector(BitCount - 1 downto 0);
          I12:      in std_logic_vector(BitCount - 1 downto 0);
          I13:      in std_logic_vector(BitCount - 1 downto 0);
          I14:      in std_logic_vector(BitCount - 1 downto 0);
          I15:      in std_logic_vector(BitCount - 1 downto 0);
          I16:      in std_logic_vector(BitCount - 1 downto 0);
          I17:      in std_logic_vector(BitCount - 1 downto 0);
          I18:      in std_logic_vector(BitCount - 1 downto 0);
          I19:      in std_logic_vector(BitCount - 1 downto 0);
          I20:      in std_logic_vector(BitCount - 1 downto 0);
          I21:      in std_logic_vector(BitCount - 1 downto 0);
          I22:      in std_logic_vector(BitCount - 1 downto 0);
          I23:      in std_logic_vector(BitCount - 1 downto 0);
          I24:      in std_logic_vector(BitCount - 1 downto 0);
          I25:      in std_logic_vector(BitCount - 1 downto 0);
          I26:      in std_logic_vector(BitCount - 1 downto 0);
          I27:      in std_logic_vector(BitCount - 1 downto 0);
          I28:      in std_logic_vector(BitCount - 1 downto 0);
          I29:      in std_logic_vector(BitCount - 1 downto 0);
          I30:      in std_logic_vector(BitCount - 1 downto 0);
          I31:      in std_logic_vector(BitCount - 1 downto 0);
          Sel:      in std_logic_vector(4 downto 0);
          O:        out std_logic_vector(BitCount - 1 downto 0)
     );
end Mux32;

architecture arch of Mux32 is

begin

     process (
          I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15,
          I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31,
          Sel
     )
     begin
          case Sel is
               when "00000" => O <= I0 	               after Tsel;
               when "00001" => O <= I1 	               after Tsel;
               when "00010" => O <= I2		          after Tsel;
               when "00011" => O <= I3		          after Tsel;
               when "00100" => O <= I4 	               after Tsel;
               when "00101" => O <= I5 	               after Tsel;
               when "00110" => O <= I6		          after Tsel;
               when "00111" => O <= I7		          after Tsel;
               when "01000" => O <= I8 	               after Tsel;
               when "01001" => O <= I9 	               after Tsel;
               when "01010" => O <= I10		          after Tsel;
               when "01011" => O <= I11		          after Tsel;
               when "01100" => O <= I12 	          after Tsel;
               when "01101" => O <= I13 	          after Tsel;
               when "01110" => O <= I14		          after Tsel;
               when "01111" => O <= I15		          after Tsel;
               when "10000" => O <= I16 	          after Tsel;
               when "10001" => O <= I17 	          after Tsel;
               when "10010" => O <= I18		          after Tsel;
               when "10011" => O <= I19		          after Tsel;
               when "10100" => O <= I20 	          after Tsel;
               when "10101" => O <= I21 	          after Tsel;
               when "10110" => O <= I22		          after Tsel;
               when "10111" => O <= I23		          after Tsel;
               when "11000" => O <= I24 	          after Tsel;
               when "11001" => O <= I25 	          after Tsel;
               when "11010" => O <= I26		          after Tsel;
               when "11011" => O <= I27		          after Tsel;
               when "11100" => O <= I28 	          after Tsel;
               when "11101" => O <= I29 	          after Tsel;
               when "11110" => O <= I30		          after Tsel;
               when "11111" => O <= I31		          after Tsel;
               when others => O <= (others => 'X')     after Tsel;
          end case;
     end process;

end arch;