-- Laboratory RA solutions/versuch5
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser 
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold


-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 22.05.2024
-- Description:  RUI-Only-RISC-V for an incomplete RV32I implementation, 
--               support only R/I/U-Instructions. 
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types.all;

entity ri_only_RISC_V is
  generic (
    G_word_width :integer := WORD_WIDTH;
    G_addr_width : integer := ADR_WIDTH
  );
  port (
    pi_rst         : in    std_logic := '0';
    pi_clk         : in    std_logic := '0';
    pi_instruction : in    memory := (others => (others => '0'));
    po_registersOut : out   registerMemory := (others => (others => '0'))
  );
end entity ri_only_RISC_V;

architecture structure of ri_only_RISC_V is

  constant PERIOD                : time                                            := 10 ns;
  constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)       := std_logic_vector(to_signed((4), WORD_WIDTH));
  -- signals
  -- begin solution:

  -- Signals for External Ports:
  signal s_clk,s_rst : std_logic := '0';
  signal s_instructions : memory:= (others => (others => '0'));
  signal s_registersOut : registermemory := (others => (others => '0'));

  -- PC signals: 
  signal s_pc_count,s_pc_internal : std_logic_vector(G_word_width-1  downto 0) := (others => '0');


  -- IF signals:
  signal s_if_instruction,s_if_internal: std_logic_vector(G_word_width-1 downto 0):= (others => '0');


  -- Decoder Signals
  signal s_out_decode_opcode :  controlword := control_word_init;

  -- Sign extension Signals
  signal s_out_I_signextended : std_logic_vector (G_word_width -1 downto 0);

  -- CWR(Control Word registry) Signals
  signal s_out_cwr1, s_out_cwr2, s_out_cwr3:  controlword := control_word_init;

  -- Destination Registry Signals
  signal s_out_dreg1, s_out_dreg2, s_out_dreg3 : std_logic_vector(REG_ADR_WIDTH-1 downto 0):= (others => '0');

  -- Mux signals
  signal s_in_default_mux,s_in_imm_mux  : std_logic_vector (G_word_width -1 downto 0) := (others => '0');
  -- ALU signals
  signal s_alu_op1,s_alu_op2,s_alu_out : std_logic_vector(G_word_width -1 downto 0):= (others => '0');

  -- MEM reg signals
  signal s_out_memreg : std_logic_vector(G_word_width -1 downto 0):= (others => '0');
  -- WB reg signals
  signal s_out_wb : std_logic_vector(G_word_width-1 downto 0):= (others => '0');

  -- Registerfile Signals 
  signal s_out_reg_op1,s_out_reg_op2 : std_logic_vector(G_word_width -1 downto 0) := (others => '0');


  -- end solution!!
begin
    s_clk <= pi_clk;
    s_rst <= pi_rst;
    s_instructions <= pi_instruction;
    po_registersOut <= s_registersOut;
    ---********************************************************************
    ---* program counter adder and pc-register
    ---********************************************************************
    -- begin solution:  
    PC_ADDER: entity work.variable_bit_add
        generic map (G_word_width)
        port map(   PI_A => s_pc_count,
                    PI_B => x"00000004",
                    PI_SUBTRACT => '0',
                    PO_RESULT => s_pc_internal
        );                
    PC_REG: entity work.pipelineregister 
        generic map (G_word_width)
        port map(   pi_data => s_pc_internal,
                    pi_clk => s_clk,
                    pi_rst => s_rst,
                    po_data => s_pc_count
        );
    -- end solution!!


    ---********************************************************************
    ---* instruction fetch 
    ---********************************************************************
    -- begin solution: 
    IF_ICACHE: entity work.instruction_cache
        generic map (G_addr_width)
        port map (
            pi_adr => s_pc_count,
            pi_clk => not s_clk,
            pi_rst => s_rst,
            pi_instructionCache => s_instructions,
            po_instruction => s_if_internal 
        );


    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (IF -> ID) start
    ---********************************************************************
    
    -- begin solution:

    IF_REG: entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_if_internal,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_if_instruction
        );


    -- end solution!!


    ---********************************************************************
    ---* decode phase
    ---********************************************************************

    -- begin solution:

    decoder: entity work.decoder
        generic map (G_word_width)
        port map (
            pi_instruction => s_if_instruction,
            po_controlWord => s_out_decode_opcode
        );

    sign_extender: entity work.signExtension
        generic map (G_word_width)
        port map(
            pi_instr => s_if_instruction,
            po_immediateImm => s_out_I_signextended
        );

    -- end solution!!


    ---********************************************************************
    ---* Pipeline-Register (ID -> EX) 
    ---********************************************************************
    -- begin solution:
    
    -- Registrys to delay dest till WB phase of Innstruction
    DEST_REG1 : entity work.pipelineregister
        generic map(REG_ADR_WIDTH)
        port map(
            pi_data => s_if_instruction(11 downto 7),
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_dreg1
        );
    DEST_REG2 : entity work.pipelineregister
        generic map(REG_ADR_WIDTH)
        port map(
            pi_data => s_out_dreg1,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_dreg2
            );

    DEST_REG3 : entity work.pipelineregister
        generic map(REG_ADR_WIDTH)
        port map(
            pi_data => s_out_dreg2,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_dreg3
            );

    CWR1: entity work.ControlWordRegister
        port map (
            pi_rst => s_rst,
            pi_clk => s_clk,
            pi_controlWord => s_out_decode_opcode,
            po_controlWord => s_out_cwr1
        );

    CWR2: entity work.ControlWordRegister
        port map (
            pi_rst => s_rst,
            pi_clk => s_clk,
            pi_controlWord => s_out_cwr1,
            po_controlWord => s_out_cwr2
        );
    CWR3: entity work.ControlWordRegister
        port map (
            pi_rst => s_rst,
            pi_clk => s_clk,
            pi_controlWord => s_out_cwr2,
            po_controlWord => s_out_cwr3
        );
    -- end solution!!

    im_reg : entity work.pipelineregister
        generic map (G_word_width)
        port map (
            pi_data => s_out_I_signextended,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_in_imm_mux
        );

    ---********************************************************************
    ---* execute phase
    ---********************************************************************
     -- begin solution:

    im_mux : entity work.gen_mux 
        generic map(G_word_width)
        port map(
            pi_first => s_in_default_mux,
            pi_second => s_in_imm_mux,
            pi_sel => s_out_cwr1.I_IMM_SEL,
            po_result => s_alu_op2 
        );


    alu_reg_op1: entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_reg_op1,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_alu_op1
        );

    alu_reg_op2: entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_reg_op2,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_in_default_mux
        );

    ALU: entity work.alu
        generic map(G_word_width,ALU_OPCODE_WIDTH)
        port map (
            pi_op1 => s_alu_op1,
            pi_op2 => s_alu_op2,
            pi_aluOp => s_out_cwr1.ALU_OP, 
            po_aluOut => s_alu_out
        );
     -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (EX -> MEM) 
    ---********************************************************************
    -- begin solution:
    mem_reg : entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_alu_out,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_memreg
        );


    -- end solution!!

    ---********************************************************************
    ---* memory phase
    ---********************************************************************


    ---********************************************************************
    ---* Pipeline-Register (MEM -> WB) 
    ---********************************************************************
     -- begin solution:

    wb_reg : entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_memreg,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_wb
        );
    -- end solution!!

    ---********************************************************************
    ---* write back phase
    ---********************************************************************



    ---********************************************************************
    ---* register file (negative clock)
    ---********************************************************************
    -- begin solution:
    regfile : entity work.register_file
        generic map(REG_ADR_WIDTH , G_word_width)
        port map (
            pi_clk => not s_clk,
            pi_rst => s_rst,
            pi_writeEnable => s_out_cwr3.REG_WRITE,

            pi_writeRegAddr => s_out_dreg3,
            pi_readRegAddr1 => s_if_instruction(19 downto 15),
            pi_readRegAddr2 => s_if_instruction(24 downto 20),

            pi_writeRegData => s_out_wb,

            po_readRegData1 => s_out_reg_op1, 
            po_readRegData2 => s_out_reg_op2, 

            po_registerOut => s_registersOut
        );

        -- end solution!!
    ---********************************************************************
    ---********************************************************************    
end architecture;
