-------------------------------------------------------------------------------
--
-- Title       : UC_MC
-- Design      : T-FIVE-MC
-- Author      : Gustavo Oliveira
-- Company     : LARC-EPUSP
--
-------------------------------------------------------------------------------
--
-- Description : Implementation of the Control Unit entity.
--
-------------------------------------------------------------------------------
entity UC_MC is
    port (
        -- Global Clock and Reset signals
        clk:            in std_logic;
        rst:            in std_logic;

        -- Write enable for PC
        PCWEn:          out std_logic;

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
    signal sr:          std_logic_vector(5 downto 0);

    -- PROM signals
    signal prom:        std_logic_vector(34 downto 0);
    signal test:        std_logic_vector(6 downto 0);
    signal link_true:   std_logic_vector(5 downto 0);
    signal link_false:  std_logic_vector(5 downto 0);
    signal outputs:     std_logic_vector(18 downto 0);

    -- MUX signals
    signal mux_in:      std_logic;
    signal mux_sr:      std_logic_vector(5 downto 0);
    
begin

    STATE_REGISTER: entity work.Reg
        generic map (
            BitCount => 6
        )
        port map (
            clk => clk,
            ce => '1',
            rst => rst,
            din => mux_sr,
            dout => sr
        );

    CONTROL_MEMORY: entity work.Ram
        generic map (
            BE => 6,
		    BP => 35,
            NA => "uc_memory.txt"
        )
        port map (
            Clock => clk,
            enable => '1',
            rw => '0',
            ender => sr,
            pronto => open,
            dado_in => (others => '0'),
            dado_out => prom
        );

    outputs => prom(18 downto 0)
    link_false => prom(24 downto 19)
    link_true => prom(30 downto 25)
    test => prom(34 downto 31)

    MULTIPLEXER_IN: entity work.Mux16
        generic map (
            BitCount => 1
        )
        port map (
            I0 => ,
            I1 => ,
            I2 => ,
            I3 => ,
            I4 => ,
            I5 => ,
            I6 => ,
            I7 => ,
            I8 => ,
            I9 => ,
            I10 => ,
            I11 => ,
            I12 => ,
            I13 => ,
            I14 => ,
            I15 => ,
            Sel => ,
            O => mux_in
        );

    MULTIPLEXER_SR: entity work.Mux2
        generic map (
            BitCount => 6
        )
        port map (
            I0 => link_false,
            I1 => link_true,
            Sel => mux_in,
            O => mux_sr
        );

end arch;