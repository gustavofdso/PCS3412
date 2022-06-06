-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\Biblioteca_de_ComponentesV4.5\compile\deslocador_combinatorio.vhd
-- Generated   : Thu Feb  1 16:01:22 2018
-- From        : C:\My_Designs\Biblioteca_de_ComponentesV4.5\src\deslocador_combinatorio.bde
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


entity deslocador_combinatorio is
  generic(
       NB : integer := 8;
       NBD : integer := 1;
       Tprop : time := 1 ns
  );
  port(
       DE : in std_logic;
       I : in std_logic_vector(NB - 1 downto 0);
       O : out std_logic_vector(NB - 1 downto 0)
  );
end deslocador_combinatorio;

architecture deslocador_combinatorio of deslocador_combinatorio is

---- Architecture declarations -----
constant  Zer : std_logic_vector (NB - 1 downto 0) := (others => '0');


begin

---- User Signal Assignments ----
With DE select
	O	 <=  Zer( NB - 1 downto NB - NBD) & I(NB -1 downto NBD)	after Tprop when  '0' ,-- Desl. Direita
	 				I(NB - 1 - NBD downto 0) & Zer(NBD - 1 downto 0)			 after  Tprop when '1', -- Desl. Esquerda
	 				I 																													 							when others; -- Transfere

end deslocador_combinatorio;
