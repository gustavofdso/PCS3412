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

    -- Buffer signals
    signal if_id:       std_logic_vector(255 downto 0);
    signal id_ex:       std_logic_vector(255 downto 0);
    signal ex_mem:      std_logic_vector(255 downto 0);
    signal mem_wb:      std_logic_vector(255 downto 0);

    signal c_if_id:     std_logic_vector(13 downto 0);
    signal c_id_ex:     std_logic_vector(13 downto 0);
    signal c_ex_mem:    std_logic_vector(13 downto 0);
    signal c_mem_wb:    std_logic_vector(13 downto 0);
	 
begin

    MULTIPLEXER_1: entity work.Mux2
        port map (
            I0 => ex_mem(31 downto 0),
            I1 => ex_mem(95 downto 64),
            Sel => c_ex_mem(1),
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

    opcode <= dout_i(6 downto 0);
    funct3 <= dout_i(14 downto 12);
    funct7 <= dout_i(31 downto 25);

    REGISTER_FILE: entity work.RegFile
        port map (
            clk => clk,
            we => c_if_id(4),
            din => mux_4,
            addrin => mem_wb(75 downto 71),
            addra => if_id(83 downto 79),
            addrb => if_id(88 downto 84),
            douta => dout_r_a,
            doutb => dout_r_b
        );

    IMMED_GENERATOR: entity work.ImmediateGenerator
        port map (
            ri => if_id(95 downto 64),
            ImmSel => c_if_id(3 downto 2),
            immed => immed
        );

    BRANCH_COMP: entity work.Comparator
        port map (
            A => id_ex(127 downto 96),
            B => id_ex(159 downto 128),
            eq => BrEq,
            lt => BrLt,
            gt => open,
            le => open,
            ge => open
        );

    MULTIPLEXER_2: entity work.Mux2
        port map (
            I0 => id_ex(127 downto 96),
            I1 => id_ex(63 downto 32),
            Sel => c_id_ex(5),
            O => mux_2
        );
        
    MULTIPLEXER_3: entity work.Mux2
        port map (
            I0 => id_ex(159 downto 128),
            I1 => id_ex(191 downto 160),
            Sel => c_id_ex(6),
            O => mux_3
        );

    MULTIFUNCIONAL_ALU: entity work.ALU
        port map (
            cin => '0',
            A => mux_2,
            B => mux_3,
            ALUOpe => c_id_ex(10 downto 7),
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
            rw => c_ex_mem(11),
            ender => ex_mem(223 downto 192),
            pronto => open,
            dado_in => ex_mem(191 downto 160),
            dado_out => dout_d
        );

    MULTIPLEXER_4: entity work.Mux4
        port map (
            I0 => mem_wb(255 downto 224),
            I1 => mem_wb(223 downto 192),
            I2 => mem_wb(63 downto 32),
            I3 => (others => '0'),
            Sel => c_mem_wb(13 downto 12),
            O => mux_4
        );

    -- [0]          ce_pc
    -- [1]          PCsel
    -- [3:2]        ImmSel
    -- [4]          RegWEn
    -- [5]          ASEl
    -- [6]          BSEl
    -- [10:7]       ALUSEl
    -- [11]         MemRW
    -- [13:12]      WBSel

    CONTROL_IF_ID: entity work.Reg
        generic map (
            BitCount => 14
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din(0) => ce_pc,
            din(1) => PCsel,
            din(3 downto 2) => ImmSel,
            din(4) => RegWEn,
            din(5) => ASEl,
            din(6) => BSEl,
            din(10 downto 7) => ALUSEl,
            din(11) => MemRW,
            din(13 downto 12) => WBSel,
            dout => c_if_id
        );

    CONTROL_ID_EX: entity work.Reg
        generic map (
            BitCount => 14
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din => c_if_id,
            dout => c_id_ex
        );

    CONTROL_EX_MEM: entity work.Reg
        generic map (
            BitCount => 14
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din => c_id_ex,
            dout => c_ex_mem
        );

    CONTROL_MEM_WB: entity work.Reg
        generic map (
            BitCount => 14
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
            ce => '1',
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

end architecture_fd;