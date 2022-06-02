-------------------------------------------------------------------------------
--
-- Title       : FD
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic Register.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity Reg is
  generic(
       NumberBits : INTEGER := 8;
       Tprop : time := 5 ns;
       Tsetup : time := 2 ns
  );
  port(
       clk:         in std_logic;
       ce:          in std_logic;
       rst:         in std_logic;
       din:         in std_logic_vector(NumberBits - 1 downto 0);
       dout:        out std_logic_vector(NumberBits - 1 downto 0)
  );
end Reg;

architecture arch of Reg is
     
     signal temp:    std_logic_vector(NumberBits - 1 downto 0);

begin

     process (clk, rst, ce)
     begin
          if rst = '1' then
               temp <= (others => '0');
          elsif (rising_edge(clk)) then
               if ce = '1' then
                    temp <= din;
               else
                    null;
               end if;
          end if;
     end process;

dout <= temp after Tprop;

end arch;