// cachemem128x64

`timescale 1ns/100ps

`define SD #1

module icachemem(// inputs
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
output wire        rd_valid;

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

assign wr_pc_tag = wr_pc_reg[63:9];
assign wr_pc_idx = wr_pc_reg[8:3];
assign wb_pc_tag = wb_pc_reg[63:9];
assign wb_pc_idx = wb_pc_reg[8:3];
assign rd_pc_tag = rd_pc_reg[63:9];
assign rd_pc_idx = rd_pc_reg[8:3];

wire data_in_1 = ((tags_1[rd_pc_idx] == rd_pc_tag) & valid_1[rd_pc_idx]);
wire data_in_2 = ((tags_2[rd_pc_idx] == rd_pc_tag) & valid_2[rd_pc_idx]);
assign rd_valid = data_in_1 | data_in_2;
assign rd_data  = data_in_1 ? lines_1[rd_pc_idx]:
                  data_in_2 ? lines_2[rd_pc_idx]:
                  64'd0;

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
    if(wr2way1[wr_pc_idx] == 0) begin
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

endmodule
