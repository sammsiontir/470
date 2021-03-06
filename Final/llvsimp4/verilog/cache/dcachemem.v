// cachemem128x64

`timescale 1ns/100ps

`define SD #1

module cache(// inputs
                       clock,
                       reset, 
                       wr_en,
                       wr_data,
                       wr_pc_reg,
                       wb_pc_reg,

                       rd_pc_reg,
                       // outputs
                       rd_data,
                       rd_valid
                      );

input clock, reset;
input        wr_en;
input [63:0] wr_data;
input [63:0] wr_pc_reg;
input [63:0] wb_pc_reg;
input [63:0] rd_pc_reg;

output wire [63:0] rd_data;
wire        [63:0] rd_data_cache;
reg         [63:0] rd_data_victim;
output wire rd_valid;
wire        rd_valid_cache;
reg         rd_valid_victim;


wire [54:0]  wr_pc_tag;
wire [5:0]   wr_pc_idx;
wire [54:0]  wb_pc_tag;
wire [5:0]   wb_pc_idx;
wire [54:0]  rd_pc_tag;
wire [5:0]   rd_pc_idx;

reg  [54:0] tags_1[63:0];
reg  [63:0] valid_1;
reg  [63:0] lines_1[63:0];
reg  [54:0] tags_2[63:0];
reg  [63:0] valid_2;
reg  [63:0] lines_2[63:0];
reg  [63:0] next_wr2way1;
reg  [63:0] wr2way1;

assign rd_data   = rd_valid_cache  ? rd_data_cache :
                   rd_valid_victim ? rd_data_victim: 0;
assign rd_valid  = rd_valid_cache | rd_valid_victim;
assign wr_pc_tag = wr_pc_reg[63:9];
assign wr_pc_idx = wr_pc_reg[8:3];
assign wb_pc_tag = wb_pc_reg[63:9];
assign wb_pc_idx = wb_pc_reg[8:3];
assign rd_pc_tag = rd_pc_reg[63:9];
assign rd_pc_idx = rd_pc_reg[8:3];

wire data_in_1 = ((tags_1[rd_pc_idx] == rd_pc_tag) & valid_1[rd_pc_idx]);
wire data_in_2 = ((tags_2[rd_pc_idx] == rd_pc_tag) & valid_2[rd_pc_idx]);
assign rd_valid_cache = data_in_1 | data_in_2;
assign rd_data_cache  = data_in_1 ? lines_1[rd_pc_idx]:
                        data_in_2 ? lines_2[rd_pc_idx]:
                        64'd0;

wire store_hit_1 = ((tags_1[wr_pc_idx] == wr_pc_tag) & valid_1[wr_pc_idx]);
wire store_hit_2 = ((tags_2[wr_pc_idx] == wr_pc_tag) & valid_2[wr_pc_idx]);
reg  store_to_which_line;
always@* begin
  if(store_hit_1)store_to_which_line = 0;
  else if(store_hit_2)store_to_which_line = 1;
  else store_to_which_line = wr2way1;
end

always@* begin
  next_wr2way1 = wr2way1;
  if(data_in_1) next_wr2way1[rd_pc_idx] = 1;
  else if(data_in_2) next_wr2way1[rd_pc_idx] = 0;
end

always@(posedge clock) begin
  if(reset) wr2way1 <= `SD 64'd0;
  else wr2way1 <= `SD next_wr2way1;
end

always@(posedge clock) begin
  if(reset) begin
    valid_1 <= `SD 0;
    valid_2 <= `SD 0;
  end else if(wr_en)begin
    if(store_to_which_line == 0) begin
      lines_1[wr_pc_idx] <= `SD wr_data;
      valid_1[wr_pc_idx] <= `SD 1;
      tags_1[wr_pc_idx] <= `SD wr_pc_tag;
    end else begin
      lines_2[wr_pc_idx] <= `SD wr_data;
      valid_2[wr_pc_idx] <= `SD 1;
      tags_2[wr_pc_idx] <= `SD wr_pc_tag;
   end
 end
end


//store hit in victim
`define STORE_NOT_HIT_POS 7'd64
reg       store_hit_in_victim;
reg [6:0] store_hit_position;

reg        pull_to_victim;
reg [63:0] pull_to_victim_data;
reg [60:0] pull_to_victim_addr;

reg [5:0] next_victim_wr_position;
reg [5:0] victim_wr_position;

reg [63:0] victim_data  [63:0];
reg [60:0] victim_addr  [63:0];
reg [63:0] victim_valid;

always@* begin
  store_hit_in_victim = `FALSE;
  store_hit_position  = `STORE_NOT_HIT_POS;
  if(victim_addr[0]  == wr_pc_reg[63:3] & victim_valid[0])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd0;  end
  if(victim_addr[1]  == wr_pc_reg[63:3] & victim_valid[1])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd1;  end
  if(victim_addr[2]  == wr_pc_reg[63:3] & victim_valid[2])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd2;  end 
  if(victim_addr[3]  == wr_pc_reg[63:3] & victim_valid[3])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd3;  end 
  if(victim_addr[4]  == wr_pc_reg[63:3] & victim_valid[4])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd4;  end 
  if(victim_addr[5]  == wr_pc_reg[63:3] & victim_valid[5])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd5;  end 
  if(victim_addr[6]  == wr_pc_reg[63:3] & victim_valid[6])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd6;  end 
  if(victim_addr[7]  == wr_pc_reg[63:3] & victim_valid[7])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd7;  end 
  if(victim_addr[8]  == wr_pc_reg[63:3] & victim_valid[8])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd8;  end 
  if(victim_addr[9]  == wr_pc_reg[63:3] & victim_valid[9])  begin store_hit_in_victim = `TRUE; store_hit_position = 6'd9;  end 
  if(victim_addr[10] == wr_pc_reg[63:3] & victim_valid[10]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd10; end 
  if(victim_addr[11] == wr_pc_reg[63:3] & victim_valid[11]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd11; end 
  if(victim_addr[12] == wr_pc_reg[63:3] & victim_valid[12]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd12; end 
  if(victim_addr[13] == wr_pc_reg[63:3] & victim_valid[13]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd13; end 
  if(victim_addr[14] == wr_pc_reg[63:3] & victim_valid[14]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd14; end 
  if(victim_addr[15] == wr_pc_reg[63:3] & victim_valid[15]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd15; end 
  if(victim_addr[16] == wr_pc_reg[63:3] & victim_valid[16]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd16; end 
  if(victim_addr[17] == wr_pc_reg[63:3] & victim_valid[17]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd17; end 
  if(victim_addr[18] == wr_pc_reg[63:3] & victim_valid[18]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd18; end 
  if(victim_addr[19] == wr_pc_reg[63:3] & victim_valid[19]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd19; end 
  if(victim_addr[20] == wr_pc_reg[63:3] & victim_valid[20]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd20; end 
  if(victim_addr[21] == wr_pc_reg[63:3] & victim_valid[21]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd21; end 
  if(victim_addr[22] == wr_pc_reg[63:3] & victim_valid[22]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd22; end 
  if(victim_addr[23] == wr_pc_reg[63:3] & victim_valid[23]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd23; end 
  if(victim_addr[24] == wr_pc_reg[63:3] & victim_valid[24]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd24; end 
  if(victim_addr[25] == wr_pc_reg[63:3] & victim_valid[25]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd25; end 
  if(victim_addr[26] == wr_pc_reg[63:3] & victim_valid[26]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd26; end 
  if(victim_addr[27] == wr_pc_reg[63:3] & victim_valid[27]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd27; end 
  if(victim_addr[28] == wr_pc_reg[63:3] & victim_valid[28]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd28; end 
  if(victim_addr[29] == wr_pc_reg[63:3] & victim_valid[29]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd29; end 
  if(victim_addr[30] == wr_pc_reg[63:3] & victim_valid[30]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd30; end 
  if(victim_addr[31] == wr_pc_reg[63:3] & victim_valid[31]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd31; end
  if(victim_addr[32] == wr_pc_reg[63:3] & victim_valid[32]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd32;  end
  if(victim_addr[33] == wr_pc_reg[63:3] & victim_valid[33]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd33;  end
  if(victim_addr[34] == wr_pc_reg[63:3] & victim_valid[34]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd34;  end 
  if(victim_addr[35] == wr_pc_reg[63:3] & victim_valid[35]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd35;  end 
  if(victim_addr[36] == wr_pc_reg[63:3] & victim_valid[36]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd36;  end 
  if(victim_addr[37] == wr_pc_reg[63:3] & victim_valid[37]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd37;  end 
  if(victim_addr[38] == wr_pc_reg[63:3] & victim_valid[38]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd38;  end 
  if(victim_addr[39] == wr_pc_reg[63:3] & victim_valid[39]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd39;  end 
  if(victim_addr[40] == wr_pc_reg[63:3] & victim_valid[40]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd40;  end 
  if(victim_addr[41] == wr_pc_reg[63:3] & victim_valid[41]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd41;  end 
  if(victim_addr[42] == wr_pc_reg[63:3] & victim_valid[42]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd42; end 
  if(victim_addr[43] == wr_pc_reg[63:3] & victim_valid[43]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd43; end 
  if(victim_addr[44] == wr_pc_reg[63:3] & victim_valid[44]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd44; end 
  if(victim_addr[45] == wr_pc_reg[63:3] & victim_valid[45]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd45; end 
  if(victim_addr[46] == wr_pc_reg[63:3] & victim_valid[46]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd46; end 
  if(victim_addr[47] == wr_pc_reg[63:3] & victim_valid[47]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd47; end 
  if(victim_addr[48] == wr_pc_reg[63:3] & victim_valid[48]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd48; end 
  if(victim_addr[49] == wr_pc_reg[63:3] & victim_valid[49]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd49; end 
  if(victim_addr[50] == wr_pc_reg[63:3] & victim_valid[50]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd50; end 
  if(victim_addr[51] == wr_pc_reg[63:3] & victim_valid[51]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd51; end 
  if(victim_addr[52] == wr_pc_reg[63:3] & victim_valid[52]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd52; end 
  if(victim_addr[53] == wr_pc_reg[63:3] & victim_valid[53]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd53; end 
  if(victim_addr[54] == wr_pc_reg[63:3] & victim_valid[54]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd54; end 
  if(victim_addr[55] == wr_pc_reg[63:3] & victim_valid[55]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd55; end 
  if(victim_addr[56] == wr_pc_reg[63:3] & victim_valid[56]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd56; end 
  if(victim_addr[57] == wr_pc_reg[63:3] & victim_valid[57]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd57; end 
  if(victim_addr[58] == wr_pc_reg[63:3] & victim_valid[58]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd58; end 
  if(victim_addr[59] == wr_pc_reg[63:3] & victim_valid[59]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd59; end 
  if(victim_addr[60] == wr_pc_reg[63:3] & victim_valid[60]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd60; end 
  if(victim_addr[61] == wr_pc_reg[63:3] & victim_valid[61]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd61; end 
  if(victim_addr[62] == wr_pc_reg[63:3] & victim_valid[62]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd62; end 
  if(victim_addr[63] == wr_pc_reg[63:3] & victim_valid[63]) begin store_hit_in_victim = `TRUE; store_hit_position = 6'd63; end
end


always@* begin
  pull_to_victim = `FALSE;
  pull_to_victim_data = 0;
  pull_to_victim_addr = 0;
  if(store_to_which_line == 0 & valid_1[wr_pc_idx] ) begin
    pull_to_victim = `TRUE;
    pull_to_victim_data = lines_1[wr_pc_idx];
    pull_to_victim_addr = { tags_1[wr_pc_idx], wr_pc_idx };
  end else if(store_to_which_line == 1 & valid_2[wr_pc_idx] ) begin
    pull_to_victim = `TRUE;
    pull_to_victim_data = lines_2[wr_pc_idx];
    pull_to_victim_addr = { tags_2[wr_pc_idx], wr_pc_idx };
  end
end


always@* begin
  next_victim_wr_position = victim_wr_position + 1;
  if(!victim_valid[0])  next_victim_wr_position = 0;
  if(!victim_valid[1])  next_victim_wr_position = 1;
  if(!victim_valid[2])  next_victim_wr_position = 2;
  if(!victim_valid[3])  next_victim_wr_position = 3;
  if(!victim_valid[4])  next_victim_wr_position = 4;
  if(!victim_valid[5])  next_victim_wr_position = 5;
  if(!victim_valid[6])  next_victim_wr_position = 6;
  if(!victim_valid[7])  next_victim_wr_position = 7;
  if(!victim_valid[8])  next_victim_wr_position = 8;
  if(!victim_valid[9])  next_victim_wr_position = 9;
  if(!victim_valid[10]) next_victim_wr_position = 10;
  if(!victim_valid[11]) next_victim_wr_position = 11;
  if(!victim_valid[12]) next_victim_wr_position = 12;
  if(!victim_valid[13]) next_victim_wr_position = 13;
  if(!victim_valid[14]) next_victim_wr_position = 14;
  if(!victim_valid[15]) next_victim_wr_position = 15;
  if(!victim_valid[16]) next_victim_wr_position = 16;
  if(!victim_valid[17]) next_victim_wr_position = 17;
  if(!victim_valid[18]) next_victim_wr_position = 18;
  if(!victim_valid[19]) next_victim_wr_position = 19;
  if(!victim_valid[20]) next_victim_wr_position = 20;
  if(!victim_valid[21]) next_victim_wr_position = 21;
  if(!victim_valid[22]) next_victim_wr_position = 22;
  if(!victim_valid[23]) next_victim_wr_position = 23;
  if(!victim_valid[24]) next_victim_wr_position = 24;
  if(!victim_valid[25]) next_victim_wr_position = 25;
  if(!victim_valid[26]) next_victim_wr_position = 26;
  if(!victim_valid[27]) next_victim_wr_position = 27;
  if(!victim_valid[28]) next_victim_wr_position = 28;
  if(!victim_valid[29]) next_victim_wr_position = 29;
  if(!victim_valid[30]) next_victim_wr_position = 30;
  if(!victim_valid[31]) next_victim_wr_position = 31;
  if(!victim_valid[32]) next_victim_wr_position = 32;
  if(!victim_valid[33]) next_victim_wr_position = 33;
  if(!victim_valid[34]) next_victim_wr_position = 34;
  if(!victim_valid[35]) next_victim_wr_position = 35;
  if(!victim_valid[36]) next_victim_wr_position = 36;
  if(!victim_valid[37]) next_victim_wr_position = 37;
  if(!victim_valid[38]) next_victim_wr_position = 38;
  if(!victim_valid[39]) next_victim_wr_position = 39;
  if(!victim_valid[40]) next_victim_wr_position = 40;
  if(!victim_valid[41]) next_victim_wr_position = 41;
  if(!victim_valid[42]) next_victim_wr_position = 42;
  if(!victim_valid[43]) next_victim_wr_position = 43;
  if(!victim_valid[44]) next_victim_wr_position = 44;
  if(!victim_valid[45]) next_victim_wr_position = 45;
  if(!victim_valid[46]) next_victim_wr_position = 46;
  if(!victim_valid[47]) next_victim_wr_position = 47;
  if(!victim_valid[48]) next_victim_wr_position = 48;
  if(!victim_valid[49]) next_victim_wr_position = 49;
  if(!victim_valid[50]) next_victim_wr_position = 50;
  if(!victim_valid[51]) next_victim_wr_position = 51;
  if(!victim_valid[52]) next_victim_wr_position = 52;
  if(!victim_valid[53]) next_victim_wr_position = 53;
  if(!victim_valid[54]) next_victim_wr_position = 54;
  if(!victim_valid[55]) next_victim_wr_position = 55;
  if(!victim_valid[56]) next_victim_wr_position = 56;
  if(!victim_valid[57]) next_victim_wr_position = 57;
  if(!victim_valid[57]) next_victim_wr_position = 58;
  if(!victim_valid[58]) next_victim_wr_position = 59;
  if(!victim_valid[59]) next_victim_wr_position = 60;
  if(!victim_valid[61]) next_victim_wr_position = 61;
  if(!victim_valid[62]) next_victim_wr_position = 62;
  if(!victim_valid[63]) next_victim_wr_position = 63;
end
always@(posedge clock) begin
  if(reset) victim_wr_position <= `SD 0;
  else      victim_wr_position <= `SD next_victim_wr_position;
end

always@(posedge clock) begin
 if(reset) begin
   victim_valid <= `SD 0;
 end else if( !store_hit_1 & !store_hit_2 & !store_hit_in_victim & pull_to_victim == `TRUE ) begin
   victim_valid[victim_wr_position] <= `SD `TRUE;
   victim_addr[victim_wr_position]  <= `SD pull_to_victim_addr;
   victim_data[victim_wr_position]  <= `SD pull_to_victim_data;
 end else if( store_hit_in_victim & pull_to_victim == `TRUE) begin
   victim_valid[store_hit_position[5:0]] <= `SD `TRUE;
   victim_addr[store_hit_position[5:0]]  <= `SD pull_to_victim_addr;
   victim_data[store_hit_position[5:0]]  <= `SD pull_to_victim_data;
 end else if( store_hit_in_victim & pull_to_victim == `FALSE) begin
   victim_valid[store_hit_position[5:0]] <= `SD `FALSE;
   victim_addr[store_hit_position[5:0]]  <= `SD 0;
   victim_data[store_hit_position[5:0]]  <= `SD 0;
 end
end

always@* begin
  rd_data_victim  = 0;
  rd_valid_victim = `FALSE;
  if(victim_addr[0]  == rd_pc_reg[63:3] & victim_valid[0])  begin rd_data_victim = victim_data[0];  rd_valid_victim = `TRUE; end
  if(victim_addr[1]  == rd_pc_reg[63:3] & victim_valid[1])  begin rd_data_victim = victim_data[1];  rd_valid_victim = `TRUE; end
  if(victim_addr[2]  == rd_pc_reg[63:3] & victim_valid[2])  begin rd_data_victim = victim_data[2];  rd_valid_victim = `TRUE; end
  if(victim_addr[3]  == rd_pc_reg[63:3] & victim_valid[3])  begin rd_data_victim = victim_data[3];  rd_valid_victim = `TRUE; end
  if(victim_addr[4]  == rd_pc_reg[63:3] & victim_valid[4])  begin rd_data_victim = victim_data[4];  rd_valid_victim = `TRUE; end
  if(victim_addr[5]  == rd_pc_reg[63:3] & victim_valid[5])  begin rd_data_victim = victim_data[5];  rd_valid_victim = `TRUE; end
  if(victim_addr[6]  == rd_pc_reg[63:3] & victim_valid[6])  begin rd_data_victim = victim_data[6];  rd_valid_victim = `TRUE; end
  if(victim_addr[7]  == rd_pc_reg[63:3] & victim_valid[7])  begin rd_data_victim = victim_data[7];  rd_valid_victim = `TRUE; end
  if(victim_addr[8]  == rd_pc_reg[63:3] & victim_valid[8])  begin rd_data_victim = victim_data[8];  rd_valid_victim = `TRUE; end
  if(victim_addr[9]  == rd_pc_reg[63:3] & victim_valid[9])  begin rd_data_victim = victim_data[9];  rd_valid_victim = `TRUE; end
  if(victim_addr[10] == rd_pc_reg[63:3] & victim_valid[10]) begin rd_data_victim = victim_data[10]; rd_valid_victim = `TRUE; end
  if(victim_addr[11] == rd_pc_reg[63:3] & victim_valid[11]) begin rd_data_victim = victim_data[11]; rd_valid_victim = `TRUE; end
  if(victim_addr[12] == rd_pc_reg[63:3] & victim_valid[12]) begin rd_data_victim = victim_data[12]; rd_valid_victim = `TRUE; end
  if(victim_addr[13] == rd_pc_reg[63:3] & victim_valid[13]) begin rd_data_victim = victim_data[13]; rd_valid_victim = `TRUE; end
  if(victim_addr[14] == rd_pc_reg[63:3] & victim_valid[14]) begin rd_data_victim = victim_data[14]; rd_valid_victim = `TRUE; end
  if(victim_addr[15] == rd_pc_reg[63:3] & victim_valid[15]) begin rd_data_victim = victim_data[15]; rd_valid_victim = `TRUE; end
  if(victim_addr[16] == rd_pc_reg[63:3] & victim_valid[16]) begin rd_data_victim = victim_data[16]; rd_valid_victim = `TRUE; end
  if(victim_addr[17] == rd_pc_reg[63:3] & victim_valid[17]) begin rd_data_victim = victim_data[17]; rd_valid_victim = `TRUE; end
  if(victim_addr[18] == rd_pc_reg[63:3] & victim_valid[18]) begin rd_data_victim = victim_data[18]; rd_valid_victim = `TRUE; end
  if(victim_addr[19] == rd_pc_reg[63:3] & victim_valid[19]) begin rd_data_victim = victim_data[19]; rd_valid_victim = `TRUE; end
  if(victim_addr[20] == rd_pc_reg[63:3] & victim_valid[20]) begin rd_data_victim = victim_data[20]; rd_valid_victim = `TRUE; end
  if(victim_addr[21] == rd_pc_reg[63:3] & victim_valid[21]) begin rd_data_victim = victim_data[21]; rd_valid_victim = `TRUE; end
  if(victim_addr[22] == rd_pc_reg[63:3] & victim_valid[22]) begin rd_data_victim = victim_data[22]; rd_valid_victim = `TRUE; end
  if(victim_addr[23] == rd_pc_reg[63:3] & victim_valid[23]) begin rd_data_victim = victim_data[23]; rd_valid_victim = `TRUE; end
  if(victim_addr[24] == rd_pc_reg[63:3] & victim_valid[24]) begin rd_data_victim = victim_data[24]; rd_valid_victim = `TRUE; end
  if(victim_addr[25] == rd_pc_reg[63:3] & victim_valid[25]) begin rd_data_victim = victim_data[25]; rd_valid_victim = `TRUE; end
  if(victim_addr[26] == rd_pc_reg[63:3] & victim_valid[26]) begin rd_data_victim = victim_data[26]; rd_valid_victim = `TRUE; end
  if(victim_addr[27] == rd_pc_reg[63:3] & victim_valid[27]) begin rd_data_victim = victim_data[27]; rd_valid_victim = `TRUE; end
  if(victim_addr[28] == rd_pc_reg[63:3] & victim_valid[28]) begin rd_data_victim = victim_data[28]; rd_valid_victim = `TRUE; end
  if(victim_addr[29] == rd_pc_reg[63:3] & victim_valid[29]) begin rd_data_victim = victim_data[29]; rd_valid_victim = `TRUE; end
  if(victim_addr[30] == rd_pc_reg[63:3] & victim_valid[30]) begin rd_data_victim = victim_data[30]; rd_valid_victim = `TRUE; end
  if(victim_addr[31] == rd_pc_reg[63:3] & victim_valid[31]) begin rd_data_victim = victim_data[31]; rd_valid_victim = `TRUE; end
  if(victim_addr[32] == rd_pc_reg[63:3] & victim_valid[32]) begin rd_data_victim = victim_data[32]; rd_valid_victim = `TRUE; end
  if(victim_addr[33] == rd_pc_reg[63:3] & victim_valid[33]) begin rd_data_victim = victim_data[33]; rd_valid_victim = `TRUE; end
  if(victim_addr[34] == rd_pc_reg[63:3] & victim_valid[34]) begin rd_data_victim = victim_data[34]; rd_valid_victim = `TRUE; end
  if(victim_addr[35] == rd_pc_reg[63:3] & victim_valid[35]) begin rd_data_victim = victim_data[35]; rd_valid_victim = `TRUE; end
  if(victim_addr[36] == rd_pc_reg[63:3] & victim_valid[36]) begin rd_data_victim = victim_data[36]; rd_valid_victim = `TRUE; end
  if(victim_addr[37] == rd_pc_reg[63:3] & victim_valid[37]) begin rd_data_victim = victim_data[37]; rd_valid_victim = `TRUE; end
  if(victim_addr[38] == rd_pc_reg[63:3] & victim_valid[38]) begin rd_data_victim = victim_data[38]; rd_valid_victim = `TRUE; end
  if(victim_addr[39] == rd_pc_reg[63:3] & victim_valid[39]) begin rd_data_victim = victim_data[39]; rd_valid_victim = `TRUE; end
  if(victim_addr[40] == rd_pc_reg[63:3] & victim_valid[40]) begin rd_data_victim = victim_data[40]; rd_valid_victim = `TRUE; end
  if(victim_addr[41] == rd_pc_reg[63:3] & victim_valid[41]) begin rd_data_victim = victim_data[41]; rd_valid_victim = `TRUE; end
  if(victim_addr[42] == rd_pc_reg[63:3] & victim_valid[42]) begin rd_data_victim = victim_data[42]; rd_valid_victim = `TRUE; end
  if(victim_addr[43] == rd_pc_reg[63:3] & victim_valid[43]) begin rd_data_victim = victim_data[43]; rd_valid_victim = `TRUE; end
  if(victim_addr[44] == rd_pc_reg[63:3] & victim_valid[44]) begin rd_data_victim = victim_data[44]; rd_valid_victim = `TRUE; end
  if(victim_addr[45] == rd_pc_reg[63:3] & victim_valid[45]) begin rd_data_victim = victim_data[45]; rd_valid_victim = `TRUE; end
  if(victim_addr[46] == rd_pc_reg[63:3] & victim_valid[46]) begin rd_data_victim = victim_data[46]; rd_valid_victim = `TRUE; end
  if(victim_addr[47] == rd_pc_reg[63:3] & victim_valid[47]) begin rd_data_victim = victim_data[47]; rd_valid_victim = `TRUE; end
  if(victim_addr[48] == rd_pc_reg[63:3] & victim_valid[48]) begin rd_data_victim = victim_data[48]; rd_valid_victim = `TRUE; end
  if(victim_addr[49] == rd_pc_reg[63:3] & victim_valid[49]) begin rd_data_victim = victim_data[49]; rd_valid_victim = `TRUE; end
  if(victim_addr[50] == rd_pc_reg[63:3] & victim_valid[50]) begin rd_data_victim = victim_data[50]; rd_valid_victim = `TRUE; end
  if(victim_addr[51] == rd_pc_reg[63:3] & victim_valid[51]) begin rd_data_victim = victim_data[51]; rd_valid_victim = `TRUE; end
  if(victim_addr[52] == rd_pc_reg[63:3] & victim_valid[52]) begin rd_data_victim = victim_data[52]; rd_valid_victim = `TRUE; end
  if(victim_addr[53] == rd_pc_reg[63:3] & victim_valid[53]) begin rd_data_victim = victim_data[53]; rd_valid_victim = `TRUE; end
  if(victim_addr[54] == rd_pc_reg[63:3] & victim_valid[54]) begin rd_data_victim = victim_data[54]; rd_valid_victim = `TRUE; end
  if(victim_addr[55] == rd_pc_reg[63:3] & victim_valid[55]) begin rd_data_victim = victim_data[55]; rd_valid_victim = `TRUE; end
  if(victim_addr[56] == rd_pc_reg[63:3] & victim_valid[56]) begin rd_data_victim = victim_data[56]; rd_valid_victim = `TRUE; end
  if(victim_addr[57] == rd_pc_reg[63:3] & victim_valid[57]) begin rd_data_victim = victim_data[57]; rd_valid_victim = `TRUE; end
  if(victim_addr[58] == rd_pc_reg[63:3] & victim_valid[58]) begin rd_data_victim = victim_data[58]; rd_valid_victim = `TRUE; end
  if(victim_addr[59] == rd_pc_reg[63:3] & victim_valid[59]) begin rd_data_victim = victim_data[59]; rd_valid_victim = `TRUE; end
  if(victim_addr[60] == rd_pc_reg[63:3] & victim_valid[60]) begin rd_data_victim = victim_data[60]; rd_valid_victim = `TRUE; end
  if(victim_addr[61] == rd_pc_reg[63:3] & victim_valid[61]) begin rd_data_victim = victim_data[61]; rd_valid_victim = `TRUE; end
  if(victim_addr[62] == rd_pc_reg[63:3] & victim_valid[62]) begin rd_data_victim = victim_data[62]; rd_valid_victim = `TRUE; end
  if(victim_addr[63] == rd_pc_reg[63:3] & victim_valid[63]) begin rd_data_victim = victim_data[63]; rd_valid_victim = `TRUE; end
end

endmodule
