-------------------------------------------------------------------------------
--
-- Title       : FD
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a generic Register File
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile is
    generic(
        NBend:      integer := 4;
        NBdado:     integer := 8;
        Tread:      time := 5 ns;
        Twrite:     time := 5 ns
    );
    port(
        clk:        in std_logic;
        we:         in std_logic;
        din:        in std_logic_vector(NBdado - 1 downto 0);
        addrin:     in std_logic_vector(NBend - 1 downto 0);
        addra:      in std_logic_vector(NBend - 1 downto 0);
        addrb:      in std_logic_vector(NBend - 1 downto 0);
        douta:      out std_logic_vector(NBdado - 1 downto 0);
        doutb:      out std_logic_vector(NBdado - 1 downto 0)
    );
end;

architecture arch of RegisterFile is

type ram_type is array (0 to 2**NBend - 1)  of std_logic_vector (NBdado - 1 downto 0);
signal ram: ram_type;

signal enda_reg:    std_logic_vector(NBend - 1 downto 0);
signal endb_reg:    std_logic_vector(NBend - 1 downto 0);

begin

RegisterMemory:
process (clk)
begin
    if (rising_edge(clk)) then
        if (we = '1') then
            ram(to_integer(unsigned(addrin))) <= din after Twrite;
        end if;
        enda_reg <= addra;
        endb_reg <= addrb;
    end if;
end process;

douta <= ram(to_integer(unsigned(enda_reg))) after Tread;
doutb <= ram(to_integer(unsigned(endb_reg))) after Tread;

end arch;
    