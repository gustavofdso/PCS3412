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
    signal rs:          std_logic_vector(5 downto 0);
    signal rt:          std_logic_vector(5 downto 0);
    signal rd:          std_logic_vector(5 downto 0);
    
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
    program_counter: entity.work.resistrador
        generic map(
            NumeroBits => 32
        )
        port map(
            C => clk,
            R => rst,
            S => ce_pc,
            D => mux_1,
            Q => pc
        );

    -- IR
    instruction_register: entity.work. port map (
        generic map(
            NumeroBits => 32
        )
        port map(
            C => clk,
            R => rst,
            S => ce_ri,
            D => dout_i,
            Q => ri
        );
        
    -- Branch
    adder_1: entity.work. port map (
        
    );

    adder_2: entity.work. port map (
        
    );

    shift_left_1: entity.work. port map (
        
    );

    sign_extend: entity.work. port map (
        
    );

    shift_left_2: entity.work. port map (
        
    );

    multiplexer_1: entity.work. port map (
        
    );

    -- Instruction Memory
    instruction_memory: entity.work. port map (
        
    );

    -- Data Memory
    data_memory: entity.work. port map (
        
    );

    -- Register Bank
    multiplexer_2: entity.work. port map (
        
    );
        
    multiplexer_3: entity.work. port map (
        
    );

    register_bank: entity.work. port map (
        
    );

    -- ALU
    multiplexer_4: entity.work. port map (
        
    );

    ALU: entity.work. port map (
        
    );

end arch;