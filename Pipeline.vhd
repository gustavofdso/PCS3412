-------------------------------------------------------------------------------
--
-- Title       : Pipeline
-- Design      : T-FIVE-Pipe
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a Pipeline Processor
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity Pipeline is
    port (
        -- Global Clock and Reset signals
        clk:                in std_logic;
        rst:                in std_logic
    );
end entity;

architecture arch of Pipeline is

    signal PCsel:           std_logic;
    signal ImmSel:          std_logic_vector(1 downto 0);
    signal RegWEn:          std_logic;
    signal BrEq:            std_logic;
    signal BrLt:            std_logic;
    signal ALUSEl:          std_logic_vector(3 downto 0);
    signal MemRW:           std_logic;
    signal WBSel:           std_logic_vector(1 downto 0);
    signal instruction:     std_logic_vector(31 downto 0);

begin

    UC: entity work.UC_PL
        port map(
            clk => clk,
            rst => rst,
            PCsel => PCsel,
            ImmSel => ImmSel,
            RegWEn => RegWEn,
            BrEq => BrEq,
            BrLt => BrLt,
            ALUSEl => ALUSEl,
            MemRW => MemRW,
            WBSel => WBSel,
            instruction => instruction
        );

    FD: entity work.FD_PL
        port map(
            clk => clk,
            rst => rst,
            PCsel => PCsel,
            ImmSel => ImmSel,
            RegWEn => RegWEn,
            BrEq => BrEq,
            BrLt => BrLt,
            ALUSEl => ALUSEl,
            MemRW => MemRW,
            WBSel => WBSel,
            instruction => instruction
        );

end arch;