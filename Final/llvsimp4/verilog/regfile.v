/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  regfile.v   2-way superscalar                       //
//                                                                     //
//  Description :  This module creates the Regfile used by the ID and  // 
//                 WB Stages of the Pipeline.                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`define ZERO_REG    6'd31
`define SD #1
`timescale 1ns/100ps


module regfile(//input
               clock,
               rda1_idx,
               rda2_idx,
               rdb1_idx,
               rdb2_idx, 
               wr1_idx,
               wr2_idx, 
               wr1_data, 
               wr2_data, 
               wr1_en, 
               wr2_en, 


               //output
               rda1_out,
               rda2_out, 
               rdb1_out,
               rdb2_out
              ); 

  input   [5:0] rda1_idx, rdb1_idx, wr1_idx, wr2_idx;
  input   [5:0] rda2_idx, rdb2_idx;
  input  [63:0] wr1_data, wr2_data;
  input         wr1_en, wr2_en, clock;

  output [63:0] rda1_out, rdb1_out, rda2_out, rdb2_out;
  
  reg    [63:0] rda1_out, rdb1_out, rda2_out, rdb2_out;
  reg    [63:0] registers[63:0];   // 64, 64-bit Registers

  wire   [63:0] rda1_reg = registers[rda1_idx];
  wire   [63:0] rdb1_reg = registers[rdb1_idx];
  wire   [63:0] rda2_reg = registers[rda2_idx];
  wire   [63:0] rdb2_reg = registers[rdb2_idx];

  // Read port A1
  always @*
  begin
    if (rda1_idx == `ZERO_REG)                rda1_out = 0;
    else if (wr1_en && (wr1_idx == rda1_idx)) rda1_out = wr1_data;  // internal forwarding from wr1
    else if (wr2_en && (wr2_idx == rda1_idx)) rda1_out = wr2_data;  // internal forwarding from wr2
    else                                      rda1_out = rda1_reg;
  end

  // Read port B1
  always @*
  begin
    if (rdb1_idx == `ZERO_REG)                rdb1_out = 0;
    else if (wr1_en && (wr1_idx == rdb1_idx)) rdb1_out = wr1_data;  // internal forwarding from wr1
    else if (wr2_en && (wr2_idx == rdb1_idx)) rdb1_out = wr2_data;  // internal forwarding from wr2
    else                                      rdb1_out = rdb1_reg;
  end

  // Read port A2
  always @* 
  begin
    if (rda2_idx == `ZERO_REG)                rda2_out = 0;
    else if (wr1_en && (wr1_idx == rda2_idx)) rda2_out = wr1_data;  // internal forwarding from wr1
    else if (wr2_en && (wr2_idx == rda2_idx)) rda2_out = wr2_data;  // internal forwarding from wr2
    else                                      rda2_out = rda2_reg;
  end

  // Read port B2
  always @*
  begin
    if (rdb2_idx == `ZERO_REG)                rdb2_out = 0;
    else if (wr1_en && (wr1_idx == rdb2_idx)) rdb2_out = wr1_data;  // internal forwarding from wr1
    else if (wr2_en && (wr2_idx == rdb2_idx)) rdb2_out = wr2_data;  // internal forwarding from wr2
    else                                      rdb2_out = rdb2_reg;
  end

  // Write port
  always @(posedge clock)
  begin
    if(wr1_en) begin
      registers[wr1_idx] <= `SD wr1_data;
    end
    if(wr2_en) begin
      registers[wr2_idx] <= `SD wr2_data;
    end
  end
endmodule // regfile
