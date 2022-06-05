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
        Brch:           in std_logic_vector(1 downto 0);

        -- Data Memory Control signals
        menable:        in std_logic;
        rw:             in std_logic;

        -- Register File Control signals
        MemtoReg:       in std_logic;
        RegWrite:       in std_logic;
        RegDest:        in std_logic;

        -- ALU Control signals
        ALUSrc:         in std_logic;
        ALUOpe:         in std_logic_vector(3 downto 0);

        -- Operation code
        Cop:            out std_logic_vector(5 downto 0);
        CopExt:         out std_logic_vector(5 downto 0);

        -- Zero indication for ALU
        Zero:           out std_logic
    ) ;
end FD;

architecture architecture_fd of FD is
    -- Program Counter signals
    signal pc:          std_logic_vector(31 downto 0);

    -- Instruction Resgister signals
    signal ri:          std_logic_vector(31 downto 0);
    signal rs:          std_logic_vector(4 downto 0);
    signal rt:          std_logic_vector(4 downto 0);
    signal rd:          std_logic_vector(4 downto 0);
    signal immed:       std_logic_vector(11 downto 0);
    signal jump:        std_logic_vector(19 downto 0);
    
    -- Branch signals
    signal mux_1:       std_logic_vector(31 downto 0);
    signal add_1:       std_logic_vector(31 downto 0);
    signal add_2:       std_logic_vector(31 downto 0);
    signal sext_1:      std_logic_vector(31 downto 0);
    signal sl2_1:       std_logic_vector(31 downto 0);
    signal sext_2:      std_logic_vector(31 downto 0);
    signal sl2_2:       std_logic_vector(31 downto 0);

    -- Instruction Memory signals
    signal dout_i:      std_logic_vector(31 downto 0);

    -- Data Memory signals
    signal dout_d:      std_logic_vector(31 downto 0);

    -- Register File signals
    signal mux_2:       std_logic_vector(31 downto 0);
    signal mux_3:       std_logic_vector(31 downto 0);
    signal dout_r_1:    std_logic_vector(31 downto 0);
    signal dout_r_2:    std_logic_vector(31 downto 0);

    -- ALU signals
    signal mux_4:       std_logic_vector(31 downto 0);
    signal alu:         std_logic_vector(31 downto 0);

begin
    -- PC
    PROGRAM_COUNTER: entity work.Reg_ClkEnable
        generic map (
            NumeroBits => 32,
            Tprop => 1 ns,
            Tsetup => 0.25 ns
        )
        port map (
            C => clk,
            CE => ce_pc,
            R => rst,
            S => '0',
            D => mux_1,
            Q => pc
        );

    -- IR
    INSTRUCTION_REGISTER: entity work.Reg_ClkEnable
        generic map (
            NumeroBits => 32,
            Tprop => 1 ns,
            Tsetup => 0.25 ns
        )
        port map (
            C => clk,
            CE => ce_ri,
            R => rst,
            S => '0',
            D => dout_i,
            Q => ri
        );

    -- Branch
    ADDER_1: entity work.Somador
        generic map (
            NumeroBits => 32,
            Tsoma => 1 ns
        )
        port map (
            S => '1',
            Vum => '0',
            A  => pc,
            B  => x"0100",
            C => add_1
        );
        
    ADDER_2: entity work.Somador
        generic map (
            NumeroBits => 32,
            Tsoma => 1 ns
        )
        port map (
            S => '1',
            Vum => '0',
            A  => add_1,
            B  => sl2_2,
            C => add_2
        );

    SIGN_EXTEND_1: entity work.xsign
        generic map (
            NBE => 20,
            NBS => 32
        )
        port map (
            I => jump,
            O => sext_1
        );

    SHIFT_LEFT_2_1: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2,
            Tprop => 0 ns
        )
        port map (
            DE => '1',
            I => sext_1,
            O => sl2_1
        );

    SIGN_EXTEND_2: entity work.xsign
        generic map (
            NBE => 12,
            NBS => 32
        )
        port map (
            I => immed,
            O => sext_2
        );

    SHIFT_LEFT_2_2: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2,
            Tprop => 0 ns
        )
        port map (
            DE => '1',
            I => sext_2,
            O => sl2_2
        );

    MULTIPLEXER_1: entity work.Mux4x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => add_1,
            I1 => sl2_1,
            I2 => add_2,
            I3 => (others => '0'),
            Sel => Brch,
            O => mux_1
        );

    -- Instruction Memory
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

    -- Data Memory
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
            ender => dout_r_2,
            pronto => open,
            dado => dout_d
        );

    -- Register File
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
            I1 => rt,
            Sel => RegDest,
            O => mux_3
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
            din => mux_2,
            addrin => mux_3,
            addra => rs,
            addrb => rt,
            douta => dout_r_1,
            doutb => dout_r_2
        );

    -- ALU
    MULTIPLEXER_4: entity work.Mux2x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => sext_2,
            I1 => dout_r_2,
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
            A => dout_r_1,
            B => mux_4,
            cUla => ALUOpe(2 downto 0),
            Sinal => open,
            Vaum => open,
            Zero => Zero,
            C => alu
        );

    rs <= ri(19 downto 15);
    rt <= ri(24 downto 20);
    rd <= ri(11 downto 7);
    
    immed <= ri(31 downto 20);
    jump <= ri(31 downto 12);

    Cop <= ri(5 downto 0);
    CopExt <= ri(5 downto 0);

end architecture_fd;