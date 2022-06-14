-------------------------------------------------------------------------------
--
-- Title       : Reg
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic bit Register.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Reg is
     generic(
          BitCount:      INTEGER := 32;
          Tsetup:        time := 0.25 ns;
          Thold:         time := 0.25 ns;
          Tprop:         time := 1 ns
     );
     port(
          clk:           in std_logic;
          ce:            in std_logic;
          rst:           in std_logic;
          din:           in std_logic_vector(BitCount - 1 downto 0);
          dout:          out std_logic_vector(BitCount - 1 downto 0)
     );
end Reg;

architecture Reg of Reg is

signal qi : std_logic_vector(BitCount - 1 downto 0);

begin

     process (clk, rst, ce)
     begin
          if rst = '1' then
               qi(BitCount -1 downto 0) <= (others => '0');
          elsif (rising_edge(clk)) then
               if ce = '1' then
                    qi <= din;
               else
                    null;
               end if;
          end if;
     end process;

     dout <= qi after Tprop;

end Reg;
