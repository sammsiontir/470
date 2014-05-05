/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  BPredictor                                          //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
`define NULL_PC 64'hFFFF_FFFF_FFFF_FFFF

module BPredictor      (//input
			clock,
			reset,
			PC1_input,
			PC2_input,
			PC1_en,                           //new
			PC2_en,                           //new
			PC1_branch,//pre_decoder
			PC2_branch,//pre_decoder
			PC1_Dirp_cond,//pre_decoder
			PC2_Dirp_cond,//pre_decoder
			PC1_RAS_bsr,
			PC2_RAS_bsr,
			PC1_RAS_ret,
			PC2_RAS_ret,
			ex_BTB_branch,
			ex_BTB_alu_result,
			ex_BTB_NPC,
			ex_Dirp_cond,
			ex_Dirp_T,
			PC_enable,
			
			//output
			BP_next_targetPC1,
			BP_next_targetPC2,
			BP_guess1_en,
			BP_guess2_en,
			BP_PC2_convert_NOOP
			);
input	      clock;
input	      reset;
input [63:0]  PC1_input; //the input of PC to check if it is a branch
input [63:0]  PC2_input;
input	      PC1_en;
input	      PC2_en;
input	      PC1_branch;
input  	      PC2_branch;
input	      PC1_Dirp_cond;
input	      PC2_Dirp_cond;
input	      PC1_RAS_bsr;
input	      PC2_RAS_bsr;
input	      PC1_RAS_ret;
input	      PC2_RAS_ret;
input	      ex_BTB_branch;
input [63:0]  ex_BTB_alu_result;
input [63:0]  ex_BTB_NPC;//sent from ex
input         ex_Dirp_cond;
input	      ex_Dirp_T;
input         PC_enable;

output [63:0] BP_next_targetPC1;
output [63:0] BP_next_targetPC2;
output	      BP_guess1_en;
output	      BP_guess2_en;
output	      BP_PC2_convert_NOOP;
wire   [63:0] BTB_nextPC_targetPC1;
wire   [63:0] BTB_nextPC_targetPC2;
wire          BTB_nextPC_target_en1;
wire          BTB_nextPC_target_en2;
wire	      Dirp_T1; // 0 for not taken, 1 for taken
wire	      Dirp_T2; // 0 for not taken, 1 for taken
wire   [63:0] PC1_return;
wire   [63:0] PC2_return;
wire          PC1_return_en;
wire          PC2_return_en;
wire          PC1_BTB_branch;
wire          PC2_BTB_branch;

assign PC1_BTB_branch = PC1_branch && ~(PC1_RAS_bsr || PC1_RAS_ret);
assign PC2_BTB_branch = PC2_branch && ~(PC2_RAS_bsr || PC2_RAS_ret);


RAS           R1(// Inputs
		.clock(clock),
		.reset(reset),
		.PC1_input(PC1_input),
		.PC2_input(PC2_input),
		.PC1_en(PC1_en),
		.PC2_en(PC2_en),
		.PC1_RAS_bsr(PC1_RAS_bsr),
		.PC2_RAS_bsr(PC2_RAS_bsr),
		.PC1_RAS_ret(PC1_RAS_ret),
		.PC2_RAS_ret(PC2_RAS_ret),
		.PC_enable(PC_enable),

		 // Outputs
		.RAS_nextPC_return_PC1(PC1_return),
		.RAS_nextPC_return_PC2(PC2_return),
		.RAS_nextPC_return_en1(PC1_return_en),
		.RAS_nextPC_return_en2(PC2_return_en)
              		);

BTB    B1(// Inputs
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

Dirp  D1 (// Inputs
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


assign BP_next_targetPC1 = (PC1_en && PC1_RAS_ret)? PC1_return : BTB_nextPC_targetPC1;
assign BP_next_targetPC2 = (PC2_en && PC2_RAS_ret)? PC2_return : BTB_nextPC_targetPC2;

assign BP_guess1_en =   (PC1_en && PC1_RAS_ret)? PC1_return_en:
			(PC1_en && PC1_Dirp_cond && BTB_nextPC_target_en1)?  Dirp_T1 : BTB_nextPC_target_en1;//using target1 PC or not
assign BP_guess2_en =   (PC2_en && PC2_RAS_ret)? PC1_return_en:
			(PC2_en && PC2_Dirp_cond && BTB_nextPC_target_en2)?  Dirp_T2 : BTB_nextPC_target_en2;//using target1 PC or not

assign BP_PC2_convert_NOOP = BP_guess1_en;
//assign BP_guess_en = (BP_guess1_en || BP_guess2_en);


endmodule
