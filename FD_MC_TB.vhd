library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity FD_MC_TB is
end FD_MC_TB;

architecture arch of FD_MC_TB is

    signal clk:            std_logic;
    signal rst:            std_logic;
    signal PCWEn:          std_logic;
    signal PCsel:          std_logic;
    signal ImmSel:         std_logic_vector(1 downto 0);
    signal RegWEn:         std_logic;
    signal BrEq:           std_logic;
    signal BrLt:           std_logic;
    signal ASEl:           std_logic;
    signal BSEl:           std_logic;
    signal ALUSEl:         std_logic_vector(3 downto 0);
    signal MemRW:          std_logic;
    signal WBSel:          std_logic_vector(1 downto 0);
    signal instruction:    std_logic_vector(31 downto 0);

begin

    Clock: process is
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;

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
    
    test: process is
    begin
        wait for 1 ns;

        rst <= '0';
        PCWEn <= '1';
        PCsel <= '0';
        ImmSel <= "00";
        RegWEn <= '1';
        ASEl <= '1';
        BSEl <= '0';
        ALUSEl <= "0000";
        MemRW <= '0';
        WBSel <= "00";

        wait for 30 ns;
    
        assert false report "test done";
        wait;
    end process;
end arch;