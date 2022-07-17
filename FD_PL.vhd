-------------------------------------------------------------------------------
--
-- Title       : FD_PL
-- Design      : T-FIVE-Pipe
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Data path entity with its components.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity FD_PL is
    port (
        -- Global Clock and Reset signals
        clk:            in std_logic;
        rst:            in std_logic;

        -- Selecting the new adress for PC
        PCsel:          in std_logic;

        -- Selecting the immediate based on instruction type
        ImmSel:         in std_logic_vector(1 downto 0);

        -- Write enable for the Register File
        RegWEn:         in std_logic;

        -- Branch comparisons
        BrEq:           out std_logic;
        BrLt:           out std_logic;

        -- Selecting ALU operation
        ALUSEl:         in std_logic_vector(3 downto 0);

        -- Enable and R/W signal for Data Memory
        MemRW:          in std_logic;

        -- Selecting Write-back data
        WBSel:          in std_logic_vector(1 downto 0);
        
        -- Instruction field
        instruction:    out std_logic_vector(31 downto 0)
    );
end FD_PL;

architecture arch of FD_PL is
    -- PC signals
    signal mux_pc:      std_logic_vector(31 downto 0);
    signal pc:          std_logic_vector(31 downto 0);
    signal add:         std_logic_vector(31 downto 0);

    -- Instruction Memory signals
    signal dout_i:      std_logic_vector(31 downto 0);

    -- Immediate Generator sinals
    signal immed:       std_logic_vector(31 downto 0);
    
    -- Register File signals
    signal dout_r_a:    std_logic_vector(31 downto 0);
    signal dout_r_b:    std_logic_vector(31 downto 0);

    -- ALU signals
    signal mux_a:       std_logic_vector(31 downto 0);
    signal mux_b:       std_logic_vector(31 downto 0);
    signal alu:         std_logic_vector(31 downto 0);

    -- Data Memory signals
    signal dout_d:      std_logic_vector(31 downto 0);
    signal mux_wb:      std_logic_vector(31 downto 0);

    -- Buffer signals
    signal if_id:       std_logic_vector(255 downto 0);
    signal id_ex:       std_logic_vector(255 downto 0);
    signal ex_mem:      std_logic_vector(255 downto 0);
    signal mem_wb:      std_logic_vector(255 downto 0);

    -- Control Buffer signals
    signal c_id_ex:     std_logic_vector(11 downto 0);
    signal c_ex_mem:    std_logic_vector(11 downto 0);
    signal c_mem_wb:    std_logic_vector(11 downto 0);

    -- Forwarding Unit signals
    signal Asel:        std_logic_vector(1 downto 0);
    signal Bsel:        std_logic_vector(1 downto 0);

    -- Hazard Detection Unit signals
    signal PCWEn:       std_logic;
    signal not_PCWEn:   std_logic;
	 
begin

    MULTIPLEXER_PC: entity work.Mux2
        port map (
            I0 => ex_mem(31 downto 0),
            I1 => ex_mem(223 downto 192),
            Sel => c_ex_mem(1),
            O => mux_pc
        );

    PROGRAM_COUNTER: entity work.Reg
        port map (
            clk => clk,
            ce => PCWEn,
            rst => rst,
            din => mux_pc,
            dout => pc
        );

    ADD4: entity work.Adder
        port map (
            cin => '0',
            A => pc,
            B => x"00000004",
            sum => add
        );

    INSTRUCTION_MEMORY: entity work.Ram
        generic map (
            NA => "instruction_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => '0',
            ender => pc,
            pronto => open,
            dado_in => (others => '0'),
            dado_out => dout_i
        );

    instruction <= if_id(95 downto 64);

    REGISTER_FILE: entity work.RegFile
        port map (
            clk => clk,
            we => c_mem_wb(4),
            din => mux_wb,
            addrin => mem_wb(75 downto 71),
            addra => if_id(83 downto 79),
            addrb => if_id(88 downto 84),
            douta => dout_r_a,
            doutb => dout_r_b
        );

    IMMEDIATE_GENERATOR: entity work.ImmediateGenerator
        port map (
            instruction => if_id(95 downto 64),
            ImmSel => ImmSel,
            immed => immed
        );

    BRANCH_COMPARATOR: entity work.Comparator
        port map (
            A => id_ex(127 downto 96),
            B => id_ex(159 downto 128),
            eq => BrEq,
            lt => BrLt,
            gt => open,
            le => open,
            ge => open
        );

    MULTIPLEXER_A: entity work.Mux4
        port map (
            I0 => id_ex(127 downto 96),
            I1 => id_ex(63 downto 32),
            I2 => ex_mem(223 downto 192),
            I3 => (others => '0'),
            Sel => Asel,
            O => mux_a
        );
        
    MULTIPLEXER_B: entity work.Mux4
        port map (
            I0 => id_ex(159 downto 128),
            I1 => id_ex(191 downto 160),
            I2 => ex_mem(223 downto 192),
            I3 => (others => '0'),
            Sel => Bsel,
            O => mux_b
        );

    MULTIFUNCIONAL_ALU: entity work.ALU
        port map (
            cin => '0',
            A => mux_a,
            B => mux_b,
            ALUOpe => c_id_ex(8 downto 5),
            cout => open,
            zero => open,
            negative => open,
            result => alu
        );

    DATA_MEMORY: entity work.Ram
        generic map (
            NA => "data_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => c_ex_mem(9),
            ender => ex_mem(223 downto 192),
            pronto => open,
            dado_in => ex_mem(159 downto 128),
            dado_out => dout_d
        );

    MULTIPLEXER_WB: entity work.Mux4
        port map (
            I0 => mem_wb(255 downto 224),
            I1 => mem_wb(223 downto 192),
            I2 => mem_wb(31 downto 0),
            I3 => (others => '0'),
            Sel => c_mem_wb(11 downto 10),
            O => mux_wb
        );

    -- [0]          PCWEn
    -- [1]          PCsel
    -- [3:2]        ImmSel
    -- [4]          RegWEn
    -- [8:5]        ALUSEl
    -- [9]          MemRW
    -- [11:10]      WBSel

    CONTROL_BUFFER_ID_EX: entity work.Reg
        generic map (
            BitCount => 12
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din(0) => PCWEn,
            din(1) => PCsel,
            din(3 downto 2) => ImmSel,
            din(4) => RegWEn,
            din(8 downto 5) => ALUSEl,
            din(9) => MemRW,
            din(11 downto 10) => WBSel,
            dout => c_id_ex
        );

    not_PCWEn <= not(PCWEn);

    CONTROL_BUFFER_EX_MEM: entity work.Reg
        generic map (
            BitCount => 12
        )
        port map (
            clk => clk,
            ce => '1',
            rst => not_PCWEn,
            din => c_id_ex,
            dout => c_ex_mem
        );

    CONTROL_BUFFER_MEM_WB: entity work.Reg
        generic map (
            BitCount => 12
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din => c_ex_mem,
            dout => c_mem_wb
        );

    -- [31:0]       add
    -- [63:32]      pc
    -- [95:64]      dout_i
    -- [127:96]     dout_r_a
    -- [159:128]    dout_r_b
    -- [191:160]    immed
    -- [223:192]    alu
    -- [255:224]    dout_d

    BUFFER_IF_ID: entity work.Reg
        generic map (
            BitCount => 256
        )
        port map (
            clk => clk,
            ce => PCWEn,
            rst => rst,
            din(31 downto 0) => add,
            din(63 downto 32) => pc,
            din(95 downto 64) => dout_i,
            din(127 downto 96) => (others => '0'),
            din(159 downto 128) => (others => '0'),
            din(191 downto 160) => (others => '0'),
            din(223 downto 192) => (others => '0'),
            din(255 downto 224) => (others => '0'),
            dout => if_id
        );

    BUFFER_ID_EX: entity work.Reg
        generic map (
            BitCount => 256
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din(31 downto 0) => if_id(31 downto 0),
            din(63 downto 32) => if_id(63 downto 32),
            din(95 downto 64) => if_id(95 downto 64),
            din(127 downto 96) => dout_r_a,
            din(159 downto 128) => dout_r_b,
            din(191 downto 160) => immed,
            din(223 downto 192) => (others => '0'),
            din(255 downto 224) => (others => '0'),
            dout => id_ex
        );

    BUFFER_EX_MEM: entity work.Reg
        generic map (
            BitCount => 256
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din(31 downto 0) => id_ex(31 downto 0),
            din(63 downto 32) => id_ex(63 downto 32),
            din(95 downto 64) => id_ex(95 downto 64),
            din(127 downto 96) => id_ex(127 downto 96),
            din(159 downto 128) => id_ex(159 downto 128),
            din(191 downto 160) => id_ex(191 downto 160),
            din(223 downto 192) => alu,
            din(255 downto 224) => (others => '0'),
            dout => ex_mem
        );

    BUFFER_MEM_WB: entity work.Reg
        generic map (
            BitCount => 256
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din(31 downto 0) => ex_mem(31 downto 0),
            din(63 downto 32) => ex_mem(63 downto 32),
            din(95 downto 64) => ex_mem(95 downto 64),
            din(127 downto 96) => ex_mem(127 downto 96),
            din(159 downto 128) => ex_mem(159 downto 128),
            din(191 downto 160) => ex_mem(191 downto 160),
            din(223 downto 192) => ex_mem(223 downto 192),
            din(255 downto 224) => dout_d,
            dout => mem_wb
        );

    FORWARDING_UNIT: entity work.ForwardingUnit
        port map (
            ex_mem_RegWEn => c_ex_mem(4),
            mem_wb_RegWEn => c_mem_wb(4),
            ex_mem_Rd => ex_mem(75 downto 71),
            mem_wb_Rd => mem_wb(75 downto 71),
            id_ex_Rs1 => id_ex(83 downto 79),
            id_ex_Rs2 => id_ex(88 downto 84),
            Asel => Asel,
            Bsel => Bsel
        );

    HAZARD_DETECTION_UNIT: entity work.HazardDetectionUnit
        port map (
            id_ex_Rd => id_ex(75 downto 71),
            if_id_Rs1 => if_id(83 downto 79),
            if_id_Rs2 => if_id(88 downto 84),
            ex_mem_MemRW => c_ex_mem(9),
            PCWEn => PCWEn
        );

end arch;