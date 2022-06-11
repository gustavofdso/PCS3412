-------------------------------------------------------------------------------
--
-- Title       : FD_tb
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Testbench fot the Datapath component.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity FD_tb is
end entity FD_tb;

architecture FD_tb of FD_tb is
    signal clk:            std_logic := '0';
    signal rst:            std_logic := '0';

    signal ce_pc:          std_logic := '0';
    signal ce_ri:          std_logic := '0';

    signal Brch:           std_logic_vector(1 downto 0) := (others => '0');

    signal menable:        std_logic := '0';
    signal rw:             std_logic := '0';

    signal MemtoReg:       std_logic := '0';
    signal RegWrite:       std_logic := '0';
    signal RegDest:        std_logic := '0';

    signal ALUSrc:         std_logic_vector(1 downto 0) := (others => '0');
    signal ALUOpe:         std_logic_vector(3 downto 0) := (others => '0');

    signal Cop:            std_logic_vector(5 downto 0) := (others => '0');
    signal CopExt:         std_logic_vector(5 downto 0) := (others => '0');

    signal Zero:           std_logic := '0';
begin
    FD: entity work.FD port map (
        clk => clk,
        rst => rst,
        ce_pc => ce_pc,
        ce_ri => ce_ri,
        Brch => Brch,
        menable => menable,
        rw => rw,
        MemtoReg => MemtoReg,
        RegWrite => RegWrite,
        RegDest => RegDest,
        ALUSrc => ALUSrc,
        ALUOpe => ALUOpe,
        Cop => Cop,
        CopExt => CopExt,
        Zero => Zero
    )

    test: process

    begin
        wait for 50 ns

        
        report "Finish testbench";

        wait; -- Finish
    end process test;

    clock_gen: process
    begin
        clk <= '0', '1' after 15 ns;
        wait for 30 ns;
    end process clock_gen;

end FD_tb;