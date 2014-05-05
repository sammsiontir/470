/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  Dirp.v                                              //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps
`define NULL_PC 64'hFFFF_FFFF_FFFF_FFFF
module Dirp  (// Inputs
		clock,
		reset,
		PC1_input,
		PC2_input,
		PC1_en,                           //new
		PC2_en,                           //new
		PC1_Dirp_cond,  //sent by pre-decoder to show if PC1 is conditional
		PC2_Dirp_cond,  //sent by pre-decoder to show if PC2 is conditional
		ex_Dirp_cond,   //correct enable
		ex_Dirp_T,      //correct taken/not taken, 1 means taken, 0 means not taken
		ex_BTB_NPC,

		// Outputs
		Dirp_T1,// combine with BTB to make prediction, send with instruction
		Dirp_T2 // combine with BTB to make prediction, send with instruction
              	);

input	      clock;
input	      reset;
input [63:0]  PC1_input;
input [63:0]  PC2_input;
input         PC1_en;
input         PC2_en;
input	      PC1_Dirp_cond;
input	      PC2_Dirp_cond;
input         ex_Dirp_cond;
input	      ex_Dirp_T;
input [63:0]  ex_BTB_NPC;



output	      Dirp_T1; // 0 for not taken, 1 for taken
output	      Dirp_T2; // 0 for not taken, 1 for taken

reg   [7:0]   Global_BHR;
reg   [255:0] PHT;
reg   [7:0]   HISTORY_BHR_XOR[0:31];
reg   [31:0]   HISTORY_valid;

wire   [7:0]   next_Global_BHR1;
wire   [7:0]   next_Global_BHR2;
wire   [7:0]   next_Global_BHR2_special;
wire   [7:0]   BHR_XOR1;
wire   [7:0]   BHR_XOR2;
wire   [7:0]   BHR_XOR2_special;
wire   [4:0]  PC1_input_plus4;
wire   [4:0]  PC2_input_plus4;


assign Dirp_T1 = PHT[PC1_input[9:2] ^ Global_BHR];
assign Dirp_T2 = (PC1_Dirp_cond)? PHT[PC2_input[9:2] ^ {Global_BHR[6:0],PHT[PC1_input[9:2] ^ Global_BHR]}] : PHT[PC2_input[9:2] ^ Global_BHR];
assign next_Global_BHR1 = {Global_BHR[6:0], PHT[PC1_input[9:2] ^ Global_BHR]};
assign next_Global_BHR2 = {Global_BHR[6:0], PHT[PC2_input[9:2] ^ Global_BHR]};
assign next_Global_BHR2_special = {Global_BHR[5:0], PHT[PC1_input[9:2] ^ Global_BHR], PHT[PC2_input[9:2] ^ Global_BHR]};
assign BHR_XOR1 = PC1_input[9:2] ^ Global_BHR;
assign BHR_XOR2 = PC2_input[9:2] ^ Global_BHR;
assign BHR_XOR2_special = {Global_BHR[6:0], PHT[PC1_input[9:2] ^ Global_BHR]};
assign PC1_input_plus4 = PC1_input[6:2] + 5'd1;
assign PC2_input_plus4 = PC2_input[6:2] + 5'd1;


always @(posedge clock)begin // HISTORY

//////////////
//  reset   //
//////////////
if(reset)begin
Global_BHR       <= `SD 8'd0;
PHT              <= `SD 256'h0;
HISTORY_valid    <= `SD 8'd0;
end//reset


else begin//not reset


///////////////////////////////////
// IF:there's conditional branch //
///////////////////////////////////

if(PC1_Dirp_cond && PC1_en)begin//when PC1 is cond branch, write to GBHR
	Global_BHR	<= `SD next_Global_BHR1;
	HISTORY_BHR_XOR[PC1_input_plus4]<= `SD BHR_XOR1;
	HISTORY_valid[PC1_input_plus4]  <= `SD 1'b1;
end//PC1 is branch
else if(PC2_Dirp_cond && PC2_en)begin//only PC2 is cond branch, write to GBHR (PC1 is not branch)
	Global_BHR	<= `SD next_Global_BHR2;
	HISTORY_BHR_XOR[PC2_input_plus4]<= `SD BHR_XOR2;
	HISTORY_valid[PC2_input_plus4]  <= `SD 1'b1;
end//only 2nd is cond branch
end


//////////////////////////////
// EX: there's cond branch  //
//////////////////////////////
//May need to change PHT

if(ex_Dirp_cond &&  HISTORY_valid[ex_BTB_NPC[6:2]])begin//PC is cond branch
PHT[HISTORY_BHR_XOR[ex_BTB_NPC[6:2]]] <= `SD ex_Dirp_T;
HISTORY_valid[ex_BTB_NPC[6:2]]	      <= `SD 1'b0;
end
end//always



endmodule // module id_stage
