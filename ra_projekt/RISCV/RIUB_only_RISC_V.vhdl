-- Laboratory RA solutions/versuch5
-- Sommersemester 25
-- Group Details
-- Lab Date: 11.06.2025
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

entity riub_only_RISC_V is
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
end entity riub_only_RISC_V;

architecture structure of riub_only_RISC_V is

  constant PERIOD                : time                                            := 10 ns;
  constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)       := std_logic_vector(to_signed((4), WORD_WIDTH));
  -- signals
  -- begin solution:

  -- Signals for External Ports:
  signal s_clk,s_rst : std_logic := '0';
  signal s_instructions : memory:= (others => (others => '0'));
  signal s_registersOut : registermemory := (others => (others => '0'));

  -- PC signals: 
  signal s_pc_count,s_pc_adder,s_pc_internal,s_out_pc2_mux: std_logic_vector(G_word_width-1  downto 0) := (others => '0');

  -- Pipeline PC (ppc) signals
  signal s_out_ppc1,s_out_ppc2,s_out_ppc3, s_out_ppc4,s_out_ppc_adder : std_logic_vector(G_word_width-1  downto 0) := (others => '0');

  -- IF signals:
  signal s_if_instruction,s_if_internal: std_logic_vector(G_word_width-1 downto 0):= (others => '0');


  -- Decoder Signals
  signal s_out_decode_opcode :  controlword := control_word_init;

  -- Sign extension Signals
  signal s_out_I_signextended, s_out_U_signextended, s_out_B_signextended, s_out_J_signextended, s_out_signextended : std_logic_vector (G_word_width -1 downto 0);

  -- CWR(Control Word registry) Signals
  signal s_out_cwr1, s_out_cwr2, s_out_cwr3:  controlword := control_word_init;

  -- Destination Registry Signals
  signal s_out_dreg1, s_out_dreg2, s_out_dreg3 : std_logic_vector(REG_ADR_WIDTH-1 downto 0):= (others => '0');

  -- Imm Reg signals
  signal  s_out_imm2,s_out_imm3 : std_logic_vector (G_word_width -1 downto 0) := (others => '0');

  -- Mux signals
  signal s_in_default_mux,s_in_imm_mux,s_in_auipc_mux  : std_logic_vector (G_word_width -1 downto 0) := (others => '0');
  -- ALU signals
  signal s_alu_op1,s_alu_op2,s_alu_out : std_logic_vector(G_word_width -1 downto 0):= (others => '0');
  signal s_alu_zero : STD_LOGIC;

  -- MEM reg signals
  signal s_out_memreg: std_logic_vector(G_word_width -1 downto 0):= (others => '0');
 
  -- Branch Signals
  signal s_out_branch_adder, s_out_branchreg: std_logic_vector(G_word_width -1 downto 0):= (others => '0');
  signal s_out_b_reg1 : STD_LOGIC;

  -- WB reg signals
  signal s_out_wb,s_out_wb_mux  : std_logic_vector(G_word_width-1 downto 0):= (others => '0');
  
  
  -- Registerfile Signals 
  signal s_out_reg_op1,s_out_reg_op2,s_reg_write_data: std_logic_vector(G_word_width -1 downto 0) := (others => '0');


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
                    PO_RESULT => s_pc_adder
        );                
    PC_MUX: entity work.gen_mux 
        generic map( G_word_width)
        port map (  
            pi_first => s_pc_adder,
            pi_second => s_out_memreg,
            pi_sel => s_out_cwr2.PC_SEL,
            po_result => s_pc_internal
        );
    PC_REG0: entity work.pipelineregister 
        generic map (G_word_width)
        port map(   pi_data => s_out_pc2_mux,
                    pi_clk => s_clk,
                    pi_rst => s_rst,
                    po_data => s_pc_count
        );
    -- end solution!!
    ---****************************************
    --- Pipelined PC regs
    ---****************************************
    
    
   

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
    
    -- Das flushing wird bei mir Realisiert das ich wenn ich branche oder jumpe die Ersten pipeline registries ein
    -- reset signal geschickt wird.
    -- Die ersten sind bei mir die IF_reg, Dest_Reg1, CWR_Reg1, Imm_reg1 Alu OP Reg1 und Reg2


    -- begin solution:

    IF_REG: entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_if_internal,
            pi_clk => s_clk,
            pi_rst => s_rst or s_out_b_reg1 or s_out_cwr2.PC_SEL,
            po_data => s_if_instruction
        );

    PC_REG1: entity work.pipelineregister
        generic map(
            G_WORD_width)
        port map(
            pi_data => s_pc_count,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_ppc1
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
            po_immediateImm => s_out_I_signextended,
            po_unsignedImm => s_out_U_signextended,
            po_branchImm => s_out_B_signextended,
            po_jumpImm => s_out_J_signextended
        );
    -- not sure if its works ngl?????
    with s_if_instruction(6 downto 0) select
        s_out_signextended <= s_out_I_signextended when I_INS_OP,
                              s_out_I_signextended when JALR_INS_OP,
                              s_out_U_signextended when LUI_INS_OP,
                              s_out_U_signextended when AUIPC_INS_OP,
                              s_out_J_signextended when JAL_INS_OP,
                              s_out_B_signextended when B_INS_OP,
                              (others => '0') when others;
    
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
            pi_rst => s_rst or s_out_b_reg1 or s_out_cwr2.PC_SEL,
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
            pi_rst => s_rst or s_out_b_reg1 or s_out_cwr2.PC_SEL,
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

    -- Registers to hold the immediate for the different pipeline changes
    -- RN 1 used for I ops in the ALU and the rest only for JAL 
    im_reg1 : entity work.pipelineregister
        generic map (G_word_width)
        port map (
            pi_data => s_out_signextended,
            pi_clk => s_clk,
            pi_rst => s_rst or s_out_b_reg1 or s_out_cwr2.PC_SEL,
            po_data => s_in_imm_mux
        );

    im_reg2 : entity work.pipelineregister
        generic map (G_word_width)
        port map (
            pi_data => s_in_imm_mux,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_imm2
        );


    
    PC_REG2: entity work.pipelineregister
        generic map(
            G_WORD_width)
        port map(
            pi_data => s_out_ppc1,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_ppc2
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

    auipc_mux : entity work.gen_mux
        generic map( G_word_width)
        port map (
            pi_first => s_in_auipc_mux,
            pi_second => s_out_ppc2,
            pi_sel => s_out_cwr1.A_SEL,
            po_result => s_alu_op1
        );

    alu_reg_op1: entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_reg_op1,
            pi_clk => s_clk,
            pi_rst => s_rst or s_out_b_reg1 or s_out_cwr2.PC_SEL,
            po_data => s_in_auipc_mux
        );

    alu_reg_op2: entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_reg_op2,
            pi_clk => s_clk,
            pi_rst => s_rst or s_out_b_reg1 or s_out_cwr2.PC_SEL,
            po_data => s_in_default_mux
        );

    ALU: entity work.alu
        generic map(G_word_width,ALU_OPCODE_WIDTH)
        port map (
            pi_op1 => s_alu_op1,
            pi_op2 => s_alu_op2,
            pi_aluOp => s_out_cwr1.ALU_OP,
            po_zero => s_alu_zero, 
            po_aluOut => s_alu_out
        );

    
    PPC_Adder: entity work.variable_bit_add
        generic map (G_word_width)
        port map(   PI_A => s_out_ppc2,
                    PI_B => x"00000004",
                    PI_SUBTRACT => '0',
                    PO_RESULT => s_out_ppc_adder
        );                

    -- Combines the Programm counter with the immediate
    BRANCH_Adder: entity work.variable_bit_add
        generic map (G_word_width)
        port map(   PI_A => s_out_ppc2,
                    PI_B => s_in_imm_mux,
                    PI_SUBTRACT => '0',
                    PO_RESULT => s_out_branch_adder
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

    branch_reg : entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_branch_adder,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_branchreg
        );
    
    b_sel_reg1 : entity work.single_bit_pipelineregister
        port map( 
            pi_data => s_out_cwr1.IS_BRANCH AND (s_alu_zero XOR s_out_cwr1.CMP_RESULT),
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_b_reg1 
        );
    ppc3: entity work.pipelineregister
        generic map(G_word_width)
        port map (
            pi_data => s_out_ppc_adder,
            pi_clk => s_clk,
            pi_rst => s_rst,
            po_data => s_out_ppc3
        );

    -- end solution!!

    ---********************************************************************
    ---* memory phase
    ---********************************************************************

    -- why does moving it here work?????? i hate this so much
    wb_mux : entity work.four_port_mux
        generic map( G_word_width)
        port map (
            pi_0 => s_out_memreg,
            pi_1 => s_out_imm2,    
            pi_2 => s_out_ppc3,

            pi_sel => s_out_cwr2.WB_SEL,
            po_result => s_out_wb_mux
        );
    -- i guess im gonna add it in series to the existing PC mux
    pc2_mux: entity work.gen_mux
        generic map (G_word_width)
        port map(
            pi_first => s_pc_internal,
            pi_second => s_out_branchreg,
            pi_sel => s_out_b_reg1,
            po_result => s_out_pc2_mux
        );
    
    ---********************************************************************
    ---* Pipeline-Register (MEM -> WB) 
    ---********************************************************************
     -- begin solution:

    wb_reg : entity work.pipelineregister
        generic map(G_word_width)
        port map(
            pi_data => s_out_wb_mux,
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
