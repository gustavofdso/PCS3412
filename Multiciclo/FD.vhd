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
    -- Program Counter signals
    signal pc:          std_logic_vector(31 downto 0);

    -- Instruction Resgister signals
    signal ri:          std_logic_vector(31 downto 0);
    
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

    -- Register Bank signals
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
            NumeroBits => 32
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
            NumeroBits => 32
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
            NumeroBits => 32
        )
        port map (
            S => '1',
            Vum => '0',
            A  => pc,
            B  => 4,
            C => add_1
        );
        
    ADDER_2: entity work.Somador
        generic map (
            NumeroBits => 32
        )
        port map (
            S => '1',
            Vum => '0',
            A  => add_1,
            B  => sl2_2,
            C => add_2
        );

    SHIFT_LEFT_2_1: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2
        )
        port map (
            DE => '1',
            I => ri,
            O => sl2_1
        );

    -- TODO: CONFIRMAR ESSE
    SIGN_EXTEND: entity work.xsign
        generic map (
            NBE => 20,
            NBS => 32
        )
        port map (
            I => ri(31 downto 12),
            O => sext
        );

    SHIFT_LEFT_2_2: entity work.deslocador_combinatorio
        generic map (
            NB => 32,
            NBD => 2
        )
        port map (
            DE => '1',
            I => sext,
            O => sl2_2
        );

    MULTIPLEXER_1: entity work.Mux4x1
        generic map (
            NB => 32
        )
        port map (
            I0 => add_1,
            I1 => sl2_1,
            I2 => add_2,
            I3 => (others => '0'),
            Sel => Brch,
            O => mux_1
        );

    -- TODO: FAZER O INSTRUCTION MEMORY
    -- Instruction Memory
    INSTRUCTION_MEMORY: entity work.

    -- TODO: FAZER O DATA MEMORY
    -- Data Memory
    DATA_MEMORY: entity work.

    -- Register Bank
    MULTIPLEXER_2: entity work.Mux2x1
        generic map (
            NB => 32
        )
        port map (
            I0 => dout_d,
            I1 => alu,
            Sel => MemtoReg,
            O => mux_2
        );
        
    MULTIPLEXER_3: entity work.Mux2x1
        generic map (
            NB => 32
        )
        port map (
            I0 => ri(11 downto 7),
            I1 => ri(19 downto 15),
            Sel => RegDest,
            O => mux_3
        );

    -- TODO: FAZER O REGISTER FILE
    REGISTER_BANK: entity work.

    -- ALU
    MULTIPLEXER_4: entity work.Mux2x1
        generic map (
            NB => 32
        )
        port map (
            I0 => sext,
            I1 => dout_r_2,
            Sel => ALUSrc,
            O => mux_4
        );

    ALU: entity work.ULA
        generic(
            NB => 32
        );
        port(
            Veum => '0',
            A => dout_r_1,
            B => mux_4,
            cUla => ALUOpe(2 downto 0);
            Sinal => open,
            Vaum => open,
            Zero => Zero,
            C => alu
        );

    Cop <= ri(5 downto 0);

end arch;