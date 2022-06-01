-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\compile\multiplexador.vhd
-- Generated   : Sun Mar 18 18:56:26 2018
-- From        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\src\multiplexador.bde
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


entity multiplexador is
  generic(
       NumeroBits : integer := 8;
       Tsel : time := 2 ns;
       Tdata : time := 1 ns
  );
  port(
       S : in std_logic;
       I0 : in std_logic_vector(NumeroBits - 1 downto 0);
       I1 : in std_logic_vector(NumeroBits - 1 downto 0);
       O : out std_logic_vector(NumeroBits - 1 downto 0)
  );
end multiplexador;

architecture multiplexador of multiplexador is

begin

---- Processes ----

Mux :
process (I0, I1, S)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
variable Delay: time := 0 ns;
begin
	--If (S'event) then 
--		Delay := Tsel;
--	else
--		Delay := Tdata;
--	end if;
	case S is
		when '0' 	=> O <= I0 				after Delay;
		when '1' 	=> O <= I1 				after Delay;
		when others => O <= (others => 'X') after Delay;
	end case;
end process;


end multiplexador;
