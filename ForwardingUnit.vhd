-------------------------------------------------------------------------------
--
-- Title       : ForwardingUnit
-- Design      : T-FIVE-Pipe
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Forwarding Unit.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ForwardingUnit is
    port (
        -- Register write enables
        mem_RegWEn:     in std_logic;
        wb_RegWEn:      in std_logic;

        -- Destination registers
        mem_Rd:         in std_logic_vector(4 downto 0);
        wb_Rd:          in std_logic_vector(4 downto 0);

        -- Source registers
        ex_Rs:          in std_logic_vector(4 downto 0);
        ex_Rt:          in std_logic_vector(4 downto 0);

        -- Multiplexer selectors
        ASel:           out std_logic_vector(1 downto 0);
        BSel:           out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;

architecture arch of ForwardingUnit is

    signal a, b, c, d:  std_logic;

begin

    process (mem_RegWEn, wb_RegWEn, mem_Rd, wb_Rd, ex_Rs, ex_Rt)
    begin
        if mem_RegWEn = '1' and mem_Rd = ex_Rs then a <= '1';
        else a <= '0';
        end if;
        
        if wb_RegWEn = '1' and wb_Rd = ex_Rs then b <= '1';
        else b <= '0';
        end if;

        if mem_RegWEn = '1' and mem_Rd = ex_Rt then c <= '1';
        else c <= '0';
        end if;
        
        if wb_RegWEn = '1' and wb_Rd = ex_Rt then d <= '1';
        else d <= '0';
        end if;
    end process;
    
    Asel(0) <= not(a) and b;
    Asel(1) <= a;

    Bsel(0) <= not(c) and d;
    Bsel(1) <= c;

end arch;