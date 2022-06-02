-------------------------------------------------------------------------------
--
-- Title       : FD
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Dataflow entity with its components.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

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

        -- Register Bank Control signals
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

architecture arch of FD is
    -- PC signals
    signal pc:          std_logic_vector(31 downto 0);

    -- IR signals
    signal ri:          std_logic_vector(31 downto 0);
    
    -- Branch signals
    signal mux_1:       std_logic_vector(31 downto 0);
    signal add_1:       std_logic_vector(31 downto 0);
    signal add_2:       std_logic_vector(31 downto 0);
    signal sl_1:        std_logic_vector(31 downto 0);
    signal sext:        std_logic_vector(31 downto 0);
    signal sl_2:        std_logic_vector(31 downto 0);

    -- Instruction Memory signals
    signal dout_i:      std_logic_vector(31 downto 0);

    -- Data Memory signals
    signal dout_d:      std_logic_vector(31 downto 0);

    -- Register Bank signals
    signal mux_2:       std_logic_vector(31 downto 0);
    signal mux_3:       std_logic_vector(31 downto 0);
    signal dout_r:      std_logic_vector(31 downto 0);

    -- ALU signals
    signal mux_4:       std_logic_vector(31 downto 0);
    signal alu:         std_logic_vector(31 downto 0);

begin
    -- PC
    program_counter: entity work.Reg_ClkEnable
        generic map (
            NumeroBits => 32
        )
        port map (
            C => clk,
            CE => ce_pc,
            R => rst,
            S => '1',
            D => mux_1,
            Q => pc
        );

    -- IR
    instruction_register: entity work.Reg_ClkEnable
        generic map (
            NumeroBits => 32
        )
        port map (
            C => clk,
            CE => ce_ri,
            R => rst,
            S => '1',
            D => dout_i,
            Q => ri
        );

    -- Branch
    adder_1: entity work.Somador
        generic map (
            NumeroBits => 32
        )
        port map (
            S => '1',
            Vum => '0',
            A  => pc,
            B  => "0100",
            C => add_1
        );
        
    adder_2: entity work.Somador
        generic map (
            NumeroBits => 32
        )
        port map (
            S => '0',
            Vum => '0',
            A  => add_1,
            B  => sext,
            C => add_2
        );

    shift_left_1: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2
        )
        port map (
            DE => '1',
            I => ri,
            O => sl_1
        );

    sign_extend: entity work.xsign
        generic map (
            NBE => 12,
            NBS => 32
        )
        port map (
            I => ri(31 downto 20),
            O => sext
        );

    shift_left_2: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2
        )
        port map (
            DE => '1',
            I => sext,
            O => sl_2
        );

    multiplexer_1: entity work.Mux4x1
        generic map (
            NB => 32
        )
        port map (
            I0 => add_1,
            I1 => sl_1,
            I2 => add_2,
            I3 => (others => '0'),
            Sel => Brch,
            O => mux_1
        );

    -- Instruction Memory
    instruction_memory: entity work.

    -- Data Memory
    data_memory: entity work.

    -- Register Bank
    multiplexer_2: entity work.Mux2x1
        generic map (
            NB => 32
        )
        port map (
            I0 => dout_d,
            I1 => alu,
            Sel => MemtoReg,
            O => mux_2
        );
        
    multiplexer_3: entity work.Mux2x1
        generic map (
            NB => 32
        )
        port map (
            I0 => ri(11 downto 7),
            I1 => ri(19 downto 15),
            Sel => RegDest,
            O => mux_3
        );

    register_bank: entity work.

    -- ALU
    multiplexer_4: entity work.Mux2x1
        generic map (
            NB => 32
        )
        port map (
            I0 => sext,
            I1 => ri(19 downto 15),
            Sel => ALUSrc,
            O => mux_4
        );

    ALU: entity work.ULA
        generic map (
            NB => 32
        )
        port map (
            Veum => '0',
            A => mux_4,
            B => ,
            cUla => ALUOpe,
            Sinal => open,
            Vaum => open,
            Zero => Zero,
            C => open
        );

    
end arch;