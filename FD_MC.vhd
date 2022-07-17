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

entity FD_MC is
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
		  
    );
end FD_MC;

architecture arch of FD_MC is
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
	 
begin

    MULTIPLEXER_PC: entity work.Mux2
        port map (
            I0 => add,
            I1 => alu,
            Sel => PCSel,
            O => mux_pc
        );

    PROGRAM_COUNTER: entity work.Reg
        port map (
            clk => clk,
            ce => '1',
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

    opcode <= dout_i(6 downto 0);
    funct3 <= dout_i(14 downto 12);
    funct7 <= dout_i(31 downto 25);

    REGISTER_FILE: entity work.RegFile
        port map (
            clk => clk,
            we => RegWEn,
            din => mux_wb,
            addrin => dout_i(11 downto 7),
            addra => dout_i(19 downto 15),
            addrb => dout_i(24 downto 20),
            douta => dout_r_a,
            doutb => dout_r_b
        );

    IMMEDIATE_GENERATOR: entity work.ImmediateGenerator
        port map (
            ri => dout_i,
            ImmSel => ImmSel,
            immed => immed
        );

    BRANCH_COMPARATOR: entity work.Comparator
        port map (
            A => dout_r_a,
            B => dout_r_b,
            eq => BrEq,
            lt => BrLt,
            gt => open,
            le => open,
            ge => open
        );

    MULTIPLEXER_A: entity work.Mux2
        port map (
            I0 => dout_r_a,
            I1 => pc,
            Sel => ASel,
            O => mux_a
        );
        
    MULTIPLEXER_B: entity work.Mux2
        port map (
            I0 => dout_r_b,
            I1 => immed,
            Sel => BSel,
            O => mux_b
        );

    MULTIFUNCIONAL_ALU: entity work.ALU
        port map (
            cin => '0',
            A => mux_a,
            B => mux_b,
            ALUOpe => ALUSel,
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
            rw => MemRW,
            ender => alu,
            pronto => open,
            dado_in => dout_r_b,
            dado_out => dout_d
        );

    MULTIPLEXER_WB: entity work.Mux4
        port map (
            I0 => dout_d,
            I1 => alu,
            I2 => add,
            I3 => (others => '0'),
            Sel => WBSel,
            O => mux_wb
        );
	 
end arch;