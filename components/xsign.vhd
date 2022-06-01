-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\compile\xsign.vhd
-- Generated   : Wed Feb 28 10:13:20 2018
-- From        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\src\xsign.bde
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


entity xsign is
  generic(
       NBE : integer := 8;
       NBS : integer := 16
  );
  port(
       I : in std_logic_vector(NBE- 1 downto 0);
       O : out std_logic_vector(NBS - 1 downto 0)
  );
end xsign;

architecture xsign of xsign is

begin

---- User Signal Assignments ----
O(NBE - 1 downto 0) <= I;
O(NBS - 1 downto NBE) <= (others => I(NBE-1));

end xsign;
