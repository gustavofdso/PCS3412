-------------------------------------------------------------------------------
--
-- Title       : ALU
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic bit ALU.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity ALU is
     generic(
          BitCount:      integer := 32;
          Tadd:          time := 1 ns;
          Tsub:          time := 1.25 ns;
          Tgate:         time := 0.25 ns;
          Tsetup:        time := 0.25 ns
     );
     port(
          cin:           in std_logic;
          A:             in std_logic_vector(BitCount - 1 downto 0);
          B:             in std_logic_vector(BitCount - 1 downto 0);
          ALUOpe:        in std_logic_vector(3 downto 0);
          cout:          out std_logic;
          zero:          out std_logic;
          negative:      out std_logic;
          result:        out std_logic_vector(BitCount - 1 downto 0)
     );
end ALU;

architecture ALU of ALU is

signal qi:               std_logic_vector (BitCount downto 0);

begin

     process(A, B, ALUOpe)
     begin
          case(ALUOpe) is
               when "0000" => -- Addition
                    qi <= A + B after Tadd; 
               when "0001" => -- Subtraction
                    qi <= A - B after Tsub;
               when "0010" => -- Multiplication
                    qi <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))), BitCount));
               when "0011" => -- Division
                    qi <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / to_integer(unsigned(B)), BitCount));
               when "0100" => -- Logical shift left
                    qi <= std_logic_vector(unsigned(A) sll to_integer(signed(B))) after Tsetup;
               when "0101" => -- Logical shift right
                    qi <= std_logic_vector(unsigned(A) srl to_integer(signed(B))) after Tsetup;
               when "0110" => --  Rotate left
                    qi <= std_logic_vector(unsigned(A) rol to_integer(signed(B))) after Tsetup;
               when "0111" => -- Rotate right
                    qi <= std_logic_vector(unsigned(A) ror to_integer(signed(B))) after Tsetup;
               when "1000" => -- Logical and 
                    qi <= A and B after Tgate;
               when "1001" => -- Logical or
                    qi <= A or B after Tgate;
               when "1010" => -- Logical xor 
                    qi <= A xor B after 2*Tgate;
               when "1011" => -- Logical nor
                    qi <= A nor B after Tgate;
               when "1100" => -- Logical nand 
                    qi <= A nand B after Tgate;
               when "1101" => -- Logical xnor
                    qi <= A xnor B after 2*Tgate;
               when "1110" => -- Lower comparison
                    if(A < B) then
                         qi <= x"01" after Tsub;
                    else
                         qi <= x"00" after Tsub;
                    end if; 
               when "1111" => -- Equal comparison   
                    if(A = B) then
                         qi <= x"01" after Tsub;
                    else
                         qi <= x"00" after Tsub;
                    end if;
               when others => qi <= A + B; 
          end case;
     end process;

     cout <= qi(BitCount);
     zero <= '1' after Tadd when unsigned(qi) = 0 else '0' after Tadd;
     negative <= qi(BitCount - 1) after Tadd;

     result <= qi(BitCount - 1 downto 0);

end ALU;
