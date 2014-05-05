module X_stage(// Input 
               clock,
               reset,

               I_X_NPC_alu0,
               I_X_IR_alu0,
               I_X_rega_alu0,
               I_X_regb_alu0,
               I_X_dest_reg_idx_alu0,
               I_X_opa_select_alu0,
               I_X_opb_select_alu0,
               I_X_alu_func_alu0,
               I_X_rd_mem_alu0,
               I_X_wr_mem_alu0,
               I_X_cond_branch_alu0,
               I_X_uncond_branch_alu0,
               I_X_br_marker_alu0,
               I_X_valid_inst_alu0,
               I_X_rs_rd_brpTN_alu0,
               I_X_rs_rd_brp_TAR_PC_alu0,
               I_X_rs_rd_lsq_tail_alu0,

               I_X_NPC_alu1,
               I_X_IR_alu1,
               I_X_rega_alu1,
               I_X_regb_alu1,
               I_X_dest_reg_idx_alu1,
               I_X_opa_select_alu1,
               I_X_opb_select_alu1,
               I_X_alu_func_alu1,
               I_X_rd_mem_alu1,
               I_X_wr_mem_alu1,
               I_X_cond_branch_alu1,
               I_X_uncond_branch_alu1,
               I_X_br_marker_alu1,
               I_X_valid_inst_alu1,
               I_X_rs_rd_brpTN_alu1,
               I_X_rs_rd_brp_TAR_PC_alu1,
               I_X_rs_rd_lsq_tail_alu1,

               I_X_NPC_alu2,
               I_X_IR_alu2,
               I_X_rega_alu2,
               I_X_regb_alu2,
               I_X_dest_reg_idx_alu2,
               I_X_opa_select_alu2,
               I_X_opb_select_alu2,
               I_X_valid_inst_alu2,

               I_X_NPC_alu3,
               I_X_IR_alu3,
               I_X_rega_alu3,
               I_X_regb_alu3,
               I_X_dest_reg_idx_alu3,
               I_X_opa_select_alu3,
               I_X_opb_select_alu3,
               I_X_valid_inst_alu3,

               // Outputs
               X_NPC_out_alu0,
               X_alu_result_out_alu0,
               X_take_branch_target_out_alu0,
               X_take_branch_out_alu0,
               X_valid_inst_out_alu0,
               X_rd_mem_out_alu0,
               X_wr_mem_out_alu0,
               X_br_marker_out_alu0,
               X_dest_reg_idx_out_alu0,
               X_wr_men_value_alu0,
               X_rs_rd_brpTN_out_alu0,
               X_rs_rd_brp_TAR_PC_out_alu0,
               X_rs_rd_lsq_tail_out_alu0,

               X_NPC_out_alu1,
               X_alu_result_out_alu1,
               X_take_branch_target_out_alu1,
               X_take_branch_out_alu1,
               X_valid_inst_out_alu1,
               X_rd_mem_out_alu1,
               X_wr_mem_out_alu1,
               X_br_marker_out_alu1,
               X_dest_reg_idx_out_alu1,
               X_wr_men_value_alu1,
               X_rs_rd_brpTN_out_alu1,
               X_rs_rd_brp_TAR_PC_out_alu1,
               X_rs_rd_lsq_tail_out_alu1,

               X_NPC_out_alu2,
               X_alu_result_out_alu2,
               X_valid_inst_out_alu2,
               X_dest_reg_idx_out_alu2,

               X_NPC_out_alu3,
               X_alu_result_out_alu3,
               X_valid_inst_out_alu3,
               X_dest_reg_idx_out_alu3
              );

  input         clock;                  // system clock
  input         reset;                  // system reset
  // ALU 0
  input  [63:0] I_X_NPC_alu0;           // incoming instruction PC+4
  input  [31:0] I_X_IR_alu0;            // incoming instruction
  input  [63:0] I_X_rega_alu0;          // register A value from reg file
  input  [63:0] I_X_regb_alu0;          // register B value from reg file
  input   [5:0] I_X_dest_reg_idx_alu0;
  input   [1:0] I_X_opa_select_alu0;    // opA mux select from decoder
  input   [1:0] I_X_opb_select_alu0;    // opB mux select from decoder
  input   [4:0] I_X_alu_func_alu0;      // ALU function select from decoder
  input         I_X_rd_mem_alu0;
  input         I_X_wr_mem_alu0;
  input         I_X_cond_branch_alu0;   // is this a cond br? from decoder
  input         I_X_uncond_branch_alu0; // is this an uncond br? from decoder
  input   [2:0] I_X_br_marker_alu0;
  input         I_X_valid_inst_alu0;    // is this computation valid? from fetch
  input         I_X_rs_rd_brpTN_alu0;
  input  [63:0] I_X_rs_rd_brp_TAR_PC_alu0;
  input   [4:0] I_X_rs_rd_lsq_tail_alu0;
  // ALU 1
  input  [63:0] I_X_NPC_alu1;           // incoming instruction PC+4
  input  [31:0] I_X_IR_alu1;            // incoming instruction
  input  [63:0] I_X_rega_alu1;          // register A value from reg file
  input  [63:0] I_X_regb_alu1;          // register B value from reg file
  input   [5:0] I_X_dest_reg_idx_alu1;
  input   [1:0] I_X_opa_select_alu1;    // opA mux select from decoder
  input   [1:0] I_X_opb_select_alu1;    // opB mux select from decoder
  input   [4:0] I_X_alu_func_alu1;      // ALU function select from decoder
  input         I_X_rd_mem_alu1;
  input         I_X_wr_mem_alu1;
  input         I_X_cond_branch_alu1;   // is this a cond br? from decoder
  input         I_X_uncond_branch_alu1; // is this an uncond br? from decoder
  input   [2:0] I_X_br_marker_alu1;
  input         I_X_valid_inst_alu1;    // is this computation valid? from fetch
  input         I_X_rs_rd_brpTN_alu1;
  input  [63:0] I_X_rs_rd_brp_TAR_PC_alu1;
  input   [4:0] I_X_rs_rd_lsq_tail_alu1;
  // ALU 2
  input  [63:0] I_X_NPC_alu2;           // incoming instruction PC+4
  input  [31:0] I_X_IR_alu2;            // incoming instruction
  input  [63:0] I_X_rega_alu2;          // register A value from reg file
  input  [63:0] I_X_regb_alu2;          // register B value from reg file
  input   [5:0] I_X_dest_reg_idx_alu2;
  input   [1:0] I_X_opa_select_alu2;    // opA mux select from decoder
  input   [1:0] I_X_opb_select_alu2;    // opB mux select from decoder
  input         I_X_valid_inst_alu2;    // is this computation valid? from fetch
  // ALU 3
  input  [63:0] I_X_NPC_alu3;           // incoming instruction PC+4
  input  [31:0] I_X_IR_alu3;            // incoming instruction
  input  [63:0] I_X_rega_alu3;          // register A value from reg file
  input  [63:0] I_X_regb_alu3;          // register B value from reg file
  input   [5:0] I_X_dest_reg_idx_alu3;
  input   [1:0] I_X_opa_select_alu3;    // opA mux select from decoder
  input   [1:0] I_X_opb_select_alu3;    // opB mux select from decoder
  input         I_X_valid_inst_alu3;    // is this computation valid? from fetch

  // ALU 0
  output [63:0] X_NPC_out_alu0;
  output [63:0] X_alu_result_out_alu0;  // ALU result or branch target
  output [63:0] X_take_branch_target_out_alu0;
  output        X_take_branch_out_alu0; // is this a taken branch?
  output        X_rd_mem_out_alu0;
  output        X_wr_mem_out_alu0;
  output        X_valid_inst_out_alu0;  // is this computation valid?
  output  [2:0] X_br_marker_out_alu0;
  output  [5:0] X_dest_reg_idx_out_alu0;
  output [63:0] X_wr_men_value_alu0;
  output        X_rs_rd_brpTN_out_alu0;
  output [63:0] X_rs_rd_brp_TAR_PC_out_alu0;
  output  [4:0] X_rs_rd_lsq_tail_out_alu0;
  // ALU 1
  output [63:0] X_NPC_out_alu1;
  output [63:0] X_alu_result_out_alu1;  // ALU result or branch target
  output        X_rd_mem_out_alu1;
  output        X_wr_mem_out_alu1;
  output [63:0] X_take_branch_target_out_alu1;
  output        X_take_branch_out_alu1; // is this a taken branch?
  output        X_valid_inst_out_alu1;  // is this computation valid?
  output  [2:0] X_br_marker_out_alu1;
  output  [5:0] X_dest_reg_idx_out_alu1;
  output [63:0] X_wr_men_value_alu1;
  output        X_rs_rd_brpTN_out_alu1;
  output [63:0] X_rs_rd_brp_TAR_PC_out_alu1;
  output  [4:0] X_rs_rd_lsq_tail_out_alu1;
  // ALU 2
  output [63:0] X_NPC_out_alu2;
  output [63:0] X_alu_result_out_alu2;  // ALU result or branch target
  output        X_valid_inst_out_alu2;  // is this computation valid?
  output  [5:0] X_dest_reg_idx_out_alu2;
  // ALU 3
  output [63:0] X_NPC_out_alu3;
  output [63:0] X_alu_result_out_alu3;  // ALU result or branch target
  output        X_valid_inst_out_alu3;  // is this computation valid?
  output  [5:0] X_dest_reg_idx_out_alu3;

  // Output from ALU
  wire   [63:0] alu_result_out_alu0;
  wire          alu_take_branch_out_alu0;
  wire   [63:0] alu_result_out_alu1;
  wire          alu_take_branch_out_alu1;

  // Output from MULT
  reg    [63:0] opa_mux_out_alu2;
  reg    [63:0] opb_mux_out_alu2;
  reg    [63:0] opa_mux_out_alu3;
  reg    [63:0] opb_mux_out_alu3;
  wire   [63:0] mem_disp_alu2 = { {48{I_X_IR_alu2[15]}}, I_X_IR_alu2[15:0] };
  wire   [63:0] br_disp_alu2  = { {41{I_X_IR_alu2[20]}}, I_X_IR_alu2[20:0], 2'b00 };
  wire   [63:0] alu_imm_alu2  = { 56'b0, I_X_IR_alu2[20:13] };
  wire   [63:0] mem_disp_alu3 = { {48{I_X_IR_alu3[15]}}, I_X_IR_alu3[15:0] };
  wire   [63:0] br_disp_alu3  = { {41{I_X_IR_alu3[20]}}, I_X_IR_alu3[20:0], 2'b00 };
  wire   [63:0] alu_imm_alu3  = { 56'b0, I_X_IR_alu3[20:13] };


  //////////////////////////////////////////////////
  //                                              //
  //                    ALU 0                     //
  //                                              //
  //////////////////////////////////////////////////

  alu alu0(// Inputs
           .clock(clock),
           .reset(reset),
           .I_X_NPC(I_X_NPC_alu0),
           .I_X_IR(I_X_IR_alu0),
           .I_X_rega(I_X_rega_alu0),
           .I_X_regb(I_X_regb_alu0),
           .I_X_opa_select(I_X_opa_select_alu0),
           .I_X_opb_select(I_X_opb_select_alu0),
           .I_X_alu_func(I_X_alu_func_alu0),
           .I_X_cond_branch(I_X_cond_branch_alu0),
           .I_X_uncond_branch(I_X_uncond_branch_alu0),
                
           // Outputs
           .X_alu_result_out(alu_result_out_alu0),
           .X_take_branch_out(alu_take_branch_out_alu0)
          );


  assign X_NPC_out_alu0          = I_X_NPC_alu0;
  assign X_alu_result_out_alu0   = (!X_valid_inst_out_alu0)? 64'h0:
                                   (I_X_uncond_branch_alu0)? I_X_NPC_alu0:
                                   alu_result_out_alu0;
  assign X_take_branch_target_out_alu0 = (X_valid_inst_out_alu0)? alu_result_out_alu0: 64'h0;
  assign X_take_branch_out_alu0  = (X_valid_inst_out_alu0)? alu_take_branch_out_alu0: 1'h0;
  assign X_rd_mem_out_alu0       = X_valid_inst_out_alu0 & I_X_rd_mem_alu0;
  assign X_wr_mem_out_alu0       = X_valid_inst_out_alu0 & I_X_wr_mem_alu0;
  assign X_valid_inst_out_alu0   = I_X_valid_inst_alu0;
  assign X_br_marker_out_alu0    = I_X_br_marker_alu0;
  assign X_dest_reg_idx_out_alu0 = (I_X_rd_mem_alu0 || I_X_wr_mem_alu0)? `ZERO_REG: I_X_dest_reg_idx_alu0;
  assign X_wr_men_value_alu0     = I_X_rega_alu0;

  assign X_rs_rd_brpTN_out_alu0      = I_X_rs_rd_brpTN_alu0;
  assign X_rs_rd_brp_TAR_PC_out_alu0 = I_X_rs_rd_brp_TAR_PC_alu0;
  assign X_rs_rd_lsq_tail_out_alu0   = I_X_rs_rd_lsq_tail_alu0;


  //////////////////////////////////////////////////
  //                                              //
  //                    ALU 1                     //
  //                                              //
  //////////////////////////////////////////////////

  alu alu1(// Inputs
           .clock(clock),
           .reset(reset),
           .I_X_NPC(I_X_NPC_alu1),
           .I_X_IR(I_X_IR_alu1),
           .I_X_rega(I_X_rega_alu1),
           .I_X_regb(I_X_regb_alu1),
           .I_X_opa_select(I_X_opa_select_alu1),
           .I_X_opb_select(I_X_opb_select_alu1),
           .I_X_alu_func(I_X_alu_func_alu1),
           .I_X_cond_branch(I_X_cond_branch_alu1),
           .I_X_uncond_branch(I_X_uncond_branch_alu1),
                
           // Outputs
           .X_alu_result_out(alu_result_out_alu1),
           .X_take_branch_out(alu_take_branch_out_alu1)
          );
  assign X_NPC_out_alu1          = I_X_NPC_alu1;
  assign X_alu_result_out_alu1   = (!X_valid_inst_out_alu1)? 64'h0:
                                   (I_X_uncond_branch_alu1)? I_X_NPC_alu1:
                                   alu_result_out_alu1;
  assign X_take_branch_out_alu1  = (X_valid_inst_out_alu1)? alu_take_branch_out_alu1: 1'h0;
  assign X_take_branch_target_out_alu1 = (X_valid_inst_out_alu1)? alu_result_out_alu1: 64'h0;
  assign X_rd_mem_out_alu1       = X_valid_inst_out_alu1 & I_X_rd_mem_alu1;
  assign X_wr_mem_out_alu1       = X_valid_inst_out_alu1 & I_X_wr_mem_alu1;
  assign X_valid_inst_out_alu1   = I_X_valid_inst_alu1;
  assign X_br_marker_out_alu1    = I_X_br_marker_alu1;
  assign X_dest_reg_idx_out_alu1 = (I_X_rd_mem_alu1 || I_X_wr_mem_alu1)? `ZERO_REG: I_X_dest_reg_idx_alu1;
  assign X_wr_men_value_alu1     = I_X_rega_alu1;

  assign X_rs_rd_brpTN_out_alu1      = I_X_rs_rd_brpTN_alu1;
  assign X_rs_rd_brp_TAR_PC_out_alu1 = I_X_rs_rd_brp_TAR_PC_alu1;
  assign X_rs_rd_lsq_tail_out_alu1   = I_X_rs_rd_lsq_tail_alu1;



  //////////////////////////////////////////////////
  //                                              //
  //                   MULT 0                     //
  //                                              //
  //////////////////////////////////////////////////


   
  // ALU opA mux
  always @*
  begin
    case (I_X_opa_select_alu2)
      `ALU_OPA_IS_REGA:     opa_mux_out_alu2 = I_X_rega_alu2;
      `ALU_OPA_IS_MEM_DISP: opa_mux_out_alu2 = mem_disp_alu2;
      `ALU_OPA_IS_NPC:      opa_mux_out_alu2 = I_X_NPC_alu2;
      `ALU_OPA_IS_NOT3:     opa_mux_out_alu2 = ~64'h3;
    endcase
  end

  // ALU opB mux
  always @*
  begin
    opb_mux_out_alu2 = 64'hbaadbeefdeadbeef;
    case (I_X_opb_select_alu2)
      `ALU_OPB_IS_REGB:    opb_mux_out_alu2 = I_X_regb_alu2;
      `ALU_OPB_IS_ALU_IMM: opb_mux_out_alu2 = alu_imm_alu2;
      `ALU_OPB_IS_BR_DISP: opb_mux_out_alu2 = br_disp_alu2;
    endcase 
  end

  eight_stage_mult mult0(// Input
                        .clock(clock),
                        .reset(reset),
                        .mplier(opa_mux_out_alu2),
                        .mcand(opb_mux_out_alu2),
                        .bmask_in(),
                        .inst_valid_in(I_X_valid_inst_alu2),
                        .dest_reg_in(I_X_dest_reg_idx_alu2),
                        .NPC_in(I_X_NPC_alu2),

                        .br_rec_en_1(),
                        .br_rec_en_2(),
                        .br_marker_1(),
                        .br_marker_2(),
                        .br_mispre_1(),
                        .br_mispre_2(),

                        // Output
                        .bmask_out(),
                        .product(X_alu_result_out_alu2),
                        .inst_valid_out(X_valid_inst_out_alu2),
                        .dest_reg_out(X_dest_reg_idx_out_alu2),
                        .NPC_out(X_NPC_out_alu2)
                       );

  //////////////////////////////////////////////////
  //                                              //
  //                   MULT 1                     //
  //                                              //
  //////////////////////////////////////////////////
  // ALU opA mux
  always @*
  begin
    case (I_X_opa_select_alu3)
      `ALU_OPA_IS_REGA:     opa_mux_out_alu3 = I_X_rega_alu3;
      `ALU_OPA_IS_MEM_DISP: opa_mux_out_alu3 = mem_disp_alu3;
      `ALU_OPA_IS_NPC:      opa_mux_out_alu3 = I_X_NPC_alu3;
      `ALU_OPA_IS_NOT3:     opa_mux_out_alu3 = ~64'h3;
    endcase
  end

  // ALU opB mux
  always @*
  begin
    opb_mux_out_alu3 = 64'hbaadbeefdeadbeef;
    case (I_X_opb_select_alu3)
      `ALU_OPB_IS_REGB:    opb_mux_out_alu3 = I_X_regb_alu3;
      `ALU_OPB_IS_ALU_IMM: opb_mux_out_alu3 = alu_imm_alu3;
      `ALU_OPB_IS_BR_DISP: opb_mux_out_alu3 = br_disp_alu3;
    endcase 
  end

  eight_stage_mult mult1(// Input
                        .clock(clock),
                        .reset(reset),
                        .mplier(opa_mux_out_alu3),
                        .mcand(opb_mux_out_alu3),
                        .bmask_in(),
                        .inst_valid_in(I_X_valid_inst_alu3),
                        .dest_reg_in(I_X_dest_reg_idx_alu3),
                        .NPC_in(I_X_NPC_alu3),

                        .br_rec_en_1(),
                        .br_rec_en_2(),
                        .br_marker_1(),
                        .br_marker_2(),
                        .br_mispre_1(),
                        .br_mispre_2(),

                        // Output
                        .bmask_out(),
                        .product(X_alu_result_out_alu3),
                        .inst_valid_out(X_valid_inst_out_alu3),
                        .dest_reg_out(X_dest_reg_idx_out_alu3),
                        .NPC_out(X_NPC_out_alu3)
                       );


endmodule





