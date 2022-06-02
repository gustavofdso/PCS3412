-------------------------------------------------------------------------------
--
-- Title       : FD
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Contém a entidade do Fluxo de Dados e seus componentes.
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
        -- Clock and Reset input signal
        clk:    in std_logic;
        rst:    in std_logic;

        -- Clock enable for PC and IR
        ce_pc:  in std_logic;
        ce_ri:  in std_logic;

        -- Branch Control signal
        Brch:   in std_logic_vector(1 downto 0);

        -- ALU Control signals
        ALUSrc: in std_logic;
        ALUOpe: in std_logic_vector(3 downto 0);
    ) ;
end FD;

architecture arch of FD is

    signal 

begin

end arch;