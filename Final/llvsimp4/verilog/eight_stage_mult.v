module single_stage_mult(clock, reset, 
                         product_in,  mplier_in,  mcand_in,  bmask_in,  inst_valid_in, dest_reg_in, NPC_in,
                         br_rec_en_1, br_rec_en_2, br_marker_1, br_marker_2, br_mispre_1, br_mispre_2,
                         product_out, mplier_out, mcand_out, bmask_out, inst_valid_out, dest_reg_out, NPC_out);
  
  input clock, reset, inst_valid_in;
  input [3:0]  bmask_in;
  input [63:0] product_in, mplier_in, mcand_in;
  input [5:0] dest_reg_in;
  input [63:0] NPC_in;
  input br_rec_en_1, br_rec_en_2;
  input [2:0] br_marker_1, br_marker_2;
  input br_mispre_1, br_mispre_2;

  output reg inst_valid_out;
  output reg [3:0]  bmask_out;
  output reg [63:0] mplier_out, mcand_out;
  output reg [5:0] dest_reg_out;
  output reg [63:0] NPC_out;
  output wire [63:0] product_out;

  reg  [63:0] prod_in_reg, partial_prod_reg;
  wire [63:0] partial_product, next_mplier, next_mcand;
  
  assign product_out = prod_in_reg + partial_prod_reg;

  assign partial_product = mplier_in[15:0] * mcand_in;

  assign next_mplier = {16'b0,mplier_in[63:16]};
  assign next_mcand = {mcand_in[47:0],16'b0};

  always @(posedge clock)
  begin
    prod_in_reg      <= #1 product_in;
    partial_prod_reg <= #1 partial_product;
    mplier_out       <= #1 next_mplier;
    mcand_out        <= #1 next_mcand;
  end

  reg next_inst_valid_out;
  reg [3:0] next_bmask_out;

  always@(*) begin
    next_inst_valid_out = inst_valid_in;
    next_bmask_out       = bmask_in;
    if( br_rec_en_1 & br_mispre_1 & bmask_in[br_marker_1] ) next_inst_valid_out = 0;
    else if( br_rec_en_2 & br_mispre_2 & bmask_in[br_marker_2] ) next_inst_valid_out = 0;
    if( br_rec_en_1 ) next_bmask_out[br_marker_1] = 0;
    if( br_rec_en_2 ) next_bmask_out[br_marker_2] = 0;
  end

  always@(posedge clock)
  begin
    if(reset) begin
      inst_valid_out <= `SD 1'b0;
      bmask_out      <= `SD 0;
      NPC_out        <= `SD 0;
      dest_reg_out   <= `SD `ZERO_REG;
    end
    else begin
      inst_valid_out <= `SD next_inst_valid_out;
      bmask_out      <= `SD next_bmask_out;
      NPC_out        <= `SD NPC_in;
      dest_reg_out   <= `SD dest_reg_in;
    end
  end

endmodule


module eight_stage_mult(clock, reset,
                        mplier, mcand, bmask_in, inst_valid_in, dest_reg_in, NPC_in,
                        br_rec_en_1, br_rec_en_2, br_marker_1, br_marker_2, br_mispre_1, br_mispre_2,
                        bmask_out, product, inst_valid_out, dest_reg_out, NPC_out);

  input clock, reset, inst_valid_in;
  input [5:0] dest_reg_in;
  input [63:0] NPC_in;
  input [3:0]  bmask_in;
  input [63:0] mcand, mplier;
  input br_rec_en_1, br_rec_en_2;
  input [2:0] br_marker_1, br_marker_2;
  input br_mispre_1, br_mispre_2;

  output [3:0]  bmask_out;
  output [63:0] product;
  output inst_valid_out;
  output [5:0] dest_reg_out;
  output [63:0] NPC_out;

  wire [63:0] mcand_out, mplier_out;
  wire [(3*4) -1:0] internal_bmask;
  wire [(3*6) -1:0] internal_dest_reg;
  wire [(3*64)-1:0] internal_products, internal_mcands, internal_mpliers, internal_NPC;
  wire [(3*1)- 1:0] internal_inst_valid_outs;
  
  single_stage_mult mstage [3:0] 
    (.clock(clock),
     .reset(reset),
     .product_in({internal_products,64'h0}),
     .mplier_in({internal_mpliers,mplier}),
     .mcand_in({internal_mcands,mcand}),
     .bmask_in({internal_bmask, bmask_in}),
     .inst_valid_in({internal_inst_valid_outs,inst_valid_in}),
     .dest_reg_in({internal_dest_reg, dest_reg_in}),
     .NPC_in({internal_NPC, NPC_in}),
     .br_rec_en_1(br_rec_en_1),
     .br_rec_en_2(br_rec_en_2),
     .br_marker_1(br_marker_1),
     .br_marker_2(br_marker_2),
     .br_mispre_1(br_mispre_1),
     .br_mispre_2(br_mispre_2),

     .product_out({product,internal_products}),
     .mplier_out({mplier_out,internal_mpliers}),
     .mcand_out({mcand_out,internal_mcands}),
     .bmask_out({bmask_out, internal_bmask}),
     .inst_valid_out({inst_valid_out,internal_inst_valid_outs}),
     .dest_reg_out({dest_reg_out, internal_dest_reg}),
     .NPC_out({NPC_out, internal_NPC})
    );

endmodule
