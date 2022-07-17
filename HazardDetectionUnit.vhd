-------------------------------------------------------------------------------
--
-- Title       : HazardDetectionUnit
-- Design      : T-FIVE-Pipe
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Hazard Detection Unit.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity HazardDetectionUnit is
    port (
        -- Destination register
        id_ex_Rd:           in std_logic_vector(4 downto 0);

        -- Source registers
        if_id_Rs1:          in std_logic_vector(4 downto 0);
        if_id_Rs2:          in std_logic_vector(4 downto 0);

        -- Memory signal
        ex_mem_MemRW:       in std_logic;

        -- PC write enable
        PCWEn:              out std_logic
    );
end HazardDetectionUnit;

architecture arch of HazardDetectionUnit is

    signal hazard:          std_logic;

begin

    process (id_ex_Rd, if_id_Rs1, if_id_Rs2, ex_mem_MemRW)
    begin
        if ((if_id_Rs1 = id_ex_Rd) or (if_id_Rs2 = id_ex_Rd)) and ex_mem_MemRW = '1' then
            hazard <= '1';
        else
            hazard <= '0';
        end if;
    end process;

    PCWEn <= not(hazard);

end arch;