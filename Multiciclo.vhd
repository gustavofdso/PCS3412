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

    signal PCWEn:           std_logic;
    signal PCsel:           std_logic;
    signal ImmSel:          std_logic_vector(1 downto 0);
    signal RegWEn:          std_logic;
    signal BrEq:            std_logic;
    signal BrLt:            std_logic;
    signal ASEl:            std_logic;
    signal BSEl:            std_logic;
    signal ALUSEl:          std_logic_vector(3 downto 0);
    signal MemRW:           std_logic;
    signal WBSel:           std_logic_vector(1 downto 0);
    signal instruction:     std_logic_vector(31 downto 0);

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