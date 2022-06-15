-------------------------------------------------------------------------------
--
-- Title       : FD
-- Design      : T-FIVE-MC
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

entity FD is
    port (
        -- Global Clock and Reset signals
        clk:            in std_logic;
        rst:            in std_logic;

        -- Clock enable for PC
        ce_pc:          in std_logic;

        -- Selecting the new adress for PC
        PCsel:          in std_logic;

        -- Selecting the immediate based on instruction type
        ImmSel:         in std_logic_vector(1 downto 0);

        -- Write enable for the Register File
        RegWEn:         in std_logic;

        -- Branch comparisons
        BrEq:           out std_logic;
        BrLt:           out std_logic;

        -- Selecting ALU inputs
        ASEl:           in std_logic;
        BSEl:           in std_logic;

        -- Selecting ALU operation
        ALUSEl:         in std_logic_vector(3 downto 0);

        -- Enable and R/W signal for Data Memory
        MemRW:          in std_logic;

        -- Selecting Write-back data
        WBSel:          in std_logic_vector(1 downto 0);
        
        -- Instruction fields for control
        opcode:         out std_logic_vector(6 downto 0);
        funct3:         out std_logic_vector(2 downto 0);
        funct7:         out std_logic_vector(6 downto 0)
    ) ;
end FD;

architecture architecture_fd of FD is
    -- PC signals
    signal mux_1:       std_logic_vector(31 downto 0);
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
    signal mux_2:       std_logic_vector(31 downto 0);
    signal mux_3:       std_logic_vector(31 downto 0);
    signal alu:         std_logic_vector(31 downto 0);

    -- Data Memory signals
    signal dout_d:      std_logic_vector(31 downto 0);
    signal mux_4:       std_logic_vector(31 downto 0);

    -- PC Buffers
    signal pc_if_de:            std_logic_vector(31 downto 0);
    signal pc_de_ex:            std_logic_vector(31 downto 0);

    -- ADD4 Buffers
    signal add_if_de:           std_logic_vector(31 downto 0);
    signal add_de_ex:           std_logic_vector(31 downto 0);
    signal add_ex_mem:          std_logic_vector(31 downto 0);
    signal add_mem_wb:          std_logic_vector(31 downto 0);
    
    -- Instruction Memory Buffers
    signal dout_i_if_de:        std_logic_vector(31 downto 0);
    signal rd_de_ex:            std_logic_vector(31 downto 0);
    signal rd_ex_mem:           std_logic_vector(31 downto 0);
    signal rd_mem_wb:           std_logic_vector(31 downto 0);

    -- Register File Buffers
    signal dout_r_a_de_ex:      std_logic_vector(31 downto 0);
    signal dout_r_b_de_ex:      std_logic_vector(31 downto 0);
    signal dout_r_b_ex_mem:     std_logic_vector(31 downto 0);

    -- Immediate Buffers
    signal immed_de_ex:   std_logic_vector(31 downto 0);

    -- ALU Result Buffers
    signal alu_ex_mem:          std_logic_vector(31 downto 0);
    signal alu_mem_wb:          std_logic_vector(31 downto 0);
    
    -- Data Memory Buffers
    signal dout_d_mem_wb:   std_logic_vector(31 downto 0);

begin
    MULTIPLEXER_1: entity work.Mux2
        port map (
            I0 => add,
            I1 => alu,
            Sel => PCSel,
            O => mux_1
        );

    PROGRAM_COUNTER: entity work.Reg
        port map (
            clk => clk,
            ce => ce_pc,
            rst => rst,
            din => mux_1,
            dout => pc
        );

    ADD4: entity work.Adder
        port map (
            cin => '0',
            A => pc,
            B => B"0100",
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

    ADD4_IF_DE: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => add,
            dout => add_if_de
        );

    PROGRAM_COUNTER_IF_DE: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => pc,
            dout => pc_if_de
        );

    INSTRUCTION_MEMORY_IF_DE: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => dout_i,
            dout => dout_i_if_de
        );

    REGISTER_FILE: entity work.RegFile
        port map (
            clk => clk,
            we => RegWEn,
            din => mux_4,
            addrin => rd_mem_wb,
            addra => dout_i_if_de(19 downto 15),
            addrb => dout_i_if_de(24 downto 20),
            douta => dout_r_a,
            doutb => dout_r_b
        );

    IMMED_GENERATOR: entity work.ImmediateGenerator
        port map (
            ri => dout_i_if_de,
            ImmSel => ImmSel,
            immed => immed
        );

    ADD4_DE_EX: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => add_if_de,
            dout => add_de_ex
        );

    PROGRAM_COUNTER_DE_EX: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => pc_if_de,
            dout => pc_de_ex
        );

    DESTINY_REGISTER_DE_EX: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => dout_i_if_de(11 downto 7),
            dout => rd_de_ex
        );

    REGISTER_FILE_A_DE_EX: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => dout_r_a,
            dout => dout_r_a_de_ex
        );

    REGISTER_FILE_B_DE_EX: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => dout_r_b,
            dout => dout_r_b_de_ex
        );

    IMMED_GENERATOR_DE_EX: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => immed,
            dout => immed_de_ex
        );

    BRANCH_COMP: entity work.Comparator
        port map (
            A => dout_r_a_de_ex,
            B => dout_r_b_de_ex,
            eq => BrEq,
            lt => BrLt,
            gt => open,
            le => open,
            ge => open
        );

    MULTIPLEXER_2: entity work.Mux2
        port map (
            I0 => dout_r_a_de_ex,
            I1 => pc_de_ex,
            Sel => ASel,
            O => mux_2
        );
        
    MULTIPLEXER_3: entity work.Mux2
        port map (
            I0 => dout_r_b_de_ex,
            I1 => immed_de_ex,
            Sel => BSel,
            O => mux_3
        );

    MULTIFUNCIONAL_ALU: entity work.ALU
        port map (
            cin => '0',
            A => mux_2,
            B => mux_3,
            ALUOpe => ALUSel,
            cout => open,
            zero => open,
            negative => open,
            result => alu
        );

    ADD4_EX_MEM: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => add_de_ex,
            dout => add_ex_mem
        );

    DESTINY_REGISTER_EX_MEM: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => rd_de_ex,
            dout => rd_ex_mem
        );

    MULTIFUNCIONAL_ALU_EX_MEM: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => alu,
            dout => alu_ex_mem
        );

    REGISTER_FILE_B_EX_MEM: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => dout_r_b_de_ex,
            dout => dout_r_b_ex_mem
        );

    DATA_MEMORY: entity work.Ram
        generic map (
            NA => "data_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => MemRW,
            ender => alu_ex_mem,
            pronto => open,
            dado_in => dout_r_b_ex_mem,
            dado_out => dout_d
        ); 
    
    ADD4_MEM_WB: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => add_ex_mem,
            dout => add_mem_wb
        );

    DESTINY_REGISTER_MEM_WB: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => rd_ex_mem,
            dout => rd_mem_wb
        );

    MULTIFUNCIONAL_ALU_MEM_WB: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => alu_ex_mem,
            dout => alu_mem_wb
        );

    DATA_MEMORY_MEM_WB: entity work.Reg
        port map(
            clk => clk,
            ce => '1',
            rst => rst,
            din => dout_d,
            dout => dout_d_mem_wb
        );

    MULTIPLEXER_4: entity work.Mux4
        port map (
            I0 => dout_d_mem_wb,
            I1 => alu_mem_wb,
            I2 => add_mem_wb,
            I3 => (others => '0'),
            Sel => WBSel,
            O => mux_4
        );   

    opcode <= dout_i(6 downto 0);
    funct3 <= dout_i(14 downto 12);
    funct7 <= dout_i(31 downto 25);

end architecture_fd;