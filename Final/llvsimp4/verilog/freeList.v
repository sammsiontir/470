`timescale 1ns/100ps

module freeList(// Input
                clock,
                reset,
                rob_Told_1,
                rob_Told_2,
                br_wr_en_1,
                br_wr_en_2,
                br_marker_in_1,
                br_marker_in_2,
                br_mispredict,
                br_mispre_marker,
                D_en_1,
                D_en_2,
                R_en_1,
                R_en_2,

                // Output
                fl_T_1,
                fl_T_2,
                fl_stall
               );

  input        clock;
  input        reset;
  input  [5:0] rob_Told_1;
  input  [5:0] rob_Told_2;
  input        br_wr_en_1;
  input        br_wr_en_2;
  input  [2:0] br_marker_in_1;
  input  [2:0] br_marker_in_2;
  input        br_mispredict;
  input  [2:0] br_mispre_marker;
  input        D_en_1;
  input        D_en_2;
  input        R_en_1;
  input        R_en_2;

  output [5:0] fl_T_1;
  output [5:0] fl_T_2;
  output [1:0] fl_stall;     // Dispatch: Rob full? 2'b00: not full
                             //                     2'b01: only 1 space left
                             //                     2'b11: full
  reg    [5:0] fl_T_1;
  reg    [5:0] fl_T_2;

  reg    [5:0] freeReg[0:31];
  reg    [5:0] head;
  reg    [5:0] tail;
  reg    [5:0] next_head;
  wire   [5:0] head_plus_1;
  wire   [5:0] tail_plus_1;

  reg    [5:0] br_h[0:3];

  assign head_plus_1 = head + 1;
  assign tail_plus_1 = tail + 1;
  assign fl_stall = (head==tail)? 2'b11:
//                    (head+6'd1==tail)? 2'b01:
                    2'b00;

  always @*
  begin
    if(D_en_1 & D_en_2) begin
      fl_T_1 = freeReg[head[4:0]];
      fl_T_2 = freeReg[head_plus_1[4:0]];
      next_head = head + 6'd2;
    end
    else if(D_en_1) begin
      fl_T_1 = freeReg[head[4:0]];
      fl_T_2 = `ZERO_REG;
      next_head = head + 6'd1;
    end
    else if(D_en_2) begin
      fl_T_1 = `ZERO_REG;
      fl_T_2 = freeReg[head[4:0]];
      next_head = head + 6'd1;
    end
    else begin
      fl_T_1 = `ZERO_REG;
      fl_T_2 = `ZERO_REG;
      next_head = head;
    end
  end


  always @(posedge clock)
  begin
    if(reset) begin
      freeReg[0]        <= `SD `REG_32;
      freeReg[1]        <= `SD `REG_33;
      freeReg[2]        <= `SD `REG_34;
      freeReg[3]        <= `SD `REG_35;
      freeReg[4]        <= `SD `REG_36;
      freeReg[5]        <= `SD `REG_37;
      freeReg[6]        <= `SD `REG_38;
      freeReg[7]        <= `SD `REG_39;
      freeReg[8]        <= `SD `REG_40;
      freeReg[9]        <= `SD `REG_41;
      freeReg[10]       <= `SD `REG_42;
      freeReg[11]       <= `SD `REG_43;
      freeReg[12]       <= `SD `REG_44;
      freeReg[13]       <= `SD `REG_45;
      freeReg[14]       <= `SD `REG_46;
      freeReg[15]       <= `SD `REG_47;
      freeReg[16]       <= `SD `REG_48;
      freeReg[17]       <= `SD `REG_49;
      freeReg[18]       <= `SD `REG_50;
      freeReg[19]       <= `SD `REG_51;
      freeReg[20]       <= `SD `REG_52;
      freeReg[21]       <= `SD `REG_53;
      freeReg[22]       <= `SD `REG_54;
      freeReg[23]       <= `SD `REG_55;
      freeReg[24]       <= `SD `REG_56;
      freeReg[25]       <= `SD `REG_57;
      freeReg[26]       <= `SD `REG_58;
      freeReg[27]       <= `SD `REG_59;
      freeReg[28]       <= `SD `REG_60;
      freeReg[29]       <= `SD `REG_61;
      freeReg[30]       <= `SD `REG_62;
      freeReg[31]       <= `SD `REG_63;
      head              <= `SD 6'b0;
      tail              <= `SD 6'b100000;
    end
    else if(br_mispredict) begin
      head                        <= `SD br_h[br_mispre_marker[1:0]];
      // Retire
      if(R_en_1 & R_en_2) begin
        freeReg[tail[4:0]]        <= `SD rob_Told_1;
        freeReg[tail_plus_1[4:0]] <= `SD rob_Told_2;
        tail                      <= `SD tail + 2;
      end
      else if(R_en_1) begin
        freeReg[tail[4:0]]   <= `SD rob_Told_1;
        tail                 <= `SD tail + 1;
      end
      else if(R_en_2) begin
        freeReg[tail[4:0]]   <= `SD rob_Told_2;
        tail                 <= `SD tail + 1;
      end

    end
    else begin
      head              <= `SD next_head;
      // Retire
      if(R_en_1 & R_en_2) begin
        freeReg[tail[4:0]]   <= `SD rob_Told_1;
        freeReg[tail_plus_1[4:0]] <= `SD rob_Told_2;
        tail                 <= `SD tail + 2;
      end
      else if(R_en_1) begin
        freeReg[tail[4:0]]   <= `SD rob_Told_1;
        tail                 <= `SD tail + 1;
      end
      else if(R_en_2) begin
        freeReg[tail[4:0]]   <= `SD rob_Told_2;
        tail                 <= `SD tail + 1;
      end

      // branch
      if(br_wr_en_1 && !br_wr_en_2) begin
        if(D_en_1) br_h[br_marker_in_1[1:0]] <= `SD head + 1;
        else br_h[br_marker_in_1[1:0]] <= `SD head;
      end
      else if(!br_wr_en_1 & br_wr_en_2) begin
        if(D_en_1 && D_en_2) br_h[br_marker_in_2[1:0]] <= `SD head + 2;
        else if(D_en_1 || D_en_2) br_h[br_marker_in_2[1:0]] <= `SD head + 1;
        else br_h[br_marker_in_2[1:0]] <= `SD head;
      end
    end
  end

endmodule
