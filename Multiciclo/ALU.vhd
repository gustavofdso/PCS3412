-------------------------------------------------------------------------------
--
-- Title       : ALU
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of a Multifuncional ALU.
--      ALUOpes:
--          AND     0000
--          OR      0001
--          ADD     0010
--          SUB     0011
--          SLT     0100
--          ADDU    0101
--          SLL     0110
--          
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    generic (
        NB:         integer := 32;
        Tsom:       in time := 2 ns;
        Tsub:       in time := 2.5 ns;
        Tgate:      in time := 1 ns
    );
    port (
        A:          in  std_logic_vector(NB - 1 downto 0);
        B:          in  std_logic_vector(NB - 1 downto 0);
        ALUOpe:     in  std_logic_vector(3 downto 0);

        result:     out std_logic_vector(NB - 1 downto 0);
        zero:       out std_logic
    );
end ALU;

architecture arch of ALU is

    signal temp:    std_logic_vector(NB - 1 downto 0);

begin
    result <= 
        std_logic_vector(signed(A)   + signed(B))                           after Tsom  when ALUOpe = "0010"            else
        std_logic_vector(unsigned(A) + unsigned(B))                         after Tsub  when ALUOpe = "0101"            else
        std_logic_vector(signed(A)   - signed(B))                           after Tsub  when ALUOpe = "0011"            else
        A and B                                                             after Tgate when ALUOpe = "0000"            else
        A or  B                                                             after Tgate when ALUOpe = "0001"            else
        std_logic_vector(shift_left(signed(B), to_integer(unsigned(A))))    after Tgate when ALUOpe = "0110"            else
        x"00000001"                                                         after Tsom  when ALUOpe = "0100" and A < B  else
        x"00000000"                                                         after Tsom  when ALUOpe = "0100";

    zero <= '1' after Tsom when temp = x"00000000" else '0' after Tsom;

    result <= temp;
end arch;