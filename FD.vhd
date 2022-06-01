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
	if R='1' then	-- 	Reset ass�ncrono
		qi(NumeroBits -1 downto 0) <= (others => '0');-- Inicializa��o com zero
	elsif S = '1' then -- Set ass�ncrono
		qi(NumeroBits - 1 downto 0) <= (others => '1'); -- Inicializa��o com um
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

-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\compile\somador.vhd
-- Generated   : Wed Feb 28 10:12:30 2018
-- From        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\src\somador.bde
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

entity Somador is
  generic(
       NumeroBits : integer := 8;
       Tsoma : time := 3 ns;
       Tinc : time := 2 ns
  );
  port(
       S : in std_logic;
       Vum : in std_logic;
       A : in std_logic_vector(NumeroBits - 1 downto 0);
       B : in std_logic_vector(NumeroBits - 1 downto 0);
       C : out std_logic_vector(NumeroBits - 1 downto 0)
  );
end Somador;

architecture Somador of Somador is

begin

---- User Signal Assignments ----
C <= (A + B + Vum) 	after Tsoma  when S = '1' else
			 (A + Vum)			after Tinc;

end Somador;

-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Biblioteca_de_Componentes
-- Author      : Wilson Ruggiero
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- File        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\compile\RegFile.vhd
-- Generated   : Wed Feb 28 10:02:04 2018
-- From        : c:\Aldec\Active-HDL-Student-Edition\vlib\Biblioteca_de_ComponentesV4.5\src\RegFile.bde
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
use ieee.numeric_std.all;

entity RegFile is
  generic(
       NBend : integer := 4;
       NBdado : integer := 8;
       Tread : time := 5 ns;
       Twrite : time := 5 ns
  );
  port(
       clk : in std_logic;
       we : in std_logic;
       dadoina : in std_logic_vector(NBdado - 1 downto 0);
       enda : in std_logic_vector(NBend - 1 downto 0);
       dadoouta : out std_logic_vector(NBdado - 1 downto 0)
  );
end RegFile;

architecture RegFile of RegFile is

---- Architecture declarations -----
type ram_type is array (0 to 2**NBend - 1)
        of std_logic_vector (NBdado - 1 downto 0);
signal ram: ram_type;



---- Signal declarations used on the diagram ----

signal enda_reg : std_logic_vector(NBend - 1 downto 0);

begin

---- Processes ----

RegisterMemory :
process (clk)
-- Section above this comment may be overwritten according to
-- "Update sensitivity list automatically" option status
-- declarations
begin
	 if (clk'event and clk = '1') then
        if (we = '1') then
           ram(to_integer(unsigned(enda))) <= dadoina after Twrite;
        end if;
        enda_reg <= enda;
     end if;
end process RegisterMemory;

---- User Signal Assignments ----
dadoouta <= ram(to_integer(unsigned
								(enda_reg))) after Tread;


end RegFile;
