module I_stage(// Input
               clock,
               reset,
               D_IR_1,
               D_IR_2,
               D_NPC_1,
               D_NPC_2,
               D_opa_reg_idx_in_1,
               D_opa_reg_idx_in_2,
               D_opb_reg_idx_in_1,
               D_opb_reg_idx_in_2,
               D_dest_reg_idx_in_1,
               D_dest_reg_idx_in_2,
               D_opa_select_in_1,
               D_opa_select_in_2,
               D_opb_select_in_1,
               D_opb_select_in_2,
               D_alu_func_in_1,
               D_alu_func_in_2,
               D_rd_mem_in_1,
               D_rd_mem_in_2,
               D_wr_mem_in_1,
               D_wr_mem_in_2,
               D_cond_branch_in_1,
               D_cond_branch_in_2,
               D_uncond_branch_in_1,
               D_uncond_branch_in_2,
               D_rs_rd_brpTN_in_1,
               D_rs_rd_brpTN_in_2,
               D_rs_rd_brp_TAR_PC_in_1,
               D_rs_rd_brp_TAR_PC_in_2,
               D_rs_rd_lsq_tail_in_1,
               D_rs_rd_lsq_tail_in_2,
               D_rs_rd_br_marker_in_1,
               D_rs_rd_br_marker_in_2,
               D_rs_rd_bmask_in_1,
               D_rs_rd_bmask_in_2,
               D_rs_inst_status,
               C_wb_reg_wr_idx_in_1,
               C_wb_reg_wr_idx_in_2,
               C_wb_reg_wr_data_in_1,
               C_wb_reg_wr_data_in_2,
               C_wb_reg_wr_en_in_1,
               C_wb_reg_wr_en_in_2,
               X_br_inst_1,
               X_br_inst_2,
               X_br_mispredict_1,
               X_br_mispredict_2,
               X_br_marker_1,
               X_br_marker_2,

               // Output
               I_rs_rd_inst_1,
               I_rs_rd_inst_2,
               I_rs_rd_inst_en_1,
               I_rs_rd_inst_en_2,
               I_NPC_out_alu0,
               I_IR_out_alu0,
               I_rega_out_alu0,
               I_regb_out_alu0,
               I_dest_reg_idx_out_alu0,
               I_opa_select_out_alu0,
               I_opb_select_out_alu0,
               I_alu_func_out_alu0,
               I_rd_mem_out_alu0,
               I_wr_mem_out_alu0,
               I_cond_branch_out_alu0,
               I_uncond_branch_out_alu0,
               I_br_marker_out_alu0,
               I_bmask_out_alu0,
               I_valid_inst_out_alu0,
               I_rs_rd_brpTN_out_alu0,
               I_rs_rd_brp_TAR_PC_out_alu0,
               I_rs_rd_lsq_tail_out_alu0,
               I_NPC_out_alu1,
               I_IR_out_alu1,
               I_rega_out_alu1,
               I_regb_out_alu1,
               I_dest_reg_idx_out_alu1,
               I_opa_select_out_alu1,
               I_opb_select_out_alu1,
               I_alu_func_out_alu1,
               I_rd_mem_out_alu1,
               I_wr_mem_out_alu1,
               I_cond_branch_out_alu1,
               I_uncond_branch_out_alu1,
               I_br_marker_out_alu1,
               I_bmask_out_alu1,
               I_valid_inst_out_alu1,
               I_rs_rd_brpTN_out_alu1,
               I_rs_rd_brp_TAR_PC_out_alu1,
               I_rs_rd_lsq_tail_out_alu1,
               I_NPC_out_alu2,
               I_IR_out_alu2,
               I_rega_out_alu2,
               I_regb_out_alu2,
               I_dest_reg_idx_out_alu2,
               I_opa_select_out_alu2,
               I_opb_select_out_alu2,
               I_alu_func_out_alu2,
               I_rd_mem_out_alu2,
               I_wr_mem_out_alu2,
               I_cond_branch_out_alu2,
               I_uncond_branch_out_alu2,
               I_br_marker_out_alu2,
               I_bmask_out_alu2,
               I_valid_inst_out_alu2,
               I_NPC_out_alu3,
               I_IR_out_alu3,
               I_rega_out_alu3,
               I_regb_out_alu3,
               I_dest_reg_idx_out_alu3,
               I_opa_select_out_alu3,
               I_opb_select_out_alu3,
               I_alu_func_out_alu3,
               I_rd_mem_out_alu3,
               I_wr_mem_out_alu3,
               I_cond_branch_out_alu3,
               I_uncond_branch_out_alu3,
               I_br_marker_out_alu3,
               I_bmask_out_alu3,
               I_valid_inst_out_alu3
              );


  input          clock;
  input          reset;
  input   [31:0] D_IR_1;
  input   [31:0] D_IR_2;
  input   [63:0] D_NPC_1;
  input   [63:0] D_NPC_2;
  input    [5:0] D_opa_reg_idx_in_1;
  input    [5:0] D_opa_reg_idx_in_2;
  input    [5:0] D_opb_reg_idx_in_1;
  input    [5:0] D_opb_reg_idx_in_2;
  input    [5:0] D_dest_reg_idx_in_1;
  input    [5:0] D_dest_reg_idx_in_2;
  input    [1:0] D_opa_select_in_1;
  input    [1:0] D_opa_select_in_2;
  input    [1:0] D_opb_select_in_1;
  input    [1:0] D_opb_select_in_2;
  input    [4:0] D_alu_func_in_1;
  input    [4:0] D_alu_func_in_2;
  input          D_rd_mem_in_1;
  input          D_rd_mem_in_2;
  input          D_wr_mem_in_1;
  input          D_wr_mem_in_2;
  input          D_cond_branch_in_1;
  input          D_cond_branch_in_2;
  input          D_uncond_branch_in_1;
  input          D_uncond_branch_in_2;
  input          D_rs_rd_brpTN_in_1;
  input          D_rs_rd_brpTN_in_2;
  input   [63:0] D_rs_rd_brp_TAR_PC_in_1;
  input   [63:0] D_rs_rd_brp_TAR_PC_in_2;
  input    [4:0] D_rs_rd_lsq_tail_in_1;
  input    [4:0] D_rs_rd_lsq_tail_in_2;
  input    [2:0] D_rs_rd_br_marker_in_1;
  input    [2:0] D_rs_rd_br_marker_in_2;
  input    [3:0] D_rs_rd_bmask_in_1;
  input    [3:0] D_rs_rd_bmask_in_2;
  input   [15:0] D_rs_inst_status;
  input    [5:0] C_wb_reg_wr_idx_in_1;
  input    [5:0] C_wb_reg_wr_idx_in_2;
  input   [63:0] C_wb_reg_wr_data_in_1;
  input   [63:0] C_wb_reg_wr_data_in_2;
  input          C_wb_reg_wr_en_in_1;
  input          C_wb_reg_wr_en_in_2;
  input          X_br_inst_1;
  input          X_br_inst_2;
  input          X_br_mispredict_1;
  input          X_br_mispredict_2;
  input    [2:0] X_br_marker_1;
  input    [2:0] X_br_marker_2;

  output  [3:0]  I_rs_rd_inst_1;
  output  [3:0]  I_rs_rd_inst_2;
  output         I_rs_rd_inst_en_1;
  output         I_rs_rd_inst_en_2;
  // ALU 0
  output  [63:0] I_NPC_out_alu0;
  output  [31:0] I_IR_out_alu0;
  output  [63:0] I_rega_out_alu0;
  output  [63:0] I_regb_out_alu0;
  output   [5:0] I_dest_reg_idx_out_alu0;
  output   [1:0] I_opa_select_out_alu0;
  output   [1:0] I_opb_select_out_alu0;
  output   [4:0] I_alu_func_out_alu0;
  output         I_rd_mem_out_alu0;
  output         I_wr_mem_out_alu0;
  output         I_cond_branch_out_alu0;
  output         I_uncond_branch_out_alu0;
  output   [2:0] I_br_marker_out_alu0;
  output   [3:0] I_bmask_out_alu0;
  output         I_valid_inst_out_alu0;
  output         I_rs_rd_brpTN_out_alu0;
  output  [63:0] I_rs_rd_brp_TAR_PC_out_alu0;
  output   [4:0] I_rs_rd_lsq_tail_out_alu0;

  // ALU 1
  output  [63:0] I_NPC_out_alu1;
  output  [31:0] I_IR_out_alu1;
  output  [63:0] I_rega_out_alu1;
  output  [63:0] I_regb_out_alu1;
  output   [5:0] I_dest_reg_idx_out_alu1;
  output   [1:0] I_opa_select_out_alu1;
  output   [1:0] I_opb_select_out_alu1;
  output   [4:0] I_alu_func_out_alu1;
  output         I_rd_mem_out_alu1;
  output         I_wr_mem_out_alu1;
  output         I_cond_branch_out_alu1;
  output         I_uncond_branch_out_alu1;
  output   [2:0] I_br_marker_out_alu1;
  output   [3:0] I_bmask_out_alu1;
  output         I_valid_inst_out_alu1;
  output         I_rs_rd_brpTN_out_alu1;
  output  [63:0] I_rs_rd_brp_TAR_PC_out_alu1;
  output   [4:0] I_rs_rd_lsq_tail_out_alu1;

  // ALU 2
  output  [63:0] I_NPC_out_alu2;
  output  [31:0] I_IR_out_alu2;
  output  [63:0] I_rega_out_alu2;
  output  [63:0] I_regb_out_alu2;
  output   [5:0] I_dest_reg_idx_out_alu2;
  output   [1:0] I_opa_select_out_alu2;
  output   [1:0] I_opb_select_out_alu2;
  output   [4:0] I_alu_func_out_alu2;
  output         I_rd_mem_out_alu2;
  output         I_wr_mem_out_alu2;
  output         I_cond_branch_out_alu2;
  output         I_uncond_branch_out_alu2;
  output   [2:0] I_br_marker_out_alu2;
  output   [3:0] I_bmask_out_alu2;
  output         I_valid_inst_out_alu2;
  // ALU 3
  output  [63:0] I_NPC_out_alu3;
  output  [31:0] I_IR_out_alu3;
  output  [63:0] I_rega_out_alu3;
  output  [63:0] I_regb_out_alu3;
  output   [5:0] I_dest_reg_idx_out_alu3;
  output   [1:0] I_opa_select_out_alu3;
  output   [1:0] I_opb_select_out_alu3;
  output   [4:0] I_alu_func_out_alu3;
  output         I_rd_mem_out_alu3;
  output         I_wr_mem_out_alu3;
  output         I_cond_branch_out_alu3;
  output         I_uncond_branch_out_alu3;
  output   [2:0] I_br_marker_out_alu3;
  output   [3:0] I_bmask_out_alu3;
  output         I_valid_inst_out_alu3;

  wire    [63:0] I_opa_reg_value_out_1;
  wire    [63:0] I_opa_reg_value_out_2;
  wire    [63:0] I_opb_reg_value_out_1;
  wire    [63:0] I_opb_reg_value_out_2;

  selector sel(//input
               .idx(D_rs_inst_status),

               //output
               .issue1(I_rs_rd_inst_1),
               .issue1_en(I_rs_rd_inst_en_1),
               .issue2(I_rs_rd_inst_2),
               .issue2_en(I_rs_rd_inst_en_2)
               );

  regfile regfile(//input
                 .clock(clock),
                 .rda1_idx(D_opa_reg_idx_in_1),
                 .rda2_idx(D_opa_reg_idx_in_2),
                 .rdb1_idx(D_opb_reg_idx_in_1),
                 .rdb2_idx(D_opb_reg_idx_in_2),
                 .wr1_idx(C_wb_reg_wr_idx_in_1),
                 .wr2_idx(C_wb_reg_wr_idx_in_2),
                 .wr1_data(C_wb_reg_wr_data_in_1),
                 .wr2_data(C_wb_reg_wr_data_in_2),
                 .wr1_en(C_wb_reg_wr_en_in_1),
                 .wr2_en(C_wb_reg_wr_en_in_2),

                 //output
                 .rda1_out(I_opa_reg_value_out_1),
                 .rda2_out(I_opa_reg_value_out_2),
                 .rdb1_out(I_opb_reg_value_out_1),
                 .rdb2_out(I_opb_reg_value_out_2)
                ); 
  reg  [2:0] D_rs_rd_bmask_tmp_1;
  reg  [2:0] D_rs_rd_bmask_tmp_2;

  // bmask
  always @*
  begin
    D_rs_rd_bmask_tmp_1 = D_rs_rd_bmask_in_1;
    if(X_br_inst_1) D_rs_rd_bmask_tmp_1[X_br_marker_1] = 0;
    if(X_br_inst_2) D_rs_rd_bmask_tmp_1[X_br_marker_2] = 0;
    D_rs_rd_bmask_tmp_2 = D_rs_rd_bmask_in_2;
    if(X_br_inst_1) D_rs_rd_bmask_tmp_2[X_br_marker_1] = 0;
    if(X_br_inst_2) D_rs_rd_bmask_tmp_2[X_br_marker_2] = 0;
  end



  // ALU 0 is for non-mulq functions & inst 1
  assign I_NPC_out_alu0           = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_NPC_1: 0;
  assign I_IR_out_alu0            = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_IR_1: `NOOP_INST;
  assign I_rega_out_alu0          = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? I_opa_reg_value_out_1: 0;
  assign I_regb_out_alu0          = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? I_opb_reg_value_out_1: 0;
  assign I_dest_reg_idx_out_alu0  = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_dest_reg_idx_in_1: 0;
  assign I_opa_select_out_alu0    = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_opa_select_in_1: 0;
  assign I_opb_select_out_alu0    = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_opb_select_in_1: 0;
  assign I_alu_func_out_alu0      = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_alu_func_in_1: 0;
  assign I_rd_mem_out_alu0        = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_rd_mem_in_1: 0;
  assign I_wr_mem_out_alu0        = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_wr_mem_in_1: 0;
  assign I_cond_branch_out_alu0   = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_cond_branch_in_1: 0;
  assign I_uncond_branch_out_alu0 = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_uncond_branch_in_1: 0;
  assign I_br_marker_out_alu0     = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_rs_rd_br_marker_in_1:`BR_MARKER_EMPTY;
  assign I_bmask_out_alu0         = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? D_rs_rd_bmask_tmp_1:0;
  assign I_valid_inst_out_alu0    = (I_rs_rd_inst_en_1 && (D_alu_func_in_1!=`ALU_MULQ))? I_rs_rd_inst_en_1: 0;

  assign I_rs_rd_brpTN_out_alu0      = D_rs_rd_lsq_tail_in_1;
  assign I_rs_rd_brp_TAR_PC_out_alu0 = D_rs_rd_brp_TAR_PC_in_1;
  assign I_rs_rd_lsq_tail_out_alu0   = D_rs_rd_lsq_tail_in_1;

  // ALU 1 is for non-mulq functions & inst 2
  assign I_NPC_out_alu1           = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_NPC_2: 0;
  assign I_IR_out_alu1            = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_IR_2: `NOOP_INST;
  assign I_rega_out_alu1          = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? I_opa_reg_value_out_2: 0;
  assign I_regb_out_alu1          = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? I_opb_reg_value_out_2: 0;
  assign I_dest_reg_idx_out_alu1  = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_dest_reg_idx_in_2: 0;
  assign I_opa_select_out_alu1    = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_opa_select_in_2: 0;
  assign I_opb_select_out_alu1    = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_opb_select_in_2: 0;
  assign I_alu_func_out_alu1      = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_alu_func_in_2: 0;
  assign I_rd_mem_out_alu1        = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_rd_mem_in_2: 0;
  assign I_wr_mem_out_alu1        = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_wr_mem_in_2: 0;
  assign I_cond_branch_out_alu1   = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_cond_branch_in_2: 0;
  assign I_uncond_branch_out_alu1 = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_uncond_branch_in_2: 0;
  assign I_br_marker_out_alu1     = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_rs_rd_br_marker_in_2:`BR_MARKER_EMPTY;
  assign I_bmask_out_alu1         = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? D_rs_rd_bmask_tmp_2:0;
  assign I_valid_inst_out_alu1    = (I_rs_rd_inst_en_2 && (D_alu_func_in_2!=`ALU_MULQ))? I_rs_rd_inst_en_2: 0;

  assign I_rs_rd_brpTN_out_alu1      = D_rs_rd_lsq_tail_in_2;
  assign I_rs_rd_brp_TAR_PC_out_alu1 = D_rs_rd_brp_TAR_PC_in_2;
  assign I_rs_rd_lsq_tail_out_alu1   = D_rs_rd_lsq_tail_in_2;

  // ALU 2 is for mulq functions & inst 1
  assign I_NPC_out_alu2           = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_NPC_1: 0;
  assign I_IR_out_alu2            = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_IR_1: `NOOP_INST;
  assign I_rega_out_alu2          = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? I_opa_reg_value_out_1: 0;
  assign I_regb_out_alu2          = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? I_opb_reg_value_out_1: 0;
  assign I_dest_reg_idx_out_alu2  = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_dest_reg_idx_in_1: 0;
  assign I_opa_select_out_alu2    = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_opa_select_in_1: 0;
  assign I_opb_select_out_alu2    = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_opb_select_in_1: 0;
  assign I_alu_func_out_alu2      = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_alu_func_in_1: 0;
  assign I_rd_mem_out_alu2        = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_rd_mem_in_1: 0;
  assign I_wr_mem_out_alu2        = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_wr_mem_in_1: 0;
  assign I_cond_branch_out_alu2   = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_cond_branch_in_1: 0;
  assign I_uncond_branch_out_alu2 = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_uncond_branch_in_1: 0;
  assign I_br_marker_out_alu2     = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_rs_rd_br_marker_in_1:`BR_MARKER_EMPTY;
  assign I_bmask_out_alu2         = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? D_rs_rd_bmask_tmp_1:0;
  assign I_valid_inst_out_alu2    = (I_rs_rd_inst_en_1 && (D_alu_func_in_1==`ALU_MULQ))? I_rs_rd_inst_en_1: 0;
  // ALU 3 is for mulq functions & inst 2
  assign I_NPC_out_alu3           = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_NPC_2: 0;
  assign I_IR_out_alu3            = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_IR_2: `NOOP_INST;
  assign I_rega_out_alu3          = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? I_opa_reg_value_out_2: 0;
  assign I_regb_out_alu3          = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? I_opb_reg_value_out_2: 0;
  assign I_dest_reg_idx_out_alu3  = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_dest_reg_idx_in_2: 0;
  assign I_opa_select_out_alu3    = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_opa_select_in_2: 0;
  assign I_opb_select_out_alu3    = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_opb_select_in_2: 0;
  assign I_alu_func_out_alu3      = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_alu_func_in_2: 0;
  assign I_rd_mem_out_alu3        = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_rd_mem_in_2: 0;
  assign I_wr_mem_out_alu3        = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_wr_mem_in_2: 0;
  assign I_cond_branch_out_alu3   = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_cond_branch_in_2: 0;
  assign I_uncond_branch_out_alu3 = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_uncond_branch_in_2: 0;
  assign I_br_marker_out_alu3     = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_rs_rd_br_marker_in_2:`BR_MARKER_EMPTY;
  assign I_bmask_out_alu3         = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? D_rs_rd_bmask_tmp_2:0;
  assign I_valid_inst_out_alu3    = (I_rs_rd_inst_en_2 && (D_alu_func_in_2==`ALU_MULQ))? I_rs_rd_inst_en_2: 0;

endmodule
