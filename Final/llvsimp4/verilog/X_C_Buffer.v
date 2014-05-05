module X_C_Buffer(// Input
                  clock,
                  reset,

                  X_alu_result_in_alu0,
                  X_valid_inst_in_alu0,
                  X_dest_reg_idx_in_alu0,

                  X_alu_result_in_alu1,
                  X_valid_inst_in_alu1,
                  X_dest_reg_idx_in_alu1,

                  X_alu_result_in_alu2,
                  X_valid_inst_in_alu2,
                  X_dest_reg_idx_in_alu2,

                  X_alu_result_in_alu3,
                  X_valid_inst_in_alu3,
                  X_dest_reg_idx_in_alu3,

                  // Output
                  X_C_reg_wr_data_out_1,
                  X_C_reg_wr_idx_out_1,
                  X_C_reg_wr_en_out_1,
                  X_C_reg_wr_data_out_2,
                  X_C_reg_wr_idx_out_2,
                  X_C_reg_wr_en_out_2
                 );

  input         clock;
  input         reset;
  // ALU 0
  input  [63:0] X_alu_result_in_alu0; 
  input         X_valid_inst_in_alu0;
  input  [5:0]  X_dest_reg_idx_in_alu0;
  // ALU 1
  input  [63:0] X_alu_result_in_alu1;
  input         X_valid_inst_in_alu1; 
  input  [5:0]  X_dest_reg_idx_in_alu1;
  // ALU 2
  input  [63:0] X_alu_result_in_alu2;
  input         X_valid_inst_in_alu2;
  input  [5:0]  X_dest_reg_idx_in_alu2;
  // ALU 3
  input  [63:0] X_alu_result_in_alu3; 
  input         X_valid_inst_in_alu3;
  input  [5:0]  X_dest_reg_idx_in_alu3;

  output [63:0] X_C_reg_wr_data_out_1;
  output [63:0] X_C_reg_wr_data_out_2;
  output [5:0]  X_C_reg_wr_idx_out_1;
  output [5:0]  X_C_reg_wr_idx_out_2;
  output        X_C_reg_wr_en_out_1;
  output        X_C_reg_wr_en_out_2;

  reg   [63:0] alu_result [0:7];
  reg   [5:0]  dest_idx   [0:7];
  reg   [3:0]  valid      [0:7];
  reg   [3:0]  h;
  reg   [3:0]  t;


  reg   [63:0] next_alu_result [0:7];
  reg   [5:0]  next_dest_idx   [0:7];
  reg   [3:0]  next_valid      [0:7];

  wire  [3:0]  next_h;
  wire  [3:0]  next_t;
  wire  [3:0]  h_plus_1;
  wire  [3:0]  t_plus_1;
  wire  [3:0]  t_plus_2;
  wire  [3:0]  t_plus_3;
  
  wire         wb_en_0   = X_valid_inst_in_alu0 && X_dest_reg_idx_in_alu0!=`ZERO_REG;
  wire         wb_en_1   = X_valid_inst_in_alu1 && X_dest_reg_idx_in_alu1!=`ZERO_REG;
  wire         wb_en_2   = X_valid_inst_in_alu2 && X_dest_reg_idx_in_alu2!=`ZERO_REG;
  wire         wb_en_3   = X_valid_inst_in_alu3 && X_dest_reg_idx_in_alu3!=`ZERO_REG;

  wire  [2:0] total_wr_en = (wb_en_0 + wb_en_1) + (wb_en_2 + wb_en_3);

  assign h_plus_1 = h + 1;
  assign t_plus_1 = t + 1;
  assign t_plus_2 = t + 2;
  assign t_plus_3 = t + 3;
  assign next_t = t + total_wr_en;
  assign next_h = (t[2:0]==h[2:0])? h:
                  (t[2:0]==h_plus_1[2:0])? h_plus_1:
                  h+2;
/*
  assign X_C_reg_wr_data_out_1 = (t[2:0]==h[2:0])? 0: alu_result[h[2:0]];
  assign X_C_reg_wr_data_out_2 = (t[2:0]<=h_plus_1[2:0])? 0:alu_result[h_plus_1[2:0]];
  assign X_C_reg_wr_idx_out_1  = (t[2:0]==h[2:0])? 0: dest_idx[h[2:0]];
  assign X_C_reg_wr_idx_out_2  = (t[2:0]<=h_plus_1[2:0])? 0:dest_idx[h_plus_1[2:0]];
  assign X_C_reg_wr_en_out_1   = (t[2:0]==h[2:0])? 0:1;
  assign X_C_reg_wr_en_out_2   = (t[2:0]<=h_plus_1[2:0])? 0:1;
*/

  assign X_C_reg_wr_data_out_1 = (t!=h)? alu_result[h[2:0]]:0;
  assign X_C_reg_wr_data_out_2 = (t!=h_plus_1 && t!=h)? alu_result[h_plus_1[2:0]]:0;
  assign X_C_reg_wr_idx_out_1  = (t!=h)? dest_idx[h[2:0]]:0;
  assign X_C_reg_wr_idx_out_2  = (t!=h_plus_1 && t!=h)? dest_idx[h_plus_1[2:0]]:0;
  assign X_C_reg_wr_en_out_1   = (valid[h[2:0]] && t!=h)? 1:0;
  assign X_C_reg_wr_en_out_2   = (valid[h[2:0]] && t!=h_plus_1 && t!=h)? 1:0;


  always @*
  begin
    // default value
    next_alu_result[0]  = alu_result[0];
    next_dest_idx[0]    = dest_idx[0];
    next_valid[0]       = valid[0];

    next_alu_result[1]  = alu_result[1];
    next_dest_idx[1]    = dest_idx[1];
    next_valid[1]       = valid[1];

    next_alu_result[2]  = alu_result[2];
    next_dest_idx[2]    = dest_idx[2];
    next_valid[2]       = valid[2];

    next_alu_result[3]  = alu_result[3];
    next_dest_idx[3]    = dest_idx[3];
    next_valid[3]       = valid[3];

    next_alu_result[4]  = alu_result[4];
    next_dest_idx[4]    = dest_idx[4];
    next_valid[4]       = valid[4];

    next_alu_result[5]  = alu_result[5];
    next_dest_idx[5]    = dest_idx[5];
    next_valid[5]       = valid[5];

    next_alu_result[6]  = alu_result[6];
    next_dest_idx[6]    = dest_idx[6];
    next_valid[6]       = valid[6];

    next_alu_result[7]  = alu_result[7];
    next_dest_idx[7]    = dest_idx[7];
    next_valid[7]       = valid[7];
    // input case
    case(total_wr_en)
      3'd1: 
        begin
          if(wb_en_0) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu0;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu0;
            next_valid[t[2:0]]       = X_valid_inst_in_alu0;
          end
          else if(wb_en_1) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu1;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu1;
            next_valid[t[2:0]]       = X_valid_inst_in_alu1;
          end
          else if(wb_en_2) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu2;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu2;
            next_valid[t[2:0]]       = X_valid_inst_in_alu2;
          end
          else if(wb_en_3) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu3;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu3;
            next_valid[t[2:0]]       = X_valid_inst_in_alu3;
          end
        end
      3'd2:
        begin
          if(wb_en_3) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu3;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu3;
            next_valid[t[2:0]]       = X_valid_inst_in_alu3;
          end
          else if(wb_en_2) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu2;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu2;
            next_valid[t[2:0]]       = X_valid_inst_in_alu2;
          end
          else if(wb_en_1) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu1;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu1;
            next_valid[t[2:0]]       = X_valid_inst_in_alu1;
          end
          else if(wb_en_0) begin
            next_alu_result[t[2:0]]  = X_alu_result_in_alu0;
            next_dest_idx[t[2:0]]    = X_dest_reg_idx_in_alu0;
            next_valid[t[2:0]]       = X_valid_inst_in_alu0;
          end

          if(wb_en_0) begin
            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu0;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu0;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu0;
          end
          else if(wb_en_1) begin
            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu1;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu1;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu1;
          end
          else if(wb_en_2) begin
            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu2;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu2;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu2;
          end
          else if(wb_en_3) begin
            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu3;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu3;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu3;
          end
        end
      3'd3:
        begin
          if(!wb_en_0) begin
            next_alu_result[t[2:0]]         = X_alu_result_in_alu3;
            next_dest_idx[t[2:0]]           = X_dest_reg_idx_in_alu3;
            next_valid[t[2:0]]              = X_valid_inst_in_alu3;

            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu2;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu2;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu2;

            next_alu_result[t_plus_2[2:0]]  = X_alu_result_in_alu1;
            next_dest_idx[t_plus_2[2:0]]    = X_dest_reg_idx_in_alu1;
            next_valid[t_plus_2[2:0]]       = X_valid_inst_in_alu1;
          end
          else if(!wb_en_1) begin
            next_alu_result[t[2:0]]         = X_alu_result_in_alu3;
            next_dest_idx[t[2:0]]           = X_dest_reg_idx_in_alu3;
            next_valid[t[2:0]]              = X_valid_inst_in_alu3;

            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu2;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu2;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu2;

            next_alu_result[t_plus_2[2:0]]  = X_alu_result_in_alu0;
            next_dest_idx[t_plus_2[2:0]]    = X_dest_reg_idx_in_alu0;
            next_valid[t_plus_2[2:0]]       = X_valid_inst_in_alu0;
          end
          else if(!wb_en_2) begin
            next_alu_result[t[2:0]]         = X_alu_result_in_alu3;
            next_dest_idx[t[2:0]]           = X_dest_reg_idx_in_alu3;
            next_valid[t[2:0]]              = X_valid_inst_in_alu3;

            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu1;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu1;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu1;

            next_alu_result[t_plus_2[2:0]]  = X_alu_result_in_alu0;
            next_dest_idx[t_plus_2[2:0]]    = X_dest_reg_idx_in_alu0;
            next_valid[t_plus_2[2:0]]       = X_valid_inst_in_alu0;
          end
          else if(!wb_en_3) begin
            next_alu_result[t[2:0]]         = X_alu_result_in_alu2;
            next_dest_idx[t[2:0]]           = X_dest_reg_idx_in_alu2;
            next_valid[t[2:0]]              = X_valid_inst_in_alu2;

            next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu1;
            next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu1;
            next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu1;

            next_alu_result[t_plus_2[2:0]]  = X_alu_result_in_alu0;
            next_dest_idx[t_plus_2[2:0]]    = X_dest_reg_idx_in_alu0;
            next_valid[t_plus_2[2:0]]       = X_valid_inst_in_alu0;
          end
        end
      3'd4:
        begin
          next_alu_result[t[2:0]]         = X_alu_result_in_alu3;
          next_dest_idx[t[2:0]]           = X_dest_reg_idx_in_alu3;
          next_valid[t[2:0]]              = X_valid_inst_in_alu3;

          next_alu_result[t_plus_1[2:0]]  = X_alu_result_in_alu2;
          next_dest_idx[t_plus_1[2:0]]    = X_dest_reg_idx_in_alu2;
          next_valid[t_plus_1[2:0]]       = X_valid_inst_in_alu2;

          next_alu_result[t_plus_2[2:0]]  = X_alu_result_in_alu1;
          next_dest_idx[t_plus_2[2:0]]    = X_dest_reg_idx_in_alu1;
          next_valid[t_plus_2[2:0]]       = X_valid_inst_in_alu1;

          next_alu_result[t_plus_3[2:0]]  = X_alu_result_in_alu0;
          next_dest_idx[t_plus_3[2:0]]    = X_dest_reg_idx_in_alu0;
          next_valid[t_plus_3[2:0]]       = X_valid_inst_in_alu0;
        end
    endcase
  end


  always @(posedge clock) 
  begin
    if(reset) begin
      alu_result[0]   <= `SD 0;
      alu_result[1]   <= `SD 0;
      alu_result[2]   <= `SD 0;
      alu_result[3]   <= `SD 0;
      alu_result[4]   <= `SD 0;
      alu_result[5]   <= `SD 0;
      alu_result[6]   <= `SD 0;
      alu_result[7]   <= `SD 0;
      dest_idx[0]     <= `SD `ZERO_REG;
      dest_idx[1]     <= `SD `ZERO_REG;
      dest_idx[2]     <= `SD `ZERO_REG;
      dest_idx[3]     <= `SD `ZERO_REG;
      dest_idx[4]     <= `SD `ZERO_REG;
      dest_idx[5]     <= `SD `ZERO_REG;
      dest_idx[6]     <= `SD `ZERO_REG;
      dest_idx[7]     <= `SD `ZERO_REG;
      h               <= `SD 0;
      t               <= `SD 0;
    end
    else begin
      h               <= `SD next_h;
      t               <= `SD next_t;
      alu_result[0]   <= `SD next_alu_result[0];
      dest_idx[0]     <= `SD next_dest_idx[0];
      valid[0]        <= `SD next_valid[0];

      alu_result[1]   <= `SD next_alu_result[1];
      dest_idx[1]     <= `SD next_dest_idx[1];
      valid[1]        <= `SD next_valid[1];

      alu_result[2]   <= `SD next_alu_result[2];
      dest_idx[2]     <= `SD next_dest_idx[2];
      valid[2]        <= `SD next_valid[2];

      alu_result[3]   <= `SD next_alu_result[3];
      dest_idx[3]     <= `SD next_dest_idx[3];
      valid[3]        <= `SD next_valid[3];

      alu_result[4]   <= `SD next_alu_result[4];
      dest_idx[4]     <= `SD next_dest_idx[4];
      valid[4]        <= `SD next_valid[4];

      alu_result[5]   <= `SD next_alu_result[5];
      dest_idx[5]     <= `SD next_dest_idx[5];
      valid[5]        <= `SD next_valid[5];

      alu_result[6]   <= `SD next_alu_result[6];
      dest_idx[6]     <= `SD next_dest_idx[6];
      valid[6]        <= `SD next_valid[6];

      alu_result[7]   <= `SD next_alu_result[7];
      dest_idx[7]     <= `SD next_dest_idx[7];
      valid[7]        <= `SD next_valid[7];
    end
  end



endmodule
