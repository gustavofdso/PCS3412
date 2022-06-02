-------------------------------------------------------------------------------
--
-- Title       : FD
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Contains the details of the Data Flow entity and its components.
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
        clk:        in std_logic;
        rst:        in std_logic;

        -- Clock enable for PC and IR
        ce_pc:      in std_logic;
        ce_ri:      in std_logic;

        -- Branch Control signal
        Brch:       in std_logic_vector(1 downto 0);

        -- Data Memory Control signals
        menable:    in std_logic;
        rw:         in std_logic;

        -- Register Bank Control signals
        MemtoReg:   in std_logic;
        RegWrite:   in std_logic;
        RegDest:    in std_logic;

        -- ALU Control signals
        ALUSrc:     in std_logic;
        ALUOpe:     in std_logic_vector(3 downto 0);

        -- Operation code
        Cop:        out std_logic_vector(5 downto 0);
        CopExt:     out std_logic_vector(5 downto 0);

        -- Zero indication for ALU
        Zero:       out std_logic;
    ) ;
end FD;

architecture arch of FD is

    signal 

begin

end arch;