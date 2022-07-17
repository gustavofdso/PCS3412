-------------------------------------------------------------------------------
--
-- Title       : Multiciclo
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a Multi Cycle Processor
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity Multiciclo is
    port (
        -- Global Clock and Reset signals
        clk:                in std_logic;
        rst:                in std_logic
    );
end entity;

architecture arch of Multiciclo is

    signal PCWEn:           out std_logic;
    signal PCsel:           out std_logic;
    signal ImmSel:          out std_logic_vector(1 downto 0);
    signal RegWEn:          out std_logic;
    signal BrEq:            in std_logic;
    signal BrLt:            in std_logic;
    signal ASEl:            out std_logic;
    signal BSEl:            out std_logic;
    signal ALUSEl:          out std_logic_vector(3 downto 0);
    signal MemRW:           out std_logic;
    signal WBSel:           out std_logic_vector(1 downto 0);
    signal instruction:     in std_logic_vector(31 downto 0)

begin

    UC: entity work.UC_MC
        port map(
            clk => clk,
            rst => rst,
            PCWEn => PCWEn,
            PCsel => PCsel,
            ImmSel => ImmSel,
            RegWEn => RegWEn,
            BrEq => BrEq,   
            BrLt => BrLt,   
            ASEl => ASEl,
            BSEl => BSEl,
            ALUSEl => ALUSEl,
            MemRW => MemRW,
            WBSel => WBSel,
            instruction => instruction
        );

    FD: entity work.FD_MC
        port map(
            clk => clk,
            rst => rst,
            PCWEn => PCWEn,
            PCsel => PCsel,
            ImmSel => ImmSel,
            RegWEn => RegWEn,
            BrEq => BrEq,   
            BrLt => BrLt,   
            ASEl => ASEl,
            BSEl => BSEl,
            ALUSEl => ALUSEl,
            MemRW => MemRW,
            WBSel => WBSel,
            instruction => instruction
        );

end arch;