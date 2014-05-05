`timescale 1ns/100ps

module D_stage(// Input
               clock,
               reset,
               if_id_IR_1,
               if_id_IR_2,
               if_id_NPC_1,
               if_id_NPC_2,
               if_id_valid_inst_1,
               if_id_valid_inst_2,
               if_D_br_marker_1,
               if_D_br_marker_2,
               if_D_bmask_1,
               if_D_bmask_2,
               I_rs_rd_inst_1,
               I_rs_rd_inst_2,
               X_rs_clear_inst_1,
               X_rs_clear_inst_2,
               X_rs_clear_en_1,
               X_rs_clear_en_2,
               X_rs_clear_bmask_bits_1,
               X_rs_clear_bmask_bits_2,
               X_rs_bmask_clear_location_1,
               X_rs_bmask_clear_location_2,
               X_br_taken_1,
               X_br_taken_2,
               X_br_target_PC_1,
               X_br_target_PC_2,
               X_br_wr_en_1,
               X_br_wr_en_2,
               X_br_marker_1,
               X_br_marker_2,
               C_cdb_idx_1,
               C_cdb_idx_2,
               C_cdb_en_1,
               C_cdb_en_2,
               C_cdb_data_1,
               C_cdb_data_2,
               F_rs_wr_data_brpTN_1,
               F_rs_wr_data_brpTN_2,
               F_rs_wr_data_brp_TAR_PC_1,
               F_rs_wr_data_brp_TAR_PC_2,
               LSQ_rs_wr_data_lsq_tail_1,
               LSQ_rs_wr_data_lsq_tail_2,
               LSQ_wr_mem_finished,

               // Output
               D_IR_1,
               D_IR_2,
               D_NPC_1,
               D_NPC_2,
               D_opa_reg_idx_out_1,
               D_opa_reg_idx_out_2,
               D_opb_reg_idx_out_1,
               D_opb_reg_idx_out_2,
               D_dest_reg_idx_out_1,
               D_dest_reg_idx_out_2,
               D_opa_select_out_1,
               D_opa_select_out_2,
               D_opb_select_out_1,
               D_opb_select_out_2,
               D_alu_func_out_1,
               D_alu_func_out_2,
               D_rd_mem_out_1,
               D_rd_mem_out_2,
               D_wr_mem_out_1,
               D_wr_mem_out_2,
               D_cond_branch_out_1,
               D_cond_branch_out_2,
               D_uncond_branch_out_1,
               D_uncond_branch_out_2,
               D_rs_rd_brpTN_1,
               D_rs_rd_brpTN_2,
               D_rs_rd_brp_TAR_PC_1,
               D_rs_rd_brp_TAR_PC_2,
               D_rs_rd_lsq_tail_1,
               D_rs_rd_lsq_tail_2,
               D_rs_rd_br_marker_1,
               D_rs_rd_br_marker_2,
               D_rs_rd_bmask_1,
               D_rs_rd_bmask_2,
               D_rs_inst_status,
               D_stall,
               retire_load,
               retire_store,
               system_halt,

               rob_br_mispredict,
               rob_br_mispredict_target_PC,
               rob_br_marker_1,
               rob_br_marker_2,
               rob_br_retire_en_out_1,
               rob_br_retire_en_out_2,
               // LSQ
               lsq_wr_en_out_1,
               lsq_wr_en_out_2,
               lsq_rd_en_out_1,
               lsq_rd_en_out_2,
               lsq_rd_dest_idx_out_1,
               lsq_rd_dest_idx_out_2,
               lsq_NPC_out_1,
               lsq_NPC_out_2,
               lsq_br_inst_out_1,
               lsq_br_inst_out_2,

               // testbench signal
               Retire_NPC_out_1,
               Retire_NPC_out_2,
               Retire_wr_idx_1,
               Retire_wr_idx_2,
               Retire_wr_data_1,
               Retire_wr_data_2,
               Retire_wr_en_1,
               Retire_wr_en_2,

               Dispatch_NPC_1,
               Dispatch_NPC_2,
               Dispatch_T_1,
               Dispatch_T_en_1,
               Dispatch_T_2,
               Dispatch_T_en_2,
               Dispatch_Told_1,
               Dispatch_Told_2,
               Dispatch_rega_1,
               Dispatch_rega_plus_1,
               Dispatch_rega_2,
               Dispatch_rega_plus_2,
               Dispatch_regb_1,
               Dispatch_regb_plus_1,
               Dispatch_regb_2,
               Dispatch_regb_plus_2,
               Dispatch_valid_inst_1,
               Dispatch_valid_inst_2,

               pipeline_commit_halt_on_2_signal
              );


  input          clock;
  input          reset;
  input  [31:0]  if_id_IR_1;
  input  [31:0]  if_id_IR_2;
  input  [63:0]  if_id_NPC_1;
  input  [63:0]  if_id_NPC_2;
  input          if_id_valid_inst_1;
  input          if_id_valid_inst_2;
  input  [2:0]   if_D_br_marker_1;
  input  [2:0]   if_D_br_marker_2;
  input  [3:0]   if_D_bmask_1;
  input  [3:0]   if_D_bmask_2;
  input  [3:0]   I_rs_rd_inst_1;
  input  [3:0]   I_rs_rd_inst_2;
  input  [3:0]   X_rs_clear_inst_1;
  input  [3:0]   X_rs_clear_inst_2;
  input          X_rs_clear_en_1;
  input          X_rs_clear_en_2;
  input  [2:0]   X_rs_clear_bmask_bits_1;
  input  [2:0]   X_rs_clear_bmask_bits_2;
  input  [2:0]   X_rs_bmask_clear_location_1;
  input  [2:0]   X_rs_bmask_clear_location_2;
  input          X_br_taken_1;
  input          X_br_taken_2;
  input  [63:0]  X_br_target_PC_1;
  input  [63:0]  X_br_target_PC_2;
  input          X_br_wr_en_1;
  input          X_br_wr_en_2;
  input  [2:0]   X_br_marker_1;
  input  [2:0]   X_br_marker_2;
  input  [5:0]   C_cdb_idx_1;
  input  [5:0]   C_cdb_idx_2;
  input          C_cdb_en_1;
  input          C_cdb_en_2;
  input  [63:0]  C_cdb_data_1;
  input  [63:0]  C_cdb_data_2;
  input          F_rs_wr_data_brpTN_1;
  input          F_rs_wr_data_brpTN_2;
  input  [63:0]  F_rs_wr_data_brp_TAR_PC_1;
  input  [63:0]  F_rs_wr_data_brp_TAR_PC_2;
  input  [4:0]   LSQ_rs_wr_data_lsq_tail_1;
  input  [4:0]   LSQ_rs_wr_data_lsq_tail_2;
  input          LSQ_wr_mem_finished;


  output [31:0]  D_IR_1;
  output [31:0]  D_IR_2;
  output [63:0]  D_NPC_1;
  output [63:0]  D_NPC_2;
  output [5:0]   D_opa_reg_idx_out_1;
  output [5:0]   D_opa_reg_idx_out_2;
  output [5:0]   D_opb_reg_idx_out_1;
  output [5:0]   D_opb_reg_idx_out_2;
  output [5:0]   D_dest_reg_idx_out_1;
  output [5:0]   D_dest_reg_idx_out_2;
  output [1:0]   D_opa_select_out_1;
  output [1:0]   D_opa_select_out_2;
  output [1:0]   D_opb_select_out_1;
  output [1:0]   D_opb_select_out_2;
  output [4:0]   D_alu_func_out_1;
  output [4:0]   D_alu_func_out_2;
  output         D_rd_mem_out_1;
  output         D_rd_mem_out_2;
  output         D_wr_mem_out_1;
  output         D_wr_mem_out_2;
  output         D_cond_branch_out_1;
  output         D_cond_branch_out_2;
  output         D_uncond_branch_out_1;
  output         D_uncond_branch_out_2;
  output         D_rs_rd_brpTN_1;
  output         D_rs_rd_brpTN_2;
  output [63:0]  D_rs_rd_brp_TAR_PC_1;
  output [63:0]  D_rs_rd_brp_TAR_PC_2;
  output [4:0]   D_rs_rd_lsq_tail_1;
  output [4:0]   D_rs_rd_lsq_tail_2;
  output [2:0]   D_rs_rd_br_marker_1;
  output [2:0]   D_rs_rd_br_marker_2;
  output [3:0]   D_rs_rd_bmask_1;
  output [3:0]   D_rs_rd_bmask_2;
  output [15:0]  D_rs_inst_status;
  output [1:0]   D_stall;
  output         retire_load;
  output         retire_store;
  output         system_halt;
  // 
  output         rob_br_mispredict;
  output [63:0]  rob_br_mispredict_target_PC;
  output [2:0]   rob_br_marker_1;
  output [2:0]   rob_br_marker_2;
  output         rob_br_retire_en_out_1;
  output         rob_br_retire_en_out_2;

  // output for LSQ
  output        lsq_wr_en_out_1;
  output        lsq_wr_en_out_2;
  output        lsq_rd_en_out_1;
  output        lsq_rd_en_out_2;
  output  [5:0] lsq_rd_dest_idx_out_1;
  output  [5:0] lsq_rd_dest_idx_out_2;
  output [63:0] lsq_NPC_out_1;
  output [63:0] lsq_NPC_out_2;
  output        lsq_br_inst_out_1;
  output        lsq_br_inst_out_2;

  // testbench signal
  output [63:0]  Retire_NPC_out_1;
  output [63:0]  Retire_NPC_out_2;
  output [5:0]   Retire_wr_idx_1;
  output [5:0]   Retire_wr_idx_2;
  output [63:0]  Retire_wr_data_1;
  output [63:0]  Retire_wr_data_2;
  output         Retire_wr_en_1;
  output         Retire_wr_en_2;

  output [63:0]  Dispatch_NPC_1;
  output [63:0]  Dispatch_NPC_2;
  output [5:0]   Dispatch_T_1;
  output         Dispatch_T_en_1;
  output [5:0]   Dispatch_T_2;
  output         Dispatch_T_en_2;
  output [5:0]   Dispatch_Told_1;
  output [5:0]   Dispatch_Told_2;
  output [5:0]   Dispatch_rega_1;
  output         Dispatch_rega_plus_1;
  output [5:0]   Dispatch_rega_2;
  output         Dispatch_rega_plus_2;
  output [5:0]   Dispatch_regb_1;
  output         Dispatch_regb_plus_1;
  output [5:0]   Dispatch_regb_2;
  output         Dispatch_regb_plus_2;
  output         Dispatch_valid_inst_1;
  output         Dispatch_valid_inst_2;
  output         pipeline_commit_halt_on_2_signal;


  // Output from decoder
  wire   [4:0]  id_ra_reg_idx_out_1;
  wire   [4:0]  id_rb_reg_idx_out_1;
  wire   [1:0]  id_opa_select_out_1;
  wire   [1:0]  id_opb_select_out_1;
  wire   [4:0]  id_dest_reg_idx_out_1;
  wire   [4:0]  id_alu_func_out_1;
  wire          id_rd_mem_out_1;
  wire          id_wr_mem_out_1;
  wire          id_cond_branch_out_1;
  wire          id_uncond_branch_out_1;
  wire          id_halt_out_1;
  wire          id_illegal_out_1;
  wire          id_valid_inst_out_1;
  wire          dispatch_en_1;
  wire          id_wb_en_1;
  wire          id_br_en_1;
  wire          id_noop_out_1;

  wire   [4:0]  id_ra_reg_idx_out_2;
  wire   [4:0]  id_rb_reg_idx_out_2;
  wire   [1:0]  id_opa_select_out_2;
  wire   [1:0]  id_opb_select_out_2;
  wire   [4:0]  id_dest_reg_idx_out_2;
  wire   [4:0]  id_alu_func_out_2;
  wire          id_rd_mem_out_2;
  wire          id_wr_mem_out_2;
  wire          id_cond_branch_out_2;
  wire          id_uncond_branch_out_2;
  wire          id_halt_out_2;
  wire          id_illegal_out_2;
  wire          id_valid_inst_out_2;
  wire          dispatch_en_2;
  wire          id_wb_en_2;
  wire          id_br_en_2;
  wire          id_noop_out_2;

  // Output from reservation station
  wire   [15:0] D_rs_inst_status_1;
  wire   [15:0] D_rs_inst_status_2;
  wire   [1:0]  rs_stall;

  // Output from rob
  wire   [5:0]  rob_T_out_1;
  wire   [5:0]  rob_T_out_2;
  wire   [5:0]  rob_Told_out_1;
  wire   [5:0]  rob_Told_out_2;
  wire          rob_T_valid_1;
  wire          rob_T_valid_2;
  wire   [1:0]  rob_stall; 
  wire   [63:0] retire_NPC_out_1;
  wire   [63:0] retire_NPC_out_2;
  wire   [63:0] retire_wb_data_out_1;
  wire   [63:0] retire_wb_data_out_2;
  wire   [2:0]  rob_br_mispredict_marker;


  // Output from map table
  wire   [5:0]  ra_reg_idx_out_1;
  wire   [5:0]  ra_reg_idx_out_2;
  wire   [5:0]  rb_reg_idx_out_1;
  wire   [5:0]  rb_reg_idx_out_2;
  wire          ra_reg_ready_out_1;
  wire          ra_reg_ready_out_2;
  wire          rb_reg_ready_out_1;
  wire          rb_reg_ready_out_2;
  wire   [5:0]  mt_dest_reg_old_1;
  wire   [5:0]  mt_dest_reg_old_2;

  // output from arcitecture map
  wire   [4:0]  arch_wr_idx_1;
  wire   [4:0]  arch_wr_idx_2;

  // Output from free list
  wire   [5:0]  fl_T_1_out;  // free list output
  wire   [5:0]  fl_T_2_out;
  wire   [5:0]  fl_T_1;      // dest tag send to rs and rob
  wire   [5:0]  fl_T_2;
  wire          fl_R_en_1;   // free reg enable signal
  wire          fl_R_en_2;
  wire   [1:0]  fl_stall;


  // structral hazard
  assign D_stall[0] = rs_stall[0] | rob_stall[0] | fl_stall[0];
  assign D_stall[1] = rs_stall[1] | rob_stall[1] | fl_stall[1];
  //////////////////////////////////////////////////
  //                                              //
  //                  testbench                   //
  //                                              //
  //////////////////////////////////////////////////
  assign Retire_NPC_out_1 = retire_NPC_out_1;
  assign Retire_NPC_out_2 = retire_NPC_out_2;
//  assign Retire_wr_idx_1  = rob_T_out_1;
//  assign Retire_wr_idx_2  = rob_T_out_2; 
  assign Retire_wr_idx_1  = arch_wr_idx_1;
  assign Retire_wr_idx_2  = arch_wr_idx_2;
  assign Retire_wr_data_1 = retire_wb_data_out_1;
  assign Retire_wr_data_2 = retire_wb_data_out_2;
  assign Retire_wr_en_1   = rob_T_valid_1;
  assign Retire_wr_en_2   = rob_T_valid_2;

  assign Dispatch_NPC_1        = if_id_NPC_1;
  assign Dispatch_NPC_2        = if_id_NPC_2;
  assign Dispatch_T_1          = fl_T_1;
  assign Dispatch_T_en_1       = id_wb_en_1;
  assign Dispatch_T_2          = fl_T_2;
  assign Dispatch_T_en_2       = id_wb_en_2;
  assign Dispatch_Told_1       = mt_dest_reg_old_1;
  assign Dispatch_Told_2       = mt_dest_reg_old_2;
  assign Dispatch_rega_1       = ra_reg_idx_out_1;
  assign Dispatch_rega_plus_1  = ra_reg_ready_out_1;
  assign Dispatch_rega_2       = ra_reg_idx_out_2;
  assign Dispatch_rega_plus_2  = ra_reg_ready_out_2;
  assign Dispatch_regb_1       = rb_reg_idx_out_1;
  assign Dispatch_regb_plus_1  = rb_reg_ready_out_1;
  assign Dispatch_regb_2       = rb_reg_idx_out_2;
  assign Dispatch_regb_plus_2  = rb_reg_ready_out_2;
  assign Dispatch_valid_inst_1 = dispatch_en_1;
  assign Dispatch_valid_inst_2 = dispatch_en_2;



  //////////////////////////////////////////////////
  //                                              //
  //                     LSQ                      //
  //                                              //
  //////////////////////////////////////////////////

  assign lsq_wr_en_out_1       = (dispatch_en_1)? id_wr_mem_out_1: 0;
  assign lsq_rd_en_out_1       = (dispatch_en_1)? id_rd_mem_out_1: 0;
  assign lsq_rd_dest_idx_out_1 = fl_T_1;
  assign lsq_NPC_out_1         = if_id_NPC_1;
  assign lsq_wr_en_out_2       = (dispatch_en_2)? id_wr_mem_out_2: 0;
  assign lsq_rd_en_out_2       = (dispatch_en_2)? id_rd_mem_out_2: 0;
  assign lsq_rd_dest_idx_out_2 = fl_T_2;
  assign lsq_NPC_out_2         = if_id_NPC_2;

  //////////////////////////////////////////////////
  //                                              //
  //                   decoder                    //
  //                                              //
  //////////////////////////////////////////////////
  id decoder0(// Inputs
             .clock(clock),
             .reset(reset),
             .if_id_IR(if_id_IR_1),
             .if_id_valid_inst(if_id_valid_inst_1),

             // Outputs
             .id_ra_reg_idx_out(id_ra_reg_idx_out_1),
             .id_rb_reg_idx_out(id_rb_reg_idx_out_1),
             .id_opa_select_out(id_opa_select_out_1),
             .id_opb_select_out(id_opb_select_out_1),
             .id_dest_reg_idx_out(id_dest_reg_idx_out_1),
             .id_alu_func_out(id_alu_func_out_1),
             .id_rd_mem_out(id_rd_mem_out_1),
             .id_wr_mem_out(id_wr_mem_out_1),
             .id_cond_branch_out(id_cond_branch_out_1),
             .id_uncond_branch_out(id_uncond_branch_out_1),
             .id_halt_out(id_halt_out_1),
             .id_illegal_out(id_illegal_out_1),
             .id_valid_inst_out(id_valid_inst_out_1)
            );

  assign dispatch_en_1 = id_valid_inst_out_1 & !rob_br_mispredict;
  assign id_wb_en_1 = dispatch_en_1 & (id_dest_reg_idx_out_1!=`ZERO_REG);
  assign id_br_en_1 = id_cond_branch_out_1 || id_uncond_branch_out_1;
  assign lsq_br_inst_out_1 = dispatch_en_1 & (id_cond_branch_out_1 | id_uncond_branch_out_1);
  assign id_noop_out_1 = (dispatch_en_1 && if_id_IR_1==`NOOP_INST)? 1:0;

  id decoder1(// Inputs
             .clock(clock),
             .reset(reset),
             .if_id_IR(if_id_IR_2),
             .if_id_valid_inst(if_id_valid_inst_2),

             // Outputs
             .id_ra_reg_idx_out(id_ra_reg_idx_out_2),
             .id_rb_reg_idx_out(id_rb_reg_idx_out_2),
             .id_opa_select_out(id_opa_select_out_2),
             .id_opb_select_out(id_opb_select_out_2),
             .id_dest_reg_idx_out(id_dest_reg_idx_out_2),
             .id_alu_func_out(id_alu_func_out_2),
             .id_rd_mem_out(id_rd_mem_out_2),
             .id_wr_mem_out(id_wr_mem_out_2),
             .id_cond_branch_out(id_cond_branch_out_2),
             .id_uncond_branch_out(id_uncond_branch_out_2),
             .id_halt_out(id_halt_out_2),
             .id_illegal_out(id_illegal_out_2),
             .id_valid_inst_out(id_valid_inst_out_2)
            );

  assign dispatch_en_2 = id_valid_inst_out_2 & !rob_br_mispredict;
  assign id_wb_en_2 = dispatch_en_2 & (id_dest_reg_idx_out_2!=`ZERO_REG);
  assign id_br_en_2 = id_cond_branch_out_2 || id_uncond_branch_out_2;
  assign lsq_br_inst_out_2 = dispatch_en_2 & (id_cond_branch_out_2 | id_uncond_branch_out_2);
  assign id_noop_out_2 = (dispatch_en_2 && if_id_IR_2==`NOOP_INST)? 1:0;

  //////////////////////////////////////////////////
  //                                              //
  //            Reservation Station               //
  //                                              //
  //////////////////////////////////////////////////

  wire  [4:0]   LSQ_rs_wr_data_lsq_tail_in_1 = (id_rd_mem_out_1 || id_wr_mem_out_1)? LSQ_rs_wr_data_lsq_tail_1: 5'b10000;
  wire  [4:0]   LSQ_rs_wr_data_lsq_tail_in_2 = ((id_rd_mem_out_1 || id_wr_mem_out_1) && (id_rd_mem_out_2 || id_wr_mem_out_2))? LSQ_rs_wr_data_lsq_tail_2:
                                               (id_rd_mem_out_1 || id_wr_mem_out_1)? 5'b10000:LSQ_rs_wr_data_lsq_tail_1;

  rs rs (// Input
        .reset(reset || rob_br_mispredict),
        .clock(clock),
        .rs_clear_enable_1(X_rs_clear_en_1),
        .rs_clear_enable_2(X_rs_clear_en_2),
        .rs_clear_position_1(X_rs_clear_inst_1),
        .rs_clear_position_2(X_rs_clear_inst_2),
        .rs_wr_enable_1(dispatch_en_1),
        .rs_wr_enable_2(dispatch_en_2),
        .rs_wr_data_op_1(id_alu_func_out_1),
        .rs_wr_data_op_2(id_alu_func_out_2),
        .rs_wr_data_T_1(fl_T_1),
        .rs_wr_data_T_2(fl_T_2),
        .rs_wr_data_T1_1(ra_reg_idx_out_1),
        .rs_wr_data_T1_2(ra_reg_idx_out_2),
        .rs_wr_data_T1plus_1(ra_reg_ready_out_1),
        .rs_wr_data_T1plus_2(ra_reg_ready_out_2),
        .rs_wr_data_T2_1(rb_reg_idx_out_1),
        .rs_wr_data_T2_2(rb_reg_idx_out_2),
        .rs_wr_data_T2plus_1(rb_reg_ready_out_1),
        .rs_wr_data_T2plus_2(rb_reg_ready_out_2),
        .rs_wr_data_opa_select_1(id_opa_select_out_1),
        .rs_wr_data_opa_select_2(id_opa_select_out_2),
        .rs_wr_data_opb_select_1(id_opb_select_out_1),
        .rs_wr_data_opb_select_2(id_opb_select_out_2),
        .rs_wr_data_rd_mem_1(id_rd_mem_out_1),
        .rs_wr_data_rd_mem_2(id_rd_mem_out_2),
        .rs_wr_data_wr_mem_1(id_wr_mem_out_1),
        .rs_wr_data_wr_mem_2(id_wr_mem_out_2),
        .rs_wr_data_IR_1(if_id_IR_1),
        .rs_wr_data_IR_2(if_id_IR_2),
        .rs_wr_data_NPC_1(if_id_NPC_1),
        .rs_wr_data_NPC_2(if_id_NPC_2),
        .rs_wr_data_cond_branch_1(id_cond_branch_out_1),
        .rs_wr_data_cond_branch_2(id_cond_branch_out_2),
        .rs_wr_data_uncond_branch_1(id_uncond_branch_out_1),
        .rs_wr_data_uncond_branch_2(id_uncond_branch_out_2),
        .rs_write_CDB_en_1(C_cdb_en_1),
        .rs_write_CDB_en_2(C_cdb_en_2),
        .rs_search_CDB_value_in_1(C_cdb_idx_1),
        .rs_search_CDB_value_in_2(C_cdb_idx_2),
        .rs_rd_position_1(I_rs_rd_inst_1),
        .rs_rd_position_2(I_rs_rd_inst_2),
        .rs_clear_bmask_bits_1(3'd4),
        .rs_clear_bmask_bits_2(3'd4),
        .rs_bmask_clear_location_1(3'd4),
        .rs_bmask_clear_location_2(3'd4),
        .rs_wr_data_bmask_1(if_D_bmask_1),
        .rs_wr_data_bmask_2(if_D_bmask_2),
        .rs_wr_data_br_marker_1(if_D_br_marker_1),
        .rs_wr_data_br_marker_2(if_D_br_marker_2),
        .rs_wr_data_brpTN_1(F_rs_wr_data_brpTN_1),
        .rs_wr_data_brpTN_2(F_rs_wr_data_brpTN_2),
        .rs_wr_data_brp_TAR_PC_1(F_rs_wr_data_brp_TAR_PC_1),
        .rs_wr_data_brp_TAR_PC_2(F_rs_wr_data_brp_TAR_PC_2),
        .rs_wr_data_lsq_tail_1(LSQ_rs_wr_data_lsq_tail_in_1),
        .rs_wr_data_lsq_tail_2(LSQ_rs_wr_data_lsq_tail_in_2),

        // Output
        .rs_rd_op_1(D_alu_func_out_1),
        .rs_rd_op_2(D_alu_func_out_2),
        .rs_rd_T_1(D_dest_reg_idx_out_1),
        .rs_rd_T_2(D_dest_reg_idx_out_2),
        .rs_rd_T1_1(D_opa_reg_idx_out_1),
        .rs_rd_T1_2(D_opa_reg_idx_out_2),
        .rs_rd_T1plus_1(),
        .rs_rd_T1plus_2(),
        .rs_rd_T2_1(D_opb_reg_idx_out_1),
        .rs_rd_T2_2(D_opb_reg_idx_out_2),
        .rs_rd_T2plus_1(),
        .rs_rd_T2plus_2(),
        .rs_rd_opa_select_1(D_opa_select_out_1),
        .rs_rd_opa_select_2(D_opa_select_out_2),
        .rs_rd_opb_select_1(D_opb_select_out_1),
        .rs_rd_opb_select_2(D_opb_select_out_2),
        .rs_rd_IR_1(D_IR_1),
        .rs_rd_IR_2(D_IR_2),
        .rs_rd_NPC_1(D_NPC_1),
        .rs_rd_NPC_2(D_NPC_2),
        .rs_rd_rd_mem_1(D_rd_mem_out_1),
        .rs_rd_rd_mem_2(D_rd_mem_out_2),
        .rs_rd_wr_mem_1(D_wr_mem_out_1),
        .rs_rd_wr_mem_2(D_wr_mem_out_2),
        .rs_rd_cond_branch_1(D_cond_branch_out_1),
        .rs_rd_cond_branch_2(D_cond_branch_out_2),
        .rs_rd_uncond_branch_1(D_uncond_branch_out_1),
        .rs_rd_uncond_branch_2(D_uncond_branch_out_2),
        .rs_rd_brpTN_1(D_rs_rd_brpTN_1),
        .rs_rd_brpTN_2(D_rs_rd_brpTN_2),
        .rs_rd_brp_TAR_PC_1(D_rs_rd_brp_TAR_PC_1),
        .rs_rd_brp_TAR_PC_2(D_rs_rd_brp_TAR_PC_2),
        .rs_rd_lsq_tail_1(D_rs_rd_lsq_tail_1),
        .rs_rd_lsq_tail_2(D_rs_rd_lsq_tail_2),
        .rs_rd_br_marker_1(D_rs_rd_br_marker_1),
        .rs_rd_br_marker_2(D_rs_rd_br_marker_2),
        .rs_rd_bmask_1(D_rs_rd_bmask_1),
        .rs_rd_bmask_2(D_rs_rd_bmask_2),
        .rs_rd_T1plus_all(D_rs_inst_status_1),
        .rs_rd_T2plus_all(D_rs_inst_status_2),
        .pre_str_hazard(rs_stall)
       );
  assign D_rs_inst_status = (D_rs_inst_status_1 & D_rs_inst_status_2);

  //////////////////////////////////////////////////
  //                                              //
  //                    ROB                       //
  //                                              //
  //////////////////////////////////////////////////
  rob rob (// Input
          .clock(clock),
          .reset(reset),
          .T_in_1(fl_T_1),
          .T_in_2(fl_T_2),
          .Told_in_1(mt_dest_reg_old_1),
          .Told_in_2(mt_dest_reg_old_2),
          .id_wr_mem_in_1(id_wr_mem_out_1),
          .id_wr_mem_in_2(id_wr_mem_out_2),
          .id_rd_mem_in_1(id_rd_mem_out_1),
          .id_rd_mem_in_2(id_rd_mem_out_2),
          .id_cond_branch_in_1(id_cond_branch_out_1),
          .id_cond_branch_in_2(id_cond_branch_out_2),
          .id_uncond_branch_in_1(id_uncond_branch_out_1),
          .id_uncond_branch_in_2(id_uncond_branch_out_2),
          .id_halt_in_1(id_halt_out_1),
          .id_halt_in_2(id_halt_out_2),
          .id_noop_in_1(id_noop_out_1),
          .id_noop_in_2(id_noop_out_2),
          .id_br_in_1(id_br_en_1),
          .id_br_in_2(id_br_en_2),
          .NPC_1(if_id_NPC_1),
          .NPC_2(if_id_NPC_2),
          .br_wr_en_1(id_br_en_1),
          .br_wr_en_2(id_br_en_2),
          .br_marker_in_1(if_D_br_marker_1),
          .br_marker_in_2(if_D_br_marker_2),
          .br_mispredict(rob_br_mispredict),
          .br_mispre_marker(rob_br_mispredict_marker),
          .T_wr_en_1(dispatch_en_1),
          .T_wr_en_2(dispatch_en_2),
          .C_tag_1(C_cdb_idx_1),
          .C_tag_2(C_cdb_idx_2),
          .C_wr_en_1(C_cdb_en_1),
          .C_wr_en_2(C_cdb_en_2),
          .C_wb_data_1(C_cdb_data_1),
          .C_wb_data_2(C_cdb_data_2),
          .X_br_wr_en_1(X_br_wr_en_1),
          .X_br_wr_en_2(X_br_wr_en_2),
          .X_br_marker_1(X_br_marker_1),
          .X_br_marker_2(X_br_marker_2),
          .X_br_taken_1(X_br_taken_1),
          .X_br_taken_2(X_br_taken_2),
          .X_br_target_PC_1(X_br_target_PC_1),
          .X_br_target_PC_2(X_br_target_PC_2),
          .LSQ_wr_mem_finished(LSQ_wr_mem_finished),

          // Output
          .T_out_1(rob_T_out_1),
          .T_out_2(rob_T_out_2),
          .Told_out_1(rob_Told_out_1),
          .Told_out_2(rob_Told_out_2),
          .T_valid_1(rob_T_valid_1),
          .T_valid_2(rob_T_valid_2),
          .rob_halt(system_halt),
          .rob_load(retire_load),
          .rob_store(retire_store),
          .rob_stall(rob_stall),
          .NPC_out_1(retire_NPC_out_1),
          .NPC_out_2(retire_NPC_out_2),
          .wb_data_out_1(retire_wb_data_out_1),
          .wb_data_out_2(retire_wb_data_out_2),

          .rob_br_mispredict(rob_br_mispredict),
          .rob_br_mispredict_target_PC(rob_br_mispredict_target_PC),
          .rob_br_mispredict_marker(rob_br_mispredict_marker),
          .rob_br_marker_1(rob_br_marker_1),
          .rob_br_marker_2(rob_br_marker_2),
          .rob_br_retire_en_1(rob_br_retire_en_out_1),
          .rob_br_retire_en_2(rob_br_retire_en_out_2),
          .pipeline_commit_halt_on_2_signal(pipeline_commit_halt_on_2_signal)
          );

  //////////////////////////////////////////////////
  //                                              //
  //                 Map Table                    //
  //                                              //
  //////////////////////////////////////////////////
  mapTable maptable(// Input
                   .clock(clock),
                   .reset(reset),
                   .id_ra_reg_idx_in_1(id_ra_reg_idx_out_1),
                   .id_ra_reg_idx_in_2(id_ra_reg_idx_out_2),
                   .id_rb_reg_idx_in_1(id_rb_reg_idx_out_1),
                   .id_rb_reg_idx_in_2(id_rb_reg_idx_out_2),
                   .id_dest_reg_idx_in_1(id_dest_reg_idx_out_1),
                   .id_dest_reg_idx_in_2(id_dest_reg_idx_out_2),
                   .fl_wr_idx_in_1(fl_T_1),
                   .fl_wr_idx_in_2(fl_T_2),
                   .fl_wr_en_1(id_wb_en_1),
                   .fl_wr_en_2(id_wb_en_2),
                   .cdb_wr_idx_1(C_cdb_idx_1),
                   .cdb_wr_idx_2(C_cdb_idx_2),
                   .cdb_wr_en_1(C_cdb_en_1),
                   .cdb_wr_en_2(C_cdb_en_2),
                   .br_wr_en_1(id_br_en_1),
                   .br_wr_en_2(id_br_en_2),
                   .br_marker_in_1(if_D_br_marker_1),
                   .br_marker_in_2(if_D_br_marker_2),
                   .br_mispredict(rob_br_mispredict),
                   .br_mispre_marker(rob_br_mispredict_marker),

                   // Output
                   .ra_reg_idx_out_1(ra_reg_idx_out_1),
                   .ra_reg_idx_out_2(ra_reg_idx_out_2),
                   .rb_reg_idx_out_1(rb_reg_idx_out_1),
                   .rb_reg_idx_out_2(rb_reg_idx_out_2),
                   .ra_reg_ready_out_1(ra_reg_ready_out_1),
                   .ra_reg_ready_out_2(ra_reg_ready_out_2),
                   .rb_reg_ready_out_1(rb_reg_ready_out_1),
                   .rb_reg_ready_out_2(rb_reg_ready_out_2),
                   .mt_dest_reg_old_1(mt_dest_reg_old_1),
                   .mt_dest_reg_old_2(mt_dest_reg_old_2)
                   );

  //////////////////////////////////////////////////
  //                                              //
  //              Architecture Map                //
  //                                              //
  //////////////////////////////////////////////////
  archMap archMap(// Inputs
                 .clock(clock),
                 .reset(reset),
                 .arch_wr_idx_1(rob_Told_out_1),   // rob Told
                 .arch_wr_idx_2(rob_Told_out_2),
                 .arch_wr_in_1(rob_T_out_1),    // rob T 
                 .arch_wr_in_2(rob_T_out_2),
                 .arch_wr_en_1(rob_T_valid_1),
                 .arch_wr_en_2(rob_T_valid_2),

                 // Output
                 .arch_idx_out_1(arch_wr_idx_1),
                 .arch_idx_out_2(arch_wr_idx_2)
                );

  //////////////////////////////////////////////////
  //                                              //
  //                 Free List                    //
  //                                              //
  //////////////////////////////////////////////////
  freeList freelist(// Input
                   .clock(clock),
                   .reset(reset),
                   .rob_Told_1(rob_Told_out_1),
                   .rob_Told_2(rob_Told_out_2),
                   .br_wr_en_1(id_br_en_1),
                   .br_wr_en_2(id_br_en_2),
                   .br_marker_in_1(if_D_br_marker_1),
                   .br_marker_in_2(if_D_br_marker_2),
                   .br_mispredict(rob_br_mispredict),
                   .br_mispre_marker(rob_br_mispredict_marker),
                   .D_en_1(id_wb_en_1),
                   .D_en_2(id_wb_en_2),
                   .R_en_1(fl_R_en_1),
                   .R_en_2(fl_R_en_2),

                   // Output
                   .fl_T_1(fl_T_1_out),
                   .fl_T_2(fl_T_2_out),
                   .fl_stall(fl_stall)
                  );
  assign fl_R_en_1 = rob_T_valid_1 && rob_Told_out_1!=`ZERO_REG;
  assign fl_R_en_2 = rob_T_valid_2 && rob_Told_out_2!=`ZERO_REG;
  assign fl_T_1 = (id_wb_en_1)? fl_T_1_out: `ZERO_REG;
  assign fl_T_2 = (id_wb_en_2)? fl_T_2_out: `ZERO_REG;


endmodule

