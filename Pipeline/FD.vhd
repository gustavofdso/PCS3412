-------------------------------------------------------------------------------
--
-- Title       : FD
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
    signal sl2_1:       std_logic_vector(31 downto 0);
    signal sext:        std_logic_vector(31 downto 0);
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
    signal aluzero:     std_logic;

    -- Buffers
    signal b1_1:        std_logic_vector(31 downto 0);
    signal b1_2:        std_logic_vector(31 downto 0);

    signal b2_1:        std_logic_vector(31 downto 0);
    signal b2_2:        std_logic_vector(31 downto 0);
    signal b2_3:        std_logic_vector(31 downto 0);
    signal b2_4:        std_logic_vector(31 downto 0);

    signal b3_1:        std_logic_vector(31 downto 0);
    signal b3_2:        std_logic;
    signal b3_3:        std_logic_vector(31 downto 0);
    signal b3_4:        std_logic_vector(31 downto 0);

    signal b4_1:        std_logic_vector(31 downto 0);
    signal b4_2:        std_logic_vector(31 downto 0);

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
            A  => b2_1,
            B  => sl2_2,
            C => add_2
        );

    -- TODO: adicionar os primeiros bits do PC antes do jump adress, como entrada desse SL2
    SHIFT_LEFT_2_1: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2,
            Tprop => 0 ns
        )
        port map (
            DE => '1',
            I => jump,
            O => sl2_1
        );

    SIGN_EXTEND: entity work.xsign
        generic map (
            NBE => 12,
            NBS => 32
        )
        port map (
            I => immed,
            O => sext
        );

    SHIFT_LEFT_2_2: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2,
            Tprop => 0 ns
        )
        port map (
            DE => '1',
            I => b2_4,
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
            I2 => b3_1,
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

    BUFFER_1_1: entity work.Reg_ClkEnable
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
            D => add_1,
            Q => b1_1
        );

    BUFFER_1_2: entity work.Reg_ClkEnable
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
            D => ri,
            Q => b1_2
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
            ender => b3_3,
            pronto => open,
            dado => dout_d
        );

    BUFFER_4_1: entity work.Reg_ClkEnable
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
            D => dout_d,
            Q => b4_1
        );

    BUFFER_4_2: entity work.Reg_ClkEnable
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
            D => b3_3,
            Q => b4_1
        );

    -- Register File
    MULTIPLEXER_2: entity work.Mux2x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => b4_2,
            I1 => b4_1,
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

    BUFFER_2_1: entity work.Reg_ClkEnable
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
            D => b1_1,
            Q => b2_1
        );

    BUFFER_2_2: entity work.Reg_ClkEnable
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
            D => dout_r_1,
            Q => b2_2
        );

    BUFFER_2_3: entity work.Reg_ClkEnable
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
            D => dout_r_2,
            Q => b2_3
        );

    BUFFER_2_4: entity work.Reg_ClkEnable
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
            D => sext,
            Q => b2_4
        );

    -- ALU
    MULTIPLEXER_4: entity work.Mux2x1
        generic map (
            NB => 32,
            Tsel => 0.5 ns,
            Tdata => 0.25 ns
        )
        port map (
            I0 => b2_3,
            I1 => b2_4,
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
            A => b2_1,
            B => mux_4,
            cUla => ALUOpe(2 downto 0),
            Sinal => open,
            Vaum => open,
            Zero => aluzero,
            C => alu
        );

    BUFFER_3_1: entity work.Reg_ClkEnable
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
            D => add_2,
            Q => b3_1
        );

    BUFFER_3_2: entity work.Reg_ClkEnable
        generic map (
            NumeroBits => 1,
            Tprop => 1 ns,
            Tsetup => 0.25 ns
        )
        port map (
            C => clk,
            CE => ce_ri,
            R => rst,
            S => '0',
            D(0) => aluzero,
            Q(0) => b3_2
        );

    BUFFER_3_3: entity work.Reg_ClkEnable
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
            D => alu,
            Q => b3_3
        );

    -- TODO: adicionar esse
    BUFFER_3_4: entity work.Reg_ClkEnable
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
            D => b2_3,
            Q => b3_4
        );

    Zero <= aluzero;

    rs <= b1_1(19 downto 15);
    rt <= b1_1(24 downto 20);
    rd <= b1_1(11 downto 7);
    
    immed <= b1_1(31 downto 20);
    jump <= ri(31 downto 12);

    Cop <= ri(5 downto 0);
    CopExt <= ri(5 downto 0);

end architecture_fd;