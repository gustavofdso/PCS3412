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

    signal PCsel:           out std_logic;
    signal ImmSel:          out std_logic_vector(1 downto 0);
    signal RegWEn:          out std_logic;
    signal BrEq:            in std_logic;
    signal BrLt:            in std_logic;
    signal ALUSEl:          out std_logic_vector(3 downto 0);
    signal MemRW:           out std_logic;
    signal WBSel:           out std_logic_vector(1 downto 0);
    signal instruction:     in std_logic_vector(31 downto 0)

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