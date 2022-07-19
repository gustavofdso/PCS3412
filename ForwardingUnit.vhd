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
    generic (
        Tprop:              time := 1 ns
    );
    port (
        -- Register write enables
        ex_mem_RegWEn:      in std_logic;
        mem_wb_RegWEn:      in std_logic;

        -- Destination registers
        ex_mem_Rd:          in std_logic_vector(4 downto 0);
        mem_wb_Rd:          in std_logic_vector(4 downto 0);

        -- Source registers
        id_ex_Rs1:          in std_logic_vector(4 downto 0);
        id_ex_Rs2:          in std_logic_vector(4 downto 0);

        -- Multiplexer selectors
        ASel:               out std_logic_vector(1 downto 0);
        BSel:               out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;

architecture arch of ForwardingUnit is

    signal a, b, c, d:      std_logic;

begin

    process (ex_mem_RegWEn, mem_wb_RegWEn, ex_mem_Rd, mem_wb_Rd, id_ex_Rs1, id_ex_Rs2)
    begin
        if ex_mem_RegWEn = '1' and ex_mem_Rd /= "00000" and ex_mem_Rd = id_ex_Rs1 then a <= '1' after Tprop;
        else a <= '0' after Tprop;
        end if;
        
        if mem_wb_RegWEn = '1' and mem_wb_Rd = id_ex_Rs1 then b <= '1' after Tprop;
        else b <= '0' after Tprop;
        end if;

        if ex_mem_RegWEn = '1' and ex_mem_Rd /= "00000" and ex_mem_Rd = id_ex_Rs2 then c <= '1' after Tprop;
        else c <= '0' after Tprop;
        end if;
        
        if mem_wb_RegWEn = '1' and mem_wb_Rd = id_ex_Rs2 then d <= '1' after Tprop;
        else d <= '0' after Tprop;
        end if;
    end process;
    
    Asel(0) <= not(a) and b;
    Asel(1) <= a;

    Bsel(0) <= not(c) and d;
    Bsel(1) <= c;

end arch;