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
        clk:                    in std_logic;
        rst:                    in std_logic;

        -- Selecting the new adress for PC
        PCsel:                  out std_logic;

        -- Selecting the immediate based on instruction type
        ImmSel:                 out std_logic_vector(1 downto 0);

        -- Write enable for the Register File
        RegWEn:                 out std_logic;

        -- Branch comparisons
        BrEq:                   in std_logic;
        BrLt:                   in std_logic;

        -- Selecting ALU operation
        ALUSEl:                 out std_logic_vector(3 downto 0);

        -- Enable and R/W signal for Data Memory
        MemRW:                  out std_logic;

        -- Selecting Write-back data
        WBSel:                  out std_logic_vector(1 downto 0);
        
        -- Instruction fields for control
        instruction:            in std_logic_vector(31 downto 0)
    );
end UC_PL;

architecture arch of UC_PL is
    -- Instruction signals
    signal opcode:              std_logic_vector(6 downto 0);
    signal funct3:              std_logic_vector(2 downto 0);
    signal funct7:              std_logic_vector(6 downto 0);

    -- RE signals
    signal sr:                  std_logic_vector(5 downto 0);
    signal link:                std_logic_vector(5 downto 0);
    
    -- PROM signals
    signal prom:                std_logic_vector(27 downto 0);
    signal outputs:             std_logic_vector(10 downto 0);
    signal link_true:           std_logic_vector(5 downto 0);
    signal link_false:          std_logic_vector(5 downto 0);
    signal test:                std_logic_vector(4 downto 0);

    -- Test signals
    signal opcode_0110011:      std_logic;
    signal opcode_0010011:      std_logic;
    signal opcode_0000011:      std_logic;
    signal opcode_0100011:      std_logic;
    signal opcode_1100111:      std_logic;
    signal opcode_1100011:      std_logic;
    signal opcode_1101111:      std_logic;
    signal funct3_000:          std_logic;
    signal funct3_010:          std_logic;
    signal funct3_001:          std_logic;
    signal funct3_101:          std_logic;
    signal funct7_0000010:      std_logic;
    signal funct7_0000000:      std_logic;
    signal funct7_0000001:      std_logic;
    signal funct7_0000100:      std_logic;

    -- MUX signals
    signal mux_in:      std_logic;

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
            din => link,
            dout => sr
        );

    CONTROL_MEMORY: entity work.Ram
        generic map (
            BE => 6,
		    BP => 28,
            NA => "control_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => '0',
            ender => sr,
            pronto => open,
            dado_in => (others => '0'),
            dado_out => prom
        );

    outputs <= prom(10 downto 0);
    link_true <= prom(16 downto 11);
    link_false <= prom(22 downto 17);
    test <= prom(27 downto 23);

    PCsel <= outputs(0);
    ImmSel <= outputs(2 downto 1);
    RegWEn <= outputs(3);
    ALUSEl <= outputs(7 downto 4);
    MemRW <= outputs(8);
    WBSel <= outputs(10 downto 9);

    COMPARATOR_OPCODE_0110011: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "0110011",
            eq => opcode_0110011,
            lt => open,
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_OPCODE_0010011: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "0010011",
            eq => opcode_0010011,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_OPCODE_0000011: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "0000011",
            eq => opcode_0000011,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_OPCODE_0100011: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "0100011",
            eq => opcode_0100011,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_OPCODE_1100111: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "1100111",
            eq => opcode_1100111,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_OPCODE_1100011: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "1100011",
            eq => opcode_1100011,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_OPCODE_1101111: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => opcode,
            B => "1101111",
            eq => opcode_1101111,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );
    
    COMPARATOR_FUNCT3_000: entity work.Comparator
        generic map (
            BitCount => 3
        )
        port map (
            A => funct3,
            B => "000",
            eq => funct3_000,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT3_010: entity work.Comparator
        generic map (
            BitCount => 3
        )
        port map (
            A => funct3,
            B => "010",
            eq => funct3_010,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT3_001: entity work.Comparator
        generic map (
            BitCount => 3
        )
        port map (
            A => funct3,
            B => "001",
            eq => funct3_001,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT3_101: entity work.Comparator
        generic map (
            BitCount => 3
        )
        port map (
            A => funct3,
            B => "101",
            eq => funct3_101,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT7_0000010: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => funct7,
            B => "0000010",
            eq => funct7_0000010,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT7_0000000: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => funct7,
            B => "0000000",
            eq => funct7_0000000,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT7_0000001: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => funct7,
            B => "0000001",
            eq => funct7_0000001,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    COMPARATOR_FUNCT7_funct7_0000100: entity work.Comparator
        generic map (
            BitCount => 7
        )
        port map (
            A => funct7,
            B => "0000100",
            eq => funct7_0000100,
            lt => open, 
            gt => open,
            le => open,
            ge => open
        );

    MULTIPLEXER_IN: entity work.Mux32
        generic map (
            BitCount => 1
        )
        port map (
            I0(0) => opcode_0110011,
            I1(0) => opcode_0010011,
            I2(0) => opcode_0000011,
            I3(0) => opcode_0100011,
            I4(0) => opcode_1100111,
            I5(0) => opcode_1100011,
            I6(0) => opcode_1101111,
            I7(0) => funct3_000,
            I8(0) => funct3_010,
            I9(0) => funct3_001,
            I10(0) => funct3_101,
            I11(0) => funct7_0000010,
            I12(0) => funct7_0000000,
            I13(0) => funct7_0000001,
            I14(0) => funct7_0000100,
            I15(0) => BrLt,
            I16(0) => BrEq,
            I17 => (others => '0'),
            I18 => (others => '0'),
            I19 => (others => '0'),
            I20 => (others => '0'),
            I21 => (others => '0'),
            I22 => (others => '0'),
            I23 => (others => '0'),
            I24 => (others => '0'),
            I25 => (others => '0'),
            I26 => (others => '0'),
            I27 => (others => '0'),
            I28 => (others => '0'),
            I29 => (others => '0'),
            I30 => (others => '0'),
            I31 => (others => '0'),
            Sel => test,
            O(0) => mux_in
        );

    MULTIPLEXER_LINK: entity work.Mux2
        generic map (
            BitCount => 6
        )
        port map (
            Sel => mux_in,
            I0 => link_false,
            I1 => link_true,
            O => link
        );

end arch;