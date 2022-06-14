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

        PCsel:          in std_logic;

        ImmSel:         in std_logic_vector(1 downto 0);

        RegWEn:         in std_logic;

        BrUn:           in std_logic;
        BrEq:           out std_logic;
        BrLt:           out std_logic;

        ASEl:           in std_logic;
        BSEl:           in std_logic;

        ALUSEl:         in std_logic_vector(1 downto 0);

        menable:        in std_logic;
        MemRW:          in std_logic;

        WBSel:          in std_logic_vector(1 downto 0);
        
        opcode:         out std_logic_vector(6 downto 0);
        funct3:         out std_logic_vector(2 downto 0);
        funct7:         out std_logic_vector(6 downto 0)
    ) ;
end FD;

architecture architecture_fd of FD is
    -- Program Counter signals
    signal pc:          std_logic_vector(31 downto 0);

    -- Instruction signals
    signal immed:       std_logic_vector(31 downto 0);
    
    -- Branch signals
    signal mux_1:       std_logic_vector(31 downto 0);
    signal add:         std_logic_vector(31 downto 0);

    -- Instruction Memory signals
    signal dout_i:      std_logic_vector(31 downto 0);

    -- Data Memory signals
    signal dout_d:      std_logic_vector(31 downto 0);

    -- Register File signals
    signal mux_2:       std_logic_vector(31 downto 0);
    signal mux_3:       std_logic_vector(31 downto 0);
    signal dout_r_a:    std_logic_vector(31 downto 0);
    signal dout_r_b:    std_logic_vector(31 downto 0);

    -- ALU signals
    signal mux_4:       std_logic_vector(31 downto 0);
    signal alu:         std_logic_vector(31 downto 0);

begin
    MULTIPLEXER_1: entity work.Mux2
        generic map (
            NB => 32,
            Tsel => 0.5 ns
        )
        port map (
            I0 => add,
            I1 => alu,
            Sel => PCSel,
            O => mux_1
        );

    PROGRAM_COUNTER: entity work.Reg
        generic map (
            NumeroBits => 32,
            Tprop => 1 ns,
            Tsetup => 0.25 ns
        )
        port map (
            clk => clk,
            ce => ce_pc,
            rst => rst,
            din => mux_1,
            dout => pc
        );

    ADD4: entity work.Adder
        generic map (
            NumeroBits => 32,
            Tsoma => 1 ns
        )
        port map (
            cin => '0',
            A => pc,
            B => B"0100",
            sum => add
        );

    INSTRUCTION_MEMORY: entity work.Ram
        generic map (
            BE => 32,
            BP => 32,
            NA => "instruction_memory.txt",
            Twrite => 5 ns,
            Tread => 5 ns
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => '0',
            ender => pc,
            pronto => open,
            dado => dout_i
        );

    REGISTER_FILE: entity work.RegisterFile
        generic map (
            NBend => 5,
            NBdado => 32,
            Tread => 5 ns,
            Twrite => 5 ns
        )
        port map (
            clk => clk,
            we => RegWEn,
            din => mux_4,
            addrin => dout_i(11 downto 7),
            addra => dout_i(19 downto 15),
            addrb => dout_i(24 downto 20),
            douta => dout_r_a,
            doutb => dout_r_b
        );

    IMMED_GENERATOR: entity work.ImmediateGenerator
        generic map (
            Tsel => 0.5 ns
        )
        port map (
            ri => dout_i,
            ImmSel => ImmSel,
            immed => immed
        );

    BRANCH_COMP: entity work.Comparator
        generic map (
            NumeroBits => 32,
            Tcomp => 1 ns
        )
        port map (
            A => dout_r_a,
            B => dout_r_b,
            eq => BrEq,
            lt => BrLt
        );

    MULTIPLEXER_2: entity work.Mux2
        generic map (
            NB => 32,
            Tsel => 0.5 ns
        )
        port map (
            I0 => dout_r_a,
            I1 => pc,
            Sel => ASel,
            O => mux_2
        );
        
    MULTIPLEXER_3: entity work.Mux2
        generic map (
            NB => 32,
            Tsel => 0.5 ns
        )
        port map (
            I0 => dout_r_b,
            I1 => immed,
            Sel => BSel,
            O => mux_3
        );

    MULTIFUNCIONAL_ALU: entity work.ULA
        generic map (
            NB => 32,
            Tsom => 1 ns,
            Tsub => 1.25 ns
        )
        port map (
            Veum => '0',
            A => mux_2,
            B => mux_3,
            cUla => ALUSel(2 downto 0),
            Sinal => open,
            Vaum => open,
            Zero => open,
            C => alu
        );

    DATA_MEMORY: entity work.Ram
        generic map (
            BE => 32,
            BP => 32,
            NA => "data_memory.txt",
            Twrite => 5 ns,
            Tread => 5 ns
        )
        port map (
            Clock => clk,
            enable => menable,
            rw => MemRW,
            ender => dout_r_b,
            pronto => open,
            dado => dout_d
        );

    MULTIPLEXER_4: entity work.Mux4
        generic map (
            NB => 32,
            Tsel => 0.5 ns
        )
        port map (
            I0 => dout_d,
            I1 => alu,
            I2 => add,
            I3 => (others => '0'),
            Sel => WBSel,
            O => mux_4
        );    

    opcode <= dout_i(6 downto 0);
    funct3 <= dout_i(14 downto 12);
    funct7 <= dout_i(31 downto 25);

end architecture_fd;