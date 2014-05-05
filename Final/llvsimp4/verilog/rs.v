`define RS_WC_DIFF_0        3'd0
`define RS_WC_LEAD_1        3'd1
`define RS_WC_LEAD_2        3'd2
`define RS_WC_LOSE_1        3'd3
`define RS_WC_LOSE_2        3'd4

`define RS_STR_HAZ_FULL     2'b11
`define RS_STR_HAZ_ONE_SLOT 2'b01
`define RS_STR_HAZ_NONE     2'b00
module rs_slot(reset, clock,
               wr_enable_1, wr_enable_2,
               clear,
               wr_data_op_1, wr_data_T_1, wr_data_T1_1, wr_data_T1plus_1, wr_data_T2_1, wr_data_T2plus_1, wr_data_opa_select_1, wr_data_opb_select_1, wr_data_IR_1, wr_data_NPC_1, wr_data_rd_mem_1, wr_data_wr_mem_1,
               wr_data_cond_branch_1, wr_data_uncond_branch_1, wr_data_br_marker_1, wr_data_brpTN_1, wr_data_brp_TAR_PC_1, wr_data_lsq_tail_1,
               wr_data_op_2, wr_data_T_2, wr_data_T1_2, wr_data_T1plus_2, wr_data_T2_2, wr_data_T2plus_2, wr_data_opa_select_2, wr_data_opb_select_2, wr_data_IR_2, wr_data_NPC_2, wr_data_rd_mem_2, wr_data_wr_mem_2,
               wr_data_cond_branch_2, wr_data_uncond_branch_2, wr_data_br_marker_2, wr_data_brpTN_2, wr_data_brp_TAR_PC_2, wr_data_lsq_tail_2,
               write_CDB_en_1,
               search_CDB_value_in_1,
               write_CDB_en_2,
               search_CDB_value_in_2,

               rd_op, rd_T, rd_T1, rd_T1plus, rd_T2, rd_T2plus, rd_opa_select, rd_opb_select, rd_IR, rd_NPC, rd_rd_mem, rd_wr_mem, rd_cond_branch, rd_uncond_branch, rd_br_marker, rd_brpTN, rd_brp_TAR_PC, rd_lsq_tail );

input    reset;
input    clock;
input    clear;
input    wr_enable_1;
input    wr_enable_2;

input [4:0]  wr_data_op_1;
input [5:0]  wr_data_T_1;
input [5:0]  wr_data_T1_1;
input [5:0]  wr_data_T2_1;
input        wr_data_T1plus_1;
input        wr_data_T2plus_1;
input [1:0]  wr_data_opa_select_1;
input [1:0]  wr_data_opb_select_1;
input [31:0] wr_data_IR_1;
input [63:0] wr_data_NPC_1;
input        wr_data_rd_mem_1;
input        wr_data_wr_mem_1;
input        wr_data_cond_branch_1;
input        wr_data_uncond_branch_1;
input [2:0]  wr_data_br_marker_1;
input        wr_data_brpTN_1;
input [63:0] wr_data_brp_TAR_PC_1;
input [4:0]  wr_data_lsq_tail_1;
input        write_CDB_en_1;
input [5:0]  search_CDB_value_in_1;

input [4:0]  wr_data_op_2;
input [5:0]  wr_data_T_2;
input [5:0]  wr_data_T1_2;
input [5:0]  wr_data_T2_2;
input        wr_data_T1plus_2;
input        wr_data_T2plus_2;
input [1:0]  wr_data_opa_select_2;
input [1:0]  wr_data_opb_select_2;
input [31:0] wr_data_IR_2;
input [63:0] wr_data_NPC_2;
input        wr_data_rd_mem_2;
input        wr_data_wr_mem_2;
input        wr_data_cond_branch_2;
input        wr_data_uncond_branch_2;
input [2:0]  wr_data_br_marker_2;
input        wr_data_brpTN_2;
input [63:0] wr_data_brp_TAR_PC_2;
input [4:0]  wr_data_lsq_tail_2;
input        write_CDB_en_2;
input [5:0]  search_CDB_value_in_2;

wire         wr_enable;
wire         write_CDB_en;
assign       wr_enable = wr_enable_1 | wr_enable_2;
assign       write_CDB_en = write_CDB_en_1 | write_CDB_en_2;

reg [4:0]  wr_data_op;
reg [5:0]  wr_data_T;
reg [5:0]  wr_data_T1;
reg [5:0]  wr_data_T2;
reg        wr_data_T1plus;
reg        wr_data_T2plus;
reg [1:0]  wr_data_opa_select;
reg [1:0]  wr_data_opb_select;
reg [31:0] wr_data_IR;
reg [63:0] wr_data_NPC;
reg        wr_data_rd_mem;
reg        wr_data_wr_mem;
reg        wr_data_cond_branch;
reg        wr_data_uncond_branch;
reg [2:0]  wr_data_br_marker;
reg        wr_data_brpTN;
reg [63:0] wr_data_brp_TAR_PC;
reg [4:0]  wr_data_lsq_tail;

always@* begin
  if(wr_enable_1) begin
    wr_data_op             = wr_data_op_1;
    wr_data_T              = wr_data_T_1;
    wr_data_T1             = wr_data_T1_1;
    wr_data_T2             = wr_data_T2_1;
    wr_data_T1plus         = wr_data_T1plus_1;
    wr_data_T2plus         = wr_data_T2plus_1;
    wr_data_opa_select     = wr_data_opa_select_1;
    wr_data_opb_select     = wr_data_opb_select_1;
    wr_data_IR             = wr_data_IR_1;
    wr_data_NPC            = wr_data_NPC_1;
    wr_data_rd_mem         = wr_data_rd_mem_1;
    wr_data_wr_mem         = wr_data_wr_mem_1;
    wr_data_cond_branch    = wr_data_cond_branch_1;
    wr_data_uncond_branch  = wr_data_uncond_branch_1;
    wr_data_br_marker      = wr_data_br_marker_1;
    wr_data_brpTN          = wr_data_brpTN_1;
    wr_data_brp_TAR_PC     = wr_data_brp_TAR_PC_1;
    wr_data_lsq_tail       = wr_data_lsq_tail_1;
  end else begin
    wr_data_op             = wr_data_op_2;
    wr_data_T              = wr_data_T_2;
    wr_data_T1             = wr_data_T1_2;
    wr_data_T2             = wr_data_T2_2;
    wr_data_T1plus         = wr_data_T1plus_2;
    wr_data_T2plus         = wr_data_T2plus_2;
    wr_data_opa_select     = wr_data_opa_select_2;
    wr_data_opb_select     = wr_data_opb_select_2;
    wr_data_IR             = wr_data_IR_2;
    wr_data_NPC            = wr_data_NPC_2;
    wr_data_rd_mem         = wr_data_rd_mem_2;
    wr_data_wr_mem         = wr_data_wr_mem_2;
    wr_data_cond_branch    = wr_data_cond_branch_2;
    wr_data_uncond_branch  = wr_data_uncond_branch_2;
    wr_data_br_marker      = wr_data_br_marker_2;
    wr_data_brpTN          = wr_data_brpTN_2;
    wr_data_brp_TAR_PC     = wr_data_brp_TAR_PC_2;
    wr_data_lsq_tail       = wr_data_lsq_tail_2;
  end
end

output reg [4:0]  rd_op;
output reg [5:0]  rd_T;
output reg [5:0]  rd_T1;
output reg [5:0]  rd_T2;
output reg        rd_T1plus;
output reg        rd_T2plus;
output reg [1:0]  rd_opa_select;
output reg [1:0]  rd_opb_select;
output reg [31:0] rd_IR;
output reg [63:0] rd_NPC;
output reg        rd_rd_mem;
output reg        rd_wr_mem;
output reg        rd_cond_branch;
output reg        rd_uncond_branch;
output reg [2:0]  rd_br_marker;
output reg        rd_brpTN;
output reg [63:0] rd_brp_TAR_PC;
output reg [4:0]  rd_lsq_tail;

reg [4:0]  op;
reg [5:0]  T;
reg [5:0]  T1;
reg [5:0]  T2;
reg        T1plus;
reg        T2plus;
reg [1:0]  opa_select;
reg [1:0]  opb_select;
reg [31:0] IR;
reg [63:0] NPC;
reg        rd_mem;
reg        wr_mem;
reg        cond_branch;
reg        uncond_branch;
reg [2:0]  br_marker;
reg        brpTN;
reg [63:0] brp_TAR_PC;
reg [4:0]  lsq_tail;

wire CDB_T1_match;
wire CDB_T2_match;
assign CDB_T1_match = ( ((T1 == search_CDB_value_in_1) && write_CDB_en_1) | ((T1 == search_CDB_value_in_2) && write_CDB_en_2)) ? `TRUE:`FALSE;
assign CDB_T2_match = ( ((T2 == search_CDB_value_in_1) && write_CDB_en_1) | ((T2 == search_CDB_value_in_2) && write_CDB_en_2)) ? `TRUE:`FALSE;
wire CDB_write_T1plus;
wire CDB_write_T2plus;
assign CDB_write_T1plus = (CDB_T1_match) ? `TRUE:T1plus;
assign CDB_write_T2plus = (CDB_T2_match) ? `TRUE:T2plus;

always@* begin
    rd_op            = op;
    rd_T             = T;
    rd_T1            = T1;
    rd_T1plus        = T1plus;
    rd_T2            = T2;
    rd_T2plus        = T2plus;
    rd_opa_select    = opa_select;
    rd_opb_select    = opb_select;
    rd_IR            = IR;
    rd_NPC           = NPC;
    rd_rd_mem        = rd_mem;
    rd_wr_mem        = wr_mem;
    rd_cond_branch   = cond_branch;
    rd_uncond_branch = uncond_branch;
    rd_br_marker     = br_marker;
    rd_brpTN         = brpTN;
    rd_brp_TAR_PC    = brp_TAR_PC;
    rd_lsq_tail      = lsq_tail;

    if(clear) begin
    //rd_op            =  0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    //rd_T             =  `ZERO_REG;
    //rd_T1            = `ZERO_REG;
    rd_T1plus        = `FALSE;
    //rd_T2            = `ZERO_REG;
    rd_T2plus        = `FALSE;
    //rd_opa_select    = 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    //rd_opb_select    = 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    //rd_IR            = 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    //rd_NPC           = 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    //rd_wr_mem        = `FALSE;
    //rd_mem        = `FALSE;
    //rd_cond_branch   = `FALSE;
    //rd_uncond_branch = `FALSE;
    //rd_br_marker     = `BR_MARKER_EMPTY;
    end
end

always@(posedge clock)begin
  if(reset) begin
    op            <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    T             <= `SD `ZERO_REG;
    T1            <= `SD `ZERO_REG;
    T1plus        <= `SD `FALSE;
    T2            <= `SD `ZERO_REG;
    T2plus        <= `SD `FALSE;
    opa_select    <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    opb_select    <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    IR            <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    NPC           <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    wr_mem        <= `SD `FALSE;
    rd_mem        <= `SD `FALSE;
    cond_branch   <= `SD `FALSE;
    uncond_branch <= `SD `FALSE;
    br_marker     <= `SD `BR_MARKER_EMPTY;
    brpTN         <= `SD `FALSE;
    brp_TAR_PC    <= `SD 0;
    lsq_tail      <= `SD 0;

  end else if(wr_enable) begin
    op            <= `SD wr_data_op;
    T             <= `SD wr_data_T;
    T1            <= `SD wr_data_T1;
    T1plus        <= `SD wr_data_T1plus;
    T2            <= `SD wr_data_T2;
    T2plus        <= `SD wr_data_T2plus;
    opa_select    <= `SD wr_data_opa_select;
    opb_select    <= `SD wr_data_opb_select;
    IR            <= `SD wr_data_IR;
    NPC           <= `SD wr_data_NPC;
    wr_mem        <= `SD wr_data_wr_mem;
    rd_mem        <= `SD wr_data_rd_mem;
    cond_branch   <= `SD wr_data_cond_branch;
    uncond_branch <= `SD wr_data_uncond_branch;
    br_marker     <= `SD wr_data_br_marker;
    brpTN         <= `SD wr_data_brpTN;
    brp_TAR_PC    <= `SD wr_data_brp_TAR_PC;
    lsq_tail      <= `SD wr_data_lsq_tail;
  end else if(clear) begin
    op            <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    T             <= `SD `ZERO_REG;
    T1            <= `SD `ZERO_REG;
    T1plus        <= `SD `FALSE;
    T2            <= `SD `ZERO_REG;
    T2plus        <= `SD `FALSE;
    opa_select    <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    opb_select    <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    IR            <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    NPC           <= `SD 0;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;
    wr_mem        <= `SD `FALSE;
    rd_mem        <= `SD `FALSE;
    cond_branch   <= `SD `FALSE;
    uncond_branch <= `SD `FALSE;
    br_marker     <= `SD `BR_MARKER_EMPTY;
    brpTN         <= `SD `FALSE;
    brp_TAR_PC    <= `SD 0;
    lsq_tail      <= `SD 0;
  end else if(write_CDB_en) begin
    T1plus        <= `SD CDB_write_T1plus;
    T2plus        <= `SD CDB_write_T2plus;
  end

end

endmodule




module rs(reset, clock,

                           rs_clear_enable_1, rs_clear_position_1, rs_clear_bmask_bits_1,
                           rs_clear_enable_2, rs_clear_position_2, rs_clear_bmask_bits_2,
                           rs_bmask_clear_location_1, rs_bmask_clear_location_2,

                           rs_wr_enable_1,
                           rs_wr_data_op_1, rs_wr_data_T_1, rs_wr_data_T1_1, rs_wr_data_T1plus_1, rs_wr_data_T2_1, rs_wr_data_T2plus_1, rs_wr_data_opa_select_1, rs_wr_data_opb_select_1, rs_wr_data_IR_1, rs_wr_data_NPC_1,
                           rs_wr_data_rd_mem_1, rs_wr_data_wr_mem_1, rs_wr_data_cond_branch_1, rs_wr_data_uncond_branch_1, rs_wr_data_bmask_1, rs_wr_data_br_marker_1, rs_wr_data_brpTN_1, rs_wr_data_brp_TAR_PC_1,
                           rs_wr_data_lsq_tail_1,
                           rs_wr_enable_2,
                           rs_wr_data_op_2, rs_wr_data_T_2, rs_wr_data_T1_2, rs_wr_data_T1plus_2, rs_wr_data_T2_2, rs_wr_data_T2plus_2, rs_wr_data_opa_select_2, rs_wr_data_opb_select_2, rs_wr_data_IR_2, rs_wr_data_NPC_2,
                           rs_wr_data_rd_mem_2, rs_wr_data_wr_mem_2, rs_wr_data_cond_branch_2, rs_wr_data_uncond_branch_2, rs_wr_data_bmask_2, rs_wr_data_br_marker_2, rs_wr_data_brpTN_2, rs_wr_data_brp_TAR_PC_2,
                           rs_wr_data_lsq_tail_2,

                           rs_write_CDB_en_1,
                           rs_search_CDB_value_in_1,
                           rs_write_CDB_en_2,
                           rs_search_CDB_value_in_2,

                           pre_str_hazard,

                           rs_rd_position_1,
                           rs_rd_op_1, rs_rd_T_1, rs_rd_T1_1, rs_rd_T1plus_1, rs_rd_T2_1, rs_rd_T2plus_1, rs_rd_opa_select_1, rs_rd_opb_select_1, rs_rd_IR_1, rs_rd_NPC_1, rs_rd_rd_mem_1, rs_rd_wr_mem_1,
                           rs_rd_cond_branch_1, rs_rd_uncond_branch_1, rs_rd_bmask_1, rs_rd_br_marker_1, rs_rd_brpTN_1, rs_rd_brp_TAR_PC_1, rs_rd_lsq_tail_1,
                           rs_rd_position_2,
                           rs_rd_op_2, rs_rd_T_2, rs_rd_T1_2, rs_rd_T1plus_2, rs_rd_T2_2, rs_rd_T2plus_2, rs_rd_opa_select_2, rs_rd_opb_select_2, rs_rd_IR_2, rs_rd_NPC_2, rs_rd_rd_mem_2, rs_rd_wr_mem_2,
                           rs_rd_cond_branch_2, rs_rd_uncond_branch_2, rs_rd_bmask_2, rs_rd_br_marker_2, rs_rd_brpTN_2, rs_rd_brp_TAR_PC_2, rs_rd_lsq_tail_2,

                           rs_rd_T1plus_all, rs_rd_T2plus_all );


input [2:0] rs_bmask_clear_location_1;
input [2:0] rs_bmask_clear_location_2;
input [2:0] rs_clear_bmask_bits_1;
input [2:0] rs_clear_bmask_bits_2;
wire        bmask_cl_en_1;
wire        bmask_cl_en_2;
wire  [1:0] bmask_clear_location_1;
wire  [1:0] bmask_clear_location_2;
assign bmask_cl_en_1 = ~rs_bmask_clear_location_1[2];
assign bmask_cl_en_2 = ~rs_bmask_clear_location_2[2];
assign bmask_clear_location_1 = rs_bmask_clear_location_1[1:0];
assign bmask_clear_location_2 = rs_bmask_clear_location_2[1:0];
wire [4:0] next_wr_pos_1_full;
wire [4:0] next_wr_pos_2_full;
wire [3:0] next_wr_pos_1;
wire [3:0] next_wr_pos_2;
assign next_wr_pos_1 = next_wr_pos_1_full[3:0];
assign next_wr_pos_2 = next_wr_pos_2_full[3:0];

reg [15:0] clear_pos_str;
reg [15:0] bmask_0;
reg [15:0] bmask_1;
reg [15:0] bmask_2;
reg [15:0] bmask_3;
reg [15:0] bmask_4;
reg [15:0] bmask_5;
reg [15:0] bmask_6;
reg [15:0] bmask_7;
reg [15:0] bmask_8;
reg [15:0] bmask_9;
reg [15:0] bmask_10;
reg [15:0] bmask_11;
reg [15:0] bmask_12;
reg [15:0] bmask_13;
reg [15:0] bmask_14;
reg [15:0] bmask_15;
reg [15:0] next_bmask_0;
reg [15:0] next_bmask_1;
reg [15:0] next_bmask_2;
reg [15:0] next_bmask_3;
reg [15:0] next_bmask_4;
reg [15:0] next_bmask_5;
reg [15:0] next_bmask_6;
reg [15:0] next_bmask_7;
reg [15:0] next_bmask_8;
reg [15:0] next_bmask_9;
reg [15:0] next_bmask_10;
reg [15:0] next_bmask_11;
reg [15:0] next_bmask_12;
reg [15:0] next_bmask_13;
reg [15:0] next_bmask_14;
reg [15:0] next_bmask_15;
always@* begin
  clear_pos_str[0]  = ((bmask_0[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_0[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[1]  = ((bmask_1[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_1[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[2]  = ((bmask_2[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_2[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[3]  = ((bmask_3[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_3[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[4]  = ((bmask_4[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_4[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[5]  = ((bmask_5[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_5[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[6]  = ((bmask_6[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_6[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[7]  = ((bmask_7[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_7[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[8]  = ((bmask_8[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_8[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[9]  = ((bmask_9[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_9[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[10] = ((bmask_10[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_10[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[11] = ((bmask_11[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_11[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[12] = ((bmask_12[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_12[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[13] = ((bmask_13[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_13[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[14] = ((bmask_14[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_14[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  clear_pos_str[15] = ((bmask_15[bmask_clear_location_1] & bmask_cl_en_1) | (bmask_15[bmask_clear_location_2] & bmask_cl_en_2))? 1'b1:1'b0;
  if(rs_clear_enable_1 == 1) clear_pos_str[rs_clear_position_1] = 1'b1;
  if(rs_clear_enable_2 == 1) clear_pos_str[rs_clear_position_2] = 1'b1;
end

input [3:0] rs_wr_data_bmask_1;
input [3:0] rs_wr_data_bmask_2;

always@*begin 
    next_bmask_0 = clear_pos_str[0]? 0 : bmask_0;
    if(rs_clear_enable_1) next_bmask_0[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_0[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 0) next_bmask_0 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 0) next_bmask_0 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_1 = clear_pos_str[1]? 0 : bmask_1;
    if(rs_clear_enable_1) next_bmask_1[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_1[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 1) next_bmask_1 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 1) next_bmask_1 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_2 = clear_pos_str[2]? 0 : bmask_2;
    if(rs_clear_enable_1) next_bmask_2[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_2[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 2) next_bmask_2 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 2) next_bmask_2 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_3 = clear_pos_str[3]? 0 : bmask_3;
    if(rs_clear_enable_1) next_bmask_3[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_3[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 3) next_bmask_3 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 3) next_bmask_3 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_4 = clear_pos_str[4]? 0 : bmask_4;
    if(rs_clear_enable_1) next_bmask_4[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_4[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 4) next_bmask_4 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 4) next_bmask_4 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_5 = clear_pos_str[5]? 0 : bmask_5;
    if(rs_clear_enable_1) next_bmask_5[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_5[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 5) next_bmask_5 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 5) next_bmask_5 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_6 = clear_pos_str[6]? 0 : bmask_6;
    if(rs_clear_enable_1) next_bmask_6[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_6[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 6) next_bmask_6 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 6) next_bmask_6 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_7 = clear_pos_str[7]? 0 : bmask_7;
    if(rs_clear_enable_1) next_bmask_7[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_7[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 7) next_bmask_7 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 7) next_bmask_7 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_8 = clear_pos_str[8]? 0 : bmask_8;
    if(rs_clear_enable_1) next_bmask_8[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_8[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 8) next_bmask_8 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 8) next_bmask_8 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_9 = clear_pos_str[9]? 0 : bmask_9;
    if(rs_clear_enable_1) next_bmask_9[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_9[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 9) next_bmask_9 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 9) next_bmask_9 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_10 = clear_pos_str[10]? 0 : bmask_10;
    if(rs_clear_enable_1) next_bmask_10[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_10[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 10) next_bmask_10 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 10) next_bmask_10 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_11 = clear_pos_str[11]? 0 : bmask_11;
    if(rs_clear_enable_1) next_bmask_11[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_11[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 11) next_bmask_11 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 11) next_bmask_11 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_12 = clear_pos_str[12]? 0 : bmask_12;
    if(rs_clear_enable_1) next_bmask_12[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_12[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 12) next_bmask_12 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 12) next_bmask_12 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_13 = clear_pos_str[13]? 0 : bmask_13;
    if(rs_clear_enable_1) next_bmask_13[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_13[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 13) next_bmask_13 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 13) next_bmask_13 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_14 = clear_pos_str[14]? 0 : bmask_14;
    if(rs_clear_enable_1) next_bmask_14[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_14[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 14) next_bmask_14 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 14) next_bmask_14 = rs_wr_data_bmask_2;
end

always@*begin 
    next_bmask_15 = clear_pos_str[15]? 0 : bmask_15;
    if(rs_clear_enable_1) next_bmask_15[rs_clear_bmask_bits_1] = 0;
    if(rs_clear_enable_2) next_bmask_15[rs_clear_bmask_bits_2] = 0;
    if(rs_wr_enable_1 & next_wr_pos_1 == 15) next_bmask_15 = rs_wr_data_bmask_1;
    else if(rs_wr_enable_2 & next_wr_pos_2 == 15) next_bmask_15 = rs_wr_data_bmask_2;
end

always@(posedge clock) begin
  if(reset) begin
    bmask_0 <= `SD 0;
    bmask_1 <= `SD 0;
    bmask_2 <= `SD 0;
    bmask_3 <= `SD 0;
    bmask_4 <= `SD 0;
    bmask_5 <= `SD 0;
    bmask_6 <= `SD 0;
    bmask_7 <= `SD 0;
    bmask_8 <= `SD 0;
    bmask_9 <= `SD 0;
    bmask_10 <= `SD 0;
    bmask_11 <= `SD 0;
    bmask_12 <= `SD 0;
    bmask_13 <= `SD 0;
    bmask_14 <= `SD 0;
    bmask_15 <= `SD 0;
  end else begin
    bmask_0 <= `SD next_bmask_0;
    bmask_1 <= `SD next_bmask_1;
    bmask_2 <= `SD next_bmask_2;
    bmask_3 <= `SD next_bmask_3;
    bmask_4 <= `SD next_bmask_4;
    bmask_5 <= `SD next_bmask_5;
    bmask_6 <= `SD next_bmask_6;
    bmask_7 <= `SD next_bmask_7;
    bmask_8 <= `SD next_bmask_8;
    bmask_9 <= `SD next_bmask_9;
    bmask_10 <= `SD next_bmask_10;
    bmask_11 <= `SD next_bmask_11;
    bmask_12 <= `SD next_bmask_12;
    bmask_13 <= `SD next_bmask_13;
    bmask_14 <= `SD next_bmask_14;
    bmask_15 <= `SD next_bmask_15;
  end
end

reg [15:0] busy_bits;
reg [15:0] next_busy_bits;

always@* begin
  next_busy_bits[0]  = clear_pos_str[0]? 0 : busy_bits[0];
  next_busy_bits[1]  = clear_pos_str[1]? 0 : busy_bits[1];
  next_busy_bits[2]  = clear_pos_str[2]? 0 : busy_bits[2];
  next_busy_bits[3]  = clear_pos_str[3]? 0 : busy_bits[3];
  next_busy_bits[4]  = clear_pos_str[4]? 0 : busy_bits[4];
  next_busy_bits[5]  = clear_pos_str[5]? 0 : busy_bits[5];
  next_busy_bits[6]  = clear_pos_str[6]? 0 : busy_bits[6];
  next_busy_bits[7]  = clear_pos_str[7]? 0 : busy_bits[7];
  next_busy_bits[8]  = clear_pos_str[8]? 0 : busy_bits[8];
  next_busy_bits[9]  = clear_pos_str[9]? 0 : busy_bits[9];
  next_busy_bits[10] = clear_pos_str[10]? 0 : busy_bits[10];
  next_busy_bits[11] = clear_pos_str[11]? 0 : busy_bits[11];
  next_busy_bits[12] = clear_pos_str[12]? 0 : busy_bits[12];
  next_busy_bits[13] = clear_pos_str[13]? 0 : busy_bits[13];
  next_busy_bits[14] = clear_pos_str[14]? 0 : busy_bits[14];
  next_busy_bits[15] = clear_pos_str[15]? 0 : busy_bits[15];
  if(rs_wr_enable_1) next_busy_bits[next_wr_pos_1] = 1'b1;
  if(rs_wr_enable_2) next_busy_bits[next_wr_pos_2] = 1'b1;
end

always@(posedge clock) begin
  if(reset) busy_bits <= `SD 0;
  else busy_bits <= `SD next_busy_bits;
end

assign next_wr_pos_1_full = (!busy_bits[0] | clear_pos_str[0])? 5'd0:
     		            (!busy_bits[1] | clear_pos_str[1])? 5'd1:
                            (!busy_bits[2] | clear_pos_str[2])? 5'd2:
     		            (!busy_bits[3] | clear_pos_str[3])? 5'd3:
     		            (!busy_bits[4] | clear_pos_str[4])? 5'd4:
     		            (!busy_bits[5] | clear_pos_str[5])? 5'd5:
     		            (!busy_bits[6] | clear_pos_str[6])? 5'd6:
     		            (!busy_bits[7] | clear_pos_str[7])? 5'd7:
     		            (!busy_bits[8] | clear_pos_str[8])? 5'd8:
     		            (!busy_bits[9] | clear_pos_str[9])? 5'd9:
     		            (!busy_bits[10] | clear_pos_str[10])? 5'd10:
     		            (!busy_bits[11] | clear_pos_str[11])? 5'd11:
     		            (!busy_bits[12] | clear_pos_str[12])? 5'd12:
     		            (!busy_bits[13] | clear_pos_str[13])? 5'd13:
     		            (!busy_bits[14] | clear_pos_str[14])? 5'd14:
     		            (!busy_bits[15] | clear_pos_str[15])? 5'd15:
                            5'b10000;
assign next_wr_pos_2_full = (!busy_bits[15] | clear_pos_str[15])? 5'd15:
     		            (!busy_bits[14] | clear_pos_str[14])? 5'd14:
     		            (!busy_bits[13] | clear_pos_str[13])? 5'd13:
     		            (!busy_bits[12] | clear_pos_str[12])? 5'd12:
     		            (!busy_bits[11] | clear_pos_str[11])? 5'd11:
     		            (!busy_bits[10] | clear_pos_str[10])? 5'd10:
     		            (!busy_bits[9] | clear_pos_str[9])? 5'd9:
     		            (!busy_bits[8] | clear_pos_str[8])? 5'd8:
     		            (!busy_bits[7] | clear_pos_str[7])? 5'd7:
     		            (!busy_bits[6] | clear_pos_str[6])? 5'd6:
     		            (!busy_bits[5] | clear_pos_str[5])? 5'd5:
     		            (!busy_bits[4] | clear_pos_str[4])? 5'd4:
     		            (!busy_bits[3] | clear_pos_str[3])? 5'd3:
     		            (!busy_bits[2] | clear_pos_str[2])? 5'd2:
     		            (!busy_bits[1] | clear_pos_str[1])? 5'd1:
     		            (!busy_bits[0] | clear_pos_str[0])? 5'd0:
                            5'b10000;

wire [1:0] str_hazard;
assign str_hazard = next_wr_pos_1_full[4]?            `RS_STR_HAZ_FULL:
                    (next_wr_pos_1 == next_wr_pos_2)? `RS_STR_HAZ_ONE_SLOT:
                                                      `RS_STR_HAZ_NONE;


input        reset;
input        clock;
input        rs_clear_enable_1;
input [3:0]  rs_clear_position_1;
input        rs_clear_enable_2;
input [3:0]  rs_clear_position_2;

input        rs_wr_enable_1;
input [4:0]  rs_wr_data_op_1;
input [5:0]  rs_wr_data_T_1;
input [5:0]  rs_wr_data_T1_1;
input        rs_wr_data_T1plus_1;
input [5:0]  rs_wr_data_T2_1;
input        rs_wr_data_T2plus_1;
input [1:0]  rs_wr_data_opa_select_1;
input [1:0]  rs_wr_data_opb_select_1;
input        rs_wr_data_rd_mem_1;
input        rs_wr_data_wr_mem_1;
input [31:0] rs_wr_data_IR_1;
input [63:0] rs_wr_data_NPC_1;
input        rs_wr_data_cond_branch_1;
input        rs_wr_data_uncond_branch_1;
input [2:0]  rs_wr_data_br_marker_1;
input        rs_wr_data_brpTN_1;
input [63:0] rs_wr_data_brp_TAR_PC_1;
input [4:0]  rs_wr_data_lsq_tail_1;
input        rs_write_CDB_en_1;
input [5:0]  rs_search_CDB_value_in_1;
input        rs_wr_enable_2;
input [4:0]  rs_wr_data_op_2;
input [5:0]  rs_wr_data_T_2;
input [5:0]  rs_wr_data_T1_2;
input        rs_wr_data_T1plus_2;
input [5:0]  rs_wr_data_T2_2;
input        rs_wr_data_T2plus_2;
input [1:0]  rs_wr_data_opa_select_2;
input [1:0]  rs_wr_data_opb_select_2;
input        rs_wr_data_rd_mem_2;
input        rs_wr_data_wr_mem_2;
input [31:0] rs_wr_data_IR_2;
input [63:0] rs_wr_data_NPC_2;
input        rs_wr_data_cond_branch_2;
input        rs_wr_data_uncond_branch_2;
input [2:0]  rs_wr_data_br_marker_2;
input        rs_wr_data_brpTN_2;
input [63:0] rs_wr_data_brp_TAR_PC_2;
input [4:0]  rs_wr_data_lsq_tail_2;
input        rs_write_CDB_en_2;
input [5:0]  rs_search_CDB_value_in_2;

input [3:0]  rs_rd_position_1;
input [3:0]  rs_rd_position_2;

output [4:0]  rs_rd_op_1;
output [5:0]  rs_rd_T_1;
output [5:0]  rs_rd_T1_1;
output        rs_rd_T1plus_1;
output [5:0]  rs_rd_T2_1;
output        rs_rd_T2plus_1;
output [1:0]  rs_rd_opa_select_1;
output [1:0]  rs_rd_opb_select_1;
output [31:0] rs_rd_IR_1;
output [63:0] rs_rd_NPC_1;
output        rs_rd_rd_mem_1;
output        rs_rd_wr_mem_1;
output        rs_rd_cond_branch_1;
output        rs_rd_uncond_branch_1;
output reg [3:0] rs_rd_bmask_1;
output [2:0]  rs_rd_br_marker_1;
output        rs_rd_brpTN_1;
output [63:0] rs_rd_brp_TAR_PC_1;
output  [4:0] rs_rd_lsq_tail_1;
output [4:0]  rs_rd_op_2;
output [5:0]  rs_rd_T_2;
output [5:0]  rs_rd_T1_2;
output        rs_rd_T1plus_2;
output [5:0]  rs_rd_T2_2;
output        rs_rd_T2plus_2;
output [1:0]  rs_rd_opa_select_2;
output [1:0]  rs_rd_opb_select_2;
output [31:0] rs_rd_IR_2;
output [63:0] rs_rd_NPC_2;
output        rs_rd_rd_mem_2;
output        rs_rd_wr_mem_2;
output        rs_rd_cond_branch_2;
output        rs_rd_uncond_branch_2;
output reg [3:0] rs_rd_bmask_2;
output [2:0]  rs_rd_br_marker_2;
output        rs_rd_brpTN_2;
output [63:0] rs_rd_brp_TAR_PC_2;
output  [4:0] rs_rd_lsq_tail_2;

output [15:0] rs_rd_T1plus_all;
output [15:0] rs_rd_T2plus_all;


reg [2:0] wr_cl_diff;
always@* begin
  wr_cl_diff = 0;
  if      ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1111) wr_cl_diff = `RS_WC_DIFF_0;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0000) wr_cl_diff = `RS_WC_DIFF_0;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1010) wr_cl_diff = `RS_WC_DIFF_0;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0101) wr_cl_diff = `RS_WC_DIFF_0;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1001) wr_cl_diff = `RS_WC_DIFF_0;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0110) wr_cl_diff = `RS_WC_DIFF_0;

  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0100) wr_cl_diff = `RS_WC_LEAD_1;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1000) wr_cl_diff = `RS_WC_LEAD_1;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1100) wr_cl_diff = `RS_WC_LEAD_2;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1101) wr_cl_diff = `RS_WC_LEAD_1;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1110) wr_cl_diff = `RS_WC_LEAD_1;

  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0010) wr_cl_diff = `RS_WC_LOSE_1;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0001) wr_cl_diff = `RS_WC_LOSE_1;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0011) wr_cl_diff = `RS_WC_LOSE_2;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b0111) wr_cl_diff = `RS_WC_LOSE_1;
  else if ({rs_wr_enable_1, rs_wr_enable_2, rs_clear_enable_1, rs_clear_enable_2} == 4'b1011) wr_cl_diff = `RS_WC_LOSE_1;
end

reg [4:0] empty_slot_left;
always@* begin
  empty_slot_left =  !busy_bits[0] + !busy_bits[2] + !busy_bits[4] + !busy_bits[6] + !busy_bits[8] + !busy_bits[10] + !busy_bits[12] + !busy_bits[14] 
                   + !busy_bits[1] + !busy_bits[3] + !busy_bits[5] + !busy_bits[7] + !busy_bits[9] + !busy_bits[11] + !busy_bits[13] + !busy_bits[15];
end

output reg [1:0] pre_str_hazard;
always@(*) begin
  pre_str_hazard = `RS_STR_HAZ_NONE;
  if( empty_slot_left == 3 & wr_cl_diff == `RS_WC_LEAD_2 ) pre_str_hazard = `RS_STR_HAZ_ONE_SLOT;
  if( empty_slot_left == 2 & wr_cl_diff == `RS_WC_LEAD_2 ) pre_str_hazard = `RS_STR_HAZ_FULL;
  if( empty_slot_left == 2 & wr_cl_diff == `RS_WC_LEAD_1 ) pre_str_hazard = `RS_STR_HAZ_ONE_SLOT;
  if( empty_slot_left == 1 & (wr_cl_diff == `RS_WC_LEAD_2 | wr_cl_diff == `RS_WC_LEAD_1) ) pre_str_hazard = `RS_STR_HAZ_FULL;
  if( empty_slot_left == 1 & wr_cl_diff == `RS_WC_DIFF_0) pre_str_hazard = `RS_STR_HAZ_ONE_SLOT;
  if( empty_slot_left == 0 & wr_cl_diff == `RS_WC_LOSE_1) pre_str_hazard = `RS_STR_HAZ_ONE_SLOT;
  if( empty_slot_left == 0 & (wr_cl_diff != `RS_WC_LOSE_1 & wr_cl_diff != `RS_WC_LOSE_2)) pre_str_hazard = `RS_STR_HAZ_FULL;
end


always@* begin
  rs_rd_bmask_1 = 0;
  case(rs_rd_position_1)
    4'd0: rs_rd_bmask_1 = bmask_0;
    4'd1: rs_rd_bmask_1 = bmask_1;
    4'd2: rs_rd_bmask_1 = bmask_2;
    4'd3: rs_rd_bmask_1 = bmask_3;
    4'd4: rs_rd_bmask_1 = bmask_4;
    4'd5: rs_rd_bmask_1 = bmask_5;
    4'd6: rs_rd_bmask_1 = bmask_6;
    4'd7: rs_rd_bmask_1 = bmask_7;
    4'd8: rs_rd_bmask_1 = bmask_8;
    4'd9: rs_rd_bmask_1 = bmask_9;
    4'd10: rs_rd_bmask_1 = bmask_10;
    4'd11: rs_rd_bmask_1 = bmask_11;
    4'd12: rs_rd_bmask_1 = bmask_12;
    4'd13: rs_rd_bmask_1 = bmask_13;
    4'd14: rs_rd_bmask_1 = bmask_14;
    4'd15: rs_rd_bmask_1 = bmask_15;
    default : rs_rd_bmask_1 = 0;
  endcase
end

always@* begin
  rs_rd_bmask_2 = 0;
  case(rs_rd_position_2)
    4'd0: rs_rd_bmask_2 = bmask_0;
    4'd1: rs_rd_bmask_2 = bmask_1;
    4'd2: rs_rd_bmask_2 = bmask_2;
    4'd3: rs_rd_bmask_2 = bmask_3;
    4'd4: rs_rd_bmask_2 = bmask_4;
    4'd5: rs_rd_bmask_2 = bmask_5;
    4'd6: rs_rd_bmask_2 = bmask_6;
    4'd7: rs_rd_bmask_2 = bmask_7;
    4'd8: rs_rd_bmask_2 = bmask_8;
    4'd9: rs_rd_bmask_2 = bmask_9;
    4'd10: rs_rd_bmask_2 = bmask_10;
    4'd11: rs_rd_bmask_2 = bmask_11;
    4'd12: rs_rd_bmask_2 = bmask_12;
    4'd13: rs_rd_bmask_2 = bmask_13;
    4'd14: rs_rd_bmask_2 = bmask_14;
    4'd15: rs_rd_bmask_2 = bmask_15;
    default : rs_rd_bmask_2 = 0;
  endcase
end

wire [5*16-1:0]  rd_op_wire;
wire [6*16-1:0]  rd_T_wire;
wire [6*16-1:0]  rd_T1_wire;
wire [15:0]      rd_T1plus_wire;
wire [6*16-1:0]  rd_T2_wire;
wire [15:0]      rd_T2plus_wire;
wire [2*16-1:0]  rd_opa_select_wire;
wire [2*16-1:0]  rd_opb_select_wire;
wire [32*16-1:0] rd_IR_wire;
wire [64*16-1:0] rd_NPC_wire;
wire [15:0]      rd_rd_mem_wire;
wire [15:0]      rd_wr_mem_wire;
wire [15:0]      rd_cond_branch_wire;
wire [15:0]      rd_uncond_branch_wire;
wire [3*16-1:0]  rd_br_marker_wire;
wire [15:0]      rd_brpTN_wire;
wire [64*16-1:0] rd_brp_TAR_PC_wire;
wire [5*16-1:0]  rd_lsq_tail_wire;

reg [15:0] enable_wr_slot_binstr_1;
reg [15:0] enable_wr_slot_binstr_2;
reg [15:0] enable_rd_slot_binstr;

always@* begin
  enable_wr_slot_binstr_1 = 16'd0;
  enable_wr_slot_binstr_2 = 16'd0;
  if(rs_wr_enable_1) enable_wr_slot_binstr_1[next_wr_pos_1] = 1'd1;
  if(rs_wr_enable_2) enable_wr_slot_binstr_2[next_wr_pos_2] = 1'd1;
  enable_rd_slot_binstr = 16'd0;
    enable_rd_slot_binstr[rs_rd_position_1] = 1'd1;
    enable_rd_slot_binstr[rs_rd_position_2] = 1'd1;
end

assign rs_rd_op_1            = {rd_op_wire[rs_rd_position_1*5+4],rd_op_wire[rs_rd_position_1*5+3],rd_op_wire[rs_rd_position_1*5+2],
                                rd_op_wire[rs_rd_position_1*5+1],rd_op_wire[rs_rd_position_1*5]};
assign rs_rd_T_1             = {rd_T_wire[rs_rd_position_1*6+5],rd_T_wire[rs_rd_position_1*6+4],rd_T_wire[rs_rd_position_1*6+3],
                                rd_T_wire[rs_rd_position_1*6+2],rd_T_wire[rs_rd_position_1*6+1],rd_T_wire[rs_rd_position_1*6]};
assign rs_rd_T1_1            = {rd_T1_wire[rs_rd_position_1*6+5],rd_T1_wire[rs_rd_position_1*6+4],rd_T1_wire[rs_rd_position_1*6+3],
                                rd_T1_wire[rs_rd_position_1*6+2],rd_T1_wire[rs_rd_position_1*6+1],rd_T1_wire[rs_rd_position_1*6]};
assign rs_rd_T1plus_1        = rd_T1plus_wire[rs_rd_position_1];
assign rs_rd_T2_1            = {rd_T2_wire[rs_rd_position_1*6+5],rd_T2_wire[rs_rd_position_1*6+4],rd_T2_wire[rs_rd_position_1*6+3],
                                rd_T2_wire[rs_rd_position_1*6+2],rd_T2_wire[rs_rd_position_1*6+1],rd_T2_wire[rs_rd_position_1*6]};
assign rs_rd_T2plus_1        = rd_T2plus_wire[rs_rd_position_1];
assign rs_rd_opa_select_1    = {rd_opa_select_wire[rs_rd_position_1*2+1],rd_opa_select_wire[rs_rd_position_1*2]};
assign rs_rd_opb_select_1    = {rd_opb_select_wire[rs_rd_position_1*2+1],rd_opb_select_wire[rs_rd_position_1*2]};
assign rs_rd_IR_1            = {rd_IR_wire[rs_rd_position_1*32+31],rd_IR_wire[rs_rd_position_1*32+30],rd_IR_wire[rs_rd_position_1*32+29],
                                rd_IR_wire[rs_rd_position_1*32+28],rd_IR_wire[rs_rd_position_1*32+27],rd_IR_wire[rs_rd_position_1*32+26],
                                rd_IR_wire[rs_rd_position_1*32+25],rd_IR_wire[rs_rd_position_1*32+24],rd_IR_wire[rs_rd_position_1*32+23],
                                rd_IR_wire[rs_rd_position_1*32+22],rd_IR_wire[rs_rd_position_1*32+21],rd_IR_wire[rs_rd_position_1*32+20],
                                rd_IR_wire[rs_rd_position_1*32+19],rd_IR_wire[rs_rd_position_1*32+18],rd_IR_wire[rs_rd_position_1*32+17],
                                rd_IR_wire[rs_rd_position_1*32+16],rd_IR_wire[rs_rd_position_1*32+15],rd_IR_wire[rs_rd_position_1*32+14],
                                rd_IR_wire[rs_rd_position_1*32+13],rd_IR_wire[rs_rd_position_1*32+12],rd_IR_wire[rs_rd_position_1*32+11],
                                rd_IR_wire[rs_rd_position_1*32+10],rd_IR_wire[rs_rd_position_1*32+ 9],rd_IR_wire[rs_rd_position_1*32+ 8],
                                rd_IR_wire[rs_rd_position_1*32+ 7],rd_IR_wire[rs_rd_position_1*32+ 6],rd_IR_wire[rs_rd_position_1*32+ 5],
                                rd_IR_wire[rs_rd_position_1*32+ 4],rd_IR_wire[rs_rd_position_1*32+ 3],rd_IR_wire[rs_rd_position_1*32+ 2],
                                rd_IR_wire[rs_rd_position_1*32+ 1],rd_IR_wire[rs_rd_position_1*32   ]};
assign rs_rd_NPC_1           = {rd_NPC_wire[rs_rd_position_1*64+63],rd_NPC_wire[rs_rd_position_1*64+62],rd_NPC_wire[rs_rd_position_1*64+61],
                                rd_NPC_wire[rs_rd_position_1*64+60],rd_NPC_wire[rs_rd_position_1*64+59],rd_NPC_wire[rs_rd_position_1*64+58],
                                rd_NPC_wire[rs_rd_position_1*64+57],rd_NPC_wire[rs_rd_position_1*64+56],rd_NPC_wire[rs_rd_position_1*64+55],
                                rd_NPC_wire[rs_rd_position_1*64+54],rd_NPC_wire[rs_rd_position_1*64+53],rd_NPC_wire[rs_rd_position_1*64+52],
                                rd_NPC_wire[rs_rd_position_1*64+51],rd_NPC_wire[rs_rd_position_1*64+50],rd_NPC_wire[rs_rd_position_1*64+49],
                                rd_NPC_wire[rs_rd_position_1*64+48],rd_NPC_wire[rs_rd_position_1*64+47],rd_NPC_wire[rs_rd_position_1*64+46],
                                rd_NPC_wire[rs_rd_position_1*64+45],rd_NPC_wire[rs_rd_position_1*64+44],rd_NPC_wire[rs_rd_position_1*64+43],
                                rd_NPC_wire[rs_rd_position_1*64+42],rd_NPC_wire[rs_rd_position_1*64+41],rd_NPC_wire[rs_rd_position_1*64+40],
                                rd_NPC_wire[rs_rd_position_1*64+39],rd_NPC_wire[rs_rd_position_1*64+38],rd_NPC_wire[rs_rd_position_1*64+37],
                                rd_NPC_wire[rs_rd_position_1*64+36],rd_NPC_wire[rs_rd_position_1*64+35],rd_NPC_wire[rs_rd_position_1*64+34],
                                rd_NPC_wire[rs_rd_position_1*64+33],rd_NPC_wire[rs_rd_position_1*64+32],rd_NPC_wire[rs_rd_position_1*64+31],
                                rd_NPC_wire[rs_rd_position_1*64+30],rd_NPC_wire[rs_rd_position_1*64+29],rd_NPC_wire[rs_rd_position_1*64+28],
                                rd_NPC_wire[rs_rd_position_1*64+27],rd_NPC_wire[rs_rd_position_1*64+26],rd_NPC_wire[rs_rd_position_1*64+25],
                                rd_NPC_wire[rs_rd_position_1*64+24],rd_NPC_wire[rs_rd_position_1*64+23],rd_NPC_wire[rs_rd_position_1*64+22],
                                rd_NPC_wire[rs_rd_position_1*64+21],rd_NPC_wire[rs_rd_position_1*64+20],rd_NPC_wire[rs_rd_position_1*64+19],
                                rd_NPC_wire[rs_rd_position_1*64+18],rd_NPC_wire[rs_rd_position_1*64+17],rd_NPC_wire[rs_rd_position_1*64+16],
                                rd_NPC_wire[rs_rd_position_1*64+15],rd_NPC_wire[rs_rd_position_1*64+14],rd_NPC_wire[rs_rd_position_1*64+13],
                                rd_NPC_wire[rs_rd_position_1*64+12],rd_NPC_wire[rs_rd_position_1*64+11],rd_NPC_wire[rs_rd_position_1*64+10],
                                rd_NPC_wire[rs_rd_position_1*64+ 9],rd_NPC_wire[rs_rd_position_1*64+ 8],rd_NPC_wire[rs_rd_position_1*64+ 7],
                                rd_NPC_wire[rs_rd_position_1*64+ 6],rd_NPC_wire[rs_rd_position_1*64+ 5],rd_NPC_wire[rs_rd_position_1*64+ 4],
                                rd_NPC_wire[rs_rd_position_1*64+ 3],rd_NPC_wire[rs_rd_position_1*64+ 2],rd_NPC_wire[rs_rd_position_1*64+ 1],
                                rd_NPC_wire[rs_rd_position_1*64+ 0]};
assign rs_rd_rd_mem_1        = rd_rd_mem_wire[rs_rd_position_1];
assign rs_rd_wr_mem_1        = rd_wr_mem_wire[rs_rd_position_1];
assign rs_rd_cond_branch_1   = rd_cond_branch_wire[rs_rd_position_1];
assign rs_rd_uncond_branch_1 = rd_uncond_branch_wire[rs_rd_position_1];
assign rs_rd_br_marker_1     = {rd_br_marker_wire[rs_rd_position_1*3+2], rd_br_marker_wire[rs_rd_position_1*3+1],rd_br_marker_wire[rs_rd_position_1*3]};
assign rs_rd_brpTN_1         = rd_brpTN_wire[rs_rd_position_1];
assign rs_rd_brp_TAR_PC_1    = {rd_brp_TAR_PC_wire[rs_rd_position_1*64+63],rd_brp_TAR_PC_wire[rs_rd_position_1*64+62],rd_brp_TAR_PC_wire[rs_rd_position_1*64+61],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+60],rd_brp_TAR_PC_wire[rs_rd_position_1*64+59],rd_brp_TAR_PC_wire[rs_rd_position_1*64+58],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+57],rd_brp_TAR_PC_wire[rs_rd_position_1*64+56],rd_brp_TAR_PC_wire[rs_rd_position_1*64+55],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+54],rd_brp_TAR_PC_wire[rs_rd_position_1*64+53],rd_brp_TAR_PC_wire[rs_rd_position_1*64+52],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+51],rd_brp_TAR_PC_wire[rs_rd_position_1*64+50],rd_brp_TAR_PC_wire[rs_rd_position_1*64+49],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+48],rd_brp_TAR_PC_wire[rs_rd_position_1*64+47],rd_brp_TAR_PC_wire[rs_rd_position_1*64+46],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+45],rd_brp_TAR_PC_wire[rs_rd_position_1*64+44],rd_brp_TAR_PC_wire[rs_rd_position_1*64+43],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+42],rd_brp_TAR_PC_wire[rs_rd_position_1*64+41],rd_brp_TAR_PC_wire[rs_rd_position_1*64+40],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+39],rd_brp_TAR_PC_wire[rs_rd_position_1*64+38],rd_brp_TAR_PC_wire[rs_rd_position_1*64+37],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+36],rd_brp_TAR_PC_wire[rs_rd_position_1*64+35],rd_brp_TAR_PC_wire[rs_rd_position_1*64+34],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+33],rd_brp_TAR_PC_wire[rs_rd_position_1*64+32],rd_brp_TAR_PC_wire[rs_rd_position_1*64+31],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+30],rd_brp_TAR_PC_wire[rs_rd_position_1*64+29],rd_brp_TAR_PC_wire[rs_rd_position_1*64+28],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+27],rd_brp_TAR_PC_wire[rs_rd_position_1*64+26],rd_brp_TAR_PC_wire[rs_rd_position_1*64+25],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+24],rd_brp_TAR_PC_wire[rs_rd_position_1*64+23],rd_brp_TAR_PC_wire[rs_rd_position_1*64+22],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+21],rd_brp_TAR_PC_wire[rs_rd_position_1*64+20],rd_brp_TAR_PC_wire[rs_rd_position_1*64+19],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+18],rd_brp_TAR_PC_wire[rs_rd_position_1*64+17],rd_brp_TAR_PC_wire[rs_rd_position_1*64+16],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+15],rd_brp_TAR_PC_wire[rs_rd_position_1*64+14],rd_brp_TAR_PC_wire[rs_rd_position_1*64+13],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+12],rd_brp_TAR_PC_wire[rs_rd_position_1*64+11],rd_brp_TAR_PC_wire[rs_rd_position_1*64+10],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 9],rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 8],rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 7],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 6],rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 5],rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 4],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 3],rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 2],rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 1],
                                rd_brp_TAR_PC_wire[rs_rd_position_1*64+ 0]};
assign rs_rd_lsq_tail_1      =  {rd_lsq_tail_wire[rs_rd_position_1*5+4],rd_lsq_tail_wire[rs_rd_position_1*5+3],rd_lsq_tail_wire[rs_rd_position_1*5+2],
                                 rd_lsq_tail_wire[rs_rd_position_1*5+1],rd_lsq_tail_wire[rs_rd_position_1*5]};

assign rs_rd_op_2            = {rd_op_wire[rs_rd_position_2*5+4],rd_op_wire[rs_rd_position_2*5+3],rd_op_wire[rs_rd_position_2*5+2],
                                rd_op_wire[rs_rd_position_2*5+1],rd_op_wire[rs_rd_position_2*5]};
assign rs_rd_T_2             = {rd_T_wire[rs_rd_position_2*6+5],rd_T_wire[rs_rd_position_2*6+4],rd_T_wire[rs_rd_position_2*6+3],
                                rd_T_wire[rs_rd_position_2*6+2],rd_T_wire[rs_rd_position_2*6+1],rd_T_wire[rs_rd_position_2*6]};
assign rs_rd_T1_2            = {rd_T1_wire[rs_rd_position_2*6+5],rd_T1_wire[rs_rd_position_2*6+4],rd_T1_wire[rs_rd_position_2*6+3],
                                rd_T1_wire[rs_rd_position_2*6+2],rd_T1_wire[rs_rd_position_2*6+1],rd_T1_wire[rs_rd_position_2*6]};
assign rs_rd_T1plus_2        = rd_T1plus_wire[rs_rd_position_2];
assign rs_rd_T2_2            = {rd_T2_wire[rs_rd_position_2*6+5],rd_T2_wire[rs_rd_position_2*6+4],rd_T2_wire[rs_rd_position_2*6+3],
                                rd_T2_wire[rs_rd_position_2*6+2],rd_T2_wire[rs_rd_position_2*6+1],rd_T2_wire[rs_rd_position_2*6]};
assign rs_rd_T2plus_2        = rd_T2plus_wire[rs_rd_position_2];
assign rs_rd_opa_select_2    = {rd_opa_select_wire[rs_rd_position_2*2+1],rd_opa_select_wire[rs_rd_position_2*2]};
assign rs_rd_opb_select_2    = {rd_opb_select_wire[rs_rd_position_2*2+1],rd_opb_select_wire[rs_rd_position_2*2]};
assign rs_rd_IR_2            = {rd_IR_wire[rs_rd_position_2*32+31],rd_IR_wire[rs_rd_position_2*32+30],rd_IR_wire[rs_rd_position_2*32+29],
                                rd_IR_wire[rs_rd_position_2*32+28],rd_IR_wire[rs_rd_position_2*32+27],rd_IR_wire[rs_rd_position_2*32+26],
                                rd_IR_wire[rs_rd_position_2*32+25],rd_IR_wire[rs_rd_position_2*32+24],rd_IR_wire[rs_rd_position_2*32+23],
                                rd_IR_wire[rs_rd_position_2*32+22],rd_IR_wire[rs_rd_position_2*32+21],rd_IR_wire[rs_rd_position_2*32+20],
                                rd_IR_wire[rs_rd_position_2*32+19],rd_IR_wire[rs_rd_position_2*32+18],rd_IR_wire[rs_rd_position_2*32+17],
                                rd_IR_wire[rs_rd_position_2*32+16],rd_IR_wire[rs_rd_position_2*32+15],rd_IR_wire[rs_rd_position_2*32+14],
                                rd_IR_wire[rs_rd_position_2*32+13],rd_IR_wire[rs_rd_position_2*32+12],rd_IR_wire[rs_rd_position_2*32+11],
                                rd_IR_wire[rs_rd_position_2*32+10],rd_IR_wire[rs_rd_position_2*32+ 9],rd_IR_wire[rs_rd_position_2*32+ 8],
                                rd_IR_wire[rs_rd_position_2*32+ 7],rd_IR_wire[rs_rd_position_2*32+ 6],rd_IR_wire[rs_rd_position_2*32+ 5],
                                rd_IR_wire[rs_rd_position_2*32+ 4],rd_IR_wire[rs_rd_position_2*32+ 3],rd_IR_wire[rs_rd_position_2*32+ 2],
                                rd_IR_wire[rs_rd_position_2*32+ 1],rd_IR_wire[rs_rd_position_2*32   ]};
assign rs_rd_NPC_2           = {rd_NPC_wire[rs_rd_position_2*64+63],rd_NPC_wire[rs_rd_position_2*64+62],rd_NPC_wire[rs_rd_position_2*64+61],
                                rd_NPC_wire[rs_rd_position_2*64+60],rd_NPC_wire[rs_rd_position_2*64+59],rd_NPC_wire[rs_rd_position_2*64+58],
                                rd_NPC_wire[rs_rd_position_2*64+57],rd_NPC_wire[rs_rd_position_2*64+56],rd_NPC_wire[rs_rd_position_2*64+55],
                                rd_NPC_wire[rs_rd_position_2*64+54],rd_NPC_wire[rs_rd_position_2*64+53],rd_NPC_wire[rs_rd_position_2*64+52],
                                rd_NPC_wire[rs_rd_position_2*64+51],rd_NPC_wire[rs_rd_position_2*64+50],rd_NPC_wire[rs_rd_position_2*64+49],
                                rd_NPC_wire[rs_rd_position_2*64+48],rd_NPC_wire[rs_rd_position_2*64+47],rd_NPC_wire[rs_rd_position_2*64+46],
                                rd_NPC_wire[rs_rd_position_2*64+45],rd_NPC_wire[rs_rd_position_2*64+44],rd_NPC_wire[rs_rd_position_2*64+43],
                                rd_NPC_wire[rs_rd_position_2*64+42],rd_NPC_wire[rs_rd_position_2*64+41],rd_NPC_wire[rs_rd_position_2*64+40],
                                rd_NPC_wire[rs_rd_position_2*64+39],rd_NPC_wire[rs_rd_position_2*64+38],rd_NPC_wire[rs_rd_position_2*64+37],
                                rd_NPC_wire[rs_rd_position_2*64+36],rd_NPC_wire[rs_rd_position_2*64+35],rd_NPC_wire[rs_rd_position_2*64+34],
                                rd_NPC_wire[rs_rd_position_2*64+33],rd_NPC_wire[rs_rd_position_2*64+32],rd_NPC_wire[rs_rd_position_2*64+31],
                                rd_NPC_wire[rs_rd_position_2*64+30],rd_NPC_wire[rs_rd_position_2*64+29],rd_NPC_wire[rs_rd_position_2*64+28],
                                rd_NPC_wire[rs_rd_position_2*64+27],rd_NPC_wire[rs_rd_position_2*64+26],rd_NPC_wire[rs_rd_position_2*64+25],
                                rd_NPC_wire[rs_rd_position_2*64+24],rd_NPC_wire[rs_rd_position_2*64+23],rd_NPC_wire[rs_rd_position_2*64+22],
                                rd_NPC_wire[rs_rd_position_2*64+21],rd_NPC_wire[rs_rd_position_2*64+20],rd_NPC_wire[rs_rd_position_2*64+19],
                                rd_NPC_wire[rs_rd_position_2*64+18],rd_NPC_wire[rs_rd_position_2*64+17],rd_NPC_wire[rs_rd_position_2*64+16],
                                rd_NPC_wire[rs_rd_position_2*64+15],rd_NPC_wire[rs_rd_position_2*64+14],rd_NPC_wire[rs_rd_position_2*64+13],
                                rd_NPC_wire[rs_rd_position_2*64+12],rd_NPC_wire[rs_rd_position_2*64+11],rd_NPC_wire[rs_rd_position_2*64+10],
                                rd_NPC_wire[rs_rd_position_2*64+ 9],rd_NPC_wire[rs_rd_position_2*64+ 8],rd_NPC_wire[rs_rd_position_2*64+ 7],
                                rd_NPC_wire[rs_rd_position_2*64+ 6],rd_NPC_wire[rs_rd_position_2*64+ 5],rd_NPC_wire[rs_rd_position_2*64+ 4],
                                rd_NPC_wire[rs_rd_position_2*64+ 3],rd_NPC_wire[rs_rd_position_2*64+ 2],rd_NPC_wire[rs_rd_position_2*64+ 1],
                                rd_NPC_wire[rs_rd_position_2*64+ 0]};
assign rs_rd_rd_mem_2        = rd_rd_mem_wire[rs_rd_position_2];
assign rs_rd_wr_mem_2        = rd_wr_mem_wire[rs_rd_position_2];
assign rs_rd_cond_branch_2   = rd_cond_branch_wire[rs_rd_position_2];
assign rs_rd_uncond_branch_2 = rd_uncond_branch_wire[rs_rd_position_2];
assign rs_rd_br_marker_2     = {rd_br_marker_wire[rs_rd_position_2*3+2], rd_br_marker_wire[rs_rd_position_2*3+1],rd_br_marker_wire[rs_rd_position_2*3]};
assign rs_rd_brpTN_2         = rd_brpTN_wire[rs_rd_position_2];
assign rs_rd_brp_TAR_PC_2    = {rd_brp_TAR_PC_wire[rs_rd_position_2*64+63],rd_brp_TAR_PC_wire[rs_rd_position_2*64+62],rd_brp_TAR_PC_wire[rs_rd_position_2*64+61],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+60],rd_brp_TAR_PC_wire[rs_rd_position_2*64+59],rd_brp_TAR_PC_wire[rs_rd_position_2*64+58],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+57],rd_brp_TAR_PC_wire[rs_rd_position_2*64+56],rd_brp_TAR_PC_wire[rs_rd_position_2*64+55],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+54],rd_brp_TAR_PC_wire[rs_rd_position_2*64+53],rd_brp_TAR_PC_wire[rs_rd_position_2*64+52],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+51],rd_brp_TAR_PC_wire[rs_rd_position_2*64+50],rd_brp_TAR_PC_wire[rs_rd_position_2*64+49],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+48],rd_brp_TAR_PC_wire[rs_rd_position_2*64+47],rd_brp_TAR_PC_wire[rs_rd_position_2*64+46],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+45],rd_brp_TAR_PC_wire[rs_rd_position_2*64+44],rd_brp_TAR_PC_wire[rs_rd_position_2*64+43],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+42],rd_brp_TAR_PC_wire[rs_rd_position_2*64+41],rd_brp_TAR_PC_wire[rs_rd_position_2*64+40],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+39],rd_brp_TAR_PC_wire[rs_rd_position_2*64+38],rd_brp_TAR_PC_wire[rs_rd_position_2*64+37],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+36],rd_brp_TAR_PC_wire[rs_rd_position_2*64+35],rd_brp_TAR_PC_wire[rs_rd_position_2*64+34],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+33],rd_brp_TAR_PC_wire[rs_rd_position_2*64+32],rd_brp_TAR_PC_wire[rs_rd_position_2*64+31],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+30],rd_brp_TAR_PC_wire[rs_rd_position_2*64+29],rd_brp_TAR_PC_wire[rs_rd_position_2*64+28],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+27],rd_brp_TAR_PC_wire[rs_rd_position_2*64+26],rd_brp_TAR_PC_wire[rs_rd_position_2*64+25],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+24],rd_brp_TAR_PC_wire[rs_rd_position_2*64+23],rd_brp_TAR_PC_wire[rs_rd_position_2*64+22],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+21],rd_brp_TAR_PC_wire[rs_rd_position_2*64+20],rd_brp_TAR_PC_wire[rs_rd_position_2*64+19],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+18],rd_brp_TAR_PC_wire[rs_rd_position_2*64+17],rd_brp_TAR_PC_wire[rs_rd_position_2*64+16],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+15],rd_brp_TAR_PC_wire[rs_rd_position_2*64+14],rd_brp_TAR_PC_wire[rs_rd_position_2*64+13],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+12],rd_brp_TAR_PC_wire[rs_rd_position_2*64+11],rd_brp_TAR_PC_wire[rs_rd_position_2*64+10],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 9],rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 8],rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 7],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 6],rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 5],rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 4],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 3],rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 2],rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 1],
                                rd_brp_TAR_PC_wire[rs_rd_position_2*64+ 0]};
assign rs_rd_lsq_tail_2      =  {rd_lsq_tail_wire[rs_rd_position_2*5+4],rd_lsq_tail_wire[rs_rd_position_2*5+3],rd_lsq_tail_wire[rs_rd_position_2*5+2],
                                 rd_lsq_tail_wire[rs_rd_position_2*5+1],rd_lsq_tail_wire[rs_rd_position_2*5]};

assign rs_rd_T1plus_all    = rd_T1plus_wire;
assign rs_rd_T2plus_all    = rd_T2plus_wire;

rs_slot reservation_station [15:0] (.reset(reset), .clock(clock),
                                    .wr_enable_1(enable_wr_slot_binstr_1), .wr_enable_2(enable_wr_slot_binstr_2), .clear(clear_pos_str),

                                    .wr_data_op_1(rs_wr_data_op_1), .wr_data_T_1(rs_wr_data_T_1), .wr_data_T1_1(rs_wr_data_T1_1), .wr_data_T1plus_1(rs_wr_data_T1plus_1),
                                    .wr_data_T2_1(rs_wr_data_T2_1), .wr_data_T2plus_1(rs_wr_data_T2plus_1), .wr_data_opa_select_1(rs_wr_data_opa_select_1), .wr_data_opb_select_1(rs_wr_data_opb_select_1),
                                    .wr_data_IR_1(rs_wr_data_IR_1), .wr_data_NPC_1(rs_wr_data_NPC_1), .wr_data_rd_mem_1(rs_wr_data_rd_mem_1), .wr_data_wr_mem_1(rs_wr_data_wr_mem_1),
                                    .wr_data_cond_branch_1(rs_wr_data_cond_branch_1), .wr_data_uncond_branch_1(rs_wr_data_uncond_branch_1), .wr_data_br_marker_1(rs_wr_data_br_marker_1),
                                    .wr_data_brpTN_1(rs_wr_data_brpTN_1), .wr_data_brp_TAR_PC_1(rs_wr_data_brp_TAR_PC_1), .wr_data_lsq_tail_1(rs_wr_data_lsq_tail_1),
                                    .write_CDB_en_1(rs_write_CDB_en_1), .search_CDB_value_in_1(rs_search_CDB_value_in_1),
                                    .wr_data_op_2(rs_wr_data_op_2), .wr_data_T_2(rs_wr_data_T_2), .wr_data_T1_2(rs_wr_data_T1_2), .wr_data_T1plus_2(rs_wr_data_T1plus_2),
                                    .wr_data_T2_2(rs_wr_data_T2_2), .wr_data_T2plus_2(rs_wr_data_T2plus_2), .wr_data_opa_select_2(rs_wr_data_opa_select_2), .wr_data_opb_select_2(rs_wr_data_opb_select_2),
                                    .wr_data_IR_2(rs_wr_data_IR_2), .wr_data_NPC_2(rs_wr_data_NPC_2), .wr_data_rd_mem_2(rs_wr_data_rd_mem_2), .wr_data_wr_mem_2(rs_wr_data_wr_mem_2),
                                    .wr_data_cond_branch_2(rs_wr_data_cond_branch_2), .wr_data_uncond_branch_2(rs_wr_data_uncond_branch_2), .wr_data_br_marker_2(rs_wr_data_br_marker_2),
                                    .wr_data_brpTN_2(rs_wr_data_brpTN_2), .wr_data_brp_TAR_PC_2(rs_wr_data_brp_TAR_PC_2), .wr_data_lsq_tail_2(rs_wr_data_lsq_tail_2),
                                    .write_CDB_en_2(rs_write_CDB_en_2), .search_CDB_value_in_2(rs_search_CDB_value_in_2),

                                    .rd_op(rd_op_wire), .rd_T(rd_T_wire), .rd_T1(rd_T1_wire), .rd_T1plus(rd_T1plus_wire), .rd_T2(rd_T2_wire), .rd_T2plus(rd_T2plus_wire),
                                    .rd_opa_select(rd_opa_select_wire), .rd_opb_select(rd_opb_select_wire), .rd_cond_branch(rd_cond_branch_wire), .rd_uncond_branch(rd_uncond_branch_wire), .rd_br_marker(rd_br_marker_wire),
                                    .rd_IR(rd_IR_wire), .rd_NPC(rd_NPC_wire), .rd_rd_mem(rd_rd_mem_wire), .rd_wr_mem(rd_wr_mem_wire),
                                    .rd_brpTN(rd_brpTN_wire), .rd_brp_TAR_PC(rd_brp_TAR_PC_wire), .rd_lsq_tail(rd_lsq_tail_wire) );

endmodule
