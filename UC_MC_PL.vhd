-------------------------------------------------------------------------------
--
-- Title       : UC_PL
-- Design      : T-FIVE-Pipe
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Control Unit entity.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity UC_PL is
    port (
        -- Global Clock and Reset signals
        clk:            in std_logic;
        rst:            in std_logic;

        -- Selecting the new adress for PC
        PCsel:          out std_logic;

        -- Selecting the immediate based on instruction type
        ImmSel:         out std_logic_vector(1 downto 0);

        -- Write enable for the Register File
        RegWEn:         out std_logic;

        -- Branch comparisons
        BrEq:           in std_logic;
        BrLt:           in std_logic;

        -- Selecting ALU operation
        ALUSEl:         out std_logic_vector(3 downto 0);

        -- Enable and R/W signal for Data Memory
        MemRW:          out std_logic;

        -- Selecting Write-back data
        WBSel:          out std_logic_vector(1 downto 0);
        
        -- Instruction fields for control
        instruction:    in std_logic_vector(31 downto 0)
    );
end UC_PL;

architecture arch of UC_PL is
    -- Instruction signals
    signal opcode:      std_logic_vector(6 downto 0);
    signal funct3:      std_logic_vector(2 downto 0);
    signal funct7:      std_logic_vector(6 downto 0);

    -- RE signals
    signal sr:          std_logic_vector(5 downto 0);

    -- PROM signals
    signal adress:      std_logic_vector(24 downto 0);
    signal prom:        std_logic_vector(16 downto 0);

begin

    opcode <= instruction(6 downto 0);
    funct3 <= instruction(14 downto 12);
    funct7 <= instruction(31 downto 25);

    STATE_REGISTER: entity work.Reg
        generic map (
            BitCount => 6
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din => prom(5 downto 0),
            dout => sr
        );

    adress(5 downto 0) <= sr;
    adress(6) <= BrEq;
    adress(7) <= BrLt;
    adress(14 downto 8) <= opcode;
    adress(17 downto 15) <= funct3;
    adress(24 downto 18) <= funct7;

    CONTROL_MEMORY: entity work.Ram
        generic map (
            BE => 25,
		    BP => 17,
            NA => "control_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => '0',
            ender => adress,
            pronto => open,
            dado_in => (others => '0'),
            dado_out => prom
        );

    PCsel <= prom(6);
    ImmSel <= prom(8 downto 7);
    RegWEn <= prom(9);
    ALUSEl <= prom(13 downto 10);
    MemRW <= prom(14);
    WBSel <= prom(16 downto 17);

end arch;