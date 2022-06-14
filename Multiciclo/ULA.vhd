-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\Biblioteca_de_ComponentesV4.5\compile\ULA.vhd
-- Generated   : Thu Feb  1 16:01:18 2018
-- From        : C:\My_Designs\Biblioteca_de_ComponentesV4.5\src\ULA.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity ULA is
     generic(
          NB 		: integer := 8;
          Tsom 	: time := 5 ns;
          Tsub 	: time := 5 ns;
          Ttrans 	: time := 5 ns;
          Tgate 	: time := 1 ns
     );
     port(
          Veum 	: in 	std_logic;
          A 		: in 	std_logic_vector(NB - 1 downto 0);
          B 		: in 	std_logic_vector(NB - 1 downto 0);
          cUla 	: in 	std_logic_vector(3 downto 0);
          Sinal 	: out 	std_logic;
          Vaum 	: out 	std_logic;
          Zero 	: out 	std_logic;
          C 		: out 	std_logic_vector(NB - 1 downto 0)
     );
end ULA;

architecture ULA of ULA is

---- Architecture declarations -----
signal S_NB 	: std_logic_vector (NB downto 0);
signal Zer 		: std_logic_vector (NB - 1 downto 0) := (others => '0');
signal Upper 	: std_logic_vector (NB downto 0) := ( '1', others => '0');


begin

---- User Signal Assignments ----
With cUla select
     S_NB <=	(('0' &  A) + Veum )		     when "0000",
               (('0' &  A) + B + Veum )	          when "0001",
               (('0' &  B) + Veum )		     when "0010",
               (('0' &  A) - B + Veum )	          when "0011",
               ('0' &  (A and B))			     when "0100",
               ('0' &  (A or B))			     when "0101",
               ('0' &  (A xor B))			     when "0110",
               ('0' & (not A))				when "0111",
               (shift_left(signed(A), signed(B)))         when "1000",
               (shift_right(signed(A), signed(B)))        when "1001",
               (others => '0')				when others;
-- Sa�da de Vai um
Vaum <=	S_NB(NB) after Tsom;
-- Resultado da Opera��o
C <= 		S_NB(NB - 1 downto 0) after Ttrans      when cUla = "0000" else
			S_NB(NB - 1 downto 0) after Tsom  	     when cUla = "0001" else
			S_NB(NB - 1 downto 0) after Ttrans      when cUla = "0010" else
			S_NB(NB - 1 downto 0) after Tsub  	     when cUla = "0011" else
			S_NB(NB - 1 downto 0) after Tgate 	     when cUla = "0100" else
			S_NB(NB - 1 downto 0) after Tgate 	     when cUla = "0101" else
			S_NB(NB - 1 downto 0) after 2*Tgate     when cUla = "0110" else
			S_NB(NB - 1 downto 0) after Tgate 	     when cUla = "0111" else
               S_NB(NB - 1 downto 0) after Tgate 	     when cUla = "1000" else
               S_NB(NB - 1 downto 0) after Tgate 	     when cUla = "1001";

-- Atualiza��o do sinal
Sinal <= S_NB(NB - 1) after Tsom;
-- Atualiza��o de Zero
Zero <= '1'  after Tsom when S_NB(NB - 1 downto 0) = Zer else
					'0' after Tsom ;


end ULA;
