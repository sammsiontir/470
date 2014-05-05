`timescale 1ns/100ps

module pipeline (// Inputs
                 clock,
                 reset,
                 mem2proc_response,
                 mem2proc_data,
                 mem2proc_tag,
                 
                 // Outputs
                 proc2mem_command,
                 proc2mem_addr,
                 proc2mem_data,

                 pipeline_completed_insts,
                 pipeline_error_status,
                 pipeline_commit_wr_data_1,
                 pipeline_commit_wr_data_2,
                 pipeline_commit_wr_idx_1,
                 pipeline_commit_wr_idx_2,
                 pipeline_commit_wr_en_1,
                 pipeline_commit_wr_en_2,
                 pipeline_commit_NPC_1,
                 pipeline_commit_NPC_2,

                 pipeline_dispatch_NPC_1,
                 pipeline_dispatch_NPC_2,
                 pipeline_dispatch_T_1,
                 pipeline_dispatch_T_2,
                 pipeline_dispatch_Told_1,
                 pipeline_dispatch_Told_2,
                 pipeline_dispatch_rega_1,
                 pipeline_dispatch_rega_2,
                 pipeline_dispatch_regb_1,
                 pipeline_dispatch_regb_2,
                 pipeline_dispatch_valid_inst_1,
                 pipeline_dispatch_valid_inst_2,
                 pipeline_dispatch_T_valid_1,
                 pipeline_dispatch_T_valid_2,
                 pipeline_dispatch_rega_plus_1,
                 pipeline_dispatch_rega_plus_2,
                 pipeline_dispatch_regb_plus_1,
                 pipeline_dispatch_regb_plus_2,

                 pipeline_commit_halt_on_2_signal
                );

  input         clock;             // System clock
  input         reset;             // System reset
  input  [3:0]  mem2proc_response; // Tag from memory about current request
  input  [63:0] mem2proc_data;     // Data coming back from memory
  input  [3:0]  mem2proc_tag;      // Tag from memory about current reply

  output [1:0]  proc2mem_command;  // command sent to memory
  output [63:0] proc2mem_addr;     // Address sent to memory
  output [63:0] proc2mem_data;     // Data sent to memory

  output [3:0]  pipeline_completed_insts;
  output [3:0]  pipeline_error_status;
  output [5:0]  pipeline_commit_wr_idx_1;
  output [5:0]  pipeline_commit_wr_idx_2;
  output [63:0] pipeline_commit_wr_data_1;
  output [63:0] pipeline_commit_wr_data_2;
  output        pipeline_commit_wr_en_1;
  output        pipeline_commit_wr_en_2;
  output [63:0] pipeline_commit_NPC_1;
  output [63:0] pipeline_commit_NPC_2;

  output [63:0] pipeline_dispatch_NPC_1;
  output [63:0] pipeline_dispatch_NPC_2;
  output [5:0]  pipeline_dispatch_T_1;
  output [5:0]  pipeline_dispatch_T_2;
  output [5:0]  pipeline_dispatch_Told_1;
  output [5:0]  pipeline_dispatch_Told_2;
  output [5:0]  pipeline_dispatch_rega_1;
  output [5:0]  pipeline_dispatch_rega_2;
  output [5:0]  pipeline_dispatch_regb_1;
  output [5:0]  pipeline_dispatch_regb_2;
  output        pipeline_dispatch_valid_inst_1;
  output        pipeline_dispatch_valid_inst_2;
  output        pipeline_dispatch_T_valid_1;
  output        pipeline_dispatch_T_valid_2;
  output        pipeline_dispatch_rega_plus_1;
  output        pipeline_dispatch_rega_plus_2;
  output        pipeline_dispatch_regb_plus_1;
  output        pipeline_dispatch_regb_plus_2;

  output        pipeline_commit_halt_on_2_signal;



  // Memory interface/arbiter wires
  wire [63:0] proc2Dmem_addr, proc2Imem_addr;
  wire [1:0]  proc2Dmem_command, proc2Imem_command;
  wire [3:0]  Imem2proc_response, Dmem2proc_response;

  // Output form cache
  wire halt_pc_known;
  wire requesting_inst_exceed_bound;
  wire [63:0] Dcache_rd_data;
  wire        Dcache_rd_valid;

  // Output form Icache
  wire [63:0] cachemem_data;
  wire        cachemem_valid;
  wire        Icache_wr_en;
  wire [63:0] Icache_data_out;
  wire [63:0] proc2Icache_addr;
  wire        Icache_valid_out;

  wire [63:0] ctr2cache_wr_data;
  wire [63:0] ctr2cache_wr_addr;
  wire [63:0] ctr2cache_rd_addr;

  // Output form Dcache
  wire [63:0] Dcache_ctr2lsq_rd_data;
  wire        Dcache_ctr2lsq_rd_valid;
  wire        Dcache_ctr2lsq_st_valid;
  wire  [3:0] Dcache_ctr2lsq_response;
  wire [63:0] Dcache_ctr2lsq_tag_data;
  wire  [3:0] Dcache_ctr2lsq_tag;
  wire [63:0] Dcache_ctr2cache_wr_addr;
  wire [63:0] Dcache_ctr2cache_wr_data;
  wire        Dcache_ctr2cache_wr_enable;
  wire [63:0] Dcache_ctr2cache_rd_addr;
  wire [63:0] Dcache_ctr2mem_req_addr;
  wire  [1:0] Dcache_ctr2mem_command;

  // Output from Branch predictor
  wire [63:0]ex_NPC;
  wire       ex_Dirp_cond;
  wire	     ex_Dirp_T;
  wire       inst_out_a_BP_Taken;
  wire       inst_out_b_BP_Taken;
  wire[63:0] inst_out_a_BP_targetPC;
  wire[63:0] inst_out_b_BP_targetPC;

  // Output from LSQ
  wire   [4:0]  LSQ_PreDe_tail_position;
  wire   [4:0]  LSQ_PreDe_tail_position_plus_one;

  wire   [5:0]  LSQ_Rob_destination;
  wire   [63:0] LSQ_Rob_data;
  wire   [63:0] LSQ_Rob_NPC;
  wire          LSQ_Rob_write_dest_n_data_en;             

  wire          LSQ_Dcash_load_address_en;
  wire   [63:0] LSQ_Dcash_load_address;
  wire          LSQ_Dcash_store_address_en;
  wire   [63:0] LSQ_Dcash_store_address;
  wire   [63:0] LSQ_Dcash_store_data;
  wire          LSQ_stall;

  // Input for Fetch stage
  wire [1:0] F_stall_in;

  // Output from Fetch stage
  wire   [63:0] if_NPC_out_1;
  wire   [63:0] if_NPC_out_2;
  wire   [31:0] if_IR_out_1;
  wire   [31:0] if_IR_out_2;
  wire          if_valid_inst_out_1;
  wire          if_valid_inst_out_2;
  wire          bmask_wr_en_1;
  wire          bmask_wr_en_2;

  // Output from pre_decoder
  wire          pre_cond_branch_1;
  wire          pre_cond_branch_2;
  wire          pre_uncond_branch_1;
  wire          pre_uncond_branch_2;
  wire          pre_bsr_branch_1;
  wire          pre_bsr_branch_2;
  wire          pre_ret_branch_1;
  wire          pre_ret_branch_2;
  wire          pre_is_ldq_1;
  wire          pre_is_ldq_2;
  wire          bsr_branch_1;
  wire          bsr_branch_2;
  wire          ret_branch_1;
  wire          ret_branch_2;

  // Output from bmask generator
  wire   [2:0]  br_marker_1;
  wire   [2:0]  br_marker_2;
  wire   [3:0]  bmask1;
  wire   [3:0]  bmask2;
  wire   [1:0]  bmask_stall;

  // Output from Fetch Dispatch pipeline register
  reg    [63:0] if_D_NPC_1;
  reg    [63:0] if_D_NPC_2;
  reg    [31:0] if_D_IR_1;
  reg    [31:0] if_D_IR_2;
  reg           if_D_valid_inst_1;
  reg           if_D_valid_inst_2;
  reg    [2:0]  if_D_br_marker_1;
  reg    [2:0]  if_D_br_marker_2;
  reg    [3:0]  if_D_bmask1;
  reg    [3:0]  if_D_bmask2;
  reg           F_rs_wr_data_brpTN_1;
  reg           F_rs_wr_data_brpTN_2;
  reg    [63:0] F_rs_wr_data_brp_TAR_PC_1;
  reg    [63:0] F_rs_wr_data_brp_TAR_PC_2;

  // Output from Dispatch stage
  wire   [31:0] D_IR_1;
  wire   [31:0] D_IR_2;
  wire   [63:0] D_NPC_1;
  wire   [63:0] D_NPC_2;
  wire   [5:0]  D_opa_reg_idx_out_1;
  wire   [5:0]  D_opa_reg_idx_out_2;
  wire   [5:0]  D_opb_reg_idx_out_1;
  wire   [5:0]  D_opb_reg_idx_out_2;
  wire   [5:0]  D_dest_reg_idx_out_1;
  wire   [5:0]  D_dest_reg_idx_out_2;
  wire   [1:0]  D_opa_select_out_1;
  wire   [1:0]  D_opa_select_out_2;
  wire   [1:0]  D_opb_select_out_1;
  wire   [1:0]  D_opb_select_out_2;
  wire   [4:0]  D_alu_func_out_1;
  wire   [4:0]  D_alu_func_out_2;
  wire          D_rd_mem_out_1;
  wire          D_rd_mem_out_2;
  wire          D_wr_mem_out_1;
  wire          D_wr_mem_out_2;
  wire          D_cond_branch_out_1;
  wire          D_cond_branch_out_2;
  wire          D_uncond_branch_out_1;
  wire          D_uncond_branch_out_2;
  wire          D_rs_rd_brpTN_out_1;
  wire          D_rs_rd_brpTN_out_2;
  wire   [63:0] D_rs_rd_brp_TAR_PC_out_1;
  wire   [63:0] D_rs_rd_brp_TAR_PC_out_2;
  wire   [4:0]  D_rs_rd_lsq_tail_out_1;
  wire   [4:0]  D_rs_rd_lsq_tail_out_2;
  wire   [2:0]  D_rs_rd_br_marker_out_1;
  wire   [2:0]  D_rs_rd_br_marker_out_2;
  wire   [3:0]  D_rs_rd_bmask_out_1;
  wire   [3:0]  D_rs_rd_bmask_out_2;
  wire   [15:0] D_rs_inst_status;
  wire   [1:0]  D_stall;
  wire          retire_store;
  wire          retire_load;
  wire          system_halt;
   // LSQ
  wire          D_lsq_wr_en_out_1;
  wire          D_lsq_wr_en_out_2;
  wire          D_lsq_rd_en_out_1;
  wire          D_lsq_rd_en_out_2;
  wire   [5:0]  D_lsq_rd_dest_idx_out_1;
  wire   [5:0]  D_lsq_rd_dest_idx_out_2;
  wire   [63:0] D_lsq_NPC_out_1;
  wire   [63:0] D_lsq_NPC_out_2;
  wire          D_lsq_br_inst_out_1;
  wire          D_lsq_br_inst_out_2;

  // branch
  wire          rob_br_mispredict;
  wire   [63:0] rob_br_mispredict_target_PC;
  wire   [2:0]  rob_br_marker_1;
  wire   [2:0]  rob_br_marker_2;
  wire          rob_br_retire_en_out_1;
  wire          rob_br_retire_en_out_2;


   // Testbench
  wire   [63:0]  Retire_NPC_out_1;
  wire   [63:0]  Retire_NPC_out_2;
  wire   [5:0]   Retire_wr_idx_1;
  wire   [5:0]   Retire_wr_idx_2;
  wire   [63:0]  Retire_wr_data_1;
  wire   [63:0]  Retire_wr_data_2;
  wire           Retire_wr_en_1;
  wire           Retire_wr_en_2;
  wire   [63:0]  Dispatch_NPC_1;
  wire   [63:0]  Dispatch_NPC_2;
  wire   [5:0]   Dispatch_T_1;
  wire           Dispatch_T_en_1;
  wire   [5:0]   Dispatch_T_2;
  wire           Dispatch_T_en_2;
  wire   [5:0]   Dispatch_Told_1;
  wire   [5:0]   Dispatch_Told_2;
  wire   [5:0]   Dispatch_rega_1;
  wire           Dispatch_rega_plus_1;
  wire   [5:0]   Dispatch_rega_2;
  wire           Dispatch_rega_plus_2;
  wire   [5:0]   Dispatch_regb_1;
  wire           Dispatch_regb_plus_1;
  wire   [5:0]   Dispatch_regb_2;
  wire           Dispatch_regb_plus_2;
  wire           Dispatch_valid_inst_1;
  wire           Dispatch_valid_inst_2;


  // Output from Dispatch Issue pipeline register
  reg    [15:0] D_I_rs_inst_status;


  // Output from Issue stage
  wire   [3:0]  I_rs_rd_inst_1;
  wire   [3:0]  I_rs_rd_inst_2;
  wire          I_rs_rd_inst_en_1;
  wire          I_rs_rd_inst_en_2;
  // ALU 0
  wire   [63:0] I_NPC_out_alu0;
  wire   [31:0] I_IR_out_alu0;
  wire   [63:0] I_rega_out_alu0;
  wire   [63:0] I_regb_out_alu0;
  wire   [5:0]  I_dest_reg_idx_out_alu0;
  wire   [1:0]  I_opa_select_out_alu0;
  wire   [1:0]  I_opb_select_out_alu0;
  wire   [4:0]  I_alu_func_out_alu0;
  wire          I_rd_mem_out_alu0;
  wire          I_wr_mem_out_alu0;
  wire          I_cond_branch_out_alu0;
  wire          I_uncond_branch_out_alu0;
  wire   [2:0]  I_br_marker_out_alu0;
  wire   [3:0]  I_bmask_out_alu0;
  wire          I_valid_inst_out_alu0;
  wire         I_rs_rd_brpTN_out_alu0;
  wire  [63:0] I_rs_rd_brp_TAR_PC_out_alu0;
  wire   [4:0] I_rs_rd_lsq_tail_out_alu0;

  // ALU 1
  wire   [63:0] I_NPC_out_alu1;
  wire   [31:0] I_IR_out_alu1;
  wire   [63:0] I_rega_out_alu1;
  wire   [63:0] I_regb_out_alu1;
  wire   [5:0]  I_dest_reg_idx_out_alu1;
  wire   [1:0]  I_opa_select_out_alu1;
  wire   [1:0]  I_opb_select_out_alu1;
  wire   [4:0]  I_alu_func_out_alu1;
  wire          I_rd_mem_out_alu1;
  wire          I_wr_mem_out_alu1;
  wire          I_cond_branch_out_alu1;
  wire          I_uncond_branch_out_alu1;
  wire   [2:0]  I_br_marker_out_alu1;
  wire   [3:0]  I_bmask_out_alu1;
  wire          I_valid_inst_out_alu1;
  wire         I_rs_rd_brpTN_out_alu1;
  wire  [63:0] I_rs_rd_brp_TAR_PC_out_alu1;
  wire   [4:0] I_rs_rd_lsq_tail_out_alu1;
  // ALU 2
  wire   [63:0] I_NPC_out_alu2;
  wire   [31:0] I_IR_out_alu2;
  wire   [63:0] I_rega_out_alu2;
  wire   [63:0] I_regb_out_alu2;
  wire   [5:0]  I_dest_reg_idx_out_alu2;
  wire   [1:0]  I_opa_select_out_alu2;
  wire   [1:0]  I_opb_select_out_alu2;
  wire   [4:0]  I_alu_func_out_alu2;
  wire          I_rd_mem_out_alu2;
  wire          I_wr_mem_out_alu2;
  wire          I_cond_branch_out_alu2;
  wire          I_uncond_branch_out_alu2;
  wire   [2:0]  I_br_marker_out_alu2;
  wire   [3:0]  I_bmask_out_alu2;
  wire          I_valid_inst_out_alu2;
  // ALU 3
  wire   [63:0] I_NPC_out_alu3;
  wire   [31:0] I_IR_out_alu3;
  wire   [63:0] I_rega_out_alu3;
  wire   [63:0] I_regb_out_alu3;
  wire   [5:0]  I_dest_reg_idx_out_alu3;
  wire   [1:0]  I_opa_select_out_alu3;
  wire   [1:0]  I_opb_select_out_alu3;
  wire   [4:0]  I_alu_func_out_alu3;
  wire          I_rd_mem_out_alu3;
  wire          I_wr_mem_out_alu3;
  wire          I_cond_branch_out_alu3;
  wire          I_uncond_branch_out_alu3;
  wire   [2:0]  I_br_marker_out_alu3;
  wire   [3:0]  I_bmask_out_alu3;
  wire          I_valid_inst_out_alu3;

  // Input for Issue Execution pipeline register
  reg    [3:0]  I_X_bmask_in_alu0;
  reg    [3:0]  I_X_bmask_in_alu1;
  reg    [3:0]  I_X_bmask_in_alu2;
  reg    [3:0]  I_X_bmask_in_alu3;

  // Output from Issue Execution pipeline register
  reg    [3:0]  I_X_rs_rd_inst_1;
  reg    [3:0]  I_X_rs_rd_inst_2;
  reg           I_X_rs_rd_inst_en_1;
  reg           I_X_rs_rd_inst_en_2;
  // ALU 0
  reg    [31:0] I_X_IR_alu0;
  reg    [63:0] I_X_NPC_alu0;
  reg    [63:0] I_X_opa_reg_value_out_alu0;
  reg    [63:0] I_X_opb_reg_value_out_alu0;
  reg    [5:0]  I_X_dest_reg_idx_out_alu0;
  reg    [1:0]  I_X_opa_select_out_alu0;
  reg    [1:0]  I_X_opb_select_out_alu0;
  reg    [4:0]  I_X_alu_func_out_alu0;
  reg           I_X_rd_mem_out_alu0;
  reg           I_X_wr_mem_out_alu0;
  reg           I_X_cond_branch_out_alu0;
  reg           I_X_uncond_branch_out_alu0;
  reg    [2:0]  I_X_br_marker_out_alu0;
  reg    [3:0]  I_X_bmask_out_alu0;
  reg           I_X_valid_inst_out_alu0;
  reg           I_X_rs_rd_brpTN_out_alu0;
  reg    [63:0] I_X_rs_rd_brp_TAR_PC_out_alu0;
  reg    [4:0]  I_X_rs_rd_lsq_tail_out_alu0;
  // ALU 1
  reg    [31:0] I_X_IR_alu1;
  reg    [63:0] I_X_NPC_alu1;
  reg    [63:0] I_X_opa_reg_value_out_alu1;
  reg    [63:0] I_X_opb_reg_value_out_alu1;
  reg    [5:0]  I_X_dest_reg_idx_out_alu1;
  reg    [1:0]  I_X_opa_select_out_alu1;
  reg    [1:0]  I_X_opb_select_out_alu1;
  reg    [4:0]  I_X_alu_func_out_alu1;
  reg           I_X_rd_mem_out_alu1;
  reg           I_X_wr_mem_out_alu1;
  reg           I_X_cond_branch_out_alu1;
  reg           I_X_uncond_branch_out_alu1;
  reg    [2:0]  I_X_br_marker_out_alu1;
  reg    [3:0]  I_X_bmask_out_alu1;
  reg           I_X_valid_inst_out_alu1;
  reg           I_X_rs_rd_brpTN_out_alu1;
  reg    [63:0] I_X_rs_rd_brp_TAR_PC_out_alu1;
  reg    [4:0]  I_X_rs_rd_lsq_tail_out_alu1;
  // ALU 2
  reg    [31:0] I_X_IR_alu2;
  reg    [63:0] I_X_NPC_alu2;
  reg    [63:0] I_X_opa_reg_value_out_alu2;
  reg    [63:0] I_X_opb_reg_value_out_alu2;
  reg    [5:0]  I_X_dest_reg_idx_out_alu2;
  reg    [1:0]  I_X_opa_select_out_alu2;
  reg    [1:0]  I_X_opb_select_out_alu2;
  reg    [4:0]  I_X_alu_func_out_alu2;
  reg           I_X_rd_mem_out_alu2;
  reg           I_X_wr_mem_out_alu2;
  reg           I_X_cond_branch_out_alu2;
  reg           I_X_uncond_branch_out_alu2;
  reg    [2:0]  I_X_br_marker_out_alu2;
  reg    [3:0]  I_X_bmask_out_alu2;
  reg           I_X_valid_inst_out_alu2;
  // ALU 3
  reg    [31:0] I_X_IR_alu3;
  reg    [63:0] I_X_NPC_alu3;
  reg    [63:0] I_X_opa_reg_value_out_alu3;
  reg    [63:0] I_X_opb_reg_value_out_alu3;
  reg    [5:0]  I_X_dest_reg_idx_out_alu3;
  reg    [1:0]  I_X_opa_select_out_alu3;
  reg    [1:0]  I_X_opb_select_out_alu3;
  reg    [4:0]  I_X_alu_func_out_alu3;
  reg           I_X_rd_mem_out_alu3;
  reg           I_X_wr_mem_out_alu3;
  reg           I_X_cond_branch_out_alu3;
  reg           I_X_uncond_branch_out_alu3;
  reg    [2:0]  I_X_br_marker_out_alu3;
  reg    [3:0]  I_X_bmask_out_alu3;
  reg           I_X_valid_inst_out_alu3;

  // Output from Execute stage
  wire   [63:0] X_NPC_out_alu0;
  wire   [63:0] X_alu_result_out_alu0;
  wire   [63:0] X_take_branch_target_out_alu0;
  wire          X_take_branch_out_alu0;
  wire          X_rd_mem_out_alu0;
  wire          X_wr_mem_out_alu0;
  wire          X_valid_inst_out_alu0;
  wire   [2:0]  X_br_marker_out_alu0;
  wire   [3:0]  X_bmask_out_alu0;
  wire   [2:0]  X_br_bmask_age_out_alu0;
  wire   [5:0]  X_dest_reg_idx_out_alu0;
  wire   [63:0] X_wr_men_value_out_alu0;
  wire          X_rs_rd_brpTN_out_alu0;
  wire   [63:0] X_rs_rd_brp_TAR_PC_out_alu0;
  wire   [4:0]  X_rs_rd_lsq_tail_out_alu0;

  wire   [63:0] X_NPC_out_alu1;
  wire   [63:0] X_alu_result_out_alu1;
  wire   [63:0] X_take_branch_target_out_alu1;
  wire          X_take_branch_out_alu1;
  wire          X_rd_mem_out_alu1;
  wire          X_wr_mem_out_alu1;
  wire          X_valid_inst_out_alu1;
  wire   [2:0]  X_br_marker_out_alu1;
  wire   [3:0]  X_bmask_out_alu1;
  wire   [2:0]  X_br_bmask_age_out_alu1;
  wire   [5:0]  X_dest_reg_idx_out_alu1;
  wire   [63:0] X_wr_men_value_out_alu1;
  wire          X_rs_rd_brpTN_out_alu1;
  wire   [63:0] X_rs_rd_brp_TAR_PC_out_alu1;
  wire   [4:0]  X_rs_rd_lsq_tail_out_alu1;

  wire   [63:0] X_NPC_out_alu2;
  wire   [63:0] X_alu_result_out_alu2;
  wire          X_take_branch_out_alu2;
  wire          X_valid_inst_out_alu2;
  wire   [3:0]  X_bmask_out_alu2;
  wire   [5:0]  X_dest_reg_idx_out_alu2;

  wire   [63:0] X_NPC_out_alu3;
  wire   [63:0] X_alu_result_out_alu3;
  wire          X_take_branch_out_alu3;
  wire          X_valid_inst_out_alu3;
  wire   [3:0]  X_bmask_out_alu3;
  wire   [5:0]  X_dest_reg_idx_out_alu3;

  wire   [2:0]  X_br_mispredict_marker;
  wire   [2:0]  X_br_marker_older;
  wire   [3:0]  X_br_bmask_older;
  wire   [3:0]  X_br_mispredict_bmask;
  wire   [2:0]  X_rs_clear_bmask_bits_1;
  wire   [2:0]  X_rs_clear_bmask_bits_2;
  wire   [2:0]  X_rs_bmask_clear_location_1;
  wire   [2:0]  X_rs_bmask_clear_location_2;
  wire   [63:0] X_br_mispredict_NPC1;
  wire   [63:0] X_br_mispredict_NPC2;
  wire          X_br_complete_en_1;
  wire          X_br_complete_en_2;
  wire          X_br_mispredict_1;
  wire          X_br_mispredict_2;

  wire          X_br_taken_1;
  wire          X_br_taken_2;
  wire          X_BP_taken1;
  wire          X_BP_taken2;
  wire   [63:0] X_BP_NPC1;
  wire   [63:0] X_BP_NPC2;

  // Output from Excute Complete pipeline register
  wire   [63:0] X_C_reg_wr_data_out_1;
  wire   [63:0] X_C_reg_wr_data_out_2;
  wire   [5:0]  X_C_reg_wr_idx_out_1;
  wire   [5:0]  X_C_reg_wr_idx_out_2;
  wire          X_C_reg_wr_en_out_1;
  wire          X_C_reg_wr_en_out_2;

  // Output from X/C buffer
  wire          lsq_wb_stall;
  reg           D_I_halt;

  //////////////////////////////////////////////////
  //                                              //
  //                 Testbench                    //
  //                                              //
  //////////////////////////////////////////////////
  assign pipeline_completed_insts = Retire_wr_en_1 + Retire_wr_en_2;
  assign pipeline_error_status = D_I_halt ? `HALTED_ON_HALT:`NO_ERROR;

  assign pipeline_commit_wr_idx_1  = Retire_wr_idx_1;
  assign pipeline_commit_wr_idx_2  = Retire_wr_idx_2;
  assign pipeline_commit_wr_data_1 = Retire_wr_data_1;
  assign pipeline_commit_wr_data_2 = Retire_wr_data_2;
  assign pipeline_commit_wr_en_1   = Retire_wr_en_1;
  assign pipeline_commit_wr_en_2   = Retire_wr_en_2;
  assign pipeline_commit_NPC_1     = Retire_NPC_out_1;
  assign pipeline_commit_NPC_2     = Retire_NPC_out_2;

  assign pipeline_dispatch_NPC_1   = Dispatch_NPC_1;
  assign pipeline_dispatch_NPC_2   = Dispatch_NPC_2;
  assign pipeline_dispatch_T_valid_1 = Dispatch_T_en_1;
  assign pipeline_dispatch_T_valid_2 = Dispatch_T_en_2;
  assign pipeline_dispatch_T_1     = Dispatch_T_1;
  assign pipeline_dispatch_T_2     = Dispatch_T_2;
  assign pipeline_dispatch_Told_1  = Dispatch_Told_1;
  assign pipeline_dispatch_Told_2  = Dispatch_Told_2;
  assign pipeline_dispatch_rega_1  = Dispatch_rega_1;
  assign pipeline_dispatch_rega_2  = Dispatch_rega_2;
  assign pipeline_dispatch_regb_1  = Dispatch_regb_1;
  assign pipeline_dispatch_regb_2  = Dispatch_regb_2;
  assign pipeline_dispatch_rega_plus_1  = Dispatch_rega_plus_1;
  assign pipeline_dispatch_rega_plus_2  = Dispatch_rega_plus_2;
  assign pipeline_dispatch_regb_plus_1  = Dispatch_regb_plus_1;
  assign pipeline_dispatch_regb_plus_2  = Dispatch_regb_plus_2;
  assign pipeline_dispatch_valid_inst_1 = Dispatch_valid_inst_1;
  assign pipeline_dispatch_valid_inst_2 = Dispatch_valid_inst_2;

  //////////////////////////////////////////////////
  //                                              //
  //                   Cache                      //
  //                                              //
  //////////////////////////////////////////////////
  assign proc2Dmem_command  = Dcache_ctr2mem_command;
  assign proc2Dmem_addr     = Dcache_ctr2mem_req_addr;
  assign proc2mem_command   = (proc2Dmem_command==`BUS_NONE)?proc2Imem_command:proc2Dmem_command;
  assign proc2mem_addr      = (proc2Dmem_command==`BUS_NONE)?proc2Imem_addr:proc2Dmem_addr;
  assign Dmem2proc_response = (proc2Dmem_command==`BUS_NONE) ? 0 : mem2proc_response;
  assign Imem2proc_response = (proc2Dmem_command==`BUS_NONE) ? mem2proc_response : 0;

  icachemem icontrol(// inputs
                       .clock(clock),
                       .reset(reset),
                       .wr_en(Icache_wr_en),
                       .wr_pc_reg(ctr2cache_wr_addr),
                       .wr_data(ctr2cache_wr_data),
                             
                       .rd_pc_reg(ctr2cache_rd_addr),
                       // outputs
                       .rd_data(cachemem_data),
                       .rd_valid(cachemem_valid)
                      );



  icache_controller icache_0(// inputs
			.clock(clock),
			.reset(reset),
                        .proc2ctr_rd_addr(proc2Icache_addr),
			.cache2ctr_rd_data(cachemem_data),
			.cache2ctr_rd_valid(cachemem_valid),
			.mem2ctr_tag(mem2proc_tag),
			.mem2ctr_response(Imem2proc_response),
                        .mem2ctr_wr_data(mem2proc_data),

			// outputs
			.ctr2proc_rd_data(Icache_data_out),
			.ctr2proc_rd_valid(Icache_valid_out),
                        .ctr2cache_wr_addr(ctr2cache_wr_addr),
                        .ctr2cache_wr_data(ctr2cache_wr_data),
			.ctr2cache_wr_enable(Icache_wr_en),
                        .ctr2cache_rd_addr(ctr2cache_rd_addr),
			.ctr2mem_req_addr(proc2Imem_addr),
			.ctr2mem_command(proc2Imem_command),
                        .halt_pc_known(halt_pc_known),
                        .requesting_inst_exceed_bound(requesting_inst_exceed_bound)
			);

  cache dcache_0(// inputs
                    .clock(clock),
                    .reset(reset), 
                    .wr_en(Dcache_ctr2cache_wr_enable),
                    .wr_data(Dcache_ctr2cache_wr_data),
                    .wr_pc_reg(Dcache_ctr2cache_wr_addr),

                     // outputs
                    .rd_pc_reg(Dcache_ctr2cache_rd_addr),
                    .rd_data(Dcache_rd_data),
                    .rd_valid(Dcache_rd_valid)
                    );



  dcache_controller dcontrol(// inputs
			    .clock(clock),
			    .reset(reset),

                             ////LSQ
                            .lsq2ctr_rd_addr(LSQ_Dcash_load_address),
                            .lsq2ctr_rd_en(LSQ_Dcash_load_address_en),
                            .lsq2ctr_st_addr(LSQ_Dcash_store_address),
                            .lsq2ctr_st_data(LSQ_Dcash_store_data),
                            .lsq2ctr_st_en(LSQ_Dcash_store_address_en),
                            ////cache
			    .cache2ctr_rd_data(Dcache_rd_data),
			    .cache2ctr_rd_valid(Dcache_rd_valid),
                             ////mem
			    .mem2ctr_tag(mem2proc_tag),
			    .mem2ctr_response(Dmem2proc_response),
                            .mem2ctr_wr_data(mem2proc_data),

			     // outputs
                             ////LSQ
			    .ctr2lsq_rd_data(Dcache_ctr2lsq_rd_data),
			    .ctr2lsq_rd_valid(Dcache_ctr2lsq_rd_valid),
                            .ctr2lsq_st_valid(Dcache_ctr2lsq_st_valid),
                            .ctr2lsq_response(Dcache_ctr2lsq_response),
                            .ctr2lsq_tag_data(Dcache_ctr2lsq_tag_data),
                            .ctr2lsq_tag(Dcache_ctr2lsq_tag),
                             ////cache
                            .ctr2cache_wr_addr(Dcache_ctr2cache_wr_addr),
                            .ctr2cache_wr_data(Dcache_ctr2cache_wr_data),
			    .ctr2cache_wr_enable(Dcache_ctr2cache_wr_enable),
                            .ctr2cache_rd_addr(Dcache_ctr2cache_rd_addr),
                             ////mem
			    .ctr2mem_req_addr(Dcache_ctr2mem_req_addr),
			    .ctr2mem_command(Dcache_ctr2mem_command),
                            .ctr2mem_data(proc2mem_data)
			);

  //////////////////////////////////////////////////
  //                                              //
  //                     LSQ                      //
  //                                              //
  //////////////////////////////////////////////////
  wire      LSQ_Rob_store_retire_en;
  simLSQ LSQ(// Inputs
	     .clock(clock),
	     .reset(reset || rob_br_mispredict),

             .PreDe_load_port1_allocate_en(D_lsq_rd_en_out_1),
             .PreDe_load_port1_destination(D_lsq_rd_dest_idx_out_1),
             .PreDe_load_port1_NPC(D_lsq_NPC_out_1),
             .PreDe_load_port2_allocate_en(D_lsq_rd_en_out_2),
             .PreDe_load_port2_destination(D_lsq_rd_dest_idx_out_2),
             .PreDe_load_port2_NPC(D_lsq_NPC_out_2),

             .PreDe_store_port1_allocate_en(D_lsq_wr_en_out_1),
             .PreDe_store_port1_data(X_wr_men_value_out_alu0),
             .PreDe_store_port1_NPC(D_lsq_NPC_out_1),
             .PreDe_store_port2_allocate_en(D_lsq_wr_en_out_2),
             .PreDe_store_port2_data(X_wr_men_value_out_alu1),
             .PreDe_store_port2_NPC(D_lsq_NPC_out_2),
            
             .Ex_load_port1_address_en(X_rd_mem_out_alu0),
     	     .Ex_load_port1_address(X_alu_result_out_alu0),
             .Ex_load_port1_address_insert_position(X_rs_rd_lsq_tail_out_alu0),
             .Ex_load_port2_address_en(X_rd_mem_out_alu1),
     	     .Ex_load_port2_address(X_alu_result_out_alu1),
             .Ex_load_port2_address_insert_position(X_rs_rd_lsq_tail_out_alu1),

             .Ex_store_port1_address_en(X_wr_mem_out_alu0),
     	     .Ex_store_port1_address(X_alu_result_out_alu0),
             .Ex_store_port1_address_insert_position(X_rs_rd_lsq_tail_out_alu0),
             .Ex_store_port2_address_en(X_wr_mem_out_alu1),
     	     .Ex_store_port2_address(X_alu_result_out_alu1),
             .Ex_store_port2_address_insert_position(X_rs_rd_lsq_tail_out_alu1),

             .Rob_store_port1_retire_en(retire_store),  
             .Rob_store_port2_retire_en(1'd0),
             .Rob_load_retire_en(retire_load),

             .Dcash_load_valid(Dcache_ctr2lsq_rd_valid),
             .Dcash_load_valid_data(Dcache_ctr2lsq_rd_data),
             .Dcash_store_valid(Dcache_ctr2lsq_st_valid),                   
           
             .Dcash_response(Dcache_ctr2lsq_response),
             .Dcash_tag_data(Dcache_ctr2lsq_tag_data),
             .Dcash_tag(Dcache_ctr2lsq_tag),

             .br_marker_port1_en(D_lsq_br_inst_out_1),
             .br_marker_port1_num(if_D_br_marker_1),
             .br_marker_port2_en(D_lsq_br_inst_out_2),
             .br_marker_port2_num(if_D_br_marker_2),
             .recovery_en(1'd0),
             .recovery_br_marker_num(),
                         
             .stall(lsq_wb_stall),

             // Outputs
             .LSQ_PreDe_tail_position(LSQ_PreDe_tail_position),
             .LSQ_PreDe_tail_position_plus_one(LSQ_PreDe_tail_position_plus_one),
             
             .LSQ_Rob_store_retire_en(LSQ_Rob_store_retire_en),
             .LSQ_Rob_destination(LSQ_Rob_destination),
             .LSQ_Rob_data(LSQ_Rob_data),
             .LSQ_Rob_NPC(LSQ_Rob_NPC),
             .LSQ_Rob_write_dest_n_data_en(LSQ_Rob_write_dest_n_data_en),

             .LSQ_Dcash_load_address_en(LSQ_Dcash_load_address_en),
             .LSQ_Dcash_load_address(LSQ_Dcash_load_address), 
             .LSQ_Dcash_store_address_en(LSQ_Dcash_store_address_en),
             .LSQ_Dcash_store_address(LSQ_Dcash_store_address),
             .LSQ_Dcash_store_data(LSQ_Dcash_store_data),
             
             .LSQ_str_hazard(LSQ_stall)
           );


  //////////////////////////////////////////////////
  //                                              //
  //                   Fetch                      //
  //                                              //
  //////////////////////////////////////////////////
  assign F_stall_in[0] = (D_stall[0] | bmask_stall[0]) | LSQ_stall;
  assign F_stall_in[1] = (D_stall[1] | bmask_stall[1]) | LSQ_stall;



  assign ex_NPC = (X_take_branch_out_alu0 && X_take_branch_out_alu1 && (X_br_bmask_age_out_alu0 < X_br_bmask_age_out_alu1))? X_NPC_out_alu0:
                  (X_take_branch_out_alu0)? X_NPC_out_alu0:
                  (X_take_branch_out_alu1)? X_NPC_out_alu1:
                  0;
  assign ex_Dirp_cond = (I_X_cond_branch_out_alu0 && I_X_cond_branch_out_alu1 && (X_br_bmask_age_out_alu0 < X_br_bmask_age_out_alu1))? I_X_cond_branch_out_alu0:
                  (I_X_cond_branch_out_alu0)? I_X_cond_branch_out_alu0:
                  (I_X_cond_branch_out_alu1)? I_X_cond_branch_out_alu1:
                  0;
  assign ex_Dirp_T = (I_X_cond_branch_out_alu0 && I_X_cond_branch_out_alu1 && (X_br_bmask_age_out_alu0 < X_br_bmask_age_out_alu1))? X_take_branch_out_alu0:
                  (I_X_cond_branch_out_alu0)? X_take_branch_out_alu0:
                  (I_X_cond_branch_out_alu1)? X_take_branch_out_alu1:
                  0;


  if_FB Fetch(// Inputs
              .clock(clock),
              .reset(reset),
              .ex_mem_take_branch(rob_br_mispredict),
              .ex_mem_target_pc(rob_br_mispredict_target_PC),
              .ctr2proc_rd_data(Icache_data_out),
              .ctr2proc_rd_valid(Icache_valid_out),
              .id_str_hazard(F_stall_in),
	      .pre_cond_branch_1(pre_cond_branch_1),                               
	      .pre_cond_branch_2(pre_cond_branch_2),                               
	      .pre_uncond_branch_1(pre_uncond_branch_1),                           
	      .pre_uncond_branch_2(pre_uncond_branch_2),
	      .pre_bsr_branch_1(bsr_branch_1),
	      .pre_bsr_branch_2(bsr_branch_2),
	      .pre_ret_branch_1(ret_branch_1),
	      .pre_ret_branch_2(ret_branch_2),
	      .ex_BTB_NPC(ex_NPC),
	      .ex_Dirp_cond(ex_Dirp_cond),
	      .ex_Dirp_T(ex_Dirp_T),
                    
              // Outputs
              .proc2ctr_rd_addr(proc2Icache_addr),
              .inst_out_a(if_IR_out_1),
              .inst_out_b(if_IR_out_2),
              .inst_out_a_en(if_valid_inst_out_1),
              .inst_out_b_en(if_valid_inst_out_2),
              .inst_out_a_PC(if_NPC_out_1),
              .inst_out_b_PC(if_NPC_out_2),
	      .inst_out_a_BP_Taken(inst_out_a_BP_Taken),      
	      .inst_out_b_BP_Taken(inst_out_b_BP_Taken),      
	      .inst_out_a_BP_targetPC(inst_out_a_BP_targetPC),
	      .inst_out_b_BP_targetPC(inst_out_b_BP_targetPC)
               );

  pre_decoder pre_decoder(// Input
                          .inst_1(if_IR_out_1),
                          .inst_2(if_IR_out_2),

                          // Output
                          .cond_branch_1(pre_cond_branch_1),
                          .cond_branch_2(pre_cond_branch_2),
                          .uncond_branch_1(pre_uncond_branch_1),
                          .uncond_branch_2(pre_uncond_branch_2),
			  .bsr_branch_1(bsr_branch_1),
			  .bsr_branch_2(bsr_branch_2),
			  .ret_branch_1(ret_branch_1),
			  .ret_branch_2(ret_branch_2),
                          .is_ldq_1(pre_is_ldq_1),
                          .is_ldq_2(pre_is_ldq_2)
                          );

  assign bmask_wr_en_1 = if_valid_inst_out_1 && (pre_cond_branch_1 || pre_uncond_branch_1);
  assign bmask_wr_en_2 = if_valid_inst_out_2 && (pre_cond_branch_2 || pre_uncond_branch_2);

  wire       cl_enable_1;
  wire       cl_enable_2;
  wire       cl_enable_3;
  wire       cl_enable_4;
  wire [1:0] cl_position_1;
  wire [1:0] cl_position_2;
  wire [1:0] cl_position_3;
  wire [1:0] cl_position_4;
  wire [3:0] current_bmask;

  branch_recovery_controller bmask_generate(// Input
                                            .reset(reset || rob_br_mispredict), 
                                            .clock(clock),
                                            .wr_enable_1(bmask_wr_en_1), 
                                            .wr_enable_2(bmask_wr_en_2), 
                                            .cl_enable_1(cl_enable_1), 
                                            .cl_enable_2(cl_enable_2), 
                                            .cl_enable_3(cl_enable_3), 
                                            .cl_enable_4(cl_enable_4),
                                            .cl_position_1(cl_position_1), 
                                            .cl_position_2(cl_position_2),
                                            .cl_position_3(cl_position_3),
                                            .cl_position_4(cl_position_4),

                                            // Output
                                            .next_br_marker_1(br_marker_1), 
                                            .next_br_marker_2(br_marker_2), 
                                            .next_bmask1(bmask1), 
                                            .next_bmask2(bmask2),
                                            .bmask(current_bmask),
                                            .str_hazard(bmask_stall)
                                            );



  assign cl_position_1 = rob_br_marker_1;
  assign cl_position_2 = rob_br_marker_2;
  assign cl_position_3 = 0;
  assign cl_position_4 = 0;
  assign cl_enable_1   = rob_br_retire_en_out_1;
  assign cl_enable_2   = rob_br_retire_en_out_2;
  assign cl_enable_3   = 0;
  assign cl_enable_4   = 0;

  //////////////////////////////////////////////////
  //                                              //
  //            F/D pipeline registers            //
  //                                              //
  //////////////////////////////////////////////////
  always @(posedge clock)
  begin
    if(reset | rob_br_mispredict | F_stall_in!=0) begin
      if_D_NPC_1               <= `SD 0;
      if_D_NPC_2               <= `SD 0;
      if_D_IR_1                <= `SD `NOOP_INST;
      if_D_IR_2                <= `SD `NOOP_INST;
      if_D_valid_inst_1        <= `SD `FALSE;
      if_D_valid_inst_2        <= `SD `FALSE;
      if_D_br_marker_1         <= `SD `BR_MARKER_EMPTY;
      if_D_br_marker_2         <= `SD `BR_MARKER_EMPTY;
      if_D_bmask1              <= `SD 0;
      if_D_bmask2              <= `SD 0;
      F_rs_wr_data_brpTN_1     <= `SD 0;                 
      F_rs_wr_data_brpTN_2     <= `SD 0;		    
      F_rs_wr_data_brp_TAR_PC_1<= `SD 0;		   
      F_rs_wr_data_brp_TAR_PC_2<= `SD 0;		  
    end // if (reset)
    else begin
      if_D_NPC_1        <= `SD if_NPC_out_1;
      if_D_NPC_2        <= `SD if_NPC_out_2;
      if_D_IR_1         <= `SD if_IR_out_1;
      if_D_IR_2         <= `SD if_IR_out_2;
      if_D_valid_inst_1 <= `SD if_valid_inst_out_1;
      if_D_valid_inst_2 <= `SD if_valid_inst_out_2;
      if_D_br_marker_1  <= `SD  br_marker_1;
      if_D_br_marker_2  <= `SD  br_marker_2;
      if_D_bmask1       <= `SD  bmask1;
      if_D_bmask2       <= `SD  bmask2;
      F_rs_wr_data_brpTN_1     <= `SD inst_out_a_BP_Taken;               
      F_rs_wr_data_brpTN_2     <= `SD inst_out_b_BP_Taken;		   
      F_rs_wr_data_brp_TAR_PC_1<= `SD inst_out_a_BP_targetPC;		 
      F_rs_wr_data_brp_TAR_PC_2<= `SD inst_out_b_BP_targetPC;		  
    end
  end // always

  //////////////////////////////////////////////////
  //                                              //
  //                 Dispatch                     //
  //                                              //
  //////////////////////////////////////////////////

  D_stage Dispatch(// Input
                  .clock(clock),
                  .reset(reset),
                  .if_id_IR_1(if_D_IR_1),
                  .if_id_IR_2(if_D_IR_2),
                  .if_id_NPC_1(if_D_NPC_1),
                  .if_id_NPC_2(if_D_NPC_2),
                  .if_id_valid_inst_1(if_D_valid_inst_1),
                  .if_id_valid_inst_2(if_D_valid_inst_2),
                  .if_D_br_marker_1(if_D_br_marker_1),
                  .if_D_br_marker_2(if_D_br_marker_2),
                  .if_D_bmask_1(if_D_bmask1),
                  .if_D_bmask_2(if_D_bmask2),
                  .I_rs_rd_inst_1(I_rs_rd_inst_1),
                  .I_rs_rd_inst_2(I_rs_rd_inst_2),
                  .X_rs_clear_inst_1(I_rs_rd_inst_1),
                  .X_rs_clear_inst_2(I_rs_rd_inst_2),
                  .X_rs_clear_en_1(I_rs_rd_inst_en_1),
                  .X_rs_clear_en_2(I_rs_rd_inst_en_2),
                  .X_rs_clear_bmask_bits_1(3'd0),
                  .X_rs_clear_bmask_bits_2(3'd0),
                  .X_rs_bmask_clear_location_1(3'd0),
                  .X_rs_bmask_clear_location_2(3'd0),
                  .X_br_taken_1(X_br_mispredict_1),
                  .X_br_taken_2(X_br_mispredict_2),
                  .X_br_target_PC_1(X_br_mispredict_NPC1),
                  .X_br_target_PC_2(X_br_mispredict_NPC2),
                  .X_br_wr_en_1(X_br_complete_en_1),
                  .X_br_wr_en_2(X_br_complete_en_2),
                  .X_br_marker_1(I_X_br_marker_out_alu0),
                  .X_br_marker_2(I_X_br_marker_out_alu1),
                  .C_cdb_idx_1(X_C_reg_wr_idx_out_1),
                  .C_cdb_idx_2(X_C_reg_wr_idx_out_2),
                  .C_cdb_en_1(X_C_reg_wr_en_out_1),
                  .C_cdb_en_2(X_C_reg_wr_en_out_2),
                  .C_cdb_data_1(X_C_reg_wr_data_out_1),
                  .C_cdb_data_2(X_C_reg_wr_data_out_2),
                  .F_rs_wr_data_brpTN_1(F_rs_wr_data_brpTN_1),
                  .F_rs_wr_data_brpTN_2(F_rs_wr_data_brpTN_2),
                  .F_rs_wr_data_brp_TAR_PC_1(F_rs_wr_data_brp_TAR_PC_1),
                  .F_rs_wr_data_brp_TAR_PC_2(F_rs_wr_data_brp_TAR_PC_2),
                  .LSQ_rs_wr_data_lsq_tail_1(LSQ_PreDe_tail_position),
                  .LSQ_rs_wr_data_lsq_tail_2(LSQ_PreDe_tail_position_plus_one),
                  .LSQ_wr_mem_finished(LSQ_Rob_store_retire_en),

                  // Output
                  .D_IR_1(D_IR_1),
                  .D_IR_2(D_IR_2),
                  .D_NPC_1(D_NPC_1),
                  .D_NPC_2(D_NPC_2),
                  .D_opa_reg_idx_out_1(D_opa_reg_idx_out_1),
                  .D_opa_reg_idx_out_2(D_opa_reg_idx_out_2),
                  .D_opb_reg_idx_out_1(D_opb_reg_idx_out_1),
                  .D_opb_reg_idx_out_2(D_opb_reg_idx_out_2),
                  .D_dest_reg_idx_out_1(D_dest_reg_idx_out_1),
                  .D_dest_reg_idx_out_2(D_dest_reg_idx_out_2),
                  .D_opa_select_out_1(D_opa_select_out_1),
                  .D_opa_select_out_2(D_opa_select_out_2),
                  .D_opb_select_out_1(D_opb_select_out_1),
                  .D_opb_select_out_2(D_opb_select_out_2),
                  .D_alu_func_out_1(D_alu_func_out_1),
                  .D_alu_func_out_2(D_alu_func_out_2),
                  .D_rd_mem_out_1(D_rd_mem_out_1),
                  .D_rd_mem_out_2(D_rd_mem_out_2),
                  .D_wr_mem_out_1(D_wr_mem_out_1),
                  .D_wr_mem_out_2(D_wr_mem_out_2),
                  .D_cond_branch_out_1(D_cond_branch_out_1),
                  .D_cond_branch_out_2(D_cond_branch_out_2),
                  .D_uncond_branch_out_1(D_uncond_branch_out_1),
                  .D_uncond_branch_out_2(D_uncond_branch_out_2),
                  .D_rs_rd_brpTN_1(D_rs_rd_brpTN_out_1),
                  .D_rs_rd_brpTN_2(D_rs_rd_brpTN_out_2),
                  .D_rs_rd_brp_TAR_PC_1(D_rs_rd_brp_TAR_PC_out_1),
                  .D_rs_rd_brp_TAR_PC_2(D_rs_rd_brp_TAR_PC_out_2),
                  .D_rs_rd_lsq_tail_1(D_rs_rd_lsq_tail_out_1),
                  .D_rs_rd_lsq_tail_2(D_rs_rd_lsq_tail_out_2),
                  .D_rs_rd_br_marker_1(D_rs_rd_br_marker_out_1),
                  .D_rs_rd_br_marker_2(D_rs_rd_br_marker_out_2),
                  .D_rs_rd_bmask_1(D_rs_rd_bmask_out_1),
                  .D_rs_rd_bmask_2(D_rs_rd_bmask_out_2),
                  .D_rs_inst_status(D_rs_inst_status),
                  .D_stall(D_stall),
                  .retire_store(retire_store),
                  .retire_load(retire_load),
                  .system_halt(system_halt),

                  .rob_br_mispredict(rob_br_mispredict),
                  .rob_br_mispredict_target_PC(rob_br_mispredict_target_PC),
                  .rob_br_marker_1(rob_br_marker_1),
                  .rob_br_marker_2(rob_br_marker_2),
                  .rob_br_retire_en_out_1(rob_br_retire_en_out_1),
                  .rob_br_retire_en_out_2(rob_br_retire_en_out_2),

                  .lsq_wr_en_out_1(D_lsq_wr_en_out_1),
                  .lsq_wr_en_out_2(D_lsq_wr_en_out_2),
                  .lsq_rd_en_out_1(D_lsq_rd_en_out_1),
                  .lsq_rd_en_out_2(D_lsq_rd_en_out_2),
                  .lsq_rd_dest_idx_out_1(D_lsq_rd_dest_idx_out_1),
                  .lsq_rd_dest_idx_out_2(D_lsq_rd_dest_idx_out_2),
                  .lsq_NPC_out_1(D_lsq_NPC_out_1),
                  .lsq_NPC_out_2(D_lsq_NPC_out_2),
                  .lsq_br_inst_out_1(D_lsq_br_inst_out_1),
                  .lsq_br_inst_out_2(D_lsq_br_inst_out_2),

                  // testbench signal
                  .Retire_NPC_out_1(Retire_NPC_out_1),
                  .Retire_NPC_out_2(Retire_NPC_out_2),
                  .Retire_wr_idx_1(Retire_wr_idx_1),
                  .Retire_wr_idx_2(Retire_wr_idx_2),
                  .Retire_wr_data_1(Retire_wr_data_1),
                  .Retire_wr_data_2(Retire_wr_data_2),
                  .Retire_wr_en_1(Retire_wr_en_1),
                  .Retire_wr_en_2(Retire_wr_en_2),

                  .Dispatch_NPC_1(Dispatch_NPC_1),
                  .Dispatch_NPC_2(Dispatch_NPC_2),
                  .Dispatch_T_1(Dispatch_T_1),
                  .Dispatch_T_en_1(Dispatch_T_en_1),
                  .Dispatch_T_2(Dispatch_T_2),
                  .Dispatch_T_en_2(Dispatch_T_en_2),
                  .Dispatch_Told_1(Dispatch_Told_1),
                  .Dispatch_Told_2(Dispatch_Told_2),
                  .Dispatch_rega_1(Dispatch_rega_1),
                  .Dispatch_rega_plus_1(Dispatch_rega_plus_1),
                  .Dispatch_rega_2(Dispatch_rega_2),
                  .Dispatch_rega_plus_2(Dispatch_rega_plus_2),
                  .Dispatch_regb_1(Dispatch_regb_1),
                  .Dispatch_regb_plus_1(Dispatch_regb_plus_1),
                  .Dispatch_regb_2(Dispatch_regb_2),
                  .Dispatch_regb_plus_2(Dispatch_regb_plus_2),
                  .Dispatch_valid_inst_1(Dispatch_valid_inst_1),
                  .Dispatch_valid_inst_2(Dispatch_valid_inst_2),

                  .pipeline_commit_halt_on_2_signal(pipeline_commit_halt_on_2_signal)
                  );

  //////////////////////////////////////////////////
  //                                              //
  //            D/I pipeline registers            //
  //                                              //
  //////////////////////////////////////////////////
  wire D_I_enable = 1'b1;
  always @(posedge clock)
  begin
    if(reset || rob_br_mispredict) begin
      D_I_rs_inst_status     <= `SD 0;
      D_I_halt               <= `SD 0;
    end
    else if(D_I_enable) begin
      D_I_rs_inst_status     <= `SD D_rs_inst_status;
      D_I_halt               <= `SD system_halt;
    end
  end

  //////////////////////////////////////////////////
  //                                              //
  //                   Issue                      //
  //                                              //
  //////////////////////////////////////////////////
  I_stage Issue(// Input
                .clock(clock),
                .reset(reset || rob_br_mispredict),
                .D_IR_1(D_IR_1),
                .D_IR_2(D_IR_2),
                .D_NPC_1(D_NPC_1),
                .D_NPC_2(D_NPC_2),
                .D_opa_reg_idx_in_1(D_opa_reg_idx_out_1),
                .D_opa_reg_idx_in_2(D_opa_reg_idx_out_2),
                .D_opb_reg_idx_in_1(D_opb_reg_idx_out_1),
                .D_opb_reg_idx_in_2(D_opb_reg_idx_out_2),
                .D_dest_reg_idx_in_1(D_dest_reg_idx_out_1),
                .D_dest_reg_idx_in_2(D_dest_reg_idx_out_2),
                .D_opa_select_in_1(D_opa_select_out_1),
                .D_opa_select_in_2(D_opa_select_out_2),
                .D_opb_select_in_1(D_opb_select_out_1),
                .D_opb_select_in_2(D_opb_select_out_2),
                .D_alu_func_in_1(D_alu_func_out_1),
                .D_alu_func_in_2(D_alu_func_out_2),
                .D_rd_mem_in_1(D_rd_mem_out_1),
                .D_rd_mem_in_2(D_rd_mem_out_2),
                .D_wr_mem_in_1(D_wr_mem_out_1),
                .D_wr_mem_in_2(D_wr_mem_out_2),
                .D_cond_branch_in_1(D_cond_branch_out_1),
                .D_cond_branch_in_2(D_cond_branch_out_2),
                .D_uncond_branch_in_1(D_uncond_branch_out_1),
                .D_uncond_branch_in_2(D_uncond_branch_out_2),
                .D_rs_rd_brpTN_in_1(D_rs_rd_brpTN_out_1),
                .D_rs_rd_brpTN_in_2(D_rs_rd_brpTN_out_2),
                .D_rs_rd_brp_TAR_PC_in_1(D_rs_rd_brp_TAR_PC_out_1),
                .D_rs_rd_brp_TAR_PC_in_2(D_rs_rd_brp_TAR_PC_out_2),
                .D_rs_rd_lsq_tail_in_1(D_rs_rd_lsq_tail_out_1),
                .D_rs_rd_lsq_tail_in_2(D_rs_rd_lsq_tail_out_2),
                .D_rs_rd_br_marker_in_1(D_rs_rd_br_marker_out_1),
                .D_rs_rd_br_marker_in_2(D_rs_rd_br_marker_out_2),
                .D_rs_rd_bmask_in_1(D_rs_rd_bmask_out_1),
                .D_rs_rd_bmask_in_2(D_rs_rd_bmask_out_2),
                .D_rs_inst_status(D_I_rs_inst_status),
                .C_wb_reg_wr_idx_in_1(X_C_reg_wr_idx_out_1),
                .C_wb_reg_wr_idx_in_2(X_C_reg_wr_idx_out_2),
                .C_wb_reg_wr_data_in_1(X_C_reg_wr_data_out_1),
                .C_wb_reg_wr_data_in_2(X_C_reg_wr_data_out_2),
                .C_wb_reg_wr_en_in_1(X_C_reg_wr_en_out_1),
                .C_wb_reg_wr_en_in_2(X_C_reg_wr_en_out_2),
                .X_br_inst_1(X_br_complete_en_1),
                .X_br_inst_2(X_br_complete_en_2),
                .X_br_mispredict_1(X_br_mispredict_1),
                .X_br_mispredict_2(X_br_mispredict_2),
                .X_br_marker_1(X_br_marker_out_alu0),
                .X_br_marker_2(X_br_marker_out_alu1),

                // Output
                .I_rs_rd_inst_1(I_rs_rd_inst_1),
                .I_rs_rd_inst_2(I_rs_rd_inst_2),
                .I_rs_rd_inst_en_1(I_rs_rd_inst_en_1),
                .I_rs_rd_inst_en_2(I_rs_rd_inst_en_2),
                // ALU 0
                .I_NPC_out_alu0(I_NPC_out_alu0),
                .I_IR_out_alu0(I_IR_out_alu0),
                .I_rega_out_alu0(I_rega_out_alu0),
                .I_regb_out_alu0(I_regb_out_alu0),
                .I_dest_reg_idx_out_alu0(I_dest_reg_idx_out_alu0),
                .I_opa_select_out_alu0(I_opa_select_out_alu0),
                .I_opb_select_out_alu0(I_opb_select_out_alu0),
                .I_alu_func_out_alu0(I_alu_func_out_alu0),
                .I_rd_mem_out_alu0(I_rd_mem_out_alu0),
                .I_wr_mem_out_alu0(I_wr_mem_out_alu0),
                .I_cond_branch_out_alu0(I_cond_branch_out_alu0),
                .I_uncond_branch_out_alu0(I_uncond_branch_out_alu0),
                .I_br_marker_out_alu0(I_br_marker_out_alu0),
                .I_bmask_out_alu0(I_bmask_out_alu0),
                .I_valid_inst_out_alu0(I_valid_inst_out_alu0),
                .I_rs_rd_brpTN_out_alu0(I_rs_rd_brpTN_out_alu0),
                .I_rs_rd_brp_TAR_PC_out_alu0(I_rs_rd_brp_TAR_PC_out_alu0),
                .I_rs_rd_lsq_tail_out_alu0(I_rs_rd_lsq_tail_out_alu0),
                // ALU 1
                .I_NPC_out_alu1(I_NPC_out_alu1),
                .I_IR_out_alu1(I_IR_out_alu1),
                .I_rega_out_alu1(I_rega_out_alu1),
                .I_regb_out_alu1(I_regb_out_alu1),
                .I_dest_reg_idx_out_alu1(I_dest_reg_idx_out_alu1),
                .I_opa_select_out_alu1(I_opa_select_out_alu1),
                .I_opb_select_out_alu1(I_opb_select_out_alu1),
                .I_alu_func_out_alu1(I_alu_func_out_alu1),
                .I_rd_mem_out_alu1(I_rd_mem_out_alu1),
                .I_wr_mem_out_alu1(I_wr_mem_out_alu1),
                .I_cond_branch_out_alu1(I_cond_branch_out_alu1),
                .I_uncond_branch_out_alu1(I_uncond_branch_out_alu1),
                .I_br_marker_out_alu1(I_br_marker_out_alu1),
                .I_bmask_out_alu1(I_bmask_out_alu1),
                .I_valid_inst_out_alu1(I_valid_inst_out_alu1),
                .I_rs_rd_brpTN_out_alu1(I_rs_rd_brpTN_out_alu1),
                .I_rs_rd_brp_TAR_PC_out_alu1(I_rs_rd_brp_TAR_PC_out_alu1),
                .I_rs_rd_lsq_tail_out_alu1(I_rs_rd_lsq_tail_out_alu1),
                // ALU 2
                .I_NPC_out_alu2(I_NPC_out_alu2),
                .I_IR_out_alu2(I_IR_out_alu2),
                .I_rega_out_alu2(I_rega_out_alu2),
                .I_regb_out_alu2(I_regb_out_alu2),
                .I_dest_reg_idx_out_alu2(I_dest_reg_idx_out_alu2),
                .I_opa_select_out_alu2(I_opa_select_out_alu2),
                .I_opb_select_out_alu2(I_opb_select_out_alu2),
                .I_alu_func_out_alu2(I_alu_func_out_alu2),
                .I_rd_mem_out_alu2(I_rd_mem_out_alu2),
                .I_wr_mem_out_alu2(I_wr_mem_out_alu2),
                .I_cond_branch_out_alu2(I_cond_branch_out_alu2),
                .I_uncond_branch_out_alu2(I_uncond_branch_out_alu2),
                .I_br_marker_out_alu2(I_br_marker_out_alu2),
                .I_bmask_out_alu2(I_bmask_out_alu2),
                .I_valid_inst_out_alu2(I_valid_inst_out_alu2),
                // ALU 3
                .I_NPC_out_alu3(I_NPC_out_alu3),
                .I_IR_out_alu3(I_IR_out_alu3),
                .I_rega_out_alu3(I_rega_out_alu3),
                .I_regb_out_alu3(I_regb_out_alu3),
                .I_dest_reg_idx_out_alu3(I_dest_reg_idx_out_alu3),
                .I_opa_select_out_alu3(I_opa_select_out_alu3),
                .I_opb_select_out_alu3(I_opb_select_out_alu3),
                .I_alu_func_out_alu3(I_alu_func_out_alu3),
                .I_rd_mem_out_alu3(I_rd_mem_out_alu3),
                .I_wr_mem_out_alu3(I_wr_mem_out_alu3),
                .I_cond_branch_out_alu3(I_cond_branch_out_alu3),
                .I_uncond_branch_out_alu3(I_uncond_branch_out_alu3),
                .I_br_marker_out_alu3(I_br_marker_out_alu3),
                .I_bmask_out_alu3(I_bmask_out_alu3),
                .I_valid_inst_out_alu3(I_valid_inst_out_alu3)
               );

  //////////////////////////////////////////////////
  //                                              //
  //            I/X pipeline registers            //
  //                                              //
  //////////////////////////////////////////////////
  wire I_X_enable = 1'b1;
  always @(posedge clock)
  begin
    if(reset || rob_br_mispredict) begin
      // ALU 0
      I_X_IR_alu0                   <= `SD `NOOP_INST;
      I_X_NPC_alu0                  <= `SD 0;
      I_X_opa_reg_value_out_alu0    <= `SD 0;
      I_X_opb_reg_value_out_alu0    <= `SD 0;
      I_X_dest_reg_idx_out_alu0     <= `SD `ZERO_REG;
      I_X_opa_select_out_alu0       <= `SD 0;
      I_X_opb_select_out_alu0       <= `SD 0;
      I_X_alu_func_out_alu0         <= `SD 0;
      I_X_rd_mem_out_alu0           <= `SD 0;
      I_X_wr_mem_out_alu0           <= `SD 0;
      I_X_cond_branch_out_alu0      <= `SD 0;
      I_X_uncond_branch_out_alu0    <= `SD 0;
      I_X_br_marker_out_alu0        <= `SD `BR_MARKER_EMPTY;
      I_X_valid_inst_out_alu0       <= `SD 0;
      I_X_rs_rd_brpTN_out_alu0      <= `SD 0;
      I_X_rs_rd_brp_TAR_PC_out_alu0 <= `SD 0;
      I_X_rs_rd_lsq_tail_out_alu0   <= `SD 0;
      // ALU 1
      I_X_IR_alu1                   <= `SD `NOOP_INST;
      I_X_NPC_alu1                  <= `SD 0;
      I_X_opa_reg_value_out_alu1    <= `SD 0;
      I_X_opb_reg_value_out_alu1    <= `SD 0;
      I_X_dest_reg_idx_out_alu1     <= `SD `ZERO_REG;
      I_X_opa_select_out_alu1       <= `SD 0;
      I_X_opb_select_out_alu1       <= `SD 0;
      I_X_alu_func_out_alu1         <= `SD 0;
      I_X_rd_mem_out_alu1           <= `SD 0;
      I_X_wr_mem_out_alu1           <= `SD 0;
      I_X_cond_branch_out_alu1      <= `SD 0;
      I_X_uncond_branch_out_alu1    <= `SD 0;
      I_X_br_marker_out_alu1        <= `SD `BR_MARKER_EMPTY;
      I_X_valid_inst_out_alu1       <= `SD 0;
      I_X_rs_rd_brpTN_out_alu1      <= `SD 0;
      I_X_rs_rd_brp_TAR_PC_out_alu1 <= `SD 0;
      I_X_rs_rd_lsq_tail_out_alu1   <= `SD 0;
      // ALU 2
      I_X_IR_alu2                   <= `SD `NOOP_INST;
      I_X_NPC_alu2                  <= `SD 0;
      I_X_opa_reg_value_out_alu2    <= `SD 0;
      I_X_opb_reg_value_out_alu2    <= `SD 0;
      I_X_dest_reg_idx_out_alu2     <= `SD `ZERO_REG;
      I_X_opa_select_out_alu2       <= `SD 0;
      I_X_opb_select_out_alu2       <= `SD 0;
      I_X_alu_func_out_alu2         <= `SD 0;
      I_X_rd_mem_out_alu2           <= `SD 0;
      I_X_wr_mem_out_alu2           <= `SD 0;
      I_X_cond_branch_out_alu2      <= `SD 0;
      I_X_uncond_branch_out_alu2    <= `SD 0;
      I_X_br_marker_out_alu2        <= `SD `BR_MARKER_EMPTY;
      I_X_valid_inst_out_alu2       <= `SD 0;
      // ALU 3
      I_X_IR_alu3                   <= `SD `NOOP_INST;
      I_X_NPC_alu3                  <= `SD 0;
      I_X_opa_reg_value_out_alu3    <= `SD 0;
      I_X_opb_reg_value_out_alu3    <= `SD 0;
      I_X_dest_reg_idx_out_alu3     <= `SD `ZERO_REG;
      I_X_opa_select_out_alu3       <= `SD 0;
      I_X_opb_select_out_alu3       <= `SD 0;
      I_X_alu_func_out_alu3         <= `SD 0;
      I_X_rd_mem_out_alu3           <= `SD 0;
      I_X_wr_mem_out_alu3           <= `SD 0;
      I_X_cond_branch_out_alu3      <= `SD 0;
      I_X_uncond_branch_out_alu3    <= `SD 0;
      I_X_br_marker_out_alu3        <= `SD `BR_MARKER_EMPTY;
      I_X_valid_inst_out_alu3       <= `SD 0;
      // clear reservation station control signal
      I_X_rs_rd_inst_1              <= `SD 0;
      I_X_rs_rd_inst_2              <= `SD 0;
      I_X_rs_rd_inst_en_1           <= `SD 0;
      I_X_rs_rd_inst_en_2           <= `SD 0;
    end
    else if(I_X_enable) begin
      // ALU 0
      I_X_IR_alu0                   <= `SD I_IR_out_alu0;
      I_X_NPC_alu0                  <= `SD I_NPC_out_alu0;
      I_X_opa_reg_value_out_alu0    <= `SD I_rega_out_alu0;
      I_X_opb_reg_value_out_alu0    <= `SD I_regb_out_alu0;
      I_X_dest_reg_idx_out_alu0     <= `SD I_dest_reg_idx_out_alu0;
      I_X_opa_select_out_alu0       <= `SD I_opa_select_out_alu0;
      I_X_opb_select_out_alu0       <= `SD I_opb_select_out_alu0;
      I_X_alu_func_out_alu0         <= `SD I_alu_func_out_alu0;
      I_X_rd_mem_out_alu0           <= `SD I_rd_mem_out_alu0;
      I_X_wr_mem_out_alu0           <= `SD I_wr_mem_out_alu0;
      I_X_cond_branch_out_alu0      <= `SD I_cond_branch_out_alu0;
      I_X_uncond_branch_out_alu0    <= `SD I_uncond_branch_out_alu0;
      I_X_br_marker_out_alu0        <= `SD I_br_marker_out_alu0;
      I_X_valid_inst_out_alu0       <= `SD I_valid_inst_out_alu0;
      I_X_rs_rd_brpTN_out_alu0      <= `SD I_rs_rd_brpTN_out_alu0;
      I_X_rs_rd_brp_TAR_PC_out_alu0 <= `SD I_rs_rd_brp_TAR_PC_out_alu0;
      I_X_rs_rd_lsq_tail_out_alu0   <= `SD I_rs_rd_lsq_tail_out_alu0;

      // ALU 1
      I_X_IR_alu1                   <= `SD I_IR_out_alu1;
      I_X_NPC_alu1                  <= `SD I_NPC_out_alu1;
      I_X_opa_reg_value_out_alu1    <= `SD I_rega_out_alu1;
      I_X_opb_reg_value_out_alu1    <= `SD I_regb_out_alu1;
      I_X_dest_reg_idx_out_alu1     <= `SD I_dest_reg_idx_out_alu1;
      I_X_opa_select_out_alu1       <= `SD I_opa_select_out_alu1;
      I_X_opb_select_out_alu1       <= `SD I_opb_select_out_alu1;
      I_X_alu_func_out_alu1         <= `SD I_alu_func_out_alu1;
      I_X_rd_mem_out_alu1           <= `SD I_rd_mem_out_alu1;
      I_X_wr_mem_out_alu1           <= `SD I_wr_mem_out_alu1;
      I_X_cond_branch_out_alu1      <= `SD I_cond_branch_out_alu1;
      I_X_uncond_branch_out_alu1    <= `SD I_uncond_branch_out_alu1;
      I_X_br_marker_out_alu1        <= `SD I_br_marker_out_alu1;
      I_X_valid_inst_out_alu1       <= `SD I_valid_inst_out_alu1;
      I_X_rs_rd_brpTN_out_alu1      <= `SD I_rs_rd_brpTN_out_alu1;
      I_X_rs_rd_brp_TAR_PC_out_alu1 <= `SD I_rs_rd_brp_TAR_PC_out_alu1;
      I_X_rs_rd_lsq_tail_out_alu1   <= `SD I_rs_rd_lsq_tail_out_alu1;
      // ALU 2
      I_X_IR_alu2                   <= `SD I_IR_out_alu2;
      I_X_NPC_alu2                  <= `SD I_NPC_out_alu2;
      I_X_opa_reg_value_out_alu2    <= `SD I_rega_out_alu2;
      I_X_opb_reg_value_out_alu2    <= `SD I_regb_out_alu2;
      I_X_dest_reg_idx_out_alu2     <= `SD I_dest_reg_idx_out_alu2;
      I_X_opa_select_out_alu2       <= `SD I_opa_select_out_alu2;
      I_X_opb_select_out_alu2       <= `SD I_opb_select_out_alu2;
      I_X_alu_func_out_alu2         <= `SD I_alu_func_out_alu2;
      I_X_rd_mem_out_alu2           <= `SD I_rd_mem_out_alu2;
      I_X_wr_mem_out_alu2           <= `SD I_wr_mem_out_alu2;
      I_X_cond_branch_out_alu2      <= `SD I_cond_branch_out_alu2;
      I_X_uncond_branch_out_alu2    <= `SD I_uncond_branch_out_alu2;
      I_X_br_marker_out_alu2        <= `SD I_br_marker_out_alu2;
      I_X_valid_inst_out_alu2       <= `SD I_valid_inst_out_alu2;
      // ALU 3
      I_X_IR_alu3                   <= `SD I_IR_out_alu3;
      I_X_NPC_alu3                  <= `SD I_NPC_out_alu3;
      I_X_opa_reg_value_out_alu3    <= `SD I_rega_out_alu3;
      I_X_opb_reg_value_out_alu3    <= `SD I_regb_out_alu3;
      I_X_dest_reg_idx_out_alu3     <= `SD I_dest_reg_idx_out_alu3;
      I_X_opa_select_out_alu3       <= `SD I_opa_select_out_alu3;
      I_X_opb_select_out_alu3       <= `SD I_opb_select_out_alu3;
      I_X_alu_func_out_alu3         <= `SD I_alu_func_out_alu3;
      I_X_rd_mem_out_alu3           <= `SD I_rd_mem_out_alu3;
      I_X_wr_mem_out_alu3           <= `SD I_wr_mem_out_alu3;
      I_X_cond_branch_out_alu3      <= `SD I_cond_branch_out_alu3;
      I_X_uncond_branch_out_alu3    <= `SD I_uncond_branch_out_alu3;
      I_X_br_marker_out_alu3        <= `SD I_br_marker_out_alu3;
      I_X_valid_inst_out_alu3       <= `SD I_valid_inst_out_alu3;
      // clear reservation station control signal
      I_X_rs_rd_inst_1              <= `SD I_rs_rd_inst_1;
      I_X_rs_rd_inst_2              <= `SD I_rs_rd_inst_2;
      I_X_rs_rd_inst_en_1           <= `SD I_rs_rd_inst_en_1;
      I_X_rs_rd_inst_en_2           <= `SD I_rs_rd_inst_en_2;
    end
  end

  //////////////////////////////////////////////////
  //                                              //
  //                 Execute                      //
  //                                              //
  //////////////////////////////////////////////////

X_stage Execute(// Input 
                  .clock(clock),
                  .reset(reset || rob_br_mispredict),
                   // ALU 0
                  .I_X_NPC_alu0(I_X_NPC_alu0),
                  .I_X_IR_alu0(I_X_IR_alu0),
                  .I_X_rega_alu0(I_X_opa_reg_value_out_alu0),
                  .I_X_regb_alu0(I_X_opb_reg_value_out_alu0),
                  .I_X_dest_reg_idx_alu0(I_X_dest_reg_idx_out_alu0),
                  .I_X_opa_select_alu0(I_X_opa_select_out_alu0),
                  .I_X_opb_select_alu0(I_X_opb_select_out_alu0),
                  .I_X_alu_func_alu0(I_X_alu_func_out_alu0),
                  .I_X_rd_mem_alu0(I_X_rd_mem_out_alu0),
                  .I_X_wr_mem_alu0(I_X_wr_mem_out_alu0),
                  .I_X_cond_branch_alu0(I_X_cond_branch_out_alu0),
                  .I_X_uncond_branch_alu0(I_X_uncond_branch_out_alu0),
                  .I_X_br_marker_alu0(I_X_br_marker_out_alu0),
                  .I_X_valid_inst_alu0(I_X_valid_inst_out_alu0),
                  .I_X_rs_rd_brpTN_alu0(I_X_rs_rd_brpTN_out_alu0),
                  .I_X_rs_rd_brp_TAR_PC_alu0(I_X_rs_rd_brp_TAR_PC_out_alu0),
                  .I_X_rs_rd_lsq_tail_alu0(I_X_rs_rd_lsq_tail_out_alu0),
                   // ALU 1
                  .I_X_NPC_alu1(I_X_NPC_alu1),
                  .I_X_IR_alu1(I_X_IR_alu1),
                  .I_X_rega_alu1(I_X_opa_reg_value_out_alu1),
                  .I_X_regb_alu1(I_X_opb_reg_value_out_alu1),
                  .I_X_dest_reg_idx_alu1(I_X_dest_reg_idx_out_alu1),
                  .I_X_opa_select_alu1(I_X_opa_select_out_alu1),
                  .I_X_opb_select_alu1(I_X_opb_select_out_alu1),
                  .I_X_alu_func_alu1(I_X_alu_func_out_alu1),
                  .I_X_rd_mem_alu1(I_X_rd_mem_out_alu1),
                  .I_X_wr_mem_alu1(I_X_wr_mem_out_alu1),
                  .I_X_cond_branch_alu1(I_X_cond_branch_out_alu1),
                  .I_X_uncond_branch_alu1(I_X_uncond_branch_out_alu1),
                  .I_X_br_marker_alu1(I_X_br_marker_out_alu1),
                  .I_X_valid_inst_alu1(I_X_valid_inst_out_alu1),
                  .I_X_rs_rd_brpTN_alu1(I_X_rs_rd_brpTN_out_alu1),
                  .I_X_rs_rd_brp_TAR_PC_alu1(I_X_rs_rd_brp_TAR_PC_out_alu1),
                  .I_X_rs_rd_lsq_tail_alu1(I_X_rs_rd_lsq_tail_out_alu1),
                   // ALU 2
                  .I_X_NPC_alu2(I_X_NPC_alu2),
                  .I_X_IR_alu2(I_X_IR_alu2),
                  .I_X_rega_alu2(I_X_opa_reg_value_out_alu2),
                  .I_X_regb_alu2(I_X_opb_reg_value_out_alu2),
                  .I_X_dest_reg_idx_alu2(I_X_dest_reg_idx_out_alu2),
                  .I_X_opa_select_alu2(I_X_opa_select_out_alu2),
                  .I_X_opb_select_alu2(I_X_opb_select_out_alu2),
                  .I_X_valid_inst_alu2(I_X_valid_inst_out_alu2),
                   // ALU 3
                  .I_X_NPC_alu3(I_X_NPC_alu3),
                  .I_X_IR_alu3(I_X_IR_alu3),
                  .I_X_rega_alu3(I_X_opa_reg_value_out_alu3),
                  .I_X_regb_alu3(I_X_opb_reg_value_out_alu3),
                  .I_X_dest_reg_idx_alu3(I_X_dest_reg_idx_out_alu3),
                  .I_X_opa_select_alu3(I_X_opa_select_out_alu3),
                  .I_X_opb_select_alu3(I_X_opb_select_out_alu3),
                  .I_X_valid_inst_alu3(I_X_valid_inst_out_alu3),

                  // Outputs
                  // ALU0
                  .X_NPC_out_alu0(X_NPC_out_alu0),
                  .X_alu_result_out_alu0(X_alu_result_out_alu0),
                  .X_take_branch_target_out_alu0(X_take_branch_target_out_alu0),
                  .X_take_branch_out_alu0(X_take_branch_out_alu0),
                  .X_rd_mem_out_alu0(X_rd_mem_out_alu0),
                  .X_wr_mem_out_alu0(X_wr_mem_out_alu0),
                  .X_valid_inst_out_alu0(X_valid_inst_out_alu0),
                  .X_br_marker_out_alu0(X_br_marker_out_alu0),
                  .X_dest_reg_idx_out_alu0(X_dest_reg_idx_out_alu0),
                  .X_wr_men_value_alu0(X_wr_men_value_out_alu0),
                  .X_rs_rd_brpTN_out_alu0(X_rs_rd_brpTN_out_alu0),
                  .X_rs_rd_brp_TAR_PC_out_alu0(X_rs_rd_brp_TAR_PC_out_alu0),
                  .X_rs_rd_lsq_tail_out_alu0(X_rs_rd_lsq_tail_out_alu0),
                  // ALU1
                  .X_NPC_out_alu1(X_NPC_out_alu1),
                  .X_alu_result_out_alu1(X_alu_result_out_alu1),
                  .X_take_branch_target_out_alu1(X_take_branch_target_out_alu1),
                  .X_take_branch_out_alu1(X_take_branch_out_alu1),
                  .X_rd_mem_out_alu1(X_rd_mem_out_alu1),
                  .X_wr_mem_out_alu1(X_wr_mem_out_alu1),
                  .X_valid_inst_out_alu1(X_valid_inst_out_alu1),
                  .X_br_marker_out_alu1(X_br_marker_out_alu1),
                  .X_dest_reg_idx_out_alu1(X_dest_reg_idx_out_alu1),
                  .X_wr_men_value_alu1(X_wr_men_value_out_alu1),
                  .X_rs_rd_brpTN_out_alu1(X_rs_rd_brpTN_out_alu1),
                  .X_rs_rd_brp_TAR_PC_out_alu1(X_rs_rd_brp_TAR_PC_out_alu1),
                  .X_rs_rd_lsq_tail_out_alu1(X_rs_rd_lsq_tail_out_alu1),
                  // Mult0
                  .X_NPC_out_alu2(X_NPC_out_alu2),
                  .X_alu_result_out_alu2(X_alu_result_out_alu2),
                  .X_valid_inst_out_alu2(X_valid_inst_out_alu2),
                  .X_dest_reg_idx_out_alu2(X_dest_reg_idx_out_alu2),
                  // Mult1
                  .X_NPC_out_alu3(X_NPC_out_alu3),
                  .X_alu_result_out_alu3(X_alu_result_out_alu3),
                  .X_valid_inst_out_alu3(X_valid_inst_out_alu3),
                  .X_dest_reg_idx_out_alu3(X_dest_reg_idx_out_alu3)
                 );

 
  assign X_br_complete_en_1 = I_X_valid_inst_out_alu0 & (I_X_cond_branch_out_alu0 || I_X_uncond_branch_out_alu0);
  assign X_br_complete_en_2 = I_X_valid_inst_out_alu1 & (I_X_cond_branch_out_alu1 || I_X_uncond_branch_out_alu1);

  assign X_br_taken_1         = (I_X_valid_inst_out_alu0 & X_take_branch_out_alu0);
  assign X_br_taken_2         = (I_X_valid_inst_out_alu1 & X_take_branch_out_alu1);
                                 
  assign X_BP_taken1          = I_X_valid_inst_out_alu0 & X_rs_rd_brpTN_out_alu0;
  assign X_BP_taken2          = I_X_valid_inst_out_alu1 & X_rs_rd_brpTN_out_alu1;
  assign X_BP_NPC1            = X_rs_rd_brp_TAR_PC_out_alu0;
  assign X_BP_NPC2            = X_rs_rd_brp_TAR_PC_out_alu1;
 
  
  assign X_br_mispredict_NPC1     = (~X_br_complete_en_1)? 0
				  :(~X_br_taken_1 && ~X_BP_taken1)? 0
				  :(~X_br_taken_1 && X_BP_taken1)?  X_NPC_out_alu0
				  :(X_br_taken_1 && ~X_BP_taken1)?  X_take_branch_target_out_alu0
				  :(X_take_branch_target_out_alu0 == X_BP_NPC1)? 0
				  :X_take_branch_target_out_alu0;
 assign X_br_mispredict_NPC2     = (~X_br_complete_en_2)? 0
				  :(~X_br_taken_2 && ~X_BP_taken2)? 0
				  :(~X_br_taken_2 && X_BP_taken2)?  X_NPC_out_alu1
				  :(X_br_taken_2 && ~X_BP_taken2)?  X_take_branch_target_out_alu1
				  :(X_take_branch_target_out_alu1 == X_BP_NPC2)? 0
				  :X_take_branch_target_out_alu1;
  assign X_br_mispredict_1      = (~X_br_complete_en_1)? 1'b0
				  :(~X_br_taken_1 && ~X_BP_taken1)? 1'b0
				  :(~X_br_taken_1 && X_BP_taken1)?  1'b1
				  :(X_br_taken_1 && ~X_BP_taken1)?  1'b1
				  :(X_alu_result_out_alu0 == X_BP_NPC1)? 1'b0
				  :1'b1;
  assign X_br_mispredict_2      = (~X_br_complete_en_2)? 1'b0
				  :(~X_br_taken_2 && ~X_BP_taken2)? 1'b0
				  :(~X_br_taken_2 && X_BP_taken2)?  1'b1
				  :(X_br_taken_2 && ~X_BP_taken2)?  1'b1
				  :(X_alu_result_out_alu1 == X_BP_NPC2)? 1'b0
				  :1'b1;

  //////////////////////////////////////////////////
  //                                              //
  //                 X/C Buffer                   //
  //                                              //
  //////////////////////////////////////////////////

  wire [63:0] X_alu_result_in_alu3;
  wire        X_valid_inst_in_alu3;
  wire  [5:0] X_dest_reg_idx_in_alu3;

  assign lsq_wb_stall           = (X_alu_result_out_alu3)? 1:0;
  assign X_alu_result_in_alu3   = (X_alu_result_out_alu3)? X_alu_result_out_alu3 : LSQ_Rob_data;
  assign X_valid_inst_in_alu3   = (X_alu_result_out_alu3)? X_valid_inst_out_alu3: LSQ_Rob_write_dest_n_data_en;
  assign X_dest_reg_idx_in_alu3 = (X_alu_result_out_alu3)? X_dest_reg_idx_out_alu3: LSQ_Rob_destination;



  X_C_Buffer XCBuf(// Input
                  .clock(clock),
                  .reset(reset || rob_br_mispredict),

                  .X_alu_result_in_alu0(X_alu_result_out_alu0),
                  .X_valid_inst_in_alu0(X_valid_inst_out_alu0),
                  .X_dest_reg_idx_in_alu0(X_dest_reg_idx_out_alu0),

                  .X_alu_result_in_alu1(X_alu_result_out_alu1),
                  .X_valid_inst_in_alu1(X_valid_inst_out_alu1),
                  .X_dest_reg_idx_in_alu1(X_dest_reg_idx_out_alu1),

                  .X_alu_result_in_alu2(X_alu_result_out_alu2),
                  .X_valid_inst_in_alu2(X_valid_inst_out_alu2),
                  .X_dest_reg_idx_in_alu2(X_dest_reg_idx_out_alu2),

                  .X_alu_result_in_alu3(X_alu_result_in_alu3),
                  .X_valid_inst_in_alu3(X_valid_inst_in_alu3),
                  .X_dest_reg_idx_in_alu3(X_dest_reg_idx_in_alu3),

                   // Output
                  .X_C_reg_wr_data_out_1(X_C_reg_wr_data_out_1),
                  .X_C_reg_wr_data_out_2(X_C_reg_wr_data_out_2),
                  .X_C_reg_wr_idx_out_1(X_C_reg_wr_idx_out_1),
                  .X_C_reg_wr_idx_out_2(X_C_reg_wr_idx_out_2),
                  .X_C_reg_wr_en_out_1(X_C_reg_wr_en_out_1),
                  .X_C_reg_wr_en_out_2(X_C_reg_wr_en_out_2)
                  );



endmodule
