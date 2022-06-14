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

        -- Clock enable for PC and IR
        ce_pc:          in std_logic;
        ce_ri:          in std_logic;

        -- Branch Control signal
        brch:           in std_logic;

        -- Data Memory Control signals
        menable:        in std_logic;
        rw:             in std_logic;

        -- Register File Control signals
        MemtoReg:       in std_logic;
        RegWrite:       in std_logic;
        RegDest:        in std_logic;

        -- ALU Control signals
        ALUSrc:         in std_logic_vector(1 downto 0);
        ALUOpe:         in std_logic_vector(3 downto 0);
        ImmSel:         in std_logic_vector(1 downto 0);

        -- Operation code
        opcode:         out std_logic_vector(6 downto 0);
        funct3:         out std_logic_vector(2 downto 0);
        funct7:         out std_logic_vector(6 downto 0);

        -- Zero indication for ALU
        Zero:           out std_logic
    ) ;
end FD;

architecture architecture_fd of FD is
    -- Program Counter signals
    signal pc:          std_logic_vector(31 downto 0);

    -- Instruction Resgister signals
    signal ri:          std_logic_vector(31 downto 0);
    signal rs1:         std_logic_vector(4 downto 0);
    signal rs2:         std_logic_vector(4 downto 0);
    signal rd:          std_logic_vector(4 downto 0);

    signal immed:       std_logic_vector(32 downto 0);
    
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
    MULTIPLEXER_1: entity work.Mux2x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => add,
            I1 => alu,
            Sel => brch,
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

    INSTRUCTION_REGISTER: entity work.Reg
        generic map (
            NumeroBits => 32,
            Tprop => 1 ns,
            Tsetup => 0.25 ns
        )
        port map (
            clk => clk,
            ce => ce_ri,
            rst => rst,
            din => dout_i,
            dout => ri
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
            we => RegWrite,
            din => ,
            addrin => rd,
            addra => rs1,
            addrb => rs2,
            douta => dout_r_a,
            doutb => dout_r_b
        );

    IMMED_GENERATOR: entity work.ImmediateGenerator
        generic map (
            Tsel => 0.5 ns
        )
        port map (
            ri => ri,
            ImmedSel => ImmedSel,
            immed => immed
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
            rw => rw,
            ender => dout_r_b,
            pronto => open,
            dado => dout_d
        );

    MULTIPLEXER_2: entity work.Mux2x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => alu,
            I1 => dout_d,
            Sel => MemtoReg,
            O => mux_2
        );
        
    MULTIPLEXER_3: entity work.Mux2x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => rd,
            I1 => rs2,
            Sel => RegDest,
            O => mux_3
        );

    MULTIPLEXER_4: entity work.Mux4x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => sext,
            I1 => add,
            I2 => dout_r_b,
            I3 => (others => '0'),
            Sel => ALUSrc,
            O => mux_4
        );

    MULTIFUNCIONAL_ALU: entity work.ULA
        generic map (
            NB => 32,
            Tsom => 1 ns,
            Tsub => 1.25 ns
        )
        port map (
            Veum => '0',
            A => dout_r_a,
            B => mux_4,
            cUla => ALUOpe(2 downto 0),
            Sinal => open,
            Vaum => open,
            Zero => Zero,
            C => alu
        );

    rs1 <= ri(19 downto 15);
    rs2 <= ri(24 downto 20);
    rd <= ri(11 downto 7);

    opcode <= ri(6 downto 0);
    funct3 <= ri(14 downto 12);
    funct7 <= ri(31 downto 25);

end architecture_fd;