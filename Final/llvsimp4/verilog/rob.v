/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  rob.v                                               //
//   # od ROB   :  07                                                  //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module rob(// Input
           clock,
           reset,
           T_in_1,
           T_in_2,
           Told_in_1,
           Told_in_2,
           T_wr_en_1,
           T_wr_en_2,
           id_wr_mem_in_1,
           id_wr_mem_in_2,
           id_rd_mem_in_1,
           id_rd_mem_in_2,
           id_cond_branch_in_1,
           id_cond_branch_in_2,
           id_uncond_branch_in_1,
           id_uncond_branch_in_2,
           id_halt_in_1,
           id_halt_in_2,
           id_noop_in_1,
           id_noop_in_2,
           id_br_in_1,
           id_br_in_2,
           NPC_1,
           NPC_2,
           br_wr_en_1,
           br_wr_en_2,
           br_marker_in_1,
           br_marker_in_2,
           br_mispredict,
           br_mispre_marker,
           C_tag_1,
           C_tag_2,
           C_wr_en_1,
           C_wr_en_2,
           C_wb_data_1,
           C_wb_data_2,
           X_br_wr_en_1,
           X_br_wr_en_2,
           X_br_marker_1,
           X_br_marker_2,
           X_br_taken_1,
           X_br_taken_2,
           X_br_target_PC_1,
           X_br_target_PC_2,
           LSQ_wr_mem_finished,

           // Output
           T_out_1,
           T_out_2,
           Told_out_1,
           Told_out_2,
           NPC_out_1,
           NPC_out_2,
           wb_data_out_1,
           wb_data_out_2,
           T_valid_1,
           T_valid_2,
           rob_halt,
           rob_store,
           rob_load,
           rob_stall,
           
           rob_br_mispredict,
           rob_br_mispredict_target_PC,
           rob_br_mispredict_marker,
           rob_br_marker_1,
           rob_br_marker_2,
           rob_br_retire_en_1,
           rob_br_retire_en_2,
           pipeline_commit_halt_on_2_signal
          );

  input        clock;
  input        reset;
  input  [5:0] T_in_1;       // Dispatch: put Tag into rob
  input  [5:0] T_in_2;
  input  [5:0] Told_in_1;    // Dispatch: put Tag Old into rob
  input  [5:0] Told_in_2;
  input        T_wr_en_1;    // Dispatch: tag write enable
  input        T_wr_en_2;
  input        id_wr_mem_in_1;
  input        id_wr_mem_in_2;
  input        id_rd_mem_in_1;
  input        id_rd_mem_in_2;
  input        id_cond_branch_in_1;
  input        id_cond_branch_in_2;
  input        id_uncond_branch_in_1;
  input        id_uncond_branch_in_2;
  input        id_halt_in_1;
  input        id_halt_in_2;
  input        id_noop_in_1;
  input        id_noop_in_2;
  input        id_br_in_1;
  input        id_br_in_2;
  input [63:0] NPC_1;
  input [63:0] NPC_2;
  input        br_wr_en_1;
  input        br_wr_en_2;
  input  [2:0] br_marker_in_1;
  input  [2:0] br_marker_in_2;
  input        br_mispredict;
  input  [2:0] br_mispre_marker;
  input  [5:0] C_tag_1;      // Complete: complete mark = (insn finish)? 1:0
  input  [5:0] C_tag_2;
  input        C_wr_en_1;    // Complete: mark write enable
  input        C_wr_en_2;
  input [63:0] C_wb_data_1;
  input [63:0] C_wb_data_2;
  input        X_br_wr_en_1;
  input        X_br_wr_en_2;
  input  [2:0] X_br_marker_1;
  input  [2:0] X_br_marker_2;
  input        X_br_taken_1;
  input        X_br_taken_2;
  input [63:0] X_br_target_PC_1;
  input [63:0] X_br_target_PC_2;
  input        LSQ_wr_mem_finished;
  
  output [5:0] T_out_1;      // Retire  : put tag to Maptable
  output [5:0] T_out_2;
  output [5:0] Told_out_1;   // Retire  : put Told to Architecture Map
  output [5:0] Told_out_2;
  output       T_valid_1;    // Retire  : T & Told out valid?
  output       T_valid_2;
  output       rob_halt;
  output       rob_store;
  output       rob_load;
  output [1:0] rob_stall;    // Dispatch: Rob full? 2'b00: not full
                             //                     2'b01: only 1 space left
                             //                     2'b11: full
  output        rob_br_mispredict;
  output [63:0] rob_br_mispredict_target_PC;
  output [2:0]  rob_br_mispredict_marker;
  output [2:0]  rob_br_marker_1;
  output [2:0]  rob_br_marker_2;
  output        rob_br_retire_en_1;
  output        rob_br_retire_en_2;
  output        pipeline_commit_halt_on_2_signal;

  output [63:0] NPC_out_1;
  output [63:0] NPC_out_2;
  output [63:0] wb_data_out_1;
  output [63:0] wb_data_out_2;


  reg    [5:0] T_out_1;
  reg    [5:0] T_out_2;
  reg    [5:0] Told_out_1;
  reg    [5:0] Told_out_2;
  reg          T_valid_1;
  reg          T_valid_2;
  reg   [63:0] NPC_out_1;
  reg   [63:0] NPC_out_2;
  reg   [63:0] wb_data_out_1;
  reg   [63:0] wb_data_out_2;
  // In circuit register
  reg    [5:0] T        [0:31]; 
  reg    [5:0] Told     [0:31]; 
  reg          C        [0:31]; 
  reg          wr_mem   [0:31]; 
  reg          rd_mem   [0:31]; 
  reg   [63:0] NPC      [0:31]; 
  reg   [63:0] wb_data  [0:31]; 
  reg          halt     [0:31]; 
  reg          noop     [0:31]; 
  reg          br       [0:31]; 
  reg          br_taken [0:31]; 
  reg   [63:0] br_target_PC[0:31];

  // Branch recovery
  reg    [2:0] br_marker[0:31];
  reg    [5:0] br_t     [0:3];

  reg    [5:0] h;
  reg    [5:0] t;
  wire   [5:0] next_h;
  wire   [5:0] next_t;
  wire   [5:0] h_plus_1 = h + 1;
  wire   [5:0] t_plus_1 = t + 1;

  wire         head_empty                 = (h==t);
  wire         head_plus_1_empty          = !head_empty && (h_plus_1==t);
  wire         R_ready_head               = C[h[4:0]]        || noop[h[4:0]]        || halt[h[4:0]]       ;
  wire         R_ready_head_plus_1        = C[h_plus_1[4:0]] || noop[h_plus_1[4:0]] || halt[h_plus_1[4:0]];
  wire         R_Mem_head                 = wr_mem[h[4:0]];
  wire         R_Mem_head_plus_1          = wr_mem[h_plus_1[4:0]];
  wire         R_Mem_ready_head           = R_Mem_head       && LSQ_wr_mem_finished;
  wire         R_Mis_Br_ready_head        = C[h[4:0]]        && br_taken[h[4:0]]        && !head_empty;
  wire         R_Mis_Br_ready_head_plus_1 = C[h_plus_1[4:0]] && br_taken[h_plus_1[4:0]] && !head_plus_1_empty;


  wire retire_one = !head_empty                      && (R_ready_head || R_Mem_ready_head);
  wire retire_two = !head_plus_1_empty && retire_one && R_ready_head_plus_1 && !br_taken[h[4:0]];
  
  assign rob_store = R_Mem_head && !head_empty;
  assign rob_load  = 0;
  assign rob_halt  = (halt[h[4:0]] && retire_one) || (retire_two && halt[h_plus_1[4:0]]);
  assign pipeline_commit_halt_on_2_signal = (retire_two && halt[h_plus_1[4:0]]);

  assign next_h    = (retire_two)? h + 6'd2:        // can retire 2 head inst
                     (retire_one)? h + 6'd1:        // can retire 1 inst
                     h;                             // can retire 0 inst

  assign next_t    = (T_wr_en_2 && T_wr_en_1)?  t + 6'd2: // dispatch 2 inst  
                     (!T_wr_en_2 && T_wr_en_1)? t + 6'd1: // dispatch 1 inst  
                     (T_wr_en_2 && !T_wr_en_1)? t + 6'd1: // dispatch 1 inst  
                     t;                                   // dispatch 0 inst

  assign rob_stall = ({!h[5],h[4:0]}==t)? 2'b11:
                     ({!h[5],h[4:0]}==next_t)? 2'b11:
                     ({!h[5],h[4:0]}==next_t+1)? 2'b01: 
                     2'b00;

  assign rob_br_mispredict = (retire_two)? R_Mis_Br_ready_head_plus_1: R_Mis_Br_ready_head;
  assign rob_br_mispredict_target_PC = (retire_two)? br_target_PC[h_plus_1[4:0]]: br_target_PC[h[4:0]];
  assign rob_br_mispredict_marker    = (retire_two)? rob_br_marker_2: rob_br_marker_1;
  assign rob_br_marker_1    = br_marker[h[4:0]];
  assign rob_br_marker_2    = br_marker[h_plus_1[4:0]];
  assign rob_br_retire_en_1 = (retire_one)? br[h[4:0]]:0;
  assign rob_br_retire_en_2 = (retire_two)? br[h_plus_1[4:0]]:0;


  always @(posedge clock)
  begin
    if (reset) begin
      h             <= `SD 0;
      t             <= `SD 0;
      T[0]          <= `SD `ZERO_REG;
      T[1]          <= `SD `ZERO_REG;
      T[2]          <= `SD `ZERO_REG;
      T[3]          <= `SD `ZERO_REG;
      T[4]          <= `SD `ZERO_REG;
      T[5]          <= `SD `ZERO_REG;
      T[6]          <= `SD `ZERO_REG;
      T[7]          <= `SD `ZERO_REG;
      T[8]          <= `SD `ZERO_REG;
      T[9]          <= `SD `ZERO_REG;
      T[10]         <= `SD `ZERO_REG;
      T[11]         <= `SD `ZERO_REG;
      T[12]         <= `SD `ZERO_REG;
      T[13]         <= `SD `ZERO_REG;
      T[14]         <= `SD `ZERO_REG;
      T[15]         <= `SD `ZERO_REG;
      T[16]         <= `SD `ZERO_REG;
      T[17]         <= `SD `ZERO_REG;
      T[18]         <= `SD `ZERO_REG;
      T[19]         <= `SD `ZERO_REG;
      T[20]         <= `SD `ZERO_REG;
      T[21]         <= `SD `ZERO_REG;
      T[22]         <= `SD `ZERO_REG;
      T[23]         <= `SD `ZERO_REG;
      T[24]         <= `SD `ZERO_REG;
      T[25]         <= `SD `ZERO_REG;
      T[26]         <= `SD `ZERO_REG;
      T[27]         <= `SD `ZERO_REG;
      T[28]         <= `SD `ZERO_REG;
      T[29]         <= `SD `ZERO_REG;
      T[30]         <= `SD `ZERO_REG;
      T[31]         <= `SD `ZERO_REG;

      Told[0]       <= `SD `ZERO_REG;
      Told[1]       <= `SD `ZERO_REG;
      Told[2]       <= `SD `ZERO_REG;
      Told[3]       <= `SD `ZERO_REG;
      Told[4]       <= `SD `ZERO_REG;
      Told[5]       <= `SD `ZERO_REG;
      Told[6]       <= `SD `ZERO_REG;
      Told[7]       <= `SD `ZERO_REG;
      Told[8]       <= `SD `ZERO_REG;
      Told[9]       <= `SD `ZERO_REG;
      Told[10]      <= `SD `ZERO_REG;
      Told[11]      <= `SD `ZERO_REG;
      Told[12]      <= `SD `ZERO_REG;
      Told[13]      <= `SD `ZERO_REG;
      Told[14]      <= `SD `ZERO_REG;
      Told[15]      <= `SD `ZERO_REG;
      Told[16]      <= `SD `ZERO_REG;
      Told[17]      <= `SD `ZERO_REG;
      Told[18]      <= `SD `ZERO_REG;
      Told[19]      <= `SD `ZERO_REG;
      Told[20]      <= `SD `ZERO_REG;
      Told[21]      <= `SD `ZERO_REG;
      Told[22]      <= `SD `ZERO_REG;
      Told[23]      <= `SD `ZERO_REG;
      Told[24]      <= `SD `ZERO_REG;
      Told[25]      <= `SD `ZERO_REG;
      Told[26]      <= `SD `ZERO_REG;
      Told[27]      <= `SD `ZERO_REG;
      Told[28]      <= `SD `ZERO_REG;
      Told[29]      <= `SD `ZERO_REG;
      Told[30]      <= `SD `ZERO_REG;
      Told[31]      <= `SD `ZERO_REG;

      C[0]          <= `SD 0;
      C[1]          <= `SD 0;
      C[2]          <= `SD 0;
      C[3]          <= `SD 0;
      C[4]          <= `SD 0;
      C[5]          <= `SD 0;
      C[6]          <= `SD 0;
      C[7]          <= `SD 0;
      C[8]          <= `SD 0;
      C[9]          <= `SD 0;
      C[10]         <= `SD 0;
      C[11]         <= `SD 0;
      C[12]         <= `SD 0;
      C[13]         <= `SD 0;
      C[14]         <= `SD 0;
      C[15]         <= `SD 0;
      C[16]         <= `SD 0;
      C[17]         <= `SD 0;
      C[18]         <= `SD 0;
      C[19]         <= `SD 0;
      C[20]         <= `SD 0;
      C[21]         <= `SD 0;
      C[22]         <= `SD 0;
      C[23]         <= `SD 0;
      C[24]         <= `SD 0;
      C[25]         <= `SD 0;
      C[26]         <= `SD 0;
      C[27]         <= `SD 0;
      C[28]         <= `SD 0;
      C[29]         <= `SD 0;
      C[30]         <= `SD 0;
      C[31]         <= `SD 0;

      wr_mem[0]     <= `SD 0;
      wr_mem[1]     <= `SD 0;
      wr_mem[2]     <= `SD 0;
      wr_mem[3]     <= `SD 0;
      wr_mem[4]     <= `SD 0;
      wr_mem[5]     <= `SD 0;
      wr_mem[6]     <= `SD 0;
      wr_mem[7]     <= `SD 0;
      wr_mem[8]     <= `SD 0;
      wr_mem[9]     <= `SD 0;
      wr_mem[10]    <= `SD 0;
      wr_mem[11]    <= `SD 0;
      wr_mem[12]    <= `SD 0;
      wr_mem[13]    <= `SD 0;
      wr_mem[14]    <= `SD 0;
      wr_mem[15]    <= `SD 0;
      wr_mem[16]    <= `SD 0;
      wr_mem[17]    <= `SD 0;
      wr_mem[18]    <= `SD 0;
      wr_mem[19]    <= `SD 0;
      wr_mem[20]    <= `SD 0;
      wr_mem[21]    <= `SD 0;
      wr_mem[22]    <= `SD 0;
      wr_mem[23]    <= `SD 0;
      wr_mem[24]    <= `SD 0;
      wr_mem[25]    <= `SD 0;
      wr_mem[26]    <= `SD 0;
      wr_mem[27]    <= `SD 0;
      wr_mem[28]    <= `SD 0;
      wr_mem[29]    <= `SD 0;
      wr_mem[30]    <= `SD 0;
      wr_mem[31]    <= `SD 0;

      rd_mem[0]     <= `SD 0;
      rd_mem[1]     <= `SD 0;
      rd_mem[2]     <= `SD 0;
      rd_mem[3]     <= `SD 0;
      rd_mem[4]     <= `SD 0;
      rd_mem[5]     <= `SD 0;
      rd_mem[6]     <= `SD 0;
      rd_mem[7]     <= `SD 0;
      rd_mem[8]     <= `SD 0;
      rd_mem[9]     <= `SD 0;
      rd_mem[10]    <= `SD 0;
      rd_mem[11]    <= `SD 0;
      rd_mem[12]    <= `SD 0;
      rd_mem[13]    <= `SD 0;
      rd_mem[14]    <= `SD 0;
      rd_mem[15]    <= `SD 0;
      rd_mem[16]    <= `SD 0;
      rd_mem[17]    <= `SD 0;
      rd_mem[18]    <= `SD 0;
      rd_mem[19]    <= `SD 0;
      rd_mem[20]    <= `SD 0;
      rd_mem[21]    <= `SD 0;
      rd_mem[22]    <= `SD 0;
      rd_mem[23]    <= `SD 0;
      rd_mem[24]    <= `SD 0;
      rd_mem[25]    <= `SD 0;
      rd_mem[26]    <= `SD 0;
      rd_mem[27]    <= `SD 0;
      rd_mem[28]    <= `SD 0;
      rd_mem[29]    <= `SD 0;
      rd_mem[30]    <= `SD 0;
      rd_mem[31]    <= `SD 0;

      br_marker[0]  <= `SD `BR_MARKER_EMPTY;
      br_marker[1]  <= `SD `BR_MARKER_EMPTY;
      br_marker[2]  <= `SD `BR_MARKER_EMPTY;
      br_marker[3]  <= `SD `BR_MARKER_EMPTY;
      br_marker[4]  <= `SD `BR_MARKER_EMPTY;
      br_marker[5]  <= `SD `BR_MARKER_EMPTY;
      br_marker[6]  <= `SD `BR_MARKER_EMPTY;
      br_marker[7]  <= `SD `BR_MARKER_EMPTY;
      br_marker[8]  <= `SD `BR_MARKER_EMPTY;
      br_marker[9]  <= `SD `BR_MARKER_EMPTY;
      br_marker[10] <= `SD `BR_MARKER_EMPTY;
      br_marker[11] <= `SD `BR_MARKER_EMPTY;
      br_marker[12] <= `SD `BR_MARKER_EMPTY;
      br_marker[13] <= `SD `BR_MARKER_EMPTY;
      br_marker[14] <= `SD `BR_MARKER_EMPTY;
      br_marker[15] <= `SD `BR_MARKER_EMPTY;
      br_marker[16] <= `SD `BR_MARKER_EMPTY;
      br_marker[17] <= `SD `BR_MARKER_EMPTY;
      br_marker[18] <= `SD `BR_MARKER_EMPTY;
      br_marker[19] <= `SD `BR_MARKER_EMPTY;
      br_marker[20] <= `SD `BR_MARKER_EMPTY;
      br_marker[21] <= `SD `BR_MARKER_EMPTY;
      br_marker[22] <= `SD `BR_MARKER_EMPTY;
      br_marker[23] <= `SD `BR_MARKER_EMPTY;
      br_marker[24] <= `SD `BR_MARKER_EMPTY;
      br_marker[25] <= `SD `BR_MARKER_EMPTY;
      br_marker[26] <= `SD `BR_MARKER_EMPTY;
      br_marker[27] <= `SD `BR_MARKER_EMPTY;
      br_marker[28] <= `SD `BR_MARKER_EMPTY;
      br_marker[29] <= `SD `BR_MARKER_EMPTY;
      br_marker[30] <= `SD `BR_MARKER_EMPTY;
      br_marker[31] <= `SD `BR_MARKER_EMPTY;

      br[0]     <= `SD 0;
      br[1]     <= `SD 0;
      br[2]     <= `SD 0;
      br[3]     <= `SD 0;
      br[4]     <= `SD 0;
      br[5]     <= `SD 0;
      br[6]     <= `SD 0;
      br[7]     <= `SD 0;
      br[8]     <= `SD 0;
      br[9]     <= `SD 0;
      br[10]    <= `SD 0;
      br[11]    <= `SD 0;
      br[12]    <= `SD 0;
      br[13]    <= `SD 0;
      br[14]    <= `SD 0;
      br[15]    <= `SD 0;
      br[16]    <= `SD 0;
      br[17]    <= `SD 0;
      br[18]    <= `SD 0;
      br[19]    <= `SD 0;
      br[20]    <= `SD 0;
      br[21]    <= `SD 0;
      br[22]    <= `SD 0;
      br[23]    <= `SD 0;
      br[24]    <= `SD 0;
      br[25]    <= `SD 0;
      br[26]    <= `SD 0;
      br[27]    <= `SD 0;
      br[28]    <= `SD 0;
      br[29]    <= `SD 0;
      br[30]    <= `SD 0;
      br[31]    <= `SD 0;

      br_taken[0]     <= `SD 0;
      br_taken[1]     <= `SD 0;
      br_taken[2]     <= `SD 0;
      br_taken[3]     <= `SD 0;
      br_taken[4]     <= `SD 0;
      br_taken[5]     <= `SD 0;
      br_taken[6]     <= `SD 0;
      br_taken[7]     <= `SD 0;
      br_taken[8]     <= `SD 0;
      br_taken[9]     <= `SD 0;
      br_taken[10]    <= `SD 0;
      br_taken[11]    <= `SD 0;
      br_taken[12]    <= `SD 0;
      br_taken[13]    <= `SD 0;
      br_taken[14]    <= `SD 0;
      br_taken[15]    <= `SD 0;
      br_taken[16]    <= `SD 0;
      br_taken[17]    <= `SD 0;
      br_taken[18]    <= `SD 0;
      br_taken[19]    <= `SD 0;
      br_taken[20]    <= `SD 0;
      br_taken[21]    <= `SD 0;
      br_taken[22]    <= `SD 0;
      br_taken[23]    <= `SD 0;
      br_taken[24]    <= `SD 0;
      br_taken[25]    <= `SD 0;
      br_taken[26]    <= `SD 0;
      br_taken[27]    <= `SD 0;
      br_taken[28]    <= `SD 0;
      br_taken[29]    <= `SD 0;
      br_taken[30]    <= `SD 0;
      br_taken[31]    <= `SD 0;

      br_target_PC[0]     <= `SD 0;
      br_target_PC[1]     <= `SD 0;
      br_target_PC[2]     <= `SD 0;
      br_target_PC[3]     <= `SD 0;
      br_target_PC[4]     <= `SD 0;
      br_target_PC[5]     <= `SD 0;
      br_target_PC[6]     <= `SD 0;
      br_target_PC[7]     <= `SD 0;
      br_target_PC[8]     <= `SD 0;
      br_target_PC[9]     <= `SD 0;
      br_target_PC[10]    <= `SD 0;
      br_target_PC[11]    <= `SD 0;
      br_target_PC[12]    <= `SD 0;
      br_target_PC[13]    <= `SD 0;
      br_target_PC[14]    <= `SD 0;
      br_target_PC[15]    <= `SD 0;
      br_target_PC[16]    <= `SD 0;
      br_target_PC[17]    <= `SD 0;
      br_target_PC[18]    <= `SD 0;
      br_target_PC[19]    <= `SD 0;
      br_target_PC[20]    <= `SD 0;
      br_target_PC[21]    <= `SD 0;
      br_target_PC[22]    <= `SD 0;
      br_target_PC[23]    <= `SD 0;
      br_target_PC[24]    <= `SD 0;
      br_target_PC[25]    <= `SD 0;
      br_target_PC[26]    <= `SD 0;
      br_target_PC[27]    <= `SD 0;
      br_target_PC[28]    <= `SD 0;
      br_target_PC[29]    <= `SD 0;
      br_target_PC[30]    <= `SD 0;
      br_target_PC[31]    <= `SD 0;

      halt[0]       <= `SD `FALSE;
      halt[1]       <= `SD `FALSE;
      halt[2]       <= `SD `FALSE;
      halt[3]       <= `SD `FALSE;
      halt[4]       <= `SD `FALSE;
      halt[5]       <= `SD `FALSE;
      halt[6]       <= `SD `FALSE;
      halt[7]       <= `SD `FALSE;
      halt[8]       <= `SD `FALSE;
      halt[9]       <= `SD `FALSE;
      halt[10]       <= `SD `FALSE;
      halt[11]       <= `SD `FALSE;
      halt[12]       <= `SD `FALSE;
      halt[13]       <= `SD `FALSE;
      halt[14]       <= `SD `FALSE;
      halt[15]       <= `SD `FALSE;
      halt[16]       <= `SD `FALSE;
      halt[17]       <= `SD `FALSE;
      halt[18]       <= `SD `FALSE;
      halt[19]       <= `SD `FALSE;
      halt[20]       <= `SD `FALSE;
      halt[21]       <= `SD `FALSE;
      halt[22]       <= `SD `FALSE;
      halt[23]       <= `SD `FALSE;
      halt[24]       <= `SD `FALSE;
      halt[25]       <= `SD `FALSE;
      halt[26]       <= `SD `FALSE;
      halt[27]       <= `SD `FALSE;
      halt[28]       <= `SD `FALSE;
      halt[29]       <= `SD `FALSE;
      halt[30]       <= `SD `FALSE;
      halt[31]       <= `SD `FALSE;

      noop[0]       <= `SD `FALSE;
      noop[1]       <= `SD `FALSE;
      noop[2]       <= `SD `FALSE;
      noop[3]       <= `SD `FALSE;
      noop[4]       <= `SD `FALSE;
      noop[5]       <= `SD `FALSE;
      noop[6]       <= `SD `FALSE;
      noop[7]       <= `SD `FALSE;
      noop[8]       <= `SD `FALSE;
      noop[9]       <= `SD `FALSE;
      noop[10]       <= `SD `FALSE;
      noop[11]       <= `SD `FALSE;
      noop[12]       <= `SD `FALSE;
      noop[13]       <= `SD `FALSE;
      noop[14]       <= `SD `FALSE;
      noop[15]       <= `SD `FALSE;
      noop[16]       <= `SD `FALSE;
      noop[17]       <= `SD `FALSE;
      noop[18]       <= `SD `FALSE;
      noop[19]       <= `SD `FALSE;
      noop[20]       <= `SD `FALSE;
      noop[21]       <= `SD `FALSE;
      noop[22]       <= `SD `FALSE;
      noop[23]       <= `SD `FALSE;
      noop[24]       <= `SD `FALSE;
      noop[25]       <= `SD `FALSE;
      noop[26]       <= `SD `FALSE;
      noop[27]       <= `SD `FALSE;
      noop[28]       <= `SD `FALSE;
      noop[29]       <= `SD `FALSE;
      noop[30]       <= `SD `FALSE;
      noop[31]       <= `SD `FALSE;

      NPC[0]       <= `SD `FALSE;
      NPC[1]       <= `SD `FALSE;
      NPC[2]       <= `SD `FALSE;
      NPC[3]       <= `SD `FALSE;
      NPC[4]       <= `SD `FALSE;
      NPC[5]       <= `SD `FALSE;
      NPC[6]       <= `SD `FALSE;
      NPC[7]       <= `SD `FALSE;
      NPC[8]       <= `SD `FALSE;
      NPC[9]       <= `SD `FALSE;
      NPC[10]       <= `SD `FALSE;
      NPC[11]       <= `SD `FALSE;
      NPC[12]       <= `SD `FALSE;
      NPC[13]       <= `SD `FALSE;
      NPC[14]       <= `SD `FALSE;
      NPC[15]       <= `SD `FALSE;
      NPC[16]       <= `SD `FALSE;
      NPC[17]       <= `SD `FALSE;
      NPC[18]       <= `SD `FALSE;
      NPC[19]       <= `SD `FALSE;
      NPC[20]       <= `SD `FALSE;
      NPC[21]       <= `SD `FALSE;
      NPC[22]       <= `SD `FALSE;
      NPC[23]       <= `SD `FALSE;
      NPC[24]       <= `SD `FALSE;
      NPC[25]       <= `SD `FALSE;
      NPC[26]       <= `SD `FALSE;
      NPC[27]       <= `SD `FALSE;
      NPC[28]       <= `SD `FALSE;
      NPC[29]       <= `SD `FALSE;
      NPC[30]       <= `SD `FALSE;
      NPC[31]       <= `SD `FALSE;

      wb_data[0]       <= `SD `FALSE;
      wb_data[1]       <= `SD `FALSE;
      wb_data[2]       <= `SD `FALSE;
      wb_data[3]       <= `SD `FALSE;
      wb_data[4]       <= `SD `FALSE;
      wb_data[5]       <= `SD `FALSE;
      wb_data[6]       <= `SD `FALSE;
      wb_data[7]       <= `SD `FALSE;
      wb_data[8]       <= `SD `FALSE;
      wb_data[9]       <= `SD `FALSE;
      wb_data[10]       <= `SD `FALSE;
      wb_data[11]       <= `SD `FALSE;
      wb_data[12]       <= `SD `FALSE;
      wb_data[13]       <= `SD `FALSE;
      wb_data[14]       <= `SD `FALSE;
      wb_data[15]       <= `SD `FALSE;
      wb_data[16]       <= `SD `FALSE;
      wb_data[17]       <= `SD `FALSE;
      wb_data[18]       <= `SD `FALSE;
      wb_data[19]       <= `SD `FALSE;
      wb_data[20]       <= `SD `FALSE;
      wb_data[21]       <= `SD `FALSE;
      wb_data[22]       <= `SD `FALSE;
      wb_data[23]       <= `SD `FALSE;
      wb_data[24]       <= `SD `FALSE;
      wb_data[25]       <= `SD `FALSE;
      wb_data[26]       <= `SD `FALSE;
      wb_data[27]       <= `SD `FALSE;
      wb_data[28]       <= `SD `FALSE;
      wb_data[29]       <= `SD `FALSE;
      wb_data[30]       <= `SD `FALSE;
      wb_data[31]       <= `SD `FALSE;

      br_t[0]        <= `SD 0;
      br_t[1]        <= `SD 0;
      br_t[2]        <= `SD 0;
      br_t[3]        <= `SD 0;
      T_valid_1      <= `SD 1'd0;
      T_valid_2      <= `SD 1'd0;
    end
    else if(br_mispredict) begin
      T[0]          <= `SD `ZERO_REG;
      T[1]          <= `SD `ZERO_REG;
      T[2]          <= `SD `ZERO_REG;
      T[3]          <= `SD `ZERO_REG;
      T[4]          <= `SD `ZERO_REG;
      T[5]          <= `SD `ZERO_REG;
      T[6]          <= `SD `ZERO_REG;
      T[7]          <= `SD `ZERO_REG;
      T[8]          <= `SD `ZERO_REG;
      T[9]          <= `SD `ZERO_REG;
      T[10]         <= `SD `ZERO_REG;
      T[11]         <= `SD `ZERO_REG;
      T[12]         <= `SD `ZERO_REG;
      T[13]         <= `SD `ZERO_REG;
      T[14]         <= `SD `ZERO_REG;
      T[15]         <= `SD `ZERO_REG;
      T[16]         <= `SD `ZERO_REG;
      T[17]         <= `SD `ZERO_REG;
      T[18]         <= `SD `ZERO_REG;
      T[19]         <= `SD `ZERO_REG;
      T[20]         <= `SD `ZERO_REG;
      T[21]         <= `SD `ZERO_REG;
      T[22]         <= `SD `ZERO_REG;
      T[23]         <= `SD `ZERO_REG;
      T[24]         <= `SD `ZERO_REG;
      T[25]         <= `SD `ZERO_REG;
      T[26]         <= `SD `ZERO_REG;
      T[27]         <= `SD `ZERO_REG;
      T[28]         <= `SD `ZERO_REG;
      T[29]         <= `SD `ZERO_REG;
      T[30]         <= `SD `ZERO_REG;
      T[31]         <= `SD `ZERO_REG;

      Told[0]       <= `SD `ZERO_REG;
      Told[1]       <= `SD `ZERO_REG;
      Told[2]       <= `SD `ZERO_REG;
      Told[3]       <= `SD `ZERO_REG;
      Told[4]       <= `SD `ZERO_REG;
      Told[5]       <= `SD `ZERO_REG;
      Told[6]       <= `SD `ZERO_REG;
      Told[7]       <= `SD `ZERO_REG;
      Told[8]       <= `SD `ZERO_REG;
      Told[9]       <= `SD `ZERO_REG;
      Told[10]      <= `SD `ZERO_REG;
      Told[11]      <= `SD `ZERO_REG;
      Told[12]      <= `SD `ZERO_REG;
      Told[13]      <= `SD `ZERO_REG;
      Told[14]      <= `SD `ZERO_REG;
      Told[15]      <= `SD `ZERO_REG;
      Told[16]      <= `SD `ZERO_REG;
      Told[17]      <= `SD `ZERO_REG;
      Told[18]      <= `SD `ZERO_REG;
      Told[19]      <= `SD `ZERO_REG;
      Told[20]      <= `SD `ZERO_REG;
      Told[21]      <= `SD `ZERO_REG;
      Told[22]      <= `SD `ZERO_REG;
      Told[23]      <= `SD `ZERO_REG;
      Told[24]      <= `SD `ZERO_REG;
      Told[25]      <= `SD `ZERO_REG;
      Told[26]      <= `SD `ZERO_REG;
      Told[27]      <= `SD `ZERO_REG;
      Told[28]      <= `SD `ZERO_REG;
      Told[29]      <= `SD `ZERO_REG;
      Told[30]      <= `SD `ZERO_REG;
      Told[31]      <= `SD `ZERO_REG;

      C[0]          <= `SD 0;
      C[1]          <= `SD 0;
      C[2]          <= `SD 0;
      C[3]          <= `SD 0;
      C[4]          <= `SD 0;
      C[5]          <= `SD 0;
      C[6]          <= `SD 0;
      C[7]          <= `SD 0;
      C[8]          <= `SD 0;
      C[9]          <= `SD 0;
      C[10]         <= `SD 0;
      C[11]         <= `SD 0;
      C[12]         <= `SD 0;
      C[13]         <= `SD 0;
      C[14]         <= `SD 0;
      C[15]         <= `SD 0;
      C[16]         <= `SD 0;
      C[17]         <= `SD 0;
      C[18]         <= `SD 0;
      C[19]         <= `SD 0;
      C[20]         <= `SD 0;
      C[21]         <= `SD 0;
      C[22]         <= `SD 0;
      C[23]         <= `SD 0;
      C[24]         <= `SD 0;
      C[25]         <= `SD 0;
      C[26]         <= `SD 0;
      C[27]         <= `SD 0;
      C[28]         <= `SD 0;
      C[29]         <= `SD 0;
      C[30]         <= `SD 0;
      C[31]         <= `SD 0;

      wr_mem[0]     <= `SD 0;
      wr_mem[1]     <= `SD 0;
      wr_mem[2]     <= `SD 0;
      wr_mem[3]     <= `SD 0;
      wr_mem[4]     <= `SD 0;
      wr_mem[5]     <= `SD 0;
      wr_mem[6]     <= `SD 0;
      wr_mem[7]     <= `SD 0;
      wr_mem[8]     <= `SD 0;
      wr_mem[9]     <= `SD 0;
      wr_mem[10]    <= `SD 0;
      wr_mem[11]    <= `SD 0;
      wr_mem[12]    <= `SD 0;
      wr_mem[13]    <= `SD 0;
      wr_mem[14]    <= `SD 0;
      wr_mem[15]    <= `SD 0;
      wr_mem[16]    <= `SD 0;
      wr_mem[17]    <= `SD 0;
      wr_mem[18]    <= `SD 0;
      wr_mem[19]    <= `SD 0;
      wr_mem[20]    <= `SD 0;
      wr_mem[21]    <= `SD 0;
      wr_mem[22]    <= `SD 0;
      wr_mem[23]    <= `SD 0;
      wr_mem[24]    <= `SD 0;
      wr_mem[25]    <= `SD 0;
      wr_mem[26]    <= `SD 0;
      wr_mem[27]    <= `SD 0;
      wr_mem[28]    <= `SD 0;
      wr_mem[29]    <= `SD 0;
      wr_mem[30]    <= `SD 0;
      wr_mem[31]    <= `SD 0;

      rd_mem[0]     <= `SD 0;
      rd_mem[1]     <= `SD 0;
      rd_mem[2]     <= `SD 0;
      rd_mem[3]     <= `SD 0;
      rd_mem[4]     <= `SD 0;
      rd_mem[5]     <= `SD 0;
      rd_mem[6]     <= `SD 0;
      rd_mem[7]     <= `SD 0;
      rd_mem[8]     <= `SD 0;
      rd_mem[9]     <= `SD 0;
      rd_mem[10]    <= `SD 0;
      rd_mem[11]    <= `SD 0;
      rd_mem[12]    <= `SD 0;
      rd_mem[13]    <= `SD 0;
      rd_mem[14]    <= `SD 0;
      rd_mem[15]    <= `SD 0;
      rd_mem[16]    <= `SD 0;
      rd_mem[17]    <= `SD 0;
      rd_mem[18]    <= `SD 0;
      rd_mem[19]    <= `SD 0;
      rd_mem[20]    <= `SD 0;
      rd_mem[21]    <= `SD 0;
      rd_mem[22]    <= `SD 0;
      rd_mem[23]    <= `SD 0;
      rd_mem[24]    <= `SD 0;
      rd_mem[25]    <= `SD 0;
      rd_mem[26]    <= `SD 0;
      rd_mem[27]    <= `SD 0;
      rd_mem[28]    <= `SD 0;
      rd_mem[29]    <= `SD 0;
      rd_mem[30]    <= `SD 0;
      rd_mem[31]    <= `SD 0;

      br_marker[0]  <= `SD `BR_MARKER_EMPTY;
      br_marker[1]  <= `SD `BR_MARKER_EMPTY;
      br_marker[2]  <= `SD `BR_MARKER_EMPTY;
      br_marker[3]  <= `SD `BR_MARKER_EMPTY;
      br_marker[4]  <= `SD `BR_MARKER_EMPTY;
      br_marker[5]  <= `SD `BR_MARKER_EMPTY;
      br_marker[6]  <= `SD `BR_MARKER_EMPTY;
      br_marker[7]  <= `SD `BR_MARKER_EMPTY;
      br_marker[8]  <= `SD `BR_MARKER_EMPTY;
      br_marker[9]  <= `SD `BR_MARKER_EMPTY;
      br_marker[10] <= `SD `BR_MARKER_EMPTY;
      br_marker[11] <= `SD `BR_MARKER_EMPTY;
      br_marker[12] <= `SD `BR_MARKER_EMPTY;
      br_marker[13] <= `SD `BR_MARKER_EMPTY;
      br_marker[14] <= `SD `BR_MARKER_EMPTY;
      br_marker[15] <= `SD `BR_MARKER_EMPTY;
      br_marker[16] <= `SD `BR_MARKER_EMPTY;
      br_marker[17] <= `SD `BR_MARKER_EMPTY;
      br_marker[18] <= `SD `BR_MARKER_EMPTY;
      br_marker[19] <= `SD `BR_MARKER_EMPTY;
      br_marker[20] <= `SD `BR_MARKER_EMPTY;
      br_marker[21] <= `SD `BR_MARKER_EMPTY;
      br_marker[22] <= `SD `BR_MARKER_EMPTY;
      br_marker[23] <= `SD `BR_MARKER_EMPTY;
      br_marker[24] <= `SD `BR_MARKER_EMPTY;
      br_marker[25] <= `SD `BR_MARKER_EMPTY;
      br_marker[26] <= `SD `BR_MARKER_EMPTY;
      br_marker[27] <= `SD `BR_MARKER_EMPTY;
      br_marker[28] <= `SD `BR_MARKER_EMPTY;
      br_marker[29] <= `SD `BR_MARKER_EMPTY;
      br_marker[30] <= `SD `BR_MARKER_EMPTY;
      br_marker[31] <= `SD `BR_MARKER_EMPTY;

      br[0]     <= `SD 0;
      br[1]     <= `SD 0;
      br[2]     <= `SD 0;
      br[3]     <= `SD 0;
      br[4]     <= `SD 0;
      br[5]     <= `SD 0;
      br[6]     <= `SD 0;
      br[7]     <= `SD 0;
      br[8]     <= `SD 0;
      br[9]     <= `SD 0;
      br[10]    <= `SD 0;
      br[11]    <= `SD 0;
      br[12]    <= `SD 0;
      br[13]    <= `SD 0;
      br[14]    <= `SD 0;
      br[15]    <= `SD 0;
      br[16]    <= `SD 0;
      br[17]    <= `SD 0;
      br[18]    <= `SD 0;
      br[19]    <= `SD 0;
      br[20]    <= `SD 0;
      br[21]    <= `SD 0;
      br[22]    <= `SD 0;
      br[23]    <= `SD 0;
      br[24]    <= `SD 0;
      br[25]    <= `SD 0;
      br[26]    <= `SD 0;
      br[27]    <= `SD 0;
      br[28]    <= `SD 0;
      br[29]    <= `SD 0;
      br[30]    <= `SD 0;
      br[31]    <= `SD 0;

      br_taken[0]     <= `SD 0;
      br_taken[1]     <= `SD 0;
      br_taken[2]     <= `SD 0;
      br_taken[3]     <= `SD 0;
      br_taken[4]     <= `SD 0;
      br_taken[5]     <= `SD 0;
      br_taken[6]     <= `SD 0;
      br_taken[7]     <= `SD 0;
      br_taken[8]     <= `SD 0;
      br_taken[9]     <= `SD 0;
      br_taken[10]    <= `SD 0;
      br_taken[11]    <= `SD 0;
      br_taken[12]    <= `SD 0;
      br_taken[13]    <= `SD 0;
      br_taken[14]    <= `SD 0;
      br_taken[15]    <= `SD 0;
      br_taken[16]    <= `SD 0;
      br_taken[17]    <= `SD 0;
      br_taken[18]    <= `SD 0;
      br_taken[19]    <= `SD 0;
      br_taken[20]    <= `SD 0;
      br_taken[21]    <= `SD 0;
      br_taken[22]    <= `SD 0;
      br_taken[23]    <= `SD 0;
      br_taken[24]    <= `SD 0;
      br_taken[25]    <= `SD 0;
      br_taken[26]    <= `SD 0;
      br_taken[27]    <= `SD 0;
      br_taken[28]    <= `SD 0;
      br_taken[29]    <= `SD 0;
      br_taken[30]    <= `SD 0;
      br_taken[31]    <= `SD 0;

      br_target_PC[0]     <= `SD 0;
      br_target_PC[1]     <= `SD 0;
      br_target_PC[2]     <= `SD 0;
      br_target_PC[3]     <= `SD 0;
      br_target_PC[4]     <= `SD 0;
      br_target_PC[5]     <= `SD 0;
      br_target_PC[6]     <= `SD 0;
      br_target_PC[7]     <= `SD 0;
      br_target_PC[8]     <= `SD 0;
      br_target_PC[9]     <= `SD 0;
      br_target_PC[10]    <= `SD 0;
      br_target_PC[11]    <= `SD 0;
      br_target_PC[12]    <= `SD 0;
      br_target_PC[13]    <= `SD 0;
      br_target_PC[14]    <= `SD 0;
      br_target_PC[15]    <= `SD 0;
      br_target_PC[16]    <= `SD 0;
      br_target_PC[17]    <= `SD 0;
      br_target_PC[18]    <= `SD 0;
      br_target_PC[19]    <= `SD 0;
      br_target_PC[20]    <= `SD 0;
      br_target_PC[21]    <= `SD 0;
      br_target_PC[22]    <= `SD 0;
      br_target_PC[23]    <= `SD 0;
      br_target_PC[24]    <= `SD 0;
      br_target_PC[25]    <= `SD 0;
      br_target_PC[26]    <= `SD 0;
      br_target_PC[27]    <= `SD 0;
      br_target_PC[28]    <= `SD 0;
      br_target_PC[29]    <= `SD 0;
      br_target_PC[30]    <= `SD 0;
      br_target_PC[31]    <= `SD 0;

      halt[0]       <= `SD `FALSE;
      halt[1]       <= `SD `FALSE;
      halt[2]       <= `SD `FALSE;
      halt[3]       <= `SD `FALSE;
      halt[4]       <= `SD `FALSE;
      halt[5]       <= `SD `FALSE;
      halt[6]       <= `SD `FALSE;
      halt[7]       <= `SD `FALSE;
      halt[8]       <= `SD `FALSE;
      halt[9]       <= `SD `FALSE;
      halt[10]       <= `SD `FALSE;
      halt[11]       <= `SD `FALSE;
      halt[12]       <= `SD `FALSE;
      halt[13]       <= `SD `FALSE;
      halt[14]       <= `SD `FALSE;
      halt[15]       <= `SD `FALSE;
      halt[16]       <= `SD `FALSE;
      halt[17]       <= `SD `FALSE;
      halt[18]       <= `SD `FALSE;
      halt[19]       <= `SD `FALSE;
      halt[20]       <= `SD `FALSE;
      halt[21]       <= `SD `FALSE;
      halt[22]       <= `SD `FALSE;
      halt[23]       <= `SD `FALSE;
      halt[24]       <= `SD `FALSE;
      halt[25]       <= `SD `FALSE;
      halt[26]       <= `SD `FALSE;
      halt[27]       <= `SD `FALSE;
      halt[28]       <= `SD `FALSE;
      halt[29]       <= `SD `FALSE;
      halt[30]       <= `SD `FALSE;
      halt[31]       <= `SD `FALSE;

      noop[0]       <= `SD `FALSE;
      noop[1]       <= `SD `FALSE;
      noop[2]       <= `SD `FALSE;
      noop[3]       <= `SD `FALSE;
      noop[4]       <= `SD `FALSE;
      noop[5]       <= `SD `FALSE;
      noop[6]       <= `SD `FALSE;
      noop[7]       <= `SD `FALSE;
      noop[8]       <= `SD `FALSE;
      noop[9]       <= `SD `FALSE;
      noop[10]       <= `SD `FALSE;
      noop[11]       <= `SD `FALSE;
      noop[12]       <= `SD `FALSE;
      noop[13]       <= `SD `FALSE;
      noop[14]       <= `SD `FALSE;
      noop[15]       <= `SD `FALSE;
      noop[16]       <= `SD `FALSE;
      noop[17]       <= `SD `FALSE;
      noop[18]       <= `SD `FALSE;
      noop[19]       <= `SD `FALSE;
      noop[20]       <= `SD `FALSE;
      noop[21]       <= `SD `FALSE;
      noop[22]       <= `SD `FALSE;
      noop[23]       <= `SD `FALSE;
      noop[24]       <= `SD `FALSE;
      noop[25]       <= `SD `FALSE;
      noop[26]       <= `SD `FALSE;
      noop[27]       <= `SD `FALSE;
      noop[28]       <= `SD `FALSE;
      noop[29]       <= `SD `FALSE;
      noop[30]       <= `SD `FALSE;
      noop[31]       <= `SD `FALSE;

      NPC[0]       <= `SD `FALSE;
      NPC[1]       <= `SD `FALSE;
      NPC[2]       <= `SD `FALSE;
      NPC[3]       <= `SD `FALSE;
      NPC[4]       <= `SD `FALSE;
      NPC[5]       <= `SD `FALSE;
      NPC[6]       <= `SD `FALSE;
      NPC[7]       <= `SD `FALSE;
      NPC[8]       <= `SD `FALSE;
      NPC[9]       <= `SD `FALSE;
      NPC[10]       <= `SD `FALSE;
      NPC[11]       <= `SD `FALSE;
      NPC[12]       <= `SD `FALSE;
      NPC[13]       <= `SD `FALSE;
      NPC[14]       <= `SD `FALSE;
      NPC[15]       <= `SD `FALSE;
      NPC[16]       <= `SD `FALSE;
      NPC[17]       <= `SD `FALSE;
      NPC[18]       <= `SD `FALSE;
      NPC[19]       <= `SD `FALSE;
      NPC[20]       <= `SD `FALSE;
      NPC[21]       <= `SD `FALSE;
      NPC[22]       <= `SD `FALSE;
      NPC[23]       <= `SD `FALSE;
      NPC[24]       <= `SD `FALSE;
      NPC[25]       <= `SD `FALSE;
      NPC[26]       <= `SD `FALSE;
      NPC[27]       <= `SD `FALSE;
      NPC[28]       <= `SD `FALSE;
      NPC[29]       <= `SD `FALSE;
      NPC[30]       <= `SD `FALSE;
      NPC[31]       <= `SD `FALSE;

      wb_data[0]       <= `SD `FALSE;
      wb_data[1]       <= `SD `FALSE;
      wb_data[2]       <= `SD `FALSE;
      wb_data[3]       <= `SD `FALSE;
      wb_data[4]       <= `SD `FALSE;
      wb_data[5]       <= `SD `FALSE;
      wb_data[6]       <= `SD `FALSE;
      wb_data[7]       <= `SD `FALSE;
      wb_data[8]       <= `SD `FALSE;
      wb_data[9]       <= `SD `FALSE;
      wb_data[10]       <= `SD `FALSE;
      wb_data[11]       <= `SD `FALSE;
      wb_data[12]       <= `SD `FALSE;
      wb_data[13]       <= `SD `FALSE;
      wb_data[14]       <= `SD `FALSE;
      wb_data[15]       <= `SD `FALSE;
      wb_data[16]       <= `SD `FALSE;
      wb_data[17]       <= `SD `FALSE;
      wb_data[18]       <= `SD `FALSE;
      wb_data[19]       <= `SD `FALSE;
      wb_data[20]       <= `SD `FALSE;
      wb_data[21]       <= `SD `FALSE;
      wb_data[22]       <= `SD `FALSE;
      wb_data[23]       <= `SD `FALSE;
      wb_data[24]       <= `SD `FALSE;
      wb_data[25]       <= `SD `FALSE;
      wb_data[26]       <= `SD `FALSE;
      wb_data[27]       <= `SD `FALSE;
      wb_data[28]       <= `SD `FALSE;
      wb_data[29]       <= `SD `FALSE;
      wb_data[30]       <= `SD `FALSE;
      wb_data[31]       <= `SD `FALSE;

      br_t[0]        <= `SD 0;
      br_t[1]        <= `SD 0;
      br_t[2]        <= `SD 0;
      br_t[3]        <= `SD 0;

      h              <= `SD next_h;
      t              <= `SD br_t[br_mispre_marker[1:0]];
      // Retire
      if(retire_two) begin
        T_out_1        <= `SD T[h[4:0]];
        T_out_2        <= `SD T[h_plus_1[4:0]];
        Told_out_1     <= `SD Told[h[4:0]];
        Told_out_2     <= `SD Told[h_plus_1[4:0]];
        T_valid_1      <= `SD 1'd1;
        T_valid_2      <= `SD 1'd1;
        NPC_out_1      <= `SD NPC[h[4:0]];
        NPC_out_2      <= `SD NPC[h_plus_1[4:0]];
        wb_data_out_1  <= `SD wb_data[h[4:0]];
        wb_data_out_2  <= `SD wb_data[h_plus_1[4:0]];
      end
      else if(retire_one) begin
        T_out_1        <= `SD T[h[4:0]];
        T_out_2        <= `SD `ZERO_REG;
        Told_out_1     <= `SD Told[h[4:0]];
        Told_out_2     <= `SD `ZERO_REG;
        T_valid_1      <= `SD 1'd1;
        T_valid_2      <= `SD 1'd0;
        NPC_out_1      <= `SD NPC[h[4:0]];
        NPC_out_2      <= `SD 0;
        wb_data_out_1  <= `SD wb_data[h[4:0]];
        wb_data_out_2  <= `SD 0;
      end
      else begin
        T_valid_1  <= `SD 1'd0;
        T_valid_2  <= `SD 1'd0;
      end
    end
    else begin
      // Dispatch
      if(h==t) begin
        if(T_wr_en_2 && T_wr_en_1) begin
          T[h[4:0]]                <= `SD T_in_1;
          T[h_plus_1[4:0]]         <= `SD T_in_2;
          Told[h[4:0]]             <= `SD Told_in_1;
          Told[h_plus_1[4:0]]      <= `SD Told_in_2;
          wr_mem[h[4:0]]           <= `SD id_wr_mem_in_1;
          wr_mem[h_plus_1[4:0]]    <= `SD id_wr_mem_in_2;
          rd_mem[h[4:0]]           <= `SD id_rd_mem_in_1;
          rd_mem[h_plus_1[4:0]]    <= `SD id_rd_mem_in_2;
          br_marker[h[4:0]]        <= `SD br_marker_in_1;
          br_marker[h_plus_1[4:0]] <= `SD br_marker_in_2;
          C[h[4:0]]                <= `SD 1'd0;
          C[h_plus_1[4:0]]         <= `SD 1'd0;
          t                        <= `SD next_t;
          NPC[h[4:0]]              <= `SD NPC_1;
          NPC[h_plus_1[4:0]]       <= `SD NPC_2;
          halt[h[4:0]]             <= `SD id_halt_in_1;
          halt[h_plus_1[4:0]]      <= `SD id_halt_in_2;
          noop[h[4:0]]             <= `SD id_noop_in_1;
          noop[h_plus_1[4:0]]      <= `SD id_noop_in_2;
          br[h[4:0]]               <= `SD id_br_in_1;
          br[h_plus_1[4:0]]        <= `SD id_br_in_2;
        end
        else if(T_wr_en_1) begin
          T[h[4:0]]                <= `SD T_in_1;
          Told[h[4:0]]             <= `SD Told_in_1;
          wr_mem[h[4:0]]           <= `SD id_wr_mem_in_1;
          rd_mem[h[4:0]]           <= `SD id_rd_mem_in_1;
          br_marker[h[4:0]]        <= `SD br_marker_in_1;
          C[h[4:0]]                <= `SD 1'd0;
          t                        <= `SD next_t;
          NPC[h[4:0]]              <= `SD NPC_1;
          halt[h[4:0]]             <= `SD id_halt_in_1;
          noop[h[4:0]]             <= `SD id_noop_in_1;
          br[h[4:0]]               <= `SD id_br_in_1;
        end
        else if(T_wr_en_2) begin
          T[h[4:0]]                <= `SD T_in_2;
          Told[h[4:0]]             <= `SD Told_in_2;
          wr_mem[h[4:0]]           <= `SD id_wr_mem_in_2;
          rd_mem[h[4:0]]           <= `SD id_rd_mem_in_2;
          br_marker[h[4:0]]        <= `SD br_marker_in_2;
          C[h[4:0]]                <= `SD 1'd0;
          t                        <= `SD next_t;
          NPC[h[4:0]]              <= `SD NPC_2;
          halt[h[4:0]]             <= `SD id_halt_in_2;
          noop[h[4:0]]             <= `SD id_noop_in_2;
          br[h[4:0]]               <= `SD id_br_in_2;
        end
      end
      else begin
        if(T_wr_en_2 && T_wr_en_1) begin
          T[t[4:0]]                <= `SD T_in_1;
          T[t_plus_1[4:0]]         <= `SD T_in_2;
          Told[t[4:0]]             <= `SD Told_in_1;
          Told[t_plus_1[4:0]]      <= `SD Told_in_2;
          wr_mem[t[4:0]]           <= `SD id_wr_mem_in_1;
          wr_mem[t_plus_1[4:0]]    <= `SD id_wr_mem_in_2;
          rd_mem[t[4:0]]           <= `SD id_rd_mem_in_1;
          rd_mem[t_plus_1[4:0]]    <= `SD id_rd_mem_in_2;
          br_marker[t[4:0]]        <= `SD br_marker_in_1;
          br_marker[t_plus_1[4:0]] <= `SD br_marker_in_2;
          C[t[4:0]]                <= `SD 1'd0;
          C[t_plus_1[4:0]]         <= `SD 1'd0;
          t                        <= `SD next_t;
          NPC[t[4:0]]              <= `SD NPC_1;
          NPC[t_plus_1[4:0]]       <= `SD NPC_2;
          halt[t[4:0]]             <= `SD id_halt_in_1;
          halt[t_plus_1[4:0]]      <= `SD id_halt_in_2;
          noop[t[4:0]]             <= `SD id_noop_in_1;
          noop[t_plus_1[4:0]]      <= `SD id_noop_in_2;
          br[t[4:0]]               <= `SD id_br_in_1;
          br[t_plus_1[4:0]]        <= `SD id_br_in_2;
        end
        else if(T_wr_en_1) begin
          T[t[4:0]]               <= `SD T_in_1;
          Told[t[4:0]]            <= `SD Told_in_1;
          wr_mem[t[4:0]]          <= `SD id_wr_mem_in_1;
          rd_mem[t[4:0]]          <= `SD id_rd_mem_in_1;
          br_marker[t[4:0]]       <= `SD br_marker_in_1;
          C[t[4:0]]               <= `SD 1'd0;
          t                       <= `SD next_t;
          NPC[t[4:0]]             <= `SD NPC_1;
          halt[t[4:0]]            <= `SD id_halt_in_1;
          noop[t[4:0]]            <= `SD id_noop_in_1;
          br[t[4:0]]              <= `SD id_br_in_1;
        end
        else if(T_wr_en_2) begin
          T[t[4:0]]               <= `SD T_in_2;
          Told[t[4:0]]            <= `SD Told_in_2;
          wr_mem[t[4:0]]          <= `SD id_wr_mem_in_2;
          rd_mem[t[4:0]]          <= `SD id_rd_mem_in_2;
          br_marker[t[4:0]]       <= `SD br_marker_in_2;
          C[t[4:0]]               <= `SD 1'd0;
          t                       <= `SD next_t;
          NPC[t[4:0]]             <= `SD NPC_2;
          halt[t[4:0]]            <= `SD id_halt_in_2;
          noop[t[4:0]]            <= `SD id_noop_in_2;
          br[t[4:0]]              <= `SD id_br_in_2;
        end
      end


      // Complete
      if(C_wr_en_1 && T[0]==C_tag_1) begin
        C[0]         <= `SD 1'd1;
        wb_data[0]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[0]==C_tag_2) begin
        C[0]         <= `SD 1'd1;
        wb_data[0]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[0]==X_br_marker_1) begin
        C[0]         <= `SD T[0]==`ZERO_REG;
        br_taken[0]  <= `SD X_br_taken_1;
        br_target_PC[0] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[0]==X_br_marker_2) begin
        C[0]         <= `SD T[0]==`ZERO_REG;
        br_taken[0]  <= `SD X_br_taken_2;
        br_target_PC[0] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[1]==C_tag_1) begin
        C[1]         <= `SD 1'd1;
        wb_data[1]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[1]==C_tag_2) begin
        C[1]         <= `SD 1'd1;
        wb_data[1]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[1]==X_br_marker_1) begin
        C[1]         <= `SD T[1]==`ZERO_REG;
        br_taken[1]  <= `SD X_br_taken_1;
        br_target_PC[1] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[1]==X_br_marker_2) begin
        C[1]         <= `SD T[1]==`ZERO_REG;
        br_taken[1]  <= `SD X_br_taken_2;
        br_target_PC[1] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[2]==C_tag_1) begin
        C[2]         <= `SD 1'd1;
        wb_data[2]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[2]==C_tag_2) begin
        C[2]         <= `SD 1'd1;
        wb_data[2]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[2]==X_br_marker_1) begin
        C[2]         <= `SD T[2]==`ZERO_REG;
        br_taken[2]  <= `SD X_br_taken_1;
        br_target_PC[2] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[2]==X_br_marker_2) begin
        C[2]         <= `SD T[2]==`ZERO_REG;
        br_taken[2]  <= `SD X_br_taken_2;
        br_target_PC[2] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[3]==C_tag_1) begin
        C[3]         <= `SD 1'd1;
        wb_data[3]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[3]==C_tag_2) begin
        C[3]         <= `SD 1'd1;
        wb_data[3]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[3]==X_br_marker_1) begin
        C[3]         <= `SD T[3]==`ZERO_REG;
        br_taken[3]  <= `SD X_br_taken_1;
        br_target_PC[3] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[3]==X_br_marker_2) begin
        C[3]         <= `SD T[3]==`ZERO_REG;
        br_taken[3]  <= `SD X_br_taken_2;
        br_target_PC[3] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[4]==C_tag_1) begin
        C[4]         <= `SD 1'd1;
        wb_data[4]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[4]==C_tag_2) begin
        C[4]         <= `SD 1'd1;
        wb_data[4]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[4]==X_br_marker_1) begin
        C[4]         <= `SD T[4]==`ZERO_REG;
        br_taken[4]  <= `SD X_br_taken_1;
        br_target_PC[4] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[4]==X_br_marker_2) begin
        C[4]         <= `SD T[4]==`ZERO_REG;
        br_taken[4]  <= `SD X_br_taken_2;
        br_target_PC[4] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[5]==C_tag_1) begin
        C[5]         <= `SD 1'd1;
        wb_data[5]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[5]==C_tag_2) begin
        C[5]         <= `SD 1'd1;
        wb_data[5]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[5]==X_br_marker_1) begin
        C[5]         <= `SD T[5]==`ZERO_REG;
        br_taken[5]  <= `SD X_br_taken_1;
        br_target_PC[5] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[5]==X_br_marker_2) begin
        C[5]         <= `SD T[5]==`ZERO_REG;
        br_taken[5]  <= `SD X_br_taken_2;
        br_target_PC[5] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[6]==C_tag_1) begin
        C[6]         <= `SD 1'd1;
        wb_data[6]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[6]==C_tag_2) begin
        C[6]         <= `SD 1'd1;
        wb_data[6]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[6]==X_br_marker_1) begin
        C[6]         <= `SD T[6]==`ZERO_REG;
        br_taken[6]  <= `SD X_br_taken_1;
        br_target_PC[6] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[6]==X_br_marker_2) begin
        C[6]         <= `SD T[6]==`ZERO_REG;
        br_taken[6]  <= `SD X_br_taken_2;
        br_target_PC[6] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[7]==C_tag_1) begin
        C[7]         <= `SD 1'd1;
        wb_data[7]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[7]==C_tag_2) begin
        C[7]         <= `SD 1'd1;
        wb_data[7]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[7]==X_br_marker_1) begin
        C[7]         <= `SD T[7]==`ZERO_REG;
        br_taken[7]  <= `SD X_br_taken_1;
        br_target_PC[7] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[7]==X_br_marker_2) begin
        C[7]         <= `SD T[7]==`ZERO_REG;
        br_taken[7]  <= `SD X_br_taken_2;
        br_target_PC[7] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[8]==C_tag_1) begin
        C[8]         <= `SD 1'd1;
        wb_data[8]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[8]==C_tag_2) begin
        C[8]         <= `SD 1'd1;
        wb_data[8]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[8]==X_br_marker_1) begin
        C[8]         <= `SD T[8]==`ZERO_REG;
        br_taken[8]  <= `SD X_br_taken_1;
        br_target_PC[8] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[8]==X_br_marker_2) begin
        C[8]         <= `SD T[8]==`ZERO_REG;
        br_taken[8]  <= `SD X_br_taken_2;
        br_target_PC[8] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[9]==C_tag_1) begin
        C[9]         <= `SD 1'd1;
        wb_data[9]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[9]==C_tag_2) begin
        C[9]         <= `SD 1'd1;
        wb_data[9]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[9]==X_br_marker_1) begin
        C[9]         <= `SD T[9]==`ZERO_REG;
        br_taken[9]  <= `SD X_br_taken_1;
        br_target_PC[9] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[9]==X_br_marker_2) begin
        C[9]         <= `SD T[9]==`ZERO_REG;
        br_taken[9]  <= `SD X_br_taken_2;
        br_target_PC[9] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[10]==C_tag_1) begin
        C[10]         <= `SD 1'd1;
        wb_data[10]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[10]==C_tag_2) begin
        C[10]         <= `SD 1'd1;
        wb_data[10]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[10]==X_br_marker_1) begin
        C[10]         <= `SD T[10]==`ZERO_REG;
        br_taken[10]  <= `SD X_br_taken_1;
        br_target_PC[10] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[10]==X_br_marker_2) begin
        C[10]         <= `SD T[10]==`ZERO_REG;
        br_taken[10]  <= `SD X_br_taken_2;
        br_target_PC[10] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[11]==C_tag_1) begin
        C[11]         <= `SD 1'd1;
        wb_data[11]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[11]==C_tag_2) begin
        C[11]         <= `SD 1'd1;
        wb_data[11]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[11]==X_br_marker_1) begin
        C[11]         <= `SD T[11]==`ZERO_REG;
        br_taken[11]  <= `SD X_br_taken_1;
        br_target_PC[11] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[11]==X_br_marker_2) begin
        C[11]         <= `SD T[11]==`ZERO_REG;
        br_taken[11]  <= `SD X_br_taken_2;
        br_target_PC[11] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[12]==C_tag_1) begin
        C[12]         <= `SD 1'd1;
        wb_data[12]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[12]==C_tag_2) begin
        C[12]         <= `SD 1'd1;
        wb_data[12]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[12]==X_br_marker_1) begin
        C[12]         <= `SD T[12]==`ZERO_REG;
        br_taken[12]  <= `SD X_br_taken_1;
        br_target_PC[12] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[12]==X_br_marker_2) begin
        C[12]         <= `SD T[12]==`ZERO_REG;
        br_taken[12]  <= `SD X_br_taken_2;
        br_target_PC[12] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[13]==C_tag_1) begin
        C[13]         <= `SD 1'd1;
        wb_data[13]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[13]==C_tag_2) begin
        C[13]         <= `SD 1'd1;
        wb_data[13]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[13]==X_br_marker_1) begin
        C[13]         <= `SD T[13]==`ZERO_REG;
        br_taken[13]  <= `SD X_br_taken_1;
        br_target_PC[13] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[13]==X_br_marker_2) begin
        C[13]         <= `SD T[13]==`ZERO_REG;
        br_taken[13]  <= `SD X_br_taken_2;
        br_target_PC[13] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[14]==C_tag_1) begin
        C[14]         <= `SD 1'd1;
        wb_data[14]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[14]==C_tag_2) begin
        C[14]         <= `SD 1'd1;
        wb_data[14]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[14]==X_br_marker_1) begin
        C[14]         <= `SD T[14]==`ZERO_REG;
        br_taken[14]  <= `SD X_br_taken_1;
        br_target_PC[14] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[14]==X_br_marker_2) begin
        C[14]         <= `SD T[14]==`ZERO_REG;
        br_taken[14]  <= `SD X_br_taken_2;
        br_target_PC[14] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[15]==C_tag_1) begin
        C[15]         <= `SD 1'd1;
        wb_data[15]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[15]==C_tag_2) begin
        C[15]         <= `SD 1'd1;
        wb_data[15]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[15]==X_br_marker_1) begin
        C[15]         <= `SD T[15]==`ZERO_REG;
        br_taken[15]  <= `SD X_br_taken_1;
        br_target_PC[15] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[15]==X_br_marker_2) begin
        C[15]         <= `SD T[15]==`ZERO_REG;
        br_taken[15]  <= `SD X_br_taken_2;
        br_target_PC[15] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[16]==C_tag_1) begin
        C[16]         <= `SD 1'd1;
        wb_data[16]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[16]==C_tag_2) begin
        C[16]         <= `SD 1'd1;
        wb_data[16]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[16]==X_br_marker_1) begin
        C[16]         <= `SD T[16]==`ZERO_REG;
        br_taken[16]  <= `SD X_br_taken_1;
        br_target_PC[16] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[16]==X_br_marker_2) begin
        C[16]         <= `SD T[16]==`ZERO_REG;
        br_taken[16]  <= `SD X_br_taken_2;
        br_target_PC[16] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[17]==C_tag_1) begin
        C[17]         <= `SD 1'd1;
        wb_data[17]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[17]==C_tag_2) begin
        C[17]         <= `SD 1'd1;
        wb_data[17]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[17]==X_br_marker_1) begin
        C[17]         <= `SD T[17]==`ZERO_REG;
        br_taken[17]  <= `SD X_br_taken_1;
        br_target_PC[17] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[17]==X_br_marker_2) begin
        C[17]         <= `SD T[17]==`ZERO_REG;
        br_taken[17]  <= `SD X_br_taken_2;
        br_target_PC[17] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[18]==C_tag_1) begin
        C[18]         <= `SD 1'd1;
        wb_data[18]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[18]==C_tag_2) begin
        C[18]         <= `SD 1'd1;
        wb_data[18]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[18]==X_br_marker_1) begin
        C[18]         <= `SD T[18]==`ZERO_REG;
        br_taken[18]  <= `SD X_br_taken_1;
        br_target_PC[18] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[18]==X_br_marker_2) begin
        C[18]         <= `SD T[18]==`ZERO_REG;
        br_taken[18]  <= `SD X_br_taken_2;
        br_target_PC[18] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[19]==C_tag_1) begin
        C[19]         <= `SD 1'd1;
        wb_data[19]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[19]==C_tag_2) begin
        C[19]         <= `SD 1'd1;
        wb_data[19]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[19]==X_br_marker_1) begin
        C[19]         <= `SD T[19]==`ZERO_REG;
        br_taken[19]  <= `SD X_br_taken_1;
        br_target_PC[19] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[19]==X_br_marker_2) begin
        C[19]         <= `SD T[19]==`ZERO_REG;
        br_taken[19]  <= `SD X_br_taken_2;
        br_target_PC[19] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[20]==C_tag_1) begin
        C[20]         <= `SD 1'd1;
        wb_data[20]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[20]==C_tag_2) begin
        C[20]         <= `SD 1'd1;
        wb_data[20]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[20]==X_br_marker_1) begin
        C[20]         <= `SD T[20]==`ZERO_REG;
        br_taken[20]  <= `SD X_br_taken_1;
        br_target_PC[20] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[20]==X_br_marker_2) begin
        C[20]         <= `SD T[20]==`ZERO_REG;
        br_taken[20]  <= `SD X_br_taken_2;
        br_target_PC[20] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[21]==C_tag_1) begin
        C[21]         <= `SD 1'd1;
        wb_data[21]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[21]==C_tag_2) begin
        C[21]         <= `SD 1'd1;
        wb_data[21]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[21]==X_br_marker_1) begin
        C[21]         <= `SD T[21]==`ZERO_REG;
        br_taken[21]  <= `SD X_br_taken_1;
        br_target_PC[21] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[21]==X_br_marker_2) begin
        C[21]         <= `SD T[21]==`ZERO_REG;
        br_taken[21]  <= `SD X_br_taken_2;
        br_target_PC[21] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[22]==C_tag_1) begin
        C[22]         <= `SD 1'd1;
        wb_data[22]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[22]==C_tag_2) begin
        C[22]         <= `SD 1'd1;
        wb_data[22]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[22]==X_br_marker_1) begin
        C[22]         <= `SD T[22]==`ZERO_REG;
        br_taken[22]  <= `SD X_br_taken_1;
        br_target_PC[22] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[22]==X_br_marker_2) begin
        C[22]         <= `SD T[22]==`ZERO_REG;
        br_taken[22]  <= `SD X_br_taken_2;
        br_target_PC[22] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[23]==C_tag_1) begin
        C[23]         <= `SD 1'd1;
        wb_data[23]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[23]==C_tag_2) begin
        C[23]         <= `SD 1'd1;
        wb_data[23]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[23]==X_br_marker_1) begin
        C[23]         <= `SD T[23]==`ZERO_REG;
        br_taken[23]  <= `SD X_br_taken_1;
        br_target_PC[23] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[23]==X_br_marker_2) begin
        C[23]         <= `SD T[23]==`ZERO_REG;
        br_taken[23]  <= `SD X_br_taken_2;
        br_target_PC[23] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[24]==C_tag_1) begin
        C[24]         <= `SD 1'd1;
        wb_data[24]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[24]==C_tag_2) begin
        C[24]         <= `SD 1'd1;
        wb_data[24]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[24]==X_br_marker_1) begin
        C[24]         <= `SD T[24]==`ZERO_REG;
        br_taken[24]  <= `SD X_br_taken_1;
        br_target_PC[24] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[24]==X_br_marker_2) begin
        C[24]         <= `SD T[24]==`ZERO_REG;
        br_taken[24]  <= `SD X_br_taken_2;
        br_target_PC[24] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[25]==C_tag_1) begin
        C[25]         <= `SD 1'd1;
        wb_data[25]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[25]==C_tag_2) begin
        C[25]         <= `SD 1'd1;
        wb_data[25]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[25]==X_br_marker_1) begin
        C[25]         <= `SD T[25]==`ZERO_REG;
        br_taken[25]  <= `SD X_br_taken_1;
        br_target_PC[25] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[25]==X_br_marker_2) begin
        C[25]         <= `SD T[25]==`ZERO_REG;
        br_taken[25]  <= `SD X_br_taken_2;
        br_target_PC[25] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[26]==C_tag_1) begin
        C[26]         <= `SD 1'd1;
        wb_data[26]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[26]==C_tag_2) begin
        C[26]         <= `SD 1'd1;
        wb_data[26]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[26]==X_br_marker_1) begin
        C[26]         <= `SD T[26]==`ZERO_REG;;
        br_taken[26]  <= `SD X_br_taken_1;
        br_target_PC[26] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[26]==X_br_marker_2) begin
        C[26]         <= `SD T[26]==`ZERO_REG;
        br_taken[26]  <= `SD X_br_taken_2;
        br_target_PC[26] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[27]==C_tag_1) begin
        C[27]         <= `SD 1'd1;
        wb_data[27]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[27]==C_tag_2) begin
        C[27]         <= `SD 1'd1;
        wb_data[27]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[27]==X_br_marker_1) begin
        C[27]         <= `SD T[27]==`ZERO_REG;
        br_taken[27]  <= `SD X_br_taken_1;
        br_target_PC[27] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[27]==X_br_marker_2) begin
        C[27]         <= `SD T[27]==`ZERO_REG;
        br_taken[27]  <= `SD X_br_taken_2;
        br_target_PC[27] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[28]==C_tag_1) begin
        C[28]         <= `SD 1'd1;
        wb_data[28]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[28]==C_tag_2) begin
        C[28]         <= `SD 1'd1;
        wb_data[28]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[28]==X_br_marker_1) begin
        C[28]         <= `SD T[28]==`ZERO_REG;
        br_taken[28]  <= `SD X_br_taken_1;
        br_target_PC[28] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[28]==X_br_marker_2) begin
        C[28]         <= `SD T[28]==`ZERO_REG;
        br_taken[28]  <= `SD X_br_taken_2;
        br_target_PC[28] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[29]==C_tag_1) begin
        C[29]         <= `SD 1'd1;
        wb_data[29]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[29]==C_tag_2) begin
        C[29]         <= `SD 1'd1;
        wb_data[29]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[29]==X_br_marker_1) begin
        C[29]         <= `SD T[29]==`ZERO_REG;
        br_taken[29]  <= `SD X_br_taken_1;
        br_target_PC[29] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[29]==X_br_marker_2) begin
        C[29]         <= `SD T[29]==`ZERO_REG;
        br_taken[29]  <= `SD X_br_taken_2;
        br_target_PC[29] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[30]==C_tag_1) begin
        C[30]         <= `SD 1'd1;
        wb_data[30]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[30]==C_tag_2) begin
        C[30]         <= `SD 1'd1;
        wb_data[30]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[30]==X_br_marker_1) begin
        C[30]         <= `SD T[30]==`ZERO_REG;
        br_taken[30]  <= `SD X_br_taken_1;
        br_target_PC[30] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[30]==X_br_marker_2) begin
        C[30]         <= `SD T[30]==`ZERO_REG;
        br_taken[30]  <= `SD X_br_taken_2;
        br_target_PC[30] <= `SD X_br_target_PC_2;
      end

      if(C_wr_en_1 && T[31]==C_tag_1) begin
        C[31]         <= `SD 1'd1;
        wb_data[31]   <= `SD C_wb_data_1;
      end
      else if(C_wr_en_2 && T[31]==C_tag_2) begin
        C[31]         <= `SD 1'd1;
        wb_data[31]   <= `SD C_wb_data_2;
      end
      else if(X_br_wr_en_1 && br_marker[31]==X_br_marker_1) begin
        C[31]         <= `SD T[31]==`ZERO_REG;
        br_taken[31]  <= `SD X_br_taken_1;
        br_target_PC[31] <= `SD X_br_target_PC_1;
      end
      else if(X_br_wr_en_2 && br_marker[31]==X_br_marker_2) begin
        C[31]         <= `SD T[31]==`ZERO_REG;
        br_taken[31]  <= `SD X_br_taken_2;
        br_target_PC[31] <= `SD X_br_target_PC_2;
      end
      // Retire
      if(retire_two) begin
        h              <= `SD next_h;
        T_out_1        <= `SD T[h[4:0]];
        T_out_2        <= `SD T[h_plus_1[4:0]];
        Told_out_1     <= `SD Told[h[4:0]];
        Told_out_2     <= `SD Told[h_plus_1[4:0]];
        T_valid_1      <= `SD 1'd1;
        T_valid_2      <= `SD 1'd1;
        NPC_out_1      <= `SD NPC[h[4:0]];
        NPC_out_2      <= `SD NPC[h_plus_1[4:0]];
        wb_data_out_1  <= `SD wb_data[h[4:0]];
        wb_data_out_2  <= `SD wb_data[h_plus_1[4:0]];
      end
      else if(retire_one) begin
        h              <= `SD next_h;
        T_out_1        <= `SD T[h[4:0]];
        T_out_2        <= `SD `ZERO_REG;
        Told_out_1     <= `SD Told[h[4:0]];
        Told_out_2     <= `SD `ZERO_REG;
        T_valid_1      <= `SD 1'd1;
        T_valid_2      <= `SD 1'd0;
        NPC_out_1      <= `SD NPC[h[4:0]];
        NPC_out_2      <= `SD 0;
        wb_data_out_1  <= `SD wb_data[h[4:0]];
        wb_data_out_2  <= `SD 0;
      end
      else begin
        T_valid_1  <= `SD 1'd0;
        T_valid_2  <= `SD 1'd0;
      end

      // Branch
      if(br_wr_en_1 && br_wr_en_2) begin
        br_t[br_marker_in_1[1:0]] <= `SD t+1;
        br_t[br_marker_in_2[1:0]] <= `SD t+2;
      end
      else if(br_wr_en_1) begin
        br_t[br_marker_in_1[1:0]] <= `SD t+1;
      end
      else if(br_wr_en_2) begin
        br_t[br_marker_in_2[1:0]] <= `SD (T_wr_en_1 && T_wr_en_2)? t+2:t+1;
      end

    end
  end

endmodule

