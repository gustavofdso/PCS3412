-------------------------------------------------------------------------------
--
-- Title       : Mux16
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic 16x1 Multiplexer.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;

entity Mux16 is
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
          I8:       in std_logic_vector(BitCount - 1 downto 0);
          I9:       in std_logic_vector(BitCount - 1 downto 0);
          I10:      in std_logic_vector(BitCount - 1 downto 0);
          I11:      in std_logic_vector(BitCount - 1 downto 0);
          I12:      in std_logic_vector(BitCount - 1 downto 0);
          I13:      in std_logic_vector(BitCount - 1 downto 0);
          I14:      in std_logic_vector(BitCount - 1 downto 0);
          I15:      in std_logic_vector(BitCount - 1 downto 0);
          Sel:      in std_logic_vector(3 downto 0);
          O:        out std_logic_vector(BitCount - 1 downto 0)
     );
end Mux16;

architecture arch of Mux16 is

begin

     process (I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, Sel)
     begin
          case Sel is
               when "0000" => O <= I0 	              after Tsel;
               when "0001" => O <= I1 	              after Tsel;
               when "0010" => O <= I2		         after Tsel;
               when "0011" => O <= I3		         after Tsel;
               when "0100" => O <= I4 	              after Tsel;
               when "0101" => O <= I5 	              after Tsel;
               when "0110" => O <= I6		         after Tsel;
               when "0111" => O <= I7		         after Tsel;
               when "1000" => O <= I8 	              after Tsel;
               when "1001" => O <= I9 	              after Tsel;
               when "1010" => O <= I10		         after Tsel;
               when "1011" => O <= I11		         after Tsel;
               when "1100" => O <= I12 	              after Tsel;
               when "1101" => O <= I13 	              after Tsel;
               when "1110" => O <= I14		         after Tsel;
               when "1111" => O <= I15		         after Tsel;
               when others => O <= (others => 'X')     after Tsel;
          end case;
     end process;

end arch;