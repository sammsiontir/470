/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  BTB                                                 //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps
`define NULL_PC 64'hFFFF_FFFF_FFFF_FFFF
module BTB    (// Inputs
		clock,
		reset,
		PC1_input,
		PC2_input,
		PC1_en,                           //new
		PC2_en,                           //new
		PC1_BTB_branch, //sent by pre-decoder to show if PC1 is branch
		PC2_BTB_branch, //sent by pre-decoder to show if PC2 is branch
		ex_BTB_branch,        //sent from ex, 1 if it's a branch
		ex_BTB_alu_result,//sent from ex
		ex_BTB_NPC,//sent from ex

		// Outputs
		BTB_nextPC_targetPC1,
		BTB_nextPC_targetPC2,
		BTB_nextPC_target_en1,
		BTB_nextPC_target_en2
              		);
//[6:2] to the index
//[14:7] to the tag
//need 16 rows for each cache
input	     clock;
input	     reset;
input [63:0] PC1_input; //the input of PC to check if it is a branch
input [63:0] PC2_input;
input        PC1_en;
input        PC2_en;
input	     PC1_BTB_branch;
input  	     PC2_BTB_branch;
input	     ex_BTB_branch;
input [63:0] ex_BTB_alu_result;
input [63:0] ex_BTB_NPC;//sent from ex

output[63:0] BTB_nextPC_targetPC1;
output[63:0] BTB_nextPC_targetPC2;
output       BTB_nextPC_target_en1;
output       BTB_nextPC_target_en2;





reg   [63:0]cache_target_PC [0:31];
reg   [7:0] cache_tag [0:31];
reg         cache_valid [0:31];


wire [4:0]  index;
wire [63:0] ex_BTB_PC;
assign ex_BTB_PC = ex_BTB_NPC-64'd4;

assign index = ex_BTB_PC[6:2];





//next target PC. If there exists data in cache AND pre-decoder detects a branch, then use them, else output NULL_PC
assign BTB_nextPC_targetPC1 = (cache_tag[PC1_input[6:2]] == PC1_input[14:7] & PC1_BTB_branch && PC1_en)? 
	cache_target_PC[PC1_input[6:2]] : `NULL_PC;
assign BTB_nextPC_targetPC2 = (cache_tag[PC2_input[6:2]] == PC2_input[14:7] & PC2_BTB_branch && PC2_en)? 
	cache_target_PC[PC2_input[6:2]] : `NULL_PC;
//next target enable. The same method as target PC
assign BTB_nextPC_target_en1 = (cache_valid[PC1_input[6:2]]&&(cache_tag[PC1_input[6:2]] == PC1_input[14:7]) && PC1_BTB_branch && PC1_en)? 1'b1 : 1'b0;
assign BTB_nextPC_target_en2 = (cache_valid[PC2_input[6:2]]&&(cache_tag[PC2_input[6:2]] == PC2_input[14:7]) && PC2_BTB_branch && PC2_en)? 1'b1 : 1'b0;


/////////////////////////
//        reset        //
/////////////////////////
always @(posedge clock)begin
if(reset)begin
cache_tag[0]	    <= `SD 8'd0;
cache_tag[1]	    <= `SD 8'd0;
cache_tag[2]	    <= `SD 8'd0;
cache_tag[3]	    <= `SD 8'd0;
cache_tag[4]	    <= `SD 8'd0;
cache_tag[5]	    <= `SD 8'd0;
cache_tag[6]	    <= `SD 8'd0;
cache_tag[7]	    <= `SD 8'd0;
cache_tag[8]	    <= `SD 8'd0;
cache_tag[9]	    <= `SD 8'd0;
cache_tag[10]	    <= `SD 8'd0;
cache_tag[11]	    <= `SD 8'd0;
cache_tag[12]	    <= `SD 8'd0;
cache_tag[13]	    <= `SD 8'd0;
cache_tag[14]	    <= `SD 8'd0;
cache_tag[15]	    <= `SD 8'd0;
cache_tag[16]	    <= `SD 8'd0;
cache_tag[17]	    <= `SD 8'd0;
cache_tag[18]	    <= `SD 8'd0;
cache_tag[19]	    <= `SD 8'd0;
cache_tag[20]	    <= `SD 8'd0;
cache_tag[21]	    <= `SD 8'd0;
cache_tag[22]	    <= `SD 8'd0;
cache_tag[23]	    <= `SD 8'd0;
cache_tag[24]	    <= `SD 8'd0;
cache_tag[25]	    <= `SD 8'd0;
cache_tag[26]	    <= `SD 8'd0;
cache_tag[27]	    <= `SD 8'd0;
cache_tag[28]	    <= `SD 8'd0;
cache_tag[29]	    <= `SD 8'd0;
cache_tag[30]	    <= `SD 8'd0;
cache_tag[31]	    <= `SD 8'd0;

cache_target_PC[0] <= `SD `NULL_PC;
cache_target_PC[1] <= `SD `NULL_PC;
cache_target_PC[2] <= `SD `NULL_PC;
cache_target_PC[3] <= `SD `NULL_PC;
cache_target_PC[4] <= `SD `NULL_PC;
cache_target_PC[5] <= `SD `NULL_PC;
cache_target_PC[6] <= `SD `NULL_PC;
cache_target_PC[7] <= `SD `NULL_PC;
cache_target_PC[8] <= `SD `NULL_PC;
cache_target_PC[9] <= `SD `NULL_PC;
cache_target_PC[10] <= `SD `NULL_PC;
cache_target_PC[11] <= `SD `NULL_PC;
cache_target_PC[12] <= `SD `NULL_PC;
cache_target_PC[13] <= `SD `NULL_PC;
cache_target_PC[14] <= `SD `NULL_PC;
cache_target_PC[15] <= `SD `NULL_PC;
cache_target_PC[16] <= `SD `NULL_PC;
cache_target_PC[17] <= `SD `NULL_PC;
cache_target_PC[18] <= `SD `NULL_PC;
cache_target_PC[19] <= `SD `NULL_PC;
cache_target_PC[20] <= `SD `NULL_PC;
cache_target_PC[21] <= `SD `NULL_PC;
cache_target_PC[22] <= `SD `NULL_PC;
cache_target_PC[23] <= `SD `NULL_PC;
cache_target_PC[24] <= `SD `NULL_PC;
cache_target_PC[25] <= `SD `NULL_PC;
cache_target_PC[26] <= `SD `NULL_PC;
cache_target_PC[27] <= `SD `NULL_PC;
cache_target_PC[28] <= `SD `NULL_PC;
cache_target_PC[29] <= `SD `NULL_PC;
cache_target_PC[30] <= `SD `NULL_PC;
cache_target_PC[31] <= `SD `NULL_PC;

cache_valid[0]  <= `SD 1'b0;
cache_valid[1]  <= `SD 1'b0;
cache_valid[2]  <= `SD 1'b0;
cache_valid[3]  <= `SD 1'b0;
cache_valid[4]  <= `SD 1'b0;
cache_valid[5]  <= `SD 1'b0;
cache_valid[6]  <= `SD 1'b0;
cache_valid[7]  <= `SD 1'b0;
cache_valid[8]  <= `SD 1'b0;
cache_valid[9]  <= `SD 1'b0;
cache_valid[10]  <= `SD 1'b0;
cache_valid[11]  <= `SD 1'b0;
cache_valid[12]  <= `SD 1'b0;
cache_valid[13]  <= `SD 1'b0;
cache_valid[14]  <= `SD 1'b0;
cache_valid[15]  <= `SD 1'b0;
cache_valid[16]  <= `SD 1'b0;
cache_valid[17]  <= `SD 1'b0;
cache_valid[18]  <= `SD 1'b0;
cache_valid[19]  <= `SD 1'b0;
cache_valid[20]  <= `SD 1'b0;
cache_valid[21]  <= `SD 1'b0;
cache_valid[22]  <= `SD 1'b0;
cache_valid[23]  <= `SD 1'b0;
cache_valid[24]  <= `SD 1'b0;
cache_valid[25]  <= `SD 1'b0;
cache_valid[26]  <= `SD 1'b0;
cache_valid[27]  <= `SD 1'b0;
cache_valid[28]  <= `SD 1'b0;
cache_valid[29]  <= `SD 1'b0;
cache_valid[30]  <= `SD 1'b0;
cache_valid[31]  <= `SD 1'b0;
end


//////////////////////////////////////
//  1st inst is branch   	    //
//  or 2 branches with same index   // it's a rare situation, assign to branch1
//////////////////////////////////////
else if(ex_BTB_branch)begin
cache_tag[index] 	<= `SD ex_BTB_PC[14:7];
cache_target_PC[index] <= `SD ex_BTB_alu_result;
cache_valid[index]	<= `SD 1'b1;
end//two branches


end//always


endmodule // module id_stage
