`timescale 1ns/100ps

module archMap(// Inputs
               clock,
               reset,
               arch_wr_idx_1,   // rob Told
               arch_wr_idx_2,
               arch_wr_in_1,    // rob T 
               arch_wr_in_2,
               arch_wr_en_1,
               arch_wr_en_2,

               // Output: testbench
               arch_idx_out_1,
               arch_idx_out_2
              );

  input        reset;
  input        clock;
  input  [5:0] arch_wr_idx_1;
  input  [5:0] arch_wr_idx_2;
  input  [5:0] arch_wr_in_1;
  input  [5:0] arch_wr_in_2;
  input        arch_wr_en_1;
  input        arch_wr_en_2;

  output [4:0] arch_idx_out_1;
  output [4:0] arch_idx_out_2;

  reg    [4:0] arch_idx_out_1;
  reg    [4:0] arch_idx_out_2;
  reg    [5:0] reg_tag[0:31];
  reg    [5:0] next_reg_tag[0:30];

  always @*
  begin
      arch_idx_out_1  = 6'd32;
      if(arch_wr_idx_1 == reg_tag[0]) arch_idx_out_1  = 5'd0;
      if(arch_wr_idx_1 == reg_tag[1]) arch_idx_out_1  = 5'd1;
      if(arch_wr_idx_1 == reg_tag[2]) arch_idx_out_1  = 5'd2;
      if(arch_wr_idx_1 == reg_tag[3]) arch_idx_out_1  = 5'd3;
      if(arch_wr_idx_1 == reg_tag[4]) arch_idx_out_1  = 5'd4;
      if(arch_wr_idx_1 == reg_tag[5]) arch_idx_out_1  = 5'd5;
      if(arch_wr_idx_1 == reg_tag[6]) arch_idx_out_1  = 5'd6;
      if(arch_wr_idx_1 == reg_tag[7]) arch_idx_out_1  = 5'd7;
      if(arch_wr_idx_1 == reg_tag[8]) arch_idx_out_1  = 5'd8;
      if(arch_wr_idx_1 == reg_tag[9]) arch_idx_out_1  = 5'd9;
      if(arch_wr_idx_1 == reg_tag[10]) arch_idx_out_1  = 5'd10;
      if(arch_wr_idx_1 == reg_tag[11]) arch_idx_out_1  = 5'd11;
      if(arch_wr_idx_1 == reg_tag[12]) arch_idx_out_1  = 5'd12;
      if(arch_wr_idx_1 == reg_tag[13]) arch_idx_out_1  = 5'd13;
      if(arch_wr_idx_1 == reg_tag[14]) arch_idx_out_1  = 5'd14;
      if(arch_wr_idx_1 == reg_tag[15]) arch_idx_out_1  = 5'd15;
      if(arch_wr_idx_1 == reg_tag[16]) arch_idx_out_1  = 5'd16;
      if(arch_wr_idx_1 == reg_tag[17]) arch_idx_out_1  = 5'd17;
      if(arch_wr_idx_1 == reg_tag[18]) arch_idx_out_1  = 5'd18;
      if(arch_wr_idx_1 == reg_tag[19]) arch_idx_out_1  = 5'd19;
      if(arch_wr_idx_1 == reg_tag[20]) arch_idx_out_1  = 5'd20;
      if(arch_wr_idx_1 == reg_tag[21]) arch_idx_out_1  = 5'd21;
      if(arch_wr_idx_1 == reg_tag[22]) arch_idx_out_1  = 5'd22;
      if(arch_wr_idx_1 == reg_tag[23]) arch_idx_out_1  = 5'd23;
      if(arch_wr_idx_1 == reg_tag[24]) arch_idx_out_1  = 5'd24;
      if(arch_wr_idx_1 == reg_tag[25]) arch_idx_out_1  = 5'd25;
      if(arch_wr_idx_1 == reg_tag[26]) arch_idx_out_1  = 5'd26;
      if(arch_wr_idx_1 == reg_tag[27]) arch_idx_out_1  = 5'd27;
      if(arch_wr_idx_1 == reg_tag[28]) arch_idx_out_1  = 5'd28;
      if(arch_wr_idx_1 == reg_tag[29]) arch_idx_out_1  = 5'd29;
      if(arch_wr_idx_1 == reg_tag[30]) arch_idx_out_1  = 5'd30;
      if(arch_wr_idx_1 == reg_tag[31]) arch_idx_out_1  = 5'd31;

      arch_idx_out_2  = 6'd32;
      if(arch_wr_idx_2 == reg_tag[0]) arch_idx_out_2  = 5'd0;
      if(arch_wr_idx_2 == reg_tag[1]) arch_idx_out_2  = 5'd1;
      if(arch_wr_idx_2 == reg_tag[2]) arch_idx_out_2  = 5'd2;
      if(arch_wr_idx_2 == reg_tag[3]) arch_idx_out_2  = 5'd3;
      if(arch_wr_idx_2 == reg_tag[4]) arch_idx_out_2  = 5'd4;
      if(arch_wr_idx_2 == reg_tag[5]) arch_idx_out_2  = 5'd5;
      if(arch_wr_idx_2 == reg_tag[6]) arch_idx_out_2  = 5'd6;
      if(arch_wr_idx_2 == reg_tag[7]) arch_idx_out_2  = 5'd7;
      if(arch_wr_idx_2 == reg_tag[8]) arch_idx_out_2  = 5'd8;
      if(arch_wr_idx_2 == reg_tag[9]) arch_idx_out_2  = 5'd9;
      if(arch_wr_idx_2 == reg_tag[10]) arch_idx_out_2  = 5'd10;
      if(arch_wr_idx_2 == reg_tag[11]) arch_idx_out_2  = 5'd11;
      if(arch_wr_idx_2 == reg_tag[12]) arch_idx_out_2  = 5'd12;
      if(arch_wr_idx_2 == reg_tag[13]) arch_idx_out_2  = 5'd13;
      if(arch_wr_idx_2 == reg_tag[14]) arch_idx_out_2  = 5'd14;
      if(arch_wr_idx_2 == reg_tag[15]) arch_idx_out_2  = 5'd15;
      if(arch_wr_idx_2 == reg_tag[16]) arch_idx_out_2  = 5'd16;
      if(arch_wr_idx_2 == reg_tag[17]) arch_idx_out_2  = 5'd17;
      if(arch_wr_idx_2 == reg_tag[18]) arch_idx_out_2  = 5'd18;
      if(arch_wr_idx_2 == reg_tag[19]) arch_idx_out_2  = 5'd19;
      if(arch_wr_idx_2 == reg_tag[20]) arch_idx_out_2  = 5'd20;
      if(arch_wr_idx_2 == reg_tag[21]) arch_idx_out_2  = 5'd21;
      if(arch_wr_idx_2 == reg_tag[22]) arch_idx_out_2  = 5'd22;
      if(arch_wr_idx_2 == reg_tag[23]) arch_idx_out_2  = 5'd23;
      if(arch_wr_idx_2 == reg_tag[24]) arch_idx_out_2  = 5'd24;
      if(arch_wr_idx_2 == reg_tag[25]) arch_idx_out_2  = 5'd25;
      if(arch_wr_idx_2 == reg_tag[26]) arch_idx_out_2  = 5'd26;
      if(arch_wr_idx_2 == reg_tag[27]) arch_idx_out_2  = 5'd27;
      if(arch_wr_idx_2 == reg_tag[28]) arch_idx_out_2  = 5'd28;
      if(arch_wr_idx_2 == reg_tag[29]) arch_idx_out_2  = 5'd29;
      if(arch_wr_idx_2 == reg_tag[30]) arch_idx_out_2  = 5'd30;
      if(arch_wr_idx_2 == reg_tag[31]) arch_idx_out_2  = 5'd31;
      if(arch_wr_idx_2 == arch_wr_in_1) arch_idx_out_2 = arch_idx_out_1;
  end

  always @*
  begin
    next_reg_tag[0]   = reg_tag[0];
    next_reg_tag[1]   = reg_tag[1];
    next_reg_tag[2]   = reg_tag[2];
    next_reg_tag[3]   = reg_tag[3];
    next_reg_tag[4]   = reg_tag[4];
    next_reg_tag[5]   = reg_tag[5];
    next_reg_tag[6]   = reg_tag[6];
    next_reg_tag[7]   = reg_tag[7];
    next_reg_tag[8]   = reg_tag[8];
    next_reg_tag[9]   = reg_tag[9];
    next_reg_tag[10]  = reg_tag[10];
    next_reg_tag[11]  = reg_tag[11];
    next_reg_tag[12]  = reg_tag[12];
    next_reg_tag[13]  = reg_tag[13];
    next_reg_tag[14]  = reg_tag[14];
    next_reg_tag[15]  = reg_tag[15];
    next_reg_tag[16]  = reg_tag[16];
    next_reg_tag[17]  = reg_tag[17];
    next_reg_tag[18]  = reg_tag[18];
    next_reg_tag[19]  = reg_tag[19];
    next_reg_tag[20]  = reg_tag[20];
    next_reg_tag[21]  = reg_tag[21];
    next_reg_tag[22]  = reg_tag[22];
    next_reg_tag[23]  = reg_tag[23];
    next_reg_tag[24]  = reg_tag[24];
    next_reg_tag[25]  = reg_tag[25];
    next_reg_tag[26]  = reg_tag[26];
    next_reg_tag[27]  = reg_tag[27];
    next_reg_tag[28]  = reg_tag[28];
    next_reg_tag[29]  = reg_tag[29];
    next_reg_tag[30]  = reg_tag[30];
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[0]==arch_wr_idx_1)    next_reg_tag[0]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[0]==arch_wr_idx_2)                  next_reg_tag[0]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[0]==arch_wr_idx_1)                  next_reg_tag[0]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[1]==arch_wr_idx_1)    next_reg_tag[1]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[1]==arch_wr_idx_2)                  next_reg_tag[1]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[1]==arch_wr_idx_1)                  next_reg_tag[1]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[2]==arch_wr_idx_1)    next_reg_tag[2]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[2]==arch_wr_idx_2)                  next_reg_tag[2]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[2]==arch_wr_idx_1)                  next_reg_tag[2]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[3]==arch_wr_idx_1)    next_reg_tag[3]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[3]==arch_wr_idx_2)                  next_reg_tag[3]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[3]==arch_wr_idx_1)                  next_reg_tag[3]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[4]==arch_wr_idx_1)    next_reg_tag[4]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[4]==arch_wr_idx_2)                  next_reg_tag[4]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[4]==arch_wr_idx_1)                  next_reg_tag[4]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[5]==arch_wr_idx_1)    next_reg_tag[5]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[5]==arch_wr_idx_2)                  next_reg_tag[5]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[5]==arch_wr_idx_1)                  next_reg_tag[5]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[6]==arch_wr_idx_1)    next_reg_tag[6]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[6]==arch_wr_idx_2)                  next_reg_tag[6]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[6]==arch_wr_idx_1)                  next_reg_tag[6]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[7]==arch_wr_idx_1)    next_reg_tag[7]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[7]==arch_wr_idx_2)                  next_reg_tag[7]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[7]==arch_wr_idx_1)                  next_reg_tag[7]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[8]==arch_wr_idx_1)    next_reg_tag[8]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[8]==arch_wr_idx_2)                  next_reg_tag[8]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[8]==arch_wr_idx_1)                  next_reg_tag[8]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[9]==arch_wr_idx_1)    next_reg_tag[9]   = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[9]==arch_wr_idx_2)                  next_reg_tag[9]   = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[9]==arch_wr_idx_1)                  next_reg_tag[9]   = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[10]==arch_wr_idx_1)    next_reg_tag[10]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[10]==arch_wr_idx_2)                 next_reg_tag[10]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[10]==arch_wr_idx_1)                 next_reg_tag[10]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[11]==arch_wr_idx_1)    next_reg_tag[11]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[11]==arch_wr_idx_2)                 next_reg_tag[11]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[11]==arch_wr_idx_1)                 next_reg_tag[11]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[12]==arch_wr_idx_1)    next_reg_tag[12]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[12]==arch_wr_idx_2)                 next_reg_tag[12]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[12]==arch_wr_idx_1)                 next_reg_tag[12]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[13]==arch_wr_idx_1)    next_reg_tag[13]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[13]==arch_wr_idx_2)                 next_reg_tag[13]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[13]==arch_wr_idx_1)                 next_reg_tag[13]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[14]==arch_wr_idx_1)    next_reg_tag[14]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[14]==arch_wr_idx_2)                 next_reg_tag[14]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[14]==arch_wr_idx_1)                 next_reg_tag[14]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[15]==arch_wr_idx_1)    next_reg_tag[15]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[15]==arch_wr_idx_2)                 next_reg_tag[15]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[15]==arch_wr_idx_1)                 next_reg_tag[15]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[16]==arch_wr_idx_1)    next_reg_tag[16]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[16]==arch_wr_idx_2)                 next_reg_tag[16]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[16]==arch_wr_idx_1)                 next_reg_tag[16]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[17]==arch_wr_idx_1)    next_reg_tag[17]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[17]==arch_wr_idx_2)                 next_reg_tag[17]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[17]==arch_wr_idx_1)                 next_reg_tag[17]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[18]==arch_wr_idx_1)    next_reg_tag[18]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[18]==arch_wr_idx_2)                 next_reg_tag[18]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[18]==arch_wr_idx_1)                 next_reg_tag[18]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[19]==arch_wr_idx_1)    next_reg_tag[19]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[19]==arch_wr_idx_2)                 next_reg_tag[19]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[19]==arch_wr_idx_1)                 next_reg_tag[19]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[20]==arch_wr_idx_1)    next_reg_tag[20]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[20]==arch_wr_idx_2)                 next_reg_tag[20]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[20]==arch_wr_idx_1)                 next_reg_tag[20]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[21]==arch_wr_idx_1)    next_reg_tag[21]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[21]==arch_wr_idx_2)                 next_reg_tag[21]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[21]==arch_wr_idx_1)                 next_reg_tag[21]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[22]==arch_wr_idx_1)    next_reg_tag[22]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[22]==arch_wr_idx_2)                 next_reg_tag[22]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[22]==arch_wr_idx_1)                 next_reg_tag[22]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[23]==arch_wr_idx_1)    next_reg_tag[23]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[23]==arch_wr_idx_2)                 next_reg_tag[23]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[23]==arch_wr_idx_1)                 next_reg_tag[23]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[24]==arch_wr_idx_1)    next_reg_tag[24]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[24]==arch_wr_idx_2)                 next_reg_tag[24]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[24]==arch_wr_idx_1)                 next_reg_tag[24]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[25]==arch_wr_idx_1)    next_reg_tag[25]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[25]==arch_wr_idx_2)                 next_reg_tag[25]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[25]==arch_wr_idx_1)                 next_reg_tag[25]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[26]==arch_wr_idx_1)    next_reg_tag[26]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[26]==arch_wr_idx_2)                 next_reg_tag[26]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[26]==arch_wr_idx_1)                 next_reg_tag[26]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[27]==arch_wr_idx_1)    next_reg_tag[27]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[27]==arch_wr_idx_2)                 next_reg_tag[27]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[27]==arch_wr_idx_1)                 next_reg_tag[27]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[28]==arch_wr_idx_1)    next_reg_tag[28]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[28]==arch_wr_idx_2)                 next_reg_tag[28]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[28]==arch_wr_idx_1)                 next_reg_tag[28]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[29]==arch_wr_idx_1)    next_reg_tag[29]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[29]==arch_wr_idx_2)                 next_reg_tag[29]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[29]==arch_wr_idx_1)                 next_reg_tag[29]  = arch_wr_in_1;
    if(arch_wr_en_1 && arch_wr_en_2 && arch_wr_in_1==arch_wr_idx_2 && reg_tag[30]==arch_wr_idx_1)    next_reg_tag[30]  = arch_wr_in_2;
    else if(arch_wr_en_2 && reg_tag[30]==arch_wr_idx_2)                 next_reg_tag[30]  = arch_wr_in_2;
    else if(arch_wr_en_1 && reg_tag[30]==arch_wr_idx_1)                 next_reg_tag[30]  = arch_wr_in_1;
  end

  always @(posedge clock)
  begin
    if(reset) begin
      reg_tag[0]  <= `SD `REG_00;
      reg_tag[1]  <= `SD `REG_01;
      reg_tag[2]  <= `SD `REG_02;
      reg_tag[3]  <= `SD `REG_03;
      reg_tag[4]  <= `SD `REG_04;
      reg_tag[5]  <= `SD `REG_05;
      reg_tag[6]  <= `SD `REG_06;
      reg_tag[7]  <= `SD `REG_07;
      reg_tag[8]  <= `SD `REG_08;
      reg_tag[9]  <= `SD `REG_09;
      reg_tag[10] <= `SD `REG_10;
      reg_tag[11] <= `SD `REG_11;
      reg_tag[12] <= `SD `REG_12;
      reg_tag[13] <= `SD `REG_13;
      reg_tag[14] <= `SD `REG_14;
      reg_tag[15] <= `SD `REG_15;
      reg_tag[16] <= `SD `REG_16;
      reg_tag[17] <= `SD `REG_17;
      reg_tag[18] <= `SD `REG_18;
      reg_tag[19] <= `SD `REG_19;
      reg_tag[20] <= `SD `REG_20;
      reg_tag[21] <= `SD `REG_21;
      reg_tag[22] <= `SD `REG_22;
      reg_tag[23] <= `SD `REG_23;
      reg_tag[24] <= `SD `REG_24;
      reg_tag[25] <= `SD `REG_25;
      reg_tag[26] <= `SD `REG_26;
      reg_tag[27] <= `SD `REG_27;
      reg_tag[28] <= `SD `REG_28;
      reg_tag[29] <= `SD `REG_29;
      reg_tag[30] <= `SD `REG_30;
      reg_tag[31] <= `SD `ZERO_REG;
    end
    else begin 
      reg_tag[0]  <= `SD next_reg_tag[0];
      reg_tag[1]  <= `SD next_reg_tag[1];
      reg_tag[2]  <= `SD next_reg_tag[2];
      reg_tag[3]  <= `SD next_reg_tag[3];
      reg_tag[4]  <= `SD next_reg_tag[4];
      reg_tag[5]  <= `SD next_reg_tag[5];
      reg_tag[6]  <= `SD next_reg_tag[6];
      reg_tag[7]  <= `SD next_reg_tag[7];
      reg_tag[8]  <= `SD next_reg_tag[8];
      reg_tag[9]  <= `SD next_reg_tag[9];
      reg_tag[10] <= `SD next_reg_tag[10];
      reg_tag[11] <= `SD next_reg_tag[11];
      reg_tag[12] <= `SD next_reg_tag[12];
      reg_tag[13] <= `SD next_reg_tag[13];
      reg_tag[14] <= `SD next_reg_tag[14];
      reg_tag[15] <= `SD next_reg_tag[15];
      reg_tag[16] <= `SD next_reg_tag[16];
      reg_tag[17] <= `SD next_reg_tag[17];
      reg_tag[18] <= `SD next_reg_tag[18];
      reg_tag[19] <= `SD next_reg_tag[19];
      reg_tag[20] <= `SD next_reg_tag[20];
      reg_tag[21] <= `SD next_reg_tag[21];
      reg_tag[22] <= `SD next_reg_tag[22];
      reg_tag[23] <= `SD next_reg_tag[23];
      reg_tag[24] <= `SD next_reg_tag[24];
      reg_tag[25] <= `SD next_reg_tag[25];
      reg_tag[26] <= `SD next_reg_tag[26];
      reg_tag[27] <= `SD next_reg_tag[27];
      reg_tag[28] <= `SD next_reg_tag[28];
      reg_tag[29] <= `SD next_reg_tag[29];
      reg_tag[30] <= `SD next_reg_tag[30];
      reg_tag[31] <= `SD `ZERO_REG;
    end
  end

endmodule
