`timescale 1ns/100ps
module mapTable(// Input
                clock,
                reset,
                id_ra_reg_idx_in_1,
                id_ra_reg_idx_in_2,
                id_rb_reg_idx_in_1,
                id_rb_reg_idx_in_2,
                id_dest_reg_idx_in_1,
                id_dest_reg_idx_in_2,
                fl_wr_idx_in_1,
                fl_wr_idx_in_2,
                fl_wr_en_1,
                fl_wr_en_2,
                cdb_wr_idx_1,
                cdb_wr_idx_2,
                cdb_wr_en_1,
                cdb_wr_en_2,
                br_wr_en_1,
                br_wr_en_2,
                br_marker_in_1,
                br_marker_in_2,
                br_mispredict,
                br_mispre_marker,

                // Output
                ra_reg_idx_out_1,
                ra_reg_idx_out_2,
                rb_reg_idx_out_1,
                rb_reg_idx_out_2,
                ra_reg_ready_out_1,
                ra_reg_ready_out_2,
                rb_reg_ready_out_1,
                rb_reg_ready_out_2,
                mt_dest_reg_old_1,
                mt_dest_reg_old_2
               );

  input        clock;
  input        reset;
  input [4:0]  id_ra_reg_idx_in_1;
  input [4:0]  id_ra_reg_idx_in_2;
  input [4:0]  id_rb_reg_idx_in_1;
  input [4:0]  id_rb_reg_idx_in_2;
  input [4:0]  id_dest_reg_idx_in_1;
  input [4:0]  id_dest_reg_idx_in_2;
  input [5:0]  fl_wr_idx_in_1;
  input [5:0]  fl_wr_idx_in_2;
  input        fl_wr_en_1;
  input        fl_wr_en_2;
  input [5:0]  cdb_wr_idx_1;
  input [5:0]  cdb_wr_idx_2;
  input        cdb_wr_en_1;
  input        cdb_wr_en_2;
  input        br_wr_en_1;
  input        br_wr_en_2;
  input [2:0]  br_marker_in_1;
  input [2:0]  br_marker_in_2;
  input        br_mispredict;
  input [2:0]  br_mispre_marker;

  output [5:0] ra_reg_idx_out_1;
  output [5:0] ra_reg_idx_out_2;
  output [5:0] rb_reg_idx_out_1;
  output [5:0] rb_reg_idx_out_2;
  output       ra_reg_ready_out_1;
  output       ra_reg_ready_out_2;
  output       rb_reg_ready_out_1;
  output       rb_reg_ready_out_2;
  output [5:0] mt_dest_reg_old_1;
  output [5:0] mt_dest_reg_old_2;

  reg    [5:0] reg_tag         [0:31];
  reg          reg_tag_ready   [0:31];
  // Branch
  reg    [5:0] br_tag0         [0:30];
  reg    [5:0] br_tag1         [0:30];
  reg    [5:0] br_tag2         [0:30];
  reg    [5:0] br_tag3         [0:30];
  reg          br_tag_ready0   [0:30];
  reg          br_tag_ready1   [0:30];
  reg          br_tag_ready2   [0:30];
  reg          br_tag_ready3   [0:30];
  reg    [5:0] br_tmp_1        [0:30];
  reg    [5:0] br_tmp_2        [0:30];
  reg          br_tmp_ready_1  [0:30];
  reg          br_tmp_ready_2  [0:30];

  reg    [5:0] mispredict_tag      [0:31];
  reg          mispredict_tag_ready[0:31];

  reg    [4:0] tmp_dest_reg_idx_1;
  reg    [4:0] tmp_dest_reg_idx_2;
  reg    [5:0] tmp_fl_reg_idx_1;
  reg    [5:0] tmp_fl_reg_idx_2;
  reg          tmp_fl_wr_en_1; 
  reg          tmp_fl_wr_en_2; 
  reg    [4:0] next_tmp_dest_reg_idx_1;
  reg    [4:0] next_tmp_dest_reg_idx_2;
  reg    [5:0] next_tmp_fl_reg_idx_1;
  reg    [5:0] next_tmp_fl_reg_idx_2;
  reg          next_tmp_fl_wr_en_1; 
  reg          next_tmp_fl_wr_en_2; 

  wire         cdb_wr_en_now_1;
  wire         cdb_wr_en_now_2;

  assign cdb_wr_en_now_1 = ((tmp_fl_wr_en_1 && cdb_wr_idx_1==reg_tag[tmp_dest_reg_idx_1]) || (tmp_fl_wr_en_2 && cdb_wr_idx_1==reg_tag[tmp_dest_reg_idx_2]))? 0:cdb_wr_en_1;
  assign cdb_wr_en_now_2 = ((tmp_fl_wr_en_1 && cdb_wr_idx_2==reg_tag[tmp_dest_reg_idx_1]) || (tmp_fl_wr_en_2 && cdb_wr_idx_2==reg_tag[tmp_dest_reg_idx_2]))? 0:cdb_wr_en_2;

  // reg A1 out         
  assign ra_reg_idx_out_1   = (tmp_fl_wr_en_2 && id_ra_reg_idx_in_1==tmp_dest_reg_idx_2)? tmp_fl_reg_idx_2:
                              (tmp_fl_wr_en_1 && id_ra_reg_idx_in_1==tmp_dest_reg_idx_1)? tmp_fl_reg_idx_1: 
                              reg_tag[id_ra_reg_idx_in_1];
  assign ra_reg_ready_out_1 = (cdb_wr_en_now_1 && cdb_wr_idx_1==ra_reg_idx_out_1)? 1'd1:
                              (cdb_wr_en_now_2 && cdb_wr_idx_2==ra_reg_idx_out_1)? 1'd1:
                              (tmp_fl_wr_en_2 & id_ra_reg_idx_in_1==tmp_dest_reg_idx_2)? 1'd0:
                              (tmp_fl_wr_en_1 & id_ra_reg_idx_in_1==tmp_dest_reg_idx_1)? 1'd0: 
                              reg_tag_ready[id_ra_reg_idx_in_1];
  // reg A2 out         
  assign ra_reg_idx_out_2   = (fl_wr_en_1     && id_ra_reg_idx_in_2==id_dest_reg_idx_in_1)? fl_wr_idx_in_1:
                              (tmp_fl_wr_en_2 && id_ra_reg_idx_in_2==tmp_dest_reg_idx_2)? tmp_fl_reg_idx_2:
                              (tmp_fl_wr_en_1 && id_ra_reg_idx_in_2==tmp_dest_reg_idx_1)? tmp_fl_reg_idx_1: 
                              reg_tag[id_ra_reg_idx_in_2];
  assign ra_reg_ready_out_2 = (cdb_wr_en_now_1 && cdb_wr_idx_1==ra_reg_idx_out_2)? 1'd1:
                              (cdb_wr_en_now_2 && cdb_wr_idx_2==ra_reg_idx_out_2)? 1'd1:
                              (tmp_fl_wr_en_2 & id_ra_reg_idx_in_2==tmp_dest_reg_idx_2)? 1'd0:
                              (tmp_fl_wr_en_1 & id_ra_reg_idx_in_2==tmp_dest_reg_idx_1)? 1'd0: 
                              (fl_wr_en_1     & id_ra_reg_idx_in_2==id_dest_reg_idx_in_1)? 1'd0:
                              reg_tag_ready[id_ra_reg_idx_in_2];

  // reg B1 out         
  assign rb_reg_idx_out_1   = (tmp_fl_wr_en_2 && id_rb_reg_idx_in_1==tmp_dest_reg_idx_2)? tmp_fl_reg_idx_2:
                              (tmp_fl_wr_en_1 && id_rb_reg_idx_in_1==tmp_dest_reg_idx_1)? tmp_fl_reg_idx_1: 
                              reg_tag[id_rb_reg_idx_in_1];
  assign rb_reg_ready_out_1 = (cdb_wr_en_now_1 && cdb_wr_idx_1==rb_reg_idx_out_1)? 1'd1:
                              (cdb_wr_en_now_2 && cdb_wr_idx_2==rb_reg_idx_out_1)? 1'd1:
                              (tmp_fl_wr_en_2 & id_rb_reg_idx_in_1==tmp_dest_reg_idx_2)? 1'd0:
                              (tmp_fl_wr_en_1 & id_rb_reg_idx_in_1==tmp_dest_reg_idx_1)? 1'd0: 
                              reg_tag_ready[id_rb_reg_idx_in_1];

  // reg B2 out         
  assign rb_reg_idx_out_2   = (fl_wr_en_1     && id_rb_reg_idx_in_2==id_dest_reg_idx_in_1)? fl_wr_idx_in_1:
                              (tmp_fl_wr_en_2 && id_rb_reg_idx_in_2==tmp_dest_reg_idx_2)? tmp_fl_reg_idx_2:
                              (tmp_fl_wr_en_1 && id_rb_reg_idx_in_2==tmp_dest_reg_idx_1)? tmp_fl_reg_idx_1:                               
                              reg_tag[id_rb_reg_idx_in_2];
  assign rb_reg_ready_out_2 = (cdb_wr_en_now_1 && cdb_wr_idx_1==rb_reg_idx_out_2)? 1'd1:
                              (cdb_wr_en_now_2 && cdb_wr_idx_2==rb_reg_idx_out_2)? 1'd1:
                              (fl_wr_en_1     & id_rb_reg_idx_in_2==id_dest_reg_idx_in_1)? 1'd0:
                              (tmp_fl_wr_en_2 & id_rb_reg_idx_in_2==tmp_dest_reg_idx_2)? 1'd0:
                              (tmp_fl_wr_en_1 & id_rb_reg_idx_in_2==tmp_dest_reg_idx_1)? 1'd0: 
                              reg_tag_ready[id_rb_reg_idx_in_2];

  // reg dest Told
  assign mt_dest_reg_old_1 = (!fl_wr_en_1)? `ZERO_REG:
                             (tmp_fl_wr_en_2 && tmp_dest_reg_idx_2==id_dest_reg_idx_in_1)? tmp_fl_reg_idx_2:
                             (tmp_fl_wr_en_1 && tmp_dest_reg_idx_1==id_dest_reg_idx_in_1)? tmp_fl_reg_idx_1:
                             reg_tag[id_dest_reg_idx_in_1];


  assign mt_dest_reg_old_2 = (!fl_wr_en_2)? `ZERO_REG:
                             (fl_wr_en_1 && id_dest_reg_idx_in_1==id_dest_reg_idx_in_2)?   fl_wr_idx_in_1:
                             (tmp_fl_wr_en_2 && tmp_dest_reg_idx_2==id_dest_reg_idx_in_2)? tmp_fl_reg_idx_2:
                             (tmp_fl_wr_en_1 && tmp_dest_reg_idx_1==id_dest_reg_idx_in_2)? tmp_fl_reg_idx_1:
                             reg_tag[id_dest_reg_idx_in_2];

  // write into temp 
  always @*
  begin
    if(fl_wr_en_1 && fl_wr_en_2 && id_dest_reg_idx_in_1==id_dest_reg_idx_in_2) begin
      next_tmp_dest_reg_idx_1   = id_dest_reg_idx_in_2;
      next_tmp_fl_reg_idx_1     = fl_wr_idx_in_2;
      next_tmp_fl_wr_en_1       = fl_wr_en_2;
      next_tmp_dest_reg_idx_2   = 5'd31;
      next_tmp_fl_reg_idx_2     = `ZERO_REG;
      next_tmp_fl_wr_en_2       = 0;
    end
    else begin
      next_tmp_dest_reg_idx_1   = id_dest_reg_idx_in_1;
      next_tmp_fl_reg_idx_1     = fl_wr_idx_in_1;
      next_tmp_fl_wr_en_1       = fl_wr_en_1;
      next_tmp_dest_reg_idx_2   = id_dest_reg_idx_in_2;
      next_tmp_fl_reg_idx_2     = fl_wr_idx_in_2;
      next_tmp_fl_wr_en_2       = fl_wr_en_2;
    end
  end

  // Branch 1
  always @*
  begin
    br_tmp_1[0]          =  reg_tag[0];
    br_tmp_1[1]          =  reg_tag[1];
    br_tmp_1[2]          =  reg_tag[2];
    br_tmp_1[3]          =  reg_tag[3];
    br_tmp_1[4]          =  reg_tag[4];
    br_tmp_1[5]          =  reg_tag[5];
    br_tmp_1[6]          =  reg_tag[6];
    br_tmp_1[7]          =  reg_tag[7];
    br_tmp_1[8]          =  reg_tag[8];
    br_tmp_1[9]          =  reg_tag[9];
    br_tmp_1[10]         =  reg_tag[10];
    br_tmp_1[11]         =  reg_tag[11];
    br_tmp_1[12]         =  reg_tag[12];
    br_tmp_1[13]         =  reg_tag[13];
    br_tmp_1[14]         =  reg_tag[14];
    br_tmp_1[15]         =  reg_tag[15];
    br_tmp_1[16]         =  reg_tag[16];
    br_tmp_1[17]         =  reg_tag[17];
    br_tmp_1[18]         =  reg_tag[18];
    br_tmp_1[19]         =  reg_tag[19];
    br_tmp_1[20]         =  reg_tag[20];
    br_tmp_1[21]         =  reg_tag[21];
    br_tmp_1[22]         =  reg_tag[22];
    br_tmp_1[23]         =  reg_tag[23];
    br_tmp_1[24]         =  reg_tag[24];
    br_tmp_1[25]         =  reg_tag[25];
    br_tmp_1[26]         =  reg_tag[26];
    br_tmp_1[27]         =  reg_tag[27];
    br_tmp_1[28]         =  reg_tag[28];
    br_tmp_1[29]         =  reg_tag[29];
    br_tmp_1[30]         =  reg_tag[30];
    br_tmp_ready_1[0]    =  reg_tag_ready[0];
    br_tmp_ready_1[1]    =  reg_tag_ready[1];
    br_tmp_ready_1[2]    =  reg_tag_ready[2];
    br_tmp_ready_1[3]    =  reg_tag_ready[3];
    br_tmp_ready_1[4]    =  reg_tag_ready[4];
    br_tmp_ready_1[5]    =  reg_tag_ready[5];
    br_tmp_ready_1[6]    =  reg_tag_ready[6];
    br_tmp_ready_1[7]    =  reg_tag_ready[7];
    br_tmp_ready_1[8]    =  reg_tag_ready[8];
    br_tmp_ready_1[9]    =  reg_tag_ready[9];
    br_tmp_ready_1[10]   =  reg_tag_ready[10];
    br_tmp_ready_1[11]   =  reg_tag_ready[11];
    br_tmp_ready_1[12]   =  reg_tag_ready[12];
    br_tmp_ready_1[13]   =  reg_tag_ready[13];
    br_tmp_ready_1[14]   =  reg_tag_ready[14];
    br_tmp_ready_1[15]   =  reg_tag_ready[15];
    br_tmp_ready_1[16]   =  reg_tag_ready[16];
    br_tmp_ready_1[17]   =  reg_tag_ready[17];
    br_tmp_ready_1[18]   =  reg_tag_ready[18];
    br_tmp_ready_1[19]   =  reg_tag_ready[19];
    br_tmp_ready_1[20]   =  reg_tag_ready[20];
    br_tmp_ready_1[21]   =  reg_tag_ready[21];
    br_tmp_ready_1[22]   =  reg_tag_ready[22];
    br_tmp_ready_1[23]   =  reg_tag_ready[23];
    br_tmp_ready_1[24]   =  reg_tag_ready[24];
    br_tmp_ready_1[25]   =  reg_tag_ready[25];
    br_tmp_ready_1[26]   =  reg_tag_ready[26];
    br_tmp_ready_1[27]   =  reg_tag_ready[27];
    br_tmp_ready_1[28]   =  reg_tag_ready[28];
    br_tmp_ready_1[29]   =  reg_tag_ready[29];
    br_tmp_ready_1[30]   =  reg_tag_ready[30];
    // last and this iteration write in
    if((tmp_fl_wr_en_1 && tmp_dest_reg_idx_1!=`ZERO_REG) && fl_wr_en_1 && (id_dest_reg_idx_in_1==tmp_dest_reg_idx_1)) begin
      if(tmp_fl_wr_en_2 && tmp_dest_reg_idx_2!=`ZERO_REG) begin
        br_tmp_1[tmp_dest_reg_idx_2]               =  tmp_fl_reg_idx_2;
        br_tmp_ready_1[tmp_dest_reg_idx_2]         =  1'd0;
      end
      br_tmp_1[id_dest_reg_idx_in_1]               =  fl_wr_idx_in_1;
      br_tmp_ready_1[id_dest_reg_idx_in_1]         =  1'd0;
    end
    else if((tmp_fl_wr_en_2 && tmp_dest_reg_idx_2!=`ZERO_REG) && fl_wr_en_1 && (id_dest_reg_idx_in_1==tmp_dest_reg_idx_2)) begin
      if(tmp_fl_wr_en_1 && tmp_dest_reg_idx_1!=`ZERO_REG) begin
        br_tmp_1[tmp_dest_reg_idx_1]               =  tmp_fl_reg_idx_1;
        br_tmp_ready_1[tmp_dest_reg_idx_1]         =  1'd0;
      end
      br_tmp_1[id_dest_reg_idx_in_1]               =  fl_wr_idx_in_1;
      br_tmp_ready_1[id_dest_reg_idx_in_1]         =  1'd0;
    end
    else begin
      if(tmp_fl_wr_en_1 && tmp_dest_reg_idx_1!=`ZERO_REG) begin
        br_tmp_1[tmp_dest_reg_idx_1]               =  tmp_fl_reg_idx_1;
        br_tmp_ready_1[tmp_dest_reg_idx_1]         =  1'd0;
      end
      if(tmp_fl_wr_en_2 && tmp_dest_reg_idx_2!=`ZERO_REG) begin
        br_tmp_1[tmp_dest_reg_idx_2]               =  tmp_fl_reg_idx_2;
        br_tmp_ready_1[tmp_dest_reg_idx_2]         =  1'd0;
      end
      if(fl_wr_en_1) begin
        br_tmp_1[id_dest_reg_idx_in_1]             =  fl_wr_idx_in_1;
        br_tmp_ready_1[id_dest_reg_idx_in_1]       =  1'd0;
      end
    end
    // CDB
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[0])       br_tmp_ready_1[0]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[0])  br_tmp_ready_1[0]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[1])       br_tmp_ready_1[1]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[1])  br_tmp_ready_1[1]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[2])       br_tmp_ready_1[2]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[2])  br_tmp_ready_1[2]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[3])       br_tmp_ready_1[3]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[3])  br_tmp_ready_1[3]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[4])       br_tmp_ready_1[4]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[4])  br_tmp_ready_1[4]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[5])       br_tmp_ready_1[5]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[5])  br_tmp_ready_1[5]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[6])       br_tmp_ready_1[6]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[6])  br_tmp_ready_1[6]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[7])       br_tmp_ready_1[7]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[7])  br_tmp_ready_1[7]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[8])       br_tmp_ready_1[8]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[8])  br_tmp_ready_1[8]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[9])       br_tmp_ready_1[9]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[9])  br_tmp_ready_1[9]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[10])      br_tmp_ready_1[10] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[10]) br_tmp_ready_1[10] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[11])      br_tmp_ready_1[11] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[11]) br_tmp_ready_1[11] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[12])      br_tmp_ready_1[12] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[12]) br_tmp_ready_1[12] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[13])      br_tmp_ready_1[13] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[13]) br_tmp_ready_1[13] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[14])      br_tmp_ready_1[14] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[14]) br_tmp_ready_1[14] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[15])      br_tmp_ready_1[15] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[15]) br_tmp_ready_1[15] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[16])      br_tmp_ready_1[16] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[16]) br_tmp_ready_1[16] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[17])      br_tmp_ready_1[17] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[17]) br_tmp_ready_1[17] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[18])      br_tmp_ready_1[18] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[18]) br_tmp_ready_1[18] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[19])      br_tmp_ready_1[19] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[19]) br_tmp_ready_1[19] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[20])      br_tmp_ready_1[20] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[20]) br_tmp_ready_1[20] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[21])      br_tmp_ready_1[21] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[21]) br_tmp_ready_1[21] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[22])      br_tmp_ready_1[22] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[22]) br_tmp_ready_1[22] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[23])      br_tmp_ready_1[23] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[23]) br_tmp_ready_1[23] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[24])      br_tmp_ready_1[24] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[24]) br_tmp_ready_1[24] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[25])      br_tmp_ready_1[25] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[25]) br_tmp_ready_1[25] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[26])      br_tmp_ready_1[26] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[26]) br_tmp_ready_1[26] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[27])      br_tmp_ready_1[27] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[27]) br_tmp_ready_1[27] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[28])      br_tmp_ready_1[28] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[28]) br_tmp_ready_1[28] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[29])      br_tmp_ready_1[29] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[29]) br_tmp_ready_1[29] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_1[30])      br_tmp_ready_1[30] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_1[30]) br_tmp_ready_1[30] = 1'd1;
  end
  // Branch 2
  always @*
  begin
    br_tmp_2[0]          = br_tmp_1[0];
    br_tmp_2[1]          = br_tmp_1[1];
    br_tmp_2[2]          = br_tmp_1[2];
    br_tmp_2[3]          = br_tmp_1[3];
    br_tmp_2[4]          = br_tmp_1[4];
    br_tmp_2[5]          = br_tmp_1[5];
    br_tmp_2[6]          = br_tmp_1[6];
    br_tmp_2[7]          = br_tmp_1[7];
    br_tmp_2[8]          = br_tmp_1[8];
    br_tmp_2[9]          = br_tmp_1[9];
    br_tmp_2[10]         = br_tmp_1[10];
    br_tmp_2[11]         = br_tmp_1[11];
    br_tmp_2[12]         = br_tmp_1[12];
    br_tmp_2[13]         = br_tmp_1[13];
    br_tmp_2[14]         = br_tmp_1[14];
    br_tmp_2[15]         = br_tmp_1[15];
    br_tmp_2[16]         = br_tmp_1[16];
    br_tmp_2[17]         = br_tmp_1[17];
    br_tmp_2[18]         = br_tmp_1[18];
    br_tmp_2[19]         = br_tmp_1[19];
    br_tmp_2[20]         = br_tmp_1[20];
    br_tmp_2[21]         = br_tmp_1[21];
    br_tmp_2[22]         = br_tmp_1[22];
    br_tmp_2[23]         = br_tmp_1[23];
    br_tmp_2[24]         = br_tmp_1[24];
    br_tmp_2[25]         = br_tmp_1[25];
    br_tmp_2[26]         = br_tmp_1[26];
    br_tmp_2[27]         = br_tmp_1[27];
    br_tmp_2[28]         = br_tmp_1[28];
    br_tmp_2[29]         = br_tmp_1[29];
    br_tmp_2[30]         = br_tmp_1[30];
    br_tmp_ready_2[0]    = br_tmp_ready_1[0];
    br_tmp_ready_2[1]    = br_tmp_ready_1[1];
    br_tmp_ready_2[2]    = br_tmp_ready_1[2];
    br_tmp_ready_2[3]    = br_tmp_ready_1[3];
    br_tmp_ready_2[4]    = br_tmp_ready_1[4];
    br_tmp_ready_2[5]    = br_tmp_ready_1[5];
    br_tmp_ready_2[6]    = br_tmp_ready_1[6];
    br_tmp_ready_2[7]    = br_tmp_ready_1[7];
    br_tmp_ready_2[8]    = br_tmp_ready_1[8];
    br_tmp_ready_2[9]    = br_tmp_ready_1[9];
    br_tmp_ready_2[10]   = br_tmp_ready_1[10];
    br_tmp_ready_2[11]   = br_tmp_ready_1[11];
    br_tmp_ready_2[12]   = br_tmp_ready_1[12];
    br_tmp_ready_2[13]   = br_tmp_ready_1[13];
    br_tmp_ready_2[14]   = br_tmp_ready_1[14];
    br_tmp_ready_2[15]   = br_tmp_ready_1[15];
    br_tmp_ready_2[16]   = br_tmp_ready_1[16];
    br_tmp_ready_2[17]   = br_tmp_ready_1[17];
    br_tmp_ready_2[18]   = br_tmp_ready_1[18];
    br_tmp_ready_2[19]   = br_tmp_ready_1[19];
    br_tmp_ready_2[20]   = br_tmp_ready_1[20];
    br_tmp_ready_2[21]   = br_tmp_ready_1[21];
    br_tmp_ready_2[22]   = br_tmp_ready_1[22];
    br_tmp_ready_2[23]   = br_tmp_ready_1[23];
    br_tmp_ready_2[24]   = br_tmp_ready_1[24];
    br_tmp_ready_2[25]   = br_tmp_ready_1[25];
    br_tmp_ready_2[26]   = br_tmp_ready_1[26];
    br_tmp_ready_2[27]   = br_tmp_ready_1[27];
    br_tmp_ready_2[28]   = br_tmp_ready_1[28];
    br_tmp_ready_2[29]   = br_tmp_ready_1[29];
    br_tmp_ready_2[30]   = br_tmp_ready_1[30];
    // last and this iteration write in
    if(fl_wr_en_2 && id_dest_reg_idx_in_2!=`ZERO_REG) begin
      br_tmp_2[id_dest_reg_idx_in_2]       = fl_wr_idx_in_2;
      br_tmp_ready_2[id_dest_reg_idx_in_2] = 1'd0;
    end
    // CDB
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[0])       br_tmp_ready_2[0]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[0])  br_tmp_ready_2[0]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[1])       br_tmp_ready_2[1]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[1])  br_tmp_ready_2[1]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[2])       br_tmp_ready_2[2]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[2])  br_tmp_ready_2[2]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[3])       br_tmp_ready_2[3]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[3])  br_tmp_ready_2[3]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[4])       br_tmp_ready_2[4]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[4])  br_tmp_ready_2[4]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[5])       br_tmp_ready_2[5]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[5])  br_tmp_ready_2[5]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[6])       br_tmp_ready_2[6]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[6])  br_tmp_ready_2[6]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[7])       br_tmp_ready_2[7]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[7])  br_tmp_ready_2[7]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[8])       br_tmp_ready_2[8]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[8])  br_tmp_ready_2[8]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[9])       br_tmp_ready_2[9]  = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[9])  br_tmp_ready_2[9]  = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[10])      br_tmp_ready_2[10] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[10]) br_tmp_ready_2[10] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[11])      br_tmp_ready_2[11] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[11]) br_tmp_ready_2[11] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[12])      br_tmp_ready_2[12] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[12]) br_tmp_ready_2[12] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[13])      br_tmp_ready_2[13] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[13]) br_tmp_ready_2[13] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[14])      br_tmp_ready_2[14] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[14]) br_tmp_ready_2[14] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[15])      br_tmp_ready_2[15] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[15]) br_tmp_ready_2[15] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[16])      br_tmp_ready_2[16] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[16]) br_tmp_ready_2[16] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[17])      br_tmp_ready_2[17] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[17]) br_tmp_ready_2[17] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[18])      br_tmp_ready_2[18] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[18]) br_tmp_ready_2[18] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[19])      br_tmp_ready_2[19] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[19]) br_tmp_ready_2[19] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[20])      br_tmp_ready_2[20] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[20]) br_tmp_ready_2[20] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[21])      br_tmp_ready_2[21] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[21]) br_tmp_ready_2[21] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[22])      br_tmp_ready_2[22] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[22]) br_tmp_ready_2[22] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[23])      br_tmp_ready_2[23] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[23]) br_tmp_ready_2[23] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[24])      br_tmp_ready_2[24] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[24]) br_tmp_ready_2[24] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[25])      br_tmp_ready_2[25] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[25]) br_tmp_ready_2[25] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[26])      br_tmp_ready_2[26] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[26]) br_tmp_ready_2[26] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[27])      br_tmp_ready_2[27] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[27]) br_tmp_ready_2[27] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[28])      br_tmp_ready_2[28] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[28]) br_tmp_ready_2[28] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[29])      br_tmp_ready_2[29] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[29]) br_tmp_ready_2[29] = 1'd1;
    if(cdb_wr_en_1 && cdb_wr_idx_1==br_tmp_2[30])      br_tmp_ready_2[30] = 1'd1;
    else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tmp_2[30]) br_tmp_ready_2[30] = 1'd1;
  end
  // Recovery
  always @*
  begin
     mispredict_tag[0]          = reg_tag[0];
     mispredict_tag[1]          = reg_tag[1];
     mispredict_tag[2]          = reg_tag[2];
     mispredict_tag[3]          = reg_tag[3];
     mispredict_tag[4]          = reg_tag[4];
     mispredict_tag[5]          = reg_tag[5];
     mispredict_tag[6]          = reg_tag[6];
     mispredict_tag[7]          = reg_tag[7];
     mispredict_tag[8]          = reg_tag[8];
     mispredict_tag[9]          = reg_tag[9];
     mispredict_tag[10]         = reg_tag[10];
     mispredict_tag[11]         = reg_tag[11];
     mispredict_tag[12]         = reg_tag[12];
     mispredict_tag[13]         = reg_tag[13];
     mispredict_tag[14]         = reg_tag[14];
     mispredict_tag[15]         = reg_tag[15];
     mispredict_tag[16]         = reg_tag[16];
     mispredict_tag[17]         = reg_tag[17];
     mispredict_tag[18]         = reg_tag[18];
     mispredict_tag[19]         = reg_tag[19];
     mispredict_tag[20]         = reg_tag[20];
     mispredict_tag[21]         = reg_tag[21];
     mispredict_tag[22]         = reg_tag[22];
     mispredict_tag[23]         = reg_tag[23];
     mispredict_tag[24]         = reg_tag[24];
     mispredict_tag[25]         = reg_tag[25];
     mispredict_tag[26]         = reg_tag[26];
     mispredict_tag[27]         = reg_tag[27];
     mispredict_tag[28]         = reg_tag[28];
     mispredict_tag[29]         = reg_tag[29];
     mispredict_tag[30]         = reg_tag[30];
     mispredict_tag[31]         = `ZERO_REG;
     mispredict_tag_ready[0]    = reg_tag_ready[0];
     mispredict_tag_ready[1]    = reg_tag_ready[1];
     mispredict_tag_ready[2]    = reg_tag_ready[2];
     mispredict_tag_ready[3]    = reg_tag_ready[3];
     mispredict_tag_ready[4]    = reg_tag_ready[4];
     mispredict_tag_ready[5]    = reg_tag_ready[5];
     mispredict_tag_ready[6]    = reg_tag_ready[6];
     mispredict_tag_ready[7]    = reg_tag_ready[7];
     mispredict_tag_ready[8]    = reg_tag_ready[8];
     mispredict_tag_ready[9]    = reg_tag_ready[9];
     mispredict_tag_ready[10]   = reg_tag_ready[10];
     mispredict_tag_ready[11]   = reg_tag_ready[11];
     mispredict_tag_ready[12]   = reg_tag_ready[12];
     mispredict_tag_ready[13]   = reg_tag_ready[13];
     mispredict_tag_ready[14]   = reg_tag_ready[14];
     mispredict_tag_ready[15]   = reg_tag_ready[15];
     mispredict_tag_ready[16]   = reg_tag_ready[16];
     mispredict_tag_ready[17]   = reg_tag_ready[17];
     mispredict_tag_ready[18]   = reg_tag_ready[18];
     mispredict_tag_ready[19]   = reg_tag_ready[19];
     mispredict_tag_ready[20]   = reg_tag_ready[20];
     mispredict_tag_ready[21]   = reg_tag_ready[21];
     mispredict_tag_ready[22]   = reg_tag_ready[22];
     mispredict_tag_ready[23]   = reg_tag_ready[23];
     mispredict_tag_ready[24]   = reg_tag_ready[24];
     mispredict_tag_ready[25]   = reg_tag_ready[25];
     mispredict_tag_ready[26]   = reg_tag_ready[26];
     mispredict_tag_ready[27]   = reg_tag_ready[27];
     mispredict_tag_ready[28]   = reg_tag_ready[28];
     mispredict_tag_ready[29]   = reg_tag_ready[29];
     mispredict_tag_ready[30]   = reg_tag_ready[30];
     mispredict_tag_ready[31]   = 1'd1;
     if(br_mispre_marker==3'd0) begin
        mispredict_tag[0]          = br_tag0[0];
        mispredict_tag[1]          = br_tag0[1];
        mispredict_tag[2]          = br_tag0[2];
        mispredict_tag[3]          = br_tag0[3];
        mispredict_tag[4]          = br_tag0[4];
        mispredict_tag[5]          = br_tag0[5];
        mispredict_tag[6]          = br_tag0[6];
        mispredict_tag[7]          = br_tag0[7];
        mispredict_tag[8]          = br_tag0[8];
        mispredict_tag[9]          = br_tag0[9];
        mispredict_tag[10]         = br_tag0[10];
        mispredict_tag[11]         = br_tag0[11];
        mispredict_tag[12]         = br_tag0[12];
        mispredict_tag[13]         = br_tag0[13];
        mispredict_tag[14]         = br_tag0[14];
        mispredict_tag[15]         = br_tag0[15];
        mispredict_tag[16]         = br_tag0[16];
        mispredict_tag[17]         = br_tag0[17];
        mispredict_tag[18]         = br_tag0[18];
        mispredict_tag[19]         = br_tag0[19];
        mispredict_tag[20]         = br_tag0[20];
        mispredict_tag[21]         = br_tag0[21];
        mispredict_tag[22]         = br_tag0[22];
        mispredict_tag[23]         = br_tag0[23];
        mispredict_tag[24]         = br_tag0[24];
        mispredict_tag[25]         = br_tag0[25];
        mispredict_tag[26]         = br_tag0[26];
        mispredict_tag[27]         = br_tag0[27];
        mispredict_tag[28]         = br_tag0[28];
        mispredict_tag[29]         = br_tag0[29];
        mispredict_tag[30]         = br_tag0[30];
        mispredict_tag[31]         = `ZERO_REG;
        mispredict_tag_ready[0]    = br_tag_ready0[0];
        mispredict_tag_ready[1]    = br_tag_ready0[1];
        mispredict_tag_ready[2]    = br_tag_ready0[2];
        mispredict_tag_ready[3]    = br_tag_ready0[3];
        mispredict_tag_ready[4]    = br_tag_ready0[4];
        mispredict_tag_ready[5]    = br_tag_ready0[5];
        mispredict_tag_ready[6]    = br_tag_ready0[6];
        mispredict_tag_ready[7]    = br_tag_ready0[7];
        mispredict_tag_ready[8]    = br_tag_ready0[8];
        mispredict_tag_ready[9]    = br_tag_ready0[9];
        mispredict_tag_ready[10]   = br_tag_ready0[10];
        mispredict_tag_ready[11]   = br_tag_ready0[11];
        mispredict_tag_ready[12]   = br_tag_ready0[12];
        mispredict_tag_ready[13]   = br_tag_ready0[13];
        mispredict_tag_ready[14]   = br_tag_ready0[14];
        mispredict_tag_ready[15]   = br_tag_ready0[15];
        mispredict_tag_ready[16]   = br_tag_ready0[16];
        mispredict_tag_ready[17]   = br_tag_ready0[17];
        mispredict_tag_ready[18]   = br_tag_ready0[18];
        mispredict_tag_ready[19]   = br_tag_ready0[19];
        mispredict_tag_ready[20]   = br_tag_ready0[20];
        mispredict_tag_ready[21]   = br_tag_ready0[21];
        mispredict_tag_ready[22]   = br_tag_ready0[22];
        mispredict_tag_ready[23]   = br_tag_ready0[23];
        mispredict_tag_ready[24]   = br_tag_ready0[24];
        mispredict_tag_ready[25]   = br_tag_ready0[25];
        mispredict_tag_ready[26]   = br_tag_ready0[26];
        mispredict_tag_ready[27]   = br_tag_ready0[27];
        mispredict_tag_ready[28]   = br_tag_ready0[28];
        mispredict_tag_ready[29]   = br_tag_ready0[29];
        mispredict_tag_ready[30]   = br_tag_ready0[30];
        mispredict_tag_ready[31]   = 1'd1;
      end
      else if(br_mispre_marker==3'd1) begin
        mispredict_tag[0]          = br_tag1[0];
        mispredict_tag[1]          = br_tag1[1];
        mispredict_tag[2]          = br_tag1[2];
        mispredict_tag[3]          = br_tag1[3];
        mispredict_tag[4]          = br_tag1[4];
        mispredict_tag[5]          = br_tag1[5];
        mispredict_tag[6]          = br_tag1[6];
        mispredict_tag[7]          = br_tag1[7];
        mispredict_tag[8]          = br_tag1[8];
        mispredict_tag[9]          = br_tag1[9];
        mispredict_tag[10]         = br_tag1[10];
        mispredict_tag[11]         = br_tag1[11];
        mispredict_tag[12]         = br_tag1[12];
        mispredict_tag[13]         = br_tag1[13];
        mispredict_tag[14]         = br_tag1[14];
        mispredict_tag[15]         = br_tag1[15];
        mispredict_tag[16]         = br_tag1[16];
        mispredict_tag[17]         = br_tag1[17];
        mispredict_tag[18]         = br_tag1[18];
        mispredict_tag[19]         = br_tag1[19];
        mispredict_tag[20]         = br_tag1[20];
        mispredict_tag[21]         = br_tag1[21];
        mispredict_tag[22]         = br_tag1[22];
        mispredict_tag[23]         = br_tag1[23];
        mispredict_tag[24]         = br_tag1[24];
        mispredict_tag[25]         = br_tag1[25];
        mispredict_tag[26]         = br_tag1[26];
        mispredict_tag[27]         = br_tag1[27];
        mispredict_tag[28]         = br_tag1[28];
        mispredict_tag[29]         = br_tag1[29];
        mispredict_tag[30]         = br_tag1[30];
        mispredict_tag[31]         = `ZERO_REG;
        mispredict_tag_ready[0]    = br_tag_ready1[0];
        mispredict_tag_ready[1]    = br_tag_ready1[1];
        mispredict_tag_ready[2]    = br_tag_ready1[2];
        mispredict_tag_ready[3]    = br_tag_ready1[3];
        mispredict_tag_ready[4]    = br_tag_ready1[4];
        mispredict_tag_ready[5]    = br_tag_ready1[5];
        mispredict_tag_ready[6]    = br_tag_ready1[6];
        mispredict_tag_ready[7]    = br_tag_ready1[7];
        mispredict_tag_ready[8]    = br_tag_ready1[8];
        mispredict_tag_ready[9]    = br_tag_ready1[9];
        mispredict_tag_ready[10]   = br_tag_ready1[10];
        mispredict_tag_ready[11]   = br_tag_ready1[11];
        mispredict_tag_ready[12]   = br_tag_ready1[12];
        mispredict_tag_ready[13]   = br_tag_ready1[13];
        mispredict_tag_ready[14]   = br_tag_ready1[14];
        mispredict_tag_ready[15]   = br_tag_ready1[15];
        mispredict_tag_ready[16]   = br_tag_ready1[16];
        mispredict_tag_ready[17]   = br_tag_ready1[17];
        mispredict_tag_ready[18]   = br_tag_ready1[18];
        mispredict_tag_ready[19]   = br_tag_ready1[19];
        mispredict_tag_ready[20]   = br_tag_ready1[20];
        mispredict_tag_ready[21]   = br_tag_ready1[21];
        mispredict_tag_ready[22]   = br_tag_ready1[22];
        mispredict_tag_ready[23]   = br_tag_ready1[23];
        mispredict_tag_ready[24]   = br_tag_ready1[24];
        mispredict_tag_ready[25]   = br_tag_ready1[25];
        mispredict_tag_ready[26]   = br_tag_ready1[26];
        mispredict_tag_ready[27]   = br_tag_ready1[27];
        mispredict_tag_ready[28]   = br_tag_ready1[28];
        mispredict_tag_ready[29]   = br_tag_ready1[29];
        mispredict_tag_ready[30]   = br_tag_ready1[30];
        mispredict_tag_ready[31]   = 1'd1;
      end
      else if(br_mispre_marker==3'd2) begin
        mispredict_tag[0]          = br_tag2[0];
        mispredict_tag[1]          = br_tag2[1];
        mispredict_tag[2]          = br_tag2[2];
        mispredict_tag[3]          = br_tag2[3];
        mispredict_tag[4]          = br_tag2[4];
        mispredict_tag[5]          = br_tag2[5];
        mispredict_tag[6]          = br_tag2[6];
        mispredict_tag[7]          = br_tag2[7];
        mispredict_tag[8]          = br_tag2[8];
        mispredict_tag[9]          = br_tag2[9];
        mispredict_tag[10]         = br_tag2[10];
        mispredict_tag[11]         = br_tag2[11];
        mispredict_tag[12]         = br_tag2[12];
        mispredict_tag[13]         = br_tag2[13];
        mispredict_tag[14]         = br_tag2[14];
        mispredict_tag[15]         = br_tag2[15];
        mispredict_tag[16]         = br_tag2[16];
        mispredict_tag[17]         = br_tag2[17];
        mispredict_tag[18]         = br_tag2[18];
        mispredict_tag[19]         = br_tag2[19];
        mispredict_tag[20]         = br_tag2[20];
        mispredict_tag[21]         = br_tag2[21];
        mispredict_tag[22]         = br_tag2[22];
        mispredict_tag[23]         = br_tag2[23];
        mispredict_tag[24]         = br_tag2[24];
        mispredict_tag[25]         = br_tag2[25];
        mispredict_tag[26]         = br_tag2[26];
        mispredict_tag[27]         = br_tag2[27];
        mispredict_tag[28]         = br_tag2[28];
        mispredict_tag[29]         = br_tag2[29];
        mispredict_tag[30]         = br_tag2[30];
        mispredict_tag[31]         = `ZERO_REG;
        mispredict_tag_ready[0]    = br_tag_ready2[0];
        mispredict_tag_ready[1]    = br_tag_ready2[1];
        mispredict_tag_ready[2]    = br_tag_ready2[2];
        mispredict_tag_ready[3]    = br_tag_ready2[3];
        mispredict_tag_ready[4]    = br_tag_ready2[4];
        mispredict_tag_ready[5]    = br_tag_ready2[5];
        mispredict_tag_ready[6]    = br_tag_ready2[6];
        mispredict_tag_ready[7]    = br_tag_ready2[7];
        mispredict_tag_ready[8]    = br_tag_ready2[8];
        mispredict_tag_ready[9]    = br_tag_ready2[9];
        mispredict_tag_ready[10]   = br_tag_ready2[10];
        mispredict_tag_ready[11]   = br_tag_ready2[11];
        mispredict_tag_ready[12]   = br_tag_ready2[12];
        mispredict_tag_ready[13]   = br_tag_ready2[13];
        mispredict_tag_ready[14]   = br_tag_ready2[14];
        mispredict_tag_ready[15]   = br_tag_ready2[15];
        mispredict_tag_ready[16]   = br_tag_ready2[16];
        mispredict_tag_ready[17]   = br_tag_ready2[17];
        mispredict_tag_ready[18]   = br_tag_ready2[18];
        mispredict_tag_ready[19]   = br_tag_ready2[19];
        mispredict_tag_ready[20]   = br_tag_ready2[20];
        mispredict_tag_ready[21]   = br_tag_ready2[21];
        mispredict_tag_ready[22]   = br_tag_ready2[22];
        mispredict_tag_ready[23]   = br_tag_ready2[23];
        mispredict_tag_ready[24]   = br_tag_ready2[24];
        mispredict_tag_ready[25]   = br_tag_ready2[25];
        mispredict_tag_ready[26]   = br_tag_ready2[26];
        mispredict_tag_ready[27]   = br_tag_ready2[27];
        mispredict_tag_ready[28]   = br_tag_ready2[28];
        mispredict_tag_ready[29]   = br_tag_ready2[29];
        mispredict_tag_ready[30]   = br_tag_ready2[30];
        mispredict_tag_ready[31]   = 1'd1;
      end
      else if(br_mispre_marker==3'd3) begin
        mispredict_tag[0]          = br_tag3[0];
        mispredict_tag[1]          = br_tag3[1];
        mispredict_tag[2]          = br_tag3[2];
        mispredict_tag[3]          = br_tag3[3];
        mispredict_tag[4]          = br_tag3[4];
        mispredict_tag[5]          = br_tag3[5];
        mispredict_tag[6]          = br_tag3[6];
        mispredict_tag[7]          = br_tag3[7];
        mispredict_tag[8]          = br_tag3[8];
        mispredict_tag[9]          = br_tag3[9];
        mispredict_tag[10]         = br_tag3[10];
        mispredict_tag[11]         = br_tag3[11];
        mispredict_tag[12]         = br_tag3[12];
        mispredict_tag[13]         = br_tag3[13];
        mispredict_tag[14]         = br_tag3[14];
        mispredict_tag[15]         = br_tag3[15];
        mispredict_tag[16]         = br_tag3[16];
        mispredict_tag[17]         = br_tag3[17];
        mispredict_tag[18]         = br_tag3[18];
        mispredict_tag[19]         = br_tag3[19];
        mispredict_tag[20]         = br_tag3[20];
        mispredict_tag[21]         = br_tag3[21];
        mispredict_tag[22]         = br_tag3[22];
        mispredict_tag[23]         = br_tag3[23];
        mispredict_tag[24]         = br_tag3[24];
        mispredict_tag[25]         = br_tag3[25];
        mispredict_tag[26]         = br_tag3[26];
        mispredict_tag[27]         = br_tag3[27];
        mispredict_tag[28]         = br_tag3[28];
        mispredict_tag[29]         = br_tag3[29];
        mispredict_tag[30]         = br_tag3[30];
        mispredict_tag[31]         = `ZERO_REG;
        mispredict_tag_ready[0]    = br_tag_ready3[0];
        mispredict_tag_ready[1]    = br_tag_ready3[1];
        mispredict_tag_ready[2]    = br_tag_ready3[2];
        mispredict_tag_ready[3]    = br_tag_ready3[3];
        mispredict_tag_ready[4]    = br_tag_ready3[4];
        mispredict_tag_ready[5]    = br_tag_ready3[5];
        mispredict_tag_ready[6]    = br_tag_ready3[6];
        mispredict_tag_ready[7]    = br_tag_ready3[7];
        mispredict_tag_ready[8]    = br_tag_ready3[8];
        mispredict_tag_ready[9]    = br_tag_ready3[9];
        mispredict_tag_ready[10]   = br_tag_ready3[10];
        mispredict_tag_ready[11]   = br_tag_ready3[11];
        mispredict_tag_ready[12]   = br_tag_ready3[12];
        mispredict_tag_ready[13]   = br_tag_ready3[13];
        mispredict_tag_ready[14]   = br_tag_ready3[14];
        mispredict_tag_ready[15]   = br_tag_ready3[15];
        mispredict_tag_ready[16]   = br_tag_ready3[16];
        mispredict_tag_ready[17]   = br_tag_ready3[17];
        mispredict_tag_ready[18]   = br_tag_ready3[18];
        mispredict_tag_ready[19]   = br_tag_ready3[19];
        mispredict_tag_ready[20]   = br_tag_ready3[20];
        mispredict_tag_ready[21]   = br_tag_ready3[21];
        mispredict_tag_ready[22]   = br_tag_ready3[22];
        mispredict_tag_ready[23]   = br_tag_ready3[23];
        mispredict_tag_ready[24]   = br_tag_ready3[24];
        mispredict_tag_ready[25]   = br_tag_ready3[25];
        mispredict_tag_ready[26]   = br_tag_ready3[26];
        mispredict_tag_ready[27]   = br_tag_ready3[27];
        mispredict_tag_ready[28]   = br_tag_ready3[28];
        mispredict_tag_ready[29]   = br_tag_ready3[29];
        mispredict_tag_ready[30]   = br_tag_ready3[30];
        mispredict_tag_ready[31]   = 1'd1;
      end

      // CDB
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[0])       mispredict_tag_ready[0]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[0])  mispredict_tag_ready[0]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[1])       mispredict_tag_ready[1]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[1])  mispredict_tag_ready[1]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[2])       mispredict_tag_ready[2]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[2])  mispredict_tag_ready[2]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[3])       mispredict_tag_ready[3]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[3])  mispredict_tag_ready[3]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[4])       mispredict_tag_ready[4]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[4])  mispredict_tag_ready[4]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[5])       mispredict_tag_ready[5]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[5])  mispredict_tag_ready[5]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[6])       mispredict_tag_ready[6]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[6])  mispredict_tag_ready[6]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[7])       mispredict_tag_ready[7]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[7])  mispredict_tag_ready[7]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[8])       mispredict_tag_ready[8]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[8])  mispredict_tag_ready[8]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[9])       mispredict_tag_ready[9]  = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[9])  mispredict_tag_ready[9]  = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[10])      mispredict_tag_ready[10] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[10]) mispredict_tag_ready[10] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[11])      mispredict_tag_ready[11] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[11]) mispredict_tag_ready[11] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[12])      mispredict_tag_ready[12] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[12]) mispredict_tag_ready[12] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[13])      mispredict_tag_ready[13] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[13]) mispredict_tag_ready[13] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[14])      mispredict_tag_ready[14] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[14]) mispredict_tag_ready[14] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[15])      mispredict_tag_ready[15] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[15]) mispredict_tag_ready[15] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[16])      mispredict_tag_ready[16] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[16]) mispredict_tag_ready[16] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[17])      mispredict_tag_ready[17] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[17]) mispredict_tag_ready[17] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[18])      mispredict_tag_ready[18] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[18]) mispredict_tag_ready[18] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[19])      mispredict_tag_ready[19] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[19]) mispredict_tag_ready[19] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[20])      mispredict_tag_ready[20] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[20]) mispredict_tag_ready[20] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[21])      mispredict_tag_ready[21] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[21]) mispredict_tag_ready[21] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[22])      mispredict_tag_ready[22] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[22]) mispredict_tag_ready[22] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[23])      mispredict_tag_ready[23] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[23]) mispredict_tag_ready[23] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[24])      mispredict_tag_ready[24] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[24]) mispredict_tag_ready[24] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[25])      mispredict_tag_ready[25] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[25]) mispredict_tag_ready[25] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[26])      mispredict_tag_ready[26] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[26]) mispredict_tag_ready[26] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[27])      mispredict_tag_ready[27] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[27]) mispredict_tag_ready[27] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[28])      mispredict_tag_ready[28] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[28]) mispredict_tag_ready[28] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[29])      mispredict_tag_ready[29] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[29]) mispredict_tag_ready[29] = 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[30])      mispredict_tag_ready[30] = 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[30]) mispredict_tag_ready[30] = 1'd1;
    end


  always @(posedge clock) 
  begin
    if(reset) begin
      reg_tag[0]          <= `SD `REG_00;
      reg_tag[1]          <= `SD `REG_01;
      reg_tag[2]          <= `SD `REG_02;
      reg_tag[3]          <= `SD `REG_03;
      reg_tag[4]          <= `SD `REG_04;
      reg_tag[5]          <= `SD `REG_05;
      reg_tag[6]          <= `SD `REG_06;
      reg_tag[7]          <= `SD `REG_07;
      reg_tag[8]          <= `SD `REG_08;
      reg_tag[9]          <= `SD `REG_09;
      reg_tag[10]         <= `SD `REG_10;
      reg_tag[11]         <= `SD `REG_11;
      reg_tag[12]         <= `SD `REG_12;
      reg_tag[13]         <= `SD `REG_13;
      reg_tag[14]         <= `SD `REG_14;
      reg_tag[15]         <= `SD `REG_15;
      reg_tag[16]         <= `SD `REG_16;
      reg_tag[17]         <= `SD `REG_17;
      reg_tag[18]         <= `SD `REG_18;
      reg_tag[19]         <= `SD `REG_19;
      reg_tag[20]         <= `SD `REG_20;
      reg_tag[21]         <= `SD `REG_21;
      reg_tag[22]         <= `SD `REG_22;
      reg_tag[23]         <= `SD `REG_23;
      reg_tag[24]         <= `SD `REG_24;
      reg_tag[25]         <= `SD `REG_25;
      reg_tag[26]         <= `SD `REG_26;
      reg_tag[27]         <= `SD `REG_27;
      reg_tag[28]         <= `SD `REG_28;
      reg_tag[29]         <= `SD `REG_29;
      reg_tag[30]         <= `SD `REG_30;
      reg_tag[31]         <= `SD `ZERO_REG;
      reg_tag_ready[0]    <= `SD 1'd1;
      reg_tag_ready[1]    <= `SD 1'd1;
      reg_tag_ready[2]    <= `SD 1'd1;
      reg_tag_ready[3]    <= `SD 1'd1;
      reg_tag_ready[4]    <= `SD 1'd1;
      reg_tag_ready[5]    <= `SD 1'd1;
      reg_tag_ready[6]    <= `SD 1'd1;
      reg_tag_ready[7]    <= `SD 1'd1;
      reg_tag_ready[8]    <= `SD 1'd1;
      reg_tag_ready[9]    <= `SD 1'd1;
      reg_tag_ready[10]   <= `SD 1'd1;
      reg_tag_ready[11]   <= `SD 1'd1;
      reg_tag_ready[12]   <= `SD 1'd1;
      reg_tag_ready[13]   <= `SD 1'd1;
      reg_tag_ready[14]   <= `SD 1'd1;
      reg_tag_ready[15]   <= `SD 1'd1;
      reg_tag_ready[16]   <= `SD 1'd1;
      reg_tag_ready[17]   <= `SD 1'd1;
      reg_tag_ready[18]   <= `SD 1'd1;
      reg_tag_ready[19]   <= `SD 1'd1;
      reg_tag_ready[20]   <= `SD 1'd1;
      reg_tag_ready[21]   <= `SD 1'd1;
      reg_tag_ready[22]   <= `SD 1'd1;
      reg_tag_ready[23]   <= `SD 1'd1;
      reg_tag_ready[24]   <= `SD 1'd1;
      reg_tag_ready[25]   <= `SD 1'd1;
      reg_tag_ready[26]   <= `SD 1'd1;
      reg_tag_ready[27]   <= `SD 1'd1;
      reg_tag_ready[28]   <= `SD 1'd1;
      reg_tag_ready[29]   <= `SD 1'd1;
      reg_tag_ready[30]   <= `SD 1'd1;
      reg_tag_ready[31]   <= `SD 1'd1;
      tmp_dest_reg_idx_1  <= `SD 5'd31;
      tmp_dest_reg_idx_2  <= `SD 5'd31;
      tmp_fl_reg_idx_1    <= `SD 6'd31;
      tmp_fl_reg_idx_2    <= `SD 6'd31;
      tmp_fl_wr_en_1      <= `SD 1'd0;
      tmp_fl_wr_en_2      <= `SD 1'd0;
    end
    else if(br_mispredict) begin
      reg_tag[0]          <= `SD mispredict_tag[0];
      reg_tag[1]          <= `SD mispredict_tag[1];
      reg_tag[2]          <= `SD mispredict_tag[2];
      reg_tag[3]          <= `SD mispredict_tag[3];
      reg_tag[4]          <= `SD mispredict_tag[4];
      reg_tag[5]          <= `SD mispredict_tag[5];
      reg_tag[6]          <= `SD mispredict_tag[6];
      reg_tag[7]          <= `SD mispredict_tag[7];
      reg_tag[8]          <= `SD mispredict_tag[8];
      reg_tag[9]          <= `SD mispredict_tag[9];
      reg_tag[10]         <= `SD mispredict_tag[10];
      reg_tag[11]         <= `SD mispredict_tag[11];
      reg_tag[12]         <= `SD mispredict_tag[12];
      reg_tag[13]         <= `SD mispredict_tag[13];
      reg_tag[14]         <= `SD mispredict_tag[14];
      reg_tag[15]         <= `SD mispredict_tag[15];
      reg_tag[16]         <= `SD mispredict_tag[16];
      reg_tag[17]         <= `SD mispredict_tag[17];
      reg_tag[18]         <= `SD mispredict_tag[18];
      reg_tag[19]         <= `SD mispredict_tag[19];
      reg_tag[20]         <= `SD mispredict_tag[20];
      reg_tag[21]         <= `SD mispredict_tag[21];
      reg_tag[22]         <= `SD mispredict_tag[22];
      reg_tag[23]         <= `SD mispredict_tag[23];
      reg_tag[24]         <= `SD mispredict_tag[24];
      reg_tag[25]         <= `SD mispredict_tag[25];
      reg_tag[26]         <= `SD mispredict_tag[26];
      reg_tag[27]         <= `SD mispredict_tag[27];
      reg_tag[28]         <= `SD mispredict_tag[28];
      reg_tag[29]         <= `SD mispredict_tag[29];
      reg_tag[30]         <= `SD mispredict_tag[30];
      reg_tag[31]         <= `SD `ZERO_REG;
      reg_tag_ready[0]    <= `SD mispredict_tag_ready[0];
      reg_tag_ready[1]    <= `SD mispredict_tag_ready[1];
      reg_tag_ready[2]    <= `SD mispredict_tag_ready[2];
      reg_tag_ready[3]    <= `SD mispredict_tag_ready[3];
      reg_tag_ready[4]    <= `SD mispredict_tag_ready[4];
      reg_tag_ready[5]    <= `SD mispredict_tag_ready[5];
      reg_tag_ready[6]    <= `SD mispredict_tag_ready[6];
      reg_tag_ready[7]    <= `SD mispredict_tag_ready[7];
      reg_tag_ready[8]    <= `SD mispredict_tag_ready[8];
      reg_tag_ready[9]    <= `SD mispredict_tag_ready[9];
      reg_tag_ready[10]   <= `SD mispredict_tag_ready[10];
      reg_tag_ready[11]   <= `SD mispredict_tag_ready[11];
      reg_tag_ready[12]   <= `SD mispredict_tag_ready[12];
      reg_tag_ready[13]   <= `SD mispredict_tag_ready[13];
      reg_tag_ready[14]   <= `SD mispredict_tag_ready[14];
      reg_tag_ready[15]   <= `SD mispredict_tag_ready[15];
      reg_tag_ready[16]   <= `SD mispredict_tag_ready[16];
      reg_tag_ready[17]   <= `SD mispredict_tag_ready[17];
      reg_tag_ready[18]   <= `SD mispredict_tag_ready[18];
      reg_tag_ready[19]   <= `SD mispredict_tag_ready[19];
      reg_tag_ready[20]   <= `SD mispredict_tag_ready[20];
      reg_tag_ready[21]   <= `SD mispredict_tag_ready[21];
      reg_tag_ready[22]   <= `SD mispredict_tag_ready[22];
      reg_tag_ready[23]   <= `SD mispredict_tag_ready[23];
      reg_tag_ready[24]   <= `SD mispredict_tag_ready[24];
      reg_tag_ready[25]   <= `SD mispredict_tag_ready[25];
      reg_tag_ready[26]   <= `SD mispredict_tag_ready[26];
      reg_tag_ready[27]   <= `SD mispredict_tag_ready[27];
      reg_tag_ready[28]   <= `SD mispredict_tag_ready[28];
      reg_tag_ready[29]   <= `SD mispredict_tag_ready[29];
      reg_tag_ready[30]   <= `SD mispredict_tag_ready[30];
      reg_tag_ready[31]   <= `SD 1;
      // write into temp 
      tmp_dest_reg_idx_1   <= `SD next_tmp_dest_reg_idx_1;
      tmp_fl_reg_idx_1     <= `SD next_tmp_fl_reg_idx_1;
      tmp_fl_wr_en_1       <= `SD next_tmp_fl_wr_en_1;
      tmp_dest_reg_idx_2   <= `SD next_tmp_dest_reg_idx_2;
      tmp_fl_reg_idx_2     <= `SD next_tmp_fl_reg_idx_2;
      tmp_fl_wr_en_2       <= `SD next_tmp_fl_wr_en_2;
    end
    else begin
      // Write into maptable
      if((tmp_fl_wr_en_1 && tmp_dest_reg_idx_1!=`ZERO_REG) & (tmp_fl_wr_en_2 && tmp_dest_reg_idx_2!=`ZERO_REG)) begin
        reg_tag[tmp_dest_reg_idx_1]         <= `SD tmp_fl_reg_idx_1;
        reg_tag_ready[tmp_dest_reg_idx_1]   <= `SD 1'd0;
        reg_tag[tmp_dest_reg_idx_2]         <= `SD tmp_fl_reg_idx_2;
        reg_tag_ready[tmp_dest_reg_idx_2]   <= `SD 1'd0;
      end
      else if(tmp_fl_wr_en_1 && tmp_dest_reg_idx_1!=`ZERO_REG) begin
        reg_tag[tmp_dest_reg_idx_1]         <= `SD tmp_fl_reg_idx_1;
        reg_tag_ready[tmp_dest_reg_idx_1]   <= `SD 1'd0;
      end
      else if(tmp_fl_wr_en_2 && tmp_dest_reg_idx_2!=`ZERO_REG) begin
        reg_tag[tmp_dest_reg_idx_2]         <= `SD tmp_fl_reg_idx_2;
        reg_tag_ready[tmp_dest_reg_idx_2]   <= `SD 1'd0;
      end

      // write into temp 
      tmp_dest_reg_idx_1   <= `SD next_tmp_dest_reg_idx_1;
      tmp_fl_reg_idx_1     <= `SD next_tmp_fl_reg_idx_1;
      tmp_fl_wr_en_1       <= `SD next_tmp_fl_wr_en_1;
      tmp_dest_reg_idx_2   <= `SD next_tmp_dest_reg_idx_2;
      tmp_fl_reg_idx_2     <= `SD next_tmp_fl_reg_idx_2;
      tmp_fl_wr_en_2       <= `SD next_tmp_fl_wr_en_2;

      // Branch 1
      if(br_wr_en_1) begin
        if(br_marker_in_1==3'd0) begin
          br_tag0[0]          <= `SD br_tmp_1[0];
          br_tag0[1]          <= `SD br_tmp_1[1];
          br_tag0[2]          <= `SD br_tmp_1[2];
          br_tag0[3]          <= `SD br_tmp_1[3];
          br_tag0[4]          <= `SD br_tmp_1[4];
          br_tag0[5]          <= `SD br_tmp_1[5];
          br_tag0[6]          <= `SD br_tmp_1[6];
          br_tag0[7]          <= `SD br_tmp_1[7];
          br_tag0[8]          <= `SD br_tmp_1[8];
          br_tag0[9]          <= `SD br_tmp_1[9];
          br_tag0[10]         <= `SD br_tmp_1[10];
          br_tag0[11]         <= `SD br_tmp_1[11];
          br_tag0[12]         <= `SD br_tmp_1[12];
          br_tag0[13]         <= `SD br_tmp_1[13];
          br_tag0[14]         <= `SD br_tmp_1[14];
          br_tag0[15]         <= `SD br_tmp_1[15];
          br_tag0[16]         <= `SD br_tmp_1[16];
          br_tag0[17]         <= `SD br_tmp_1[17];
          br_tag0[18]         <= `SD br_tmp_1[18];
          br_tag0[19]         <= `SD br_tmp_1[19];
          br_tag0[20]         <= `SD br_tmp_1[20];
          br_tag0[21]         <= `SD br_tmp_1[21];
          br_tag0[22]         <= `SD br_tmp_1[22];
          br_tag0[23]         <= `SD br_tmp_1[23];
          br_tag0[24]         <= `SD br_tmp_1[24];
          br_tag0[25]         <= `SD br_tmp_1[25];
          br_tag0[26]         <= `SD br_tmp_1[26];
          br_tag0[27]         <= `SD br_tmp_1[27];
          br_tag0[28]         <= `SD br_tmp_1[28];
          br_tag0[29]         <= `SD br_tmp_1[29];
          br_tag0[30]         <= `SD br_tmp_1[30];
          br_tag_ready0[0]    <= `SD br_tmp_ready_1[0];
          br_tag_ready0[1]    <= `SD br_tmp_ready_1[1];
          br_tag_ready0[2]    <= `SD br_tmp_ready_1[2];
          br_tag_ready0[3]    <= `SD br_tmp_ready_1[3];
          br_tag_ready0[4]    <= `SD br_tmp_ready_1[4];
          br_tag_ready0[5]    <= `SD br_tmp_ready_1[5];
          br_tag_ready0[6]    <= `SD br_tmp_ready_1[6];
          br_tag_ready0[7]    <= `SD br_tmp_ready_1[7];
          br_tag_ready0[8]    <= `SD br_tmp_ready_1[8];
          br_tag_ready0[9]    <= `SD br_tmp_ready_1[9];
          br_tag_ready0[10]   <= `SD br_tmp_ready_1[10];
          br_tag_ready0[11]   <= `SD br_tmp_ready_1[11];
          br_tag_ready0[12]   <= `SD br_tmp_ready_1[12];
          br_tag_ready0[13]   <= `SD br_tmp_ready_1[13];
          br_tag_ready0[14]   <= `SD br_tmp_ready_1[14];
          br_tag_ready0[15]   <= `SD br_tmp_ready_1[15];
          br_tag_ready0[16]   <= `SD br_tmp_ready_1[16];
          br_tag_ready0[17]   <= `SD br_tmp_ready_1[17];
          br_tag_ready0[18]   <= `SD br_tmp_ready_1[18];
          br_tag_ready0[19]   <= `SD br_tmp_ready_1[19];
          br_tag_ready0[20]   <= `SD br_tmp_ready_1[20];
          br_tag_ready0[21]   <= `SD br_tmp_ready_1[21];
          br_tag_ready0[22]   <= `SD br_tmp_ready_1[22];
          br_tag_ready0[23]   <= `SD br_tmp_ready_1[23];
          br_tag_ready0[24]   <= `SD br_tmp_ready_1[24];
          br_tag_ready0[25]   <= `SD br_tmp_ready_1[25];
          br_tag_ready0[26]   <= `SD br_tmp_ready_1[26];
          br_tag_ready0[27]   <= `SD br_tmp_ready_1[27];
          br_tag_ready0[28]   <= `SD br_tmp_ready_1[28];
          br_tag_ready0[29]   <= `SD br_tmp_ready_1[29];
          br_tag_ready0[30]   <= `SD br_tmp_ready_1[30];
        end
        else if(br_marker_in_1==3'd1) begin
          br_tag1[0]          <= `SD br_tmp_1[0];
          br_tag1[1]          <= `SD br_tmp_1[1];
          br_tag1[2]          <= `SD br_tmp_1[2];
          br_tag1[3]          <= `SD br_tmp_1[3];
          br_tag1[4]          <= `SD br_tmp_1[4];
          br_tag1[5]          <= `SD br_tmp_1[5];
          br_tag1[6]          <= `SD br_tmp_1[6];
          br_tag1[7]          <= `SD br_tmp_1[7];
          br_tag1[8]          <= `SD br_tmp_1[8];
          br_tag1[9]          <= `SD br_tmp_1[9];
          br_tag1[10]         <= `SD br_tmp_1[10];
          br_tag1[11]         <= `SD br_tmp_1[11];
          br_tag1[12]         <= `SD br_tmp_1[12];
          br_tag1[13]         <= `SD br_tmp_1[13];
          br_tag1[14]         <= `SD br_tmp_1[14];
          br_tag1[15]         <= `SD br_tmp_1[15];
          br_tag1[16]         <= `SD br_tmp_1[16];
          br_tag1[17]         <= `SD br_tmp_1[17];
          br_tag1[18]         <= `SD br_tmp_1[18];
          br_tag1[19]         <= `SD br_tmp_1[19];
          br_tag1[20]         <= `SD br_tmp_1[20];
          br_tag1[21]         <= `SD br_tmp_1[21];
          br_tag1[22]         <= `SD br_tmp_1[22];
          br_tag1[23]         <= `SD br_tmp_1[23];
          br_tag1[24]         <= `SD br_tmp_1[24];
          br_tag1[25]         <= `SD br_tmp_1[25];
          br_tag1[26]         <= `SD br_tmp_1[26];
          br_tag1[27]         <= `SD br_tmp_1[27];
          br_tag1[28]         <= `SD br_tmp_1[28];
          br_tag1[29]         <= `SD br_tmp_1[29];
          br_tag1[30]         <= `SD br_tmp_1[30];
          br_tag_ready1[0]    <= `SD br_tmp_ready_1[0];
          br_tag_ready1[1]    <= `SD br_tmp_ready_1[1];
          br_tag_ready1[2]    <= `SD br_tmp_ready_1[2];
          br_tag_ready1[3]    <= `SD br_tmp_ready_1[3];
          br_tag_ready1[4]    <= `SD br_tmp_ready_1[4];
          br_tag_ready1[5]    <= `SD br_tmp_ready_1[5];
          br_tag_ready1[6]    <= `SD br_tmp_ready_1[6];
          br_tag_ready1[7]    <= `SD br_tmp_ready_1[7];
          br_tag_ready1[8]    <= `SD br_tmp_ready_1[8];
          br_tag_ready1[9]    <= `SD br_tmp_ready_1[9];
          br_tag_ready1[10]   <= `SD br_tmp_ready_1[10];
          br_tag_ready1[11]   <= `SD br_tmp_ready_1[11];
          br_tag_ready1[12]   <= `SD br_tmp_ready_1[12];
          br_tag_ready1[13]   <= `SD br_tmp_ready_1[13];
          br_tag_ready1[14]   <= `SD br_tmp_ready_1[14];
          br_tag_ready1[15]   <= `SD br_tmp_ready_1[15];
          br_tag_ready1[16]   <= `SD br_tmp_ready_1[16];
          br_tag_ready1[17]   <= `SD br_tmp_ready_1[17];
          br_tag_ready1[18]   <= `SD br_tmp_ready_1[18];
          br_tag_ready1[19]   <= `SD br_tmp_ready_1[19];
          br_tag_ready1[20]   <= `SD br_tmp_ready_1[20];
          br_tag_ready1[21]   <= `SD br_tmp_ready_1[21];
          br_tag_ready1[22]   <= `SD br_tmp_ready_1[22];
          br_tag_ready1[23]   <= `SD br_tmp_ready_1[23];
          br_tag_ready1[24]   <= `SD br_tmp_ready_1[24];
          br_tag_ready1[25]   <= `SD br_tmp_ready_1[25];
          br_tag_ready1[26]   <= `SD br_tmp_ready_1[26];
          br_tag_ready1[27]   <= `SD br_tmp_ready_1[27];
          br_tag_ready1[28]   <= `SD br_tmp_ready_1[28];
          br_tag_ready1[29]   <= `SD br_tmp_ready_1[29];
          br_tag_ready1[30]   <= `SD br_tmp_ready_1[30];
        end
        else if(br_marker_in_1==3'd2) begin
          br_tag2[0]          <= `SD br_tmp_1[0];
          br_tag2[1]          <= `SD br_tmp_1[1];
          br_tag2[2]          <= `SD br_tmp_1[2];
          br_tag2[3]          <= `SD br_tmp_1[3];
          br_tag2[4]          <= `SD br_tmp_1[4];
          br_tag2[5]          <= `SD br_tmp_1[5];
          br_tag2[6]          <= `SD br_tmp_1[6];
          br_tag2[7]          <= `SD br_tmp_1[7];
          br_tag2[8]          <= `SD br_tmp_1[8];
          br_tag2[9]          <= `SD br_tmp_1[9];
          br_tag2[10]         <= `SD br_tmp_1[10];
          br_tag2[11]         <= `SD br_tmp_1[11];
          br_tag2[12]         <= `SD br_tmp_1[12];
          br_tag2[13]         <= `SD br_tmp_1[13];
          br_tag2[14]         <= `SD br_tmp_1[14];
          br_tag2[15]         <= `SD br_tmp_1[15];
          br_tag2[16]         <= `SD br_tmp_1[16];
          br_tag2[17]         <= `SD br_tmp_1[17];
          br_tag2[18]         <= `SD br_tmp_1[18];
          br_tag2[19]         <= `SD br_tmp_1[19];
          br_tag2[20]         <= `SD br_tmp_1[20];
          br_tag2[21]         <= `SD br_tmp_1[21];
          br_tag2[22]         <= `SD br_tmp_1[22];
          br_tag2[23]         <= `SD br_tmp_1[23];
          br_tag2[24]         <= `SD br_tmp_1[24];
          br_tag2[25]         <= `SD br_tmp_1[25];
          br_tag2[26]         <= `SD br_tmp_1[26];
          br_tag2[27]         <= `SD br_tmp_1[27];
          br_tag2[28]         <= `SD br_tmp_1[28];
          br_tag2[29]         <= `SD br_tmp_1[29];
          br_tag2[30]         <= `SD br_tmp_1[30];
          br_tag_ready2[0]    <= `SD br_tmp_ready_1[0];
          br_tag_ready2[1]    <= `SD br_tmp_ready_1[1];
          br_tag_ready2[2]    <= `SD br_tmp_ready_1[2];
          br_tag_ready2[3]    <= `SD br_tmp_ready_1[3];
          br_tag_ready2[4]    <= `SD br_tmp_ready_1[4];
          br_tag_ready2[5]    <= `SD br_tmp_ready_1[5];
          br_tag_ready2[6]    <= `SD br_tmp_ready_1[6];
          br_tag_ready2[7]    <= `SD br_tmp_ready_1[7];
          br_tag_ready2[8]    <= `SD br_tmp_ready_1[8];
          br_tag_ready2[9]    <= `SD br_tmp_ready_1[9];
          br_tag_ready2[10]   <= `SD br_tmp_ready_1[10];
          br_tag_ready2[11]   <= `SD br_tmp_ready_1[11];
          br_tag_ready2[12]   <= `SD br_tmp_ready_1[12];
          br_tag_ready2[13]   <= `SD br_tmp_ready_1[13];
          br_tag_ready2[14]   <= `SD br_tmp_ready_1[14];
          br_tag_ready2[15]   <= `SD br_tmp_ready_1[15];
          br_tag_ready2[16]   <= `SD br_tmp_ready_1[16];
          br_tag_ready2[17]   <= `SD br_tmp_ready_1[17];
          br_tag_ready2[18]   <= `SD br_tmp_ready_1[18];
          br_tag_ready2[19]   <= `SD br_tmp_ready_1[19];
          br_tag_ready2[20]   <= `SD br_tmp_ready_1[20];
          br_tag_ready2[21]   <= `SD br_tmp_ready_1[21];
          br_tag_ready2[22]   <= `SD br_tmp_ready_1[22];
          br_tag_ready2[23]   <= `SD br_tmp_ready_1[23];
          br_tag_ready2[24]   <= `SD br_tmp_ready_1[24];
          br_tag_ready2[25]   <= `SD br_tmp_ready_1[25];
          br_tag_ready2[26]   <= `SD br_tmp_ready_1[26];
          br_tag_ready2[27]   <= `SD br_tmp_ready_1[27];
          br_tag_ready2[28]   <= `SD br_tmp_ready_1[28];
          br_tag_ready2[29]   <= `SD br_tmp_ready_1[29];
          br_tag_ready2[30]   <= `SD br_tmp_ready_1[30];
        end
        else if(br_marker_in_1==3'd3) begin
          br_tag3[0]          <= `SD br_tmp_1[0];
          br_tag3[1]          <= `SD br_tmp_1[1];
          br_tag3[2]          <= `SD br_tmp_1[2];
          br_tag3[3]          <= `SD br_tmp_1[3];
          br_tag3[4]          <= `SD br_tmp_1[4];
          br_tag3[5]          <= `SD br_tmp_1[5];
          br_tag3[6]          <= `SD br_tmp_1[6];
          br_tag3[7]          <= `SD br_tmp_1[7];
          br_tag3[8]          <= `SD br_tmp_1[8];
          br_tag3[9]          <= `SD br_tmp_1[9];
          br_tag3[10]         <= `SD br_tmp_1[10];
          br_tag3[11]         <= `SD br_tmp_1[11];
          br_tag3[12]         <= `SD br_tmp_1[12];
          br_tag3[13]         <= `SD br_tmp_1[13];
          br_tag3[14]         <= `SD br_tmp_1[14];
          br_tag3[15]         <= `SD br_tmp_1[15];
          br_tag3[16]         <= `SD br_tmp_1[16];
          br_tag3[17]         <= `SD br_tmp_1[17];
          br_tag3[18]         <= `SD br_tmp_1[18];
          br_tag3[19]         <= `SD br_tmp_1[19];
          br_tag3[20]         <= `SD br_tmp_1[20];
          br_tag3[21]         <= `SD br_tmp_1[21];
          br_tag3[22]         <= `SD br_tmp_1[22];
          br_tag3[23]         <= `SD br_tmp_1[23];
          br_tag3[24]         <= `SD br_tmp_1[24];
          br_tag3[25]         <= `SD br_tmp_1[25];
          br_tag3[26]         <= `SD br_tmp_1[26];
          br_tag3[27]         <= `SD br_tmp_1[27];
          br_tag3[28]         <= `SD br_tmp_1[28];
          br_tag3[29]         <= `SD br_tmp_1[29];
          br_tag3[30]         <= `SD br_tmp_1[30];
          br_tag_ready3[0]    <= `SD br_tmp_ready_1[0];
          br_tag_ready3[1]    <= `SD br_tmp_ready_1[1];
          br_tag_ready3[2]    <= `SD br_tmp_ready_1[2];
          br_tag_ready3[3]    <= `SD br_tmp_ready_1[3];
          br_tag_ready3[4]    <= `SD br_tmp_ready_1[4];
          br_tag_ready3[5]    <= `SD br_tmp_ready_1[5];
          br_tag_ready3[6]    <= `SD br_tmp_ready_1[6];
          br_tag_ready3[7]    <= `SD br_tmp_ready_1[7];
          br_tag_ready3[8]    <= `SD br_tmp_ready_1[8];
          br_tag_ready3[9]    <= `SD br_tmp_ready_1[9];
          br_tag_ready3[10]   <= `SD br_tmp_ready_1[10];
          br_tag_ready3[11]   <= `SD br_tmp_ready_1[11];
          br_tag_ready3[12]   <= `SD br_tmp_ready_1[12];
          br_tag_ready3[13]   <= `SD br_tmp_ready_1[13];
          br_tag_ready3[14]   <= `SD br_tmp_ready_1[14];
          br_tag_ready3[15]   <= `SD br_tmp_ready_1[15];
          br_tag_ready3[16]   <= `SD br_tmp_ready_1[16];
          br_tag_ready3[17]   <= `SD br_tmp_ready_1[17];
          br_tag_ready3[18]   <= `SD br_tmp_ready_1[18];
          br_tag_ready3[19]   <= `SD br_tmp_ready_1[19];
          br_tag_ready3[20]   <= `SD br_tmp_ready_1[20];
          br_tag_ready3[21]   <= `SD br_tmp_ready_1[21];
          br_tag_ready3[22]   <= `SD br_tmp_ready_1[22];
          br_tag_ready3[23]   <= `SD br_tmp_ready_1[23];
          br_tag_ready3[24]   <= `SD br_tmp_ready_1[24];
          br_tag_ready3[25]   <= `SD br_tmp_ready_1[25];
          br_tag_ready3[26]   <= `SD br_tmp_ready_1[26];
          br_tag_ready3[27]   <= `SD br_tmp_ready_1[27];
          br_tag_ready3[28]   <= `SD br_tmp_ready_1[28];
          br_tag_ready3[29]   <= `SD br_tmp_ready_1[29];
          br_tag_ready3[30]   <= `SD br_tmp_ready_1[30];
        end
      end
      // Branch 2
      if(br_wr_en_2) begin
        if(br_marker_in_2==3'd0) begin
          br_tag0[0]          <= `SD br_tmp_2[0];
          br_tag0[1]          <= `SD br_tmp_2[1];
          br_tag0[2]          <= `SD br_tmp_2[2];
          br_tag0[3]          <= `SD br_tmp_2[3];
          br_tag0[4]          <= `SD br_tmp_2[4];
          br_tag0[5]          <= `SD br_tmp_2[5];
          br_tag0[6]          <= `SD br_tmp_2[6];
          br_tag0[7]          <= `SD br_tmp_2[7];
          br_tag0[8]          <= `SD br_tmp_2[8];
          br_tag0[9]          <= `SD br_tmp_2[9];
          br_tag0[10]         <= `SD br_tmp_2[10];
          br_tag0[11]         <= `SD br_tmp_2[11];
          br_tag0[12]         <= `SD br_tmp_2[12];
          br_tag0[13]         <= `SD br_tmp_2[13];
          br_tag0[14]         <= `SD br_tmp_2[14];
          br_tag0[15]         <= `SD br_tmp_2[15];
          br_tag0[16]         <= `SD br_tmp_2[16];
          br_tag0[17]         <= `SD br_tmp_2[17];
          br_tag0[18]         <= `SD br_tmp_2[18];
          br_tag0[19]         <= `SD br_tmp_2[19];
          br_tag0[20]         <= `SD br_tmp_2[20];
          br_tag0[21]         <= `SD br_tmp_2[21];
          br_tag0[22]         <= `SD br_tmp_2[22];
          br_tag0[23]         <= `SD br_tmp_2[23];
          br_tag0[24]         <= `SD br_tmp_2[24];
          br_tag0[25]         <= `SD br_tmp_2[25];
          br_tag0[26]         <= `SD br_tmp_2[26];
          br_tag0[27]         <= `SD br_tmp_2[27];
          br_tag0[28]         <= `SD br_tmp_2[28];
          br_tag0[29]         <= `SD br_tmp_2[29];
          br_tag0[30]         <= `SD br_tmp_2[30];
          br_tag_ready0[0]    <= `SD br_tmp_ready_2[0];
          br_tag_ready0[1]    <= `SD br_tmp_ready_2[1];
          br_tag_ready0[2]    <= `SD br_tmp_ready_2[2];
          br_tag_ready0[3]    <= `SD br_tmp_ready_2[3];
          br_tag_ready0[4]    <= `SD br_tmp_ready_2[4];
          br_tag_ready0[5]    <= `SD br_tmp_ready_2[5];
          br_tag_ready0[6]    <= `SD br_tmp_ready_2[6];
          br_tag_ready0[7]    <= `SD br_tmp_ready_2[7];
          br_tag_ready0[8]    <= `SD br_tmp_ready_2[8];
          br_tag_ready0[9]    <= `SD br_tmp_ready_2[9];
          br_tag_ready0[10]   <= `SD br_tmp_ready_2[10];
          br_tag_ready0[11]   <= `SD br_tmp_ready_2[11];
          br_tag_ready0[12]   <= `SD br_tmp_ready_2[12];
          br_tag_ready0[13]   <= `SD br_tmp_ready_2[13];
          br_tag_ready0[14]   <= `SD br_tmp_ready_2[14];
          br_tag_ready0[15]   <= `SD br_tmp_ready_2[15];
          br_tag_ready0[16]   <= `SD br_tmp_ready_2[16];
          br_tag_ready0[17]   <= `SD br_tmp_ready_2[17];
          br_tag_ready0[18]   <= `SD br_tmp_ready_2[18];
          br_tag_ready0[19]   <= `SD br_tmp_ready_2[19];
          br_tag_ready0[20]   <= `SD br_tmp_ready_2[20];
          br_tag_ready0[21]   <= `SD br_tmp_ready_2[21];
          br_tag_ready0[22]   <= `SD br_tmp_ready_2[22];
          br_tag_ready0[23]   <= `SD br_tmp_ready_2[23];
          br_tag_ready0[24]   <= `SD br_tmp_ready_2[24];
          br_tag_ready0[25]   <= `SD br_tmp_ready_2[25];
          br_tag_ready0[26]   <= `SD br_tmp_ready_2[26];
          br_tag_ready0[27]   <= `SD br_tmp_ready_2[27];
          br_tag_ready0[28]   <= `SD br_tmp_ready_2[28];
          br_tag_ready0[29]   <= `SD br_tmp_ready_2[29];
          br_tag_ready0[30]   <= `SD br_tmp_ready_2[30];
        end
        else if(br_marker_in_2==3'd1) begin
          br_tag1[0]          <= `SD br_tmp_2[0];
          br_tag1[1]          <= `SD br_tmp_2[1];
          br_tag1[2]          <= `SD br_tmp_2[2];
          br_tag1[3]          <= `SD br_tmp_2[3];
          br_tag1[4]          <= `SD br_tmp_2[4];
          br_tag1[5]          <= `SD br_tmp_2[5];
          br_tag1[6]          <= `SD br_tmp_2[6];
          br_tag1[7]          <= `SD br_tmp_2[7];
          br_tag1[8]          <= `SD br_tmp_2[8];
          br_tag1[9]          <= `SD br_tmp_2[9];
          br_tag1[10]         <= `SD br_tmp_2[10];
          br_tag1[11]         <= `SD br_tmp_2[11];
          br_tag1[12]         <= `SD br_tmp_2[12];
          br_tag1[13]         <= `SD br_tmp_2[13];
          br_tag1[14]         <= `SD br_tmp_2[14];
          br_tag1[15]         <= `SD br_tmp_2[15];
          br_tag1[16]         <= `SD br_tmp_2[16];
          br_tag1[17]         <= `SD br_tmp_2[17];
          br_tag1[18]         <= `SD br_tmp_2[18];
          br_tag1[19]         <= `SD br_tmp_2[19];
          br_tag1[20]         <= `SD br_tmp_2[20];
          br_tag1[21]         <= `SD br_tmp_2[21];
          br_tag1[22]         <= `SD br_tmp_2[22];
          br_tag1[23]         <= `SD br_tmp_2[23];
          br_tag1[24]         <= `SD br_tmp_2[24];
          br_tag1[25]         <= `SD br_tmp_2[25];
          br_tag1[26]         <= `SD br_tmp_2[26];
          br_tag1[27]         <= `SD br_tmp_2[27];
          br_tag1[28]         <= `SD br_tmp_2[28];
          br_tag1[29]         <= `SD br_tmp_2[29];
          br_tag1[30]         <= `SD br_tmp_2[30];
          br_tag_ready1[0]    <= `SD br_tmp_ready_2[0];
          br_tag_ready1[1]    <= `SD br_tmp_ready_2[1];
          br_tag_ready1[2]    <= `SD br_tmp_ready_2[2];
          br_tag_ready1[3]    <= `SD br_tmp_ready_2[3];
          br_tag_ready1[4]    <= `SD br_tmp_ready_2[4];
          br_tag_ready1[5]    <= `SD br_tmp_ready_2[5];
          br_tag_ready1[6]    <= `SD br_tmp_ready_2[6];
          br_tag_ready1[7]    <= `SD br_tmp_ready_2[7];
          br_tag_ready1[8]    <= `SD br_tmp_ready_2[8];
          br_tag_ready1[9]    <= `SD br_tmp_ready_2[9];
          br_tag_ready1[10]   <= `SD br_tmp_ready_2[10];
          br_tag_ready1[11]   <= `SD br_tmp_ready_2[11];
          br_tag_ready1[12]   <= `SD br_tmp_ready_2[12];
          br_tag_ready1[13]   <= `SD br_tmp_ready_2[13];
          br_tag_ready1[14]   <= `SD br_tmp_ready_2[14];
          br_tag_ready1[15]   <= `SD br_tmp_ready_2[15];
          br_tag_ready1[16]   <= `SD br_tmp_ready_2[16];
          br_tag_ready1[17]   <= `SD br_tmp_ready_2[17];
          br_tag_ready1[18]   <= `SD br_tmp_ready_2[18];
          br_tag_ready1[19]   <= `SD br_tmp_ready_2[19];
          br_tag_ready1[20]   <= `SD br_tmp_ready_2[20];
          br_tag_ready1[21]   <= `SD br_tmp_ready_2[21];
          br_tag_ready1[22]   <= `SD br_tmp_ready_2[22];
          br_tag_ready1[23]   <= `SD br_tmp_ready_2[23];
          br_tag_ready1[24]   <= `SD br_tmp_ready_2[24];
          br_tag_ready1[25]   <= `SD br_tmp_ready_2[25];
          br_tag_ready1[26]   <= `SD br_tmp_ready_2[26];
          br_tag_ready1[27]   <= `SD br_tmp_ready_2[27];
          br_tag_ready1[28]   <= `SD br_tmp_ready_2[28];
          br_tag_ready1[29]   <= `SD br_tmp_ready_2[29];
          br_tag_ready1[30]   <= `SD br_tmp_ready_2[30];
        end
        else if(br_marker_in_2==3'd2) begin
          br_tag2[0]          <= `SD br_tmp_2[0];
          br_tag2[1]          <= `SD br_tmp_2[1];
          br_tag2[2]          <= `SD br_tmp_2[2];
          br_tag2[3]          <= `SD br_tmp_2[3];
          br_tag2[4]          <= `SD br_tmp_2[4];
          br_tag2[5]          <= `SD br_tmp_2[5];
          br_tag2[6]          <= `SD br_tmp_2[6];
          br_tag2[7]          <= `SD br_tmp_2[7];
          br_tag2[8]          <= `SD br_tmp_2[8];
          br_tag2[9]          <= `SD br_tmp_2[9];
          br_tag2[10]         <= `SD br_tmp_2[10];
          br_tag2[11]         <= `SD br_tmp_2[11];
          br_tag2[12]         <= `SD br_tmp_2[12];
          br_tag2[13]         <= `SD br_tmp_2[13];
          br_tag2[14]         <= `SD br_tmp_2[14];
          br_tag2[15]         <= `SD br_tmp_2[15];
          br_tag2[16]         <= `SD br_tmp_2[16];
          br_tag2[17]         <= `SD br_tmp_2[17];
          br_tag2[18]         <= `SD br_tmp_2[18];
          br_tag2[19]         <= `SD br_tmp_2[19];
          br_tag2[20]         <= `SD br_tmp_2[20];
          br_tag2[21]         <= `SD br_tmp_2[21];
          br_tag2[22]         <= `SD br_tmp_2[22];
          br_tag2[23]         <= `SD br_tmp_2[23];
          br_tag2[24]         <= `SD br_tmp_2[24];
          br_tag2[25]         <= `SD br_tmp_2[25];
          br_tag2[26]         <= `SD br_tmp_2[26];
          br_tag2[27]         <= `SD br_tmp_2[27];
          br_tag2[28]         <= `SD br_tmp_2[28];
          br_tag2[29]         <= `SD br_tmp_2[29];
          br_tag2[30]         <= `SD br_tmp_2[30];
          br_tag_ready2[0]    <= `SD br_tmp_ready_2[0];
          br_tag_ready2[1]    <= `SD br_tmp_ready_2[1];
          br_tag_ready2[2]    <= `SD br_tmp_ready_2[2];
          br_tag_ready2[3]    <= `SD br_tmp_ready_2[3];
          br_tag_ready2[4]    <= `SD br_tmp_ready_2[4];
          br_tag_ready2[5]    <= `SD br_tmp_ready_2[5];
          br_tag_ready2[6]    <= `SD br_tmp_ready_2[6];
          br_tag_ready2[7]    <= `SD br_tmp_ready_2[7];
          br_tag_ready2[8]    <= `SD br_tmp_ready_2[8];
          br_tag_ready2[9]    <= `SD br_tmp_ready_2[9];
          br_tag_ready2[10]   <= `SD br_tmp_ready_2[10];
          br_tag_ready2[11]   <= `SD br_tmp_ready_2[11];
          br_tag_ready2[12]   <= `SD br_tmp_ready_2[12];
          br_tag_ready2[13]   <= `SD br_tmp_ready_2[13];
          br_tag_ready2[14]   <= `SD br_tmp_ready_2[14];
          br_tag_ready2[15]   <= `SD br_tmp_ready_2[15];
          br_tag_ready2[16]   <= `SD br_tmp_ready_2[16];
          br_tag_ready2[17]   <= `SD br_tmp_ready_2[17];
          br_tag_ready2[18]   <= `SD br_tmp_ready_2[18];
          br_tag_ready2[19]   <= `SD br_tmp_ready_2[19];
          br_tag_ready2[20]   <= `SD br_tmp_ready_2[20];
          br_tag_ready2[21]   <= `SD br_tmp_ready_2[21];
          br_tag_ready2[22]   <= `SD br_tmp_ready_2[22];
          br_tag_ready2[23]   <= `SD br_tmp_ready_2[23];
          br_tag_ready2[24]   <= `SD br_tmp_ready_2[24];
          br_tag_ready2[25]   <= `SD br_tmp_ready_2[25];
          br_tag_ready2[26]   <= `SD br_tmp_ready_2[26];
          br_tag_ready2[27]   <= `SD br_tmp_ready_2[27];
          br_tag_ready2[28]   <= `SD br_tmp_ready_2[28];
          br_tag_ready2[29]   <= `SD br_tmp_ready_2[29];
          br_tag_ready2[30]   <= `SD br_tmp_ready_2[30];
        end
        else if(br_marker_in_2==3'd3) begin
          br_tag3[0]          <= `SD br_tmp_2[0];
          br_tag3[1]          <= `SD br_tmp_2[1];
          br_tag3[2]          <= `SD br_tmp_2[2];
          br_tag3[3]          <= `SD br_tmp_2[3];
          br_tag3[4]          <= `SD br_tmp_2[4];
          br_tag3[5]          <= `SD br_tmp_2[5];
          br_tag3[6]          <= `SD br_tmp_2[6];
          br_tag3[7]          <= `SD br_tmp_2[7];
          br_tag3[8]          <= `SD br_tmp_2[8];
          br_tag3[9]          <= `SD br_tmp_2[9];
          br_tag3[10]         <= `SD br_tmp_2[10];
          br_tag3[11]         <= `SD br_tmp_2[11];
          br_tag3[12]         <= `SD br_tmp_2[12];
          br_tag3[13]         <= `SD br_tmp_2[13];
          br_tag3[14]         <= `SD br_tmp_2[14];
          br_tag3[15]         <= `SD br_tmp_2[15];
          br_tag3[16]         <= `SD br_tmp_2[16];
          br_tag3[17]         <= `SD br_tmp_2[17];
          br_tag3[18]         <= `SD br_tmp_2[18];
          br_tag3[19]         <= `SD br_tmp_2[19];
          br_tag3[20]         <= `SD br_tmp_2[20];
          br_tag3[21]         <= `SD br_tmp_2[21];
          br_tag3[22]         <= `SD br_tmp_2[22];
          br_tag3[23]         <= `SD br_tmp_2[23];
          br_tag3[24]         <= `SD br_tmp_2[24];
          br_tag3[25]         <= `SD br_tmp_2[25];
          br_tag3[26]         <= `SD br_tmp_2[26];
          br_tag3[27]         <= `SD br_tmp_2[27];
          br_tag3[28]         <= `SD br_tmp_2[28];
          br_tag3[29]         <= `SD br_tmp_2[29];
          br_tag3[30]         <= `SD br_tmp_2[30];
          br_tag_ready3[0]    <= `SD br_tmp_ready_2[0];
          br_tag_ready3[1]    <= `SD br_tmp_ready_2[1];
          br_tag_ready3[2]    <= `SD br_tmp_ready_2[2];
          br_tag_ready3[3]    <= `SD br_tmp_ready_2[3];
          br_tag_ready3[4]    <= `SD br_tmp_ready_2[4];
          br_tag_ready3[5]    <= `SD br_tmp_ready_2[5];
          br_tag_ready3[6]    <= `SD br_tmp_ready_2[6];
          br_tag_ready3[7]    <= `SD br_tmp_ready_2[7];
          br_tag_ready3[8]    <= `SD br_tmp_ready_2[8];
          br_tag_ready3[9]    <= `SD br_tmp_ready_2[9];
          br_tag_ready3[10]   <= `SD br_tmp_ready_2[10];
          br_tag_ready3[11]   <= `SD br_tmp_ready_2[11];
          br_tag_ready3[12]   <= `SD br_tmp_ready_2[12];
          br_tag_ready3[13]   <= `SD br_tmp_ready_2[13];
          br_tag_ready3[14]   <= `SD br_tmp_ready_2[14];
          br_tag_ready3[15]   <= `SD br_tmp_ready_2[15];
          br_tag_ready3[16]   <= `SD br_tmp_ready_2[16];
          br_tag_ready3[17]   <= `SD br_tmp_ready_2[17];
          br_tag_ready3[18]   <= `SD br_tmp_ready_2[18];
          br_tag_ready3[19]   <= `SD br_tmp_ready_2[19];
          br_tag_ready3[20]   <= `SD br_tmp_ready_2[20];
          br_tag_ready3[21]   <= `SD br_tmp_ready_2[21];
          br_tag_ready3[22]   <= `SD br_tmp_ready_2[22];
          br_tag_ready3[23]   <= `SD br_tmp_ready_2[23];
          br_tag_ready3[24]   <= `SD br_tmp_ready_2[24];
          br_tag_ready3[25]   <= `SD br_tmp_ready_2[25];
          br_tag_ready3[26]   <= `SD br_tmp_ready_2[26];
          br_tag_ready3[27]   <= `SD br_tmp_ready_2[27];
          br_tag_ready3[28]   <= `SD br_tmp_ready_2[28];
          br_tag_ready3[29]   <= `SD br_tmp_ready_2[29];
          br_tag_ready3[30]   <= `SD br_tmp_ready_2[30];
        end
      end

      // CDB
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[0])       reg_tag_ready[0]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[0])  reg_tag_ready[0]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[1])       reg_tag_ready[1]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[1])  reg_tag_ready[1]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[2])       reg_tag_ready[2]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[2])  reg_tag_ready[2]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[3])       reg_tag_ready[3]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[3])  reg_tag_ready[3]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[4])       reg_tag_ready[4]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[4])  reg_tag_ready[4]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[5])       reg_tag_ready[5]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[5])  reg_tag_ready[5]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[6])       reg_tag_ready[6]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[6])  reg_tag_ready[6]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[7])       reg_tag_ready[7]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[7])  reg_tag_ready[7]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[8])       reg_tag_ready[8]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[8])  reg_tag_ready[8]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[9])       reg_tag_ready[9]  <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[9])  reg_tag_ready[9]  <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[10])      reg_tag_ready[10] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[10]) reg_tag_ready[10] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[11])      reg_tag_ready[11] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[11]) reg_tag_ready[11] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[12])      reg_tag_ready[12] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[12]) reg_tag_ready[12] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[13])      reg_tag_ready[13] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[13]) reg_tag_ready[13] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[14])      reg_tag_ready[14] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[14]) reg_tag_ready[14] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[15])      reg_tag_ready[15] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[15]) reg_tag_ready[15] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[16])      reg_tag_ready[16] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[16]) reg_tag_ready[16] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[17])      reg_tag_ready[17] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[17]) reg_tag_ready[17] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[18])      reg_tag_ready[18] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[18]) reg_tag_ready[18] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[19])      reg_tag_ready[19] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[19]) reg_tag_ready[19] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[20])      reg_tag_ready[20] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[20]) reg_tag_ready[20] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[21])      reg_tag_ready[21] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[21]) reg_tag_ready[21] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[22])      reg_tag_ready[22] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[22]) reg_tag_ready[22] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[23])      reg_tag_ready[23] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[23]) reg_tag_ready[23] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[24])      reg_tag_ready[24] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[24]) reg_tag_ready[24] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[25])      reg_tag_ready[25] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[25]) reg_tag_ready[25] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[26])      reg_tag_ready[26] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[26]) reg_tag_ready[26] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[27])      reg_tag_ready[27] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[27]) reg_tag_ready[27] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[28])      reg_tag_ready[28] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[28]) reg_tag_ready[28] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[29])      reg_tag_ready[29] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[29]) reg_tag_ready[29] <= `SD 1'd1;
      if(cdb_wr_en_now_1 && cdb_wr_idx_1==reg_tag[30])      reg_tag_ready[30] <= `SD 1'd1;
      else if(cdb_wr_en_now_2 && cdb_wr_idx_2==reg_tag[30]) reg_tag_ready[30] <= `SD 1'd1;
      // Branch
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[0])       br_tag_ready0[0]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[0])  br_tag_ready0[0]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[1])       br_tag_ready0[1]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[1])  br_tag_ready0[1]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[2])       br_tag_ready0[2]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[2])  br_tag_ready0[2]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[3])       br_tag_ready0[3]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[3])  br_tag_ready0[3]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[4])       br_tag_ready0[4]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[4])  br_tag_ready0[4]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[5])       br_tag_ready0[5]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[5])  br_tag_ready0[5]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[6])       br_tag_ready0[6]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[6])  br_tag_ready0[6]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[7])       br_tag_ready0[7]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[7])  br_tag_ready0[7]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[8])       br_tag_ready0[8]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[8])  br_tag_ready0[8]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[9])       br_tag_ready0[9]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[9])  br_tag_ready0[9]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[10])      br_tag_ready0[10] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[10]) br_tag_ready0[10] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[11])      br_tag_ready0[11] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[11]) br_tag_ready0[11] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[12])      br_tag_ready0[12] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[12]) br_tag_ready0[12] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[13])      br_tag_ready0[13] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[13]) br_tag_ready0[13] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[14])      br_tag_ready0[14] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[14]) br_tag_ready0[14] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[15])      br_tag_ready0[15] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[15]) br_tag_ready0[15] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[16])      br_tag_ready0[16] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[16]) br_tag_ready0[16] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[17])      br_tag_ready0[17] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[17]) br_tag_ready0[17] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[18])      br_tag_ready0[18] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[18]) br_tag_ready0[18] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[19])      br_tag_ready0[19] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[19]) br_tag_ready0[19] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[20])      br_tag_ready0[20] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[20]) br_tag_ready0[20] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[21])      br_tag_ready0[21] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[21]) br_tag_ready0[21] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[22])      br_tag_ready0[22] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[22]) br_tag_ready0[22] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[23])      br_tag_ready0[23] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[23]) br_tag_ready0[23] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[24])      br_tag_ready0[24] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[24]) br_tag_ready0[24] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[25])      br_tag_ready0[25] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[25]) br_tag_ready0[25] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[26])      br_tag_ready0[26] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[26]) br_tag_ready0[26] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[27])      br_tag_ready0[27] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[27]) br_tag_ready0[27] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[28])      br_tag_ready0[28] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[28]) br_tag_ready0[28] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[29])      br_tag_ready0[29] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[29]) br_tag_ready0[29] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag0[30])      br_tag_ready0[30] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag0[30]) br_tag_ready0[30] <= `SD 1'd1;

      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[0])       br_tag_ready1[0]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[0])  br_tag_ready1[0]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[1])       br_tag_ready1[1]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[1])  br_tag_ready1[1]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[2])       br_tag_ready1[2]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[2])  br_tag_ready1[2]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[3])       br_tag_ready1[3]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[3])  br_tag_ready1[3]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[4])       br_tag_ready1[4]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[4])  br_tag_ready1[4]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[5])       br_tag_ready1[5]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[5])  br_tag_ready1[5]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[6])       br_tag_ready1[6]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[6])  br_tag_ready1[6]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[7])       br_tag_ready1[7]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[7])  br_tag_ready1[7]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[8])       br_tag_ready1[8]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[8])  br_tag_ready1[8]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[9])       br_tag_ready1[9]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[9])  br_tag_ready1[9]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[10])      br_tag_ready1[10] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[10]) br_tag_ready1[10] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[11])      br_tag_ready1[11] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[11]) br_tag_ready1[11] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[12])      br_tag_ready1[12] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[12]) br_tag_ready1[12] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[13])      br_tag_ready1[13] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[13]) br_tag_ready1[13] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[14])      br_tag_ready1[14] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[14]) br_tag_ready1[14] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[15])      br_tag_ready1[15] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[15]) br_tag_ready1[15] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[16])      br_tag_ready1[16] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[16]) br_tag_ready1[16] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[17])      br_tag_ready1[17] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[17]) br_tag_ready1[17] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[18])      br_tag_ready1[18] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[18]) br_tag_ready1[18] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[19])      br_tag_ready1[19] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[19]) br_tag_ready1[19] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[20])      br_tag_ready1[20] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[20]) br_tag_ready1[20] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[21])      br_tag_ready1[21] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[21]) br_tag_ready1[21] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[22])      br_tag_ready1[22] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[22]) br_tag_ready1[22] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[23])      br_tag_ready1[23] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[23]) br_tag_ready1[23] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[24])      br_tag_ready1[24] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[24]) br_tag_ready1[24] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[25])      br_tag_ready1[25] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[25]) br_tag_ready1[25] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[26])      br_tag_ready1[26] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[26]) br_tag_ready1[26] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[27])      br_tag_ready1[27] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[27]) br_tag_ready1[27] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[28])      br_tag_ready1[28] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[28]) br_tag_ready1[28] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[29])      br_tag_ready1[29] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[29]) br_tag_ready1[29] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag1[30])      br_tag_ready1[30] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag1[30]) br_tag_ready1[30] <= `SD 1'd1;

      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[0])       br_tag_ready2[0]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[0])  br_tag_ready2[0]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[1])       br_tag_ready2[1]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[1])  br_tag_ready2[1]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[2])       br_tag_ready2[2]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[2])  br_tag_ready2[2]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[3])       br_tag_ready2[3]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[3])  br_tag_ready2[3]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[4])       br_tag_ready2[4]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[4])  br_tag_ready2[4]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[5])       br_tag_ready2[5]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[5])  br_tag_ready2[5]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[6])       br_tag_ready2[6]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[6])  br_tag_ready2[6]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[7])       br_tag_ready2[7]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[7])  br_tag_ready2[7]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[8])       br_tag_ready2[8]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[8])  br_tag_ready2[8]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[9])       br_tag_ready2[9]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[9])  br_tag_ready2[9]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[10])      br_tag_ready2[10] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[10]) br_tag_ready2[10] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[11])      br_tag_ready2[11] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[11]) br_tag_ready2[11] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[12])      br_tag_ready2[12] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[12]) br_tag_ready2[12] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[13])      br_tag_ready2[13] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[13]) br_tag_ready2[13] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[14])      br_tag_ready2[14] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[14]) br_tag_ready2[14] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[15])      br_tag_ready2[15] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[15]) br_tag_ready2[15] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[16])      br_tag_ready2[16] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[16]) br_tag_ready2[16] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[17])      br_tag_ready2[17] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[17]) br_tag_ready2[17] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[18])      br_tag_ready2[18] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[18]) br_tag_ready2[18] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[19])      br_tag_ready2[19] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[19]) br_tag_ready2[19] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[20])      br_tag_ready2[20] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[20]) br_tag_ready2[20] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[21])      br_tag_ready2[21] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[21]) br_tag_ready2[21] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[22])      br_tag_ready2[22] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[22]) br_tag_ready2[22] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[23])      br_tag_ready2[23] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[23]) br_tag_ready2[23] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[24])      br_tag_ready2[24] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[24]) br_tag_ready2[24] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[25])      br_tag_ready2[25] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[25]) br_tag_ready2[25] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[26])      br_tag_ready2[26] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[26]) br_tag_ready2[26] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[27])      br_tag_ready2[27] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[27]) br_tag_ready2[27] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[28])      br_tag_ready2[28] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[28]) br_tag_ready2[28] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[29])      br_tag_ready2[29] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[29]) br_tag_ready2[29] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag2[30])      br_tag_ready2[30] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag2[30]) br_tag_ready2[30] <= `SD 1'd1;

      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[0])       br_tag_ready3[0]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[0])  br_tag_ready3[0]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[1])       br_tag_ready3[1]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[1])  br_tag_ready3[1]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[2])       br_tag_ready3[2]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[2])  br_tag_ready3[2]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[3])       br_tag_ready3[3]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[3])  br_tag_ready3[3]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[4])       br_tag_ready3[4]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[4])  br_tag_ready3[4]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[5])       br_tag_ready3[5]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[5])  br_tag_ready3[5]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[6])       br_tag_ready3[6]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[6])  br_tag_ready3[6]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[7])       br_tag_ready3[7]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[7])  br_tag_ready3[7]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[8])       br_tag_ready3[8]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[8])  br_tag_ready3[8]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[9])       br_tag_ready3[9]  <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[9])  br_tag_ready3[9]  <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[10])      br_tag_ready3[10] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[10]) br_tag_ready3[10] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[11])      br_tag_ready3[11] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[11]) br_tag_ready3[11] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[12])      br_tag_ready3[12] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[12]) br_tag_ready3[12] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[13])      br_tag_ready3[13] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[13]) br_tag_ready3[13] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[14])      br_tag_ready3[14] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[14]) br_tag_ready3[14] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[15])      br_tag_ready3[15] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[15]) br_tag_ready3[15] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[16])      br_tag_ready3[16] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[16]) br_tag_ready3[16] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[17])      br_tag_ready3[17] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[17]) br_tag_ready3[17] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[18])      br_tag_ready3[18] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[18]) br_tag_ready3[18] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[19])      br_tag_ready3[19] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[19]) br_tag_ready3[19] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[20])      br_tag_ready3[20] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[20]) br_tag_ready3[20] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[21])      br_tag_ready3[21] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[21]) br_tag_ready3[21] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[22])      br_tag_ready3[22] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[22]) br_tag_ready3[22] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[23])      br_tag_ready3[23] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[23]) br_tag_ready3[23] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[24])      br_tag_ready3[24] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[24]) br_tag_ready3[24] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[25])      br_tag_ready3[25] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[25]) br_tag_ready3[25] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[26])      br_tag_ready3[26] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[26]) br_tag_ready3[26] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[27])      br_tag_ready3[27] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[27]) br_tag_ready3[27] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[28])      br_tag_ready3[28] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[28]) br_tag_ready3[28] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[29])      br_tag_ready3[29] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[29]) br_tag_ready3[29] <= `SD 1'd1;
      if(cdb_wr_en_1 && cdb_wr_idx_1==br_tag3[30])      br_tag_ready3[30] <= `SD 1'd1;
      else if(cdb_wr_en_2 && cdb_wr_idx_2==br_tag3[30]) br_tag_ready3[30] <= `SD 1'd1;
    end
  end

endmodule

