-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\Biblioteca_de_ComponentesV4.5\compile\deslocador.vhd
-- Generated   : Thu Feb  1 16:01:23 2018
-- From        : C:\My_Designs\Biblioteca_de_ComponentesV4.5\src\deslocador.bde
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


entity deslocador is
  generic(
       NumeroBits : integer := 8;
       Tcarga : time := 3 ns;
       Tdesl : time := 2 ns
  );
  port(
       Clk : in std_logic;
       D_E : in std_logic;
       InBit : in std_logic;
       T_D : in std_logic;
       InA : in std_logic_vector(NumeroBits - 1 downto 0);
       SaiBit : out std_logic;
       OutA : out std_logic_vector(NumeroBits - 1 downto 0)
  );
end deslocador;

architecture deslocador of deslocador is

begin

---- User Signal Assignments ----
deslocador: block (Clk'event and Clk='1')
	begin
  	OutA 	<= 	guarded 	(InA)              after Tcarga  when (T_D = '0') 		                  else	-- Transfere sem deslocar
	   						(InA(NumeroBits - 2 downto 0) & InBit) after Tdesl  when (T_D = '1' and D_E = '0')	else   -- Desloca à esquerda
		   					(InBit & InA(NumeroBits - 1 downto 1)) after Tdesl  when (T_D = '1' and D_E = '1');		      -- Desloca à direita
							   
	SaiBit 	<= 	guarded 	'0' 				after Tcarga	  when  T_D = '0' 				              else  	-- Transfere sem deslocar
			  				InA(NumeroBits - 1) 	after Tdesl 	when (T_D = '1' and D_E = '0') 	else  	-- Desloca à esquerda
			  				InA(0)	              			after Tdesl 	when (T_D = '1' and D_E = '1');	  		    -- Desloca à direita
	end block deslocador;

end deslocador;
