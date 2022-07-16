-------------------------------------------------------------------------------
--
-- Title       : UC_MC
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Control unity entity.
--
-------------------------------------------------------------------------------
entity UC_MC is
    port (
        -- Global Clock and Reset signals
        clk:            in std_logic;
        rst:            in std_logic;

        -- Selecting the new adress for PC
        PCsel:          out std_logic;

        -- Selecting the immediate based on instruction type
        ImmSel:         out std_logic_vector(1 downto 0);

        -- Write enable for the Register File
        RegWEn:         out std_logic;

        -- Branch comparisons
        BrEq:           in std_logic;
        BrLt:           in std_logic;

        -- Selecting ALU inputs
        ASEl:           out std_logic;
        BSEl:           out std_logic;

        -- Selecting ALU operation
        ALUSEl:         out std_logic_vector(3 downto 0);

        -- Enable and R/W signal for Data Memory
        MemRW:          out std_logic;

        -- Selecting Write-back data
        WBSel:          out std_logic_vector(1 downto 0);
        
        -- Instruction fields for control
        opcode:         in std_logic_vector(6 downto 0);
        funct3:         in std_logic_vector(2 downto 0);
        funct7:         in std_logic_vector(6 downto 0)
		  
    );
end UC_MC;

architecture arch of UC_MC is

    -- RE signals
    signal re:          std_logic_vector(5 downto 0);

    -- PROM signals
    signal adress:      std_logic_vector(23 downto 0);
    signal prom:        std_logic_vector(18 downto 0);
    signal link:        std_logic_vector(5 downto 0);
    signal saidas:      std_logic_vector(12 downto 0);

begin

    RE: entity work.Reg
        generic map (
            BitCount => 6
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din => link,
            dout => re
        );

    adress(5 downto 0) <= re;
    adress(11 downto 6) <= funct7;
    adress(14 downto 12) <= funct3;
    adress(21 downto 15) <= opcode;
    adress(22) <= BrLt;
    adress(23) <= BrEq;

    CONTROL_MEMORY: entity work.Ram
        generic map (
            BE => 24,
		    BP => 28,
            NA => "uc_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => '0',
            ender => adress,
            pronto => open,
            dado_in => (others => '0'),
            dado_out => prom
        );

    link <= prom(18 downto 13);
    saida <= prom(12 downto 0);

end arch;