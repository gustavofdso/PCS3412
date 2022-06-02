-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : componentes
-- Author      : Wilson Ruggiero
-- Company     : Larc-Epusp
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\Componentes\componentes\compile\Reg_ClkEnable.vhd
-- Generated   : Thu Feb  1 16:31:25 2018
-- From        : C:\My_Designs\Componentes\componentes\src\Reg_ClkEnable.bde
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

entity Reg_ClkEnable is
  generic(
       NumeroBits : INTEGER := 8;
       Tprop : time := 5 ns;
       Tsetup : time := 2 ns
  );
  port(
       C : in std_logic;
       CE : in std_logic;
       R : in std_logic;
       S : in std_logic;
       D : in std_logic_vector(NumeroBits - 1 downto 0);
       Q : out std_logic_vector(NumeroBits - 1 downto 0)
  );
end Reg_ClkEnable;

architecture Reg_ClkEnable of Reg_ClkEnable is

---- Signal declarations used on the diagram ----

signal qi : std_logic_vector(NumeroBits - 1 downto 0);

begin

---- Processes ----

Registrador :
process (C, S, R, CE)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
begin
	if R='1' then	-- 	Reset assíncrono
		qi(NumeroBits -1 downto 0) <= (others => '0');-- Inicialização com zero
	elsif S = '1' then -- Set assíncrono
		qi(NumeroBits - 1 downto 0) <= (others => '1'); -- Inicialização com um
	elsif (C'event and C='1') then  -- Clock na borda de subida
		if CE = '1' then
			qi <= D;
		else
			null;
		end if;
	end if;
end process Registrador;


---- User Signal Assignments ----
Q <= qi after Tprop;

end Reg_ClkEnable;
