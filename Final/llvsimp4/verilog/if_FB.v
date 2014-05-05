/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  if_FB.v                                             //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps



module if_FB (// Inputs
                clock,
                reset,
                ex_mem_take_branch,
                ex_mem_target_pc,
		ctr2proc_rd_data,
		ctr2proc_rd_valid,
		id_str_hazard,
		pre_cond_branch_1,  
		pre_cond_branch_2,  
		pre_uncond_branch_1,
		pre_uncond_branch_2,
		pre_bsr_branch_1,
		pre_bsr_branch_2,
		pre_ret_branch_1,
		pre_ret_branch_2,
		ex_BTB_NPC,         
		ex_Dirp_cond,       
		ex_Dirp_T,          

		//outputs
		proc2ctr_rd_addr,
		inst_out_a,
		inst_out_b,
		inst_out_a_en,
		inst_out_b_en,
		inst_out_a_PC,
		inst_out_b_PC,
		inst_out_a_BP_Taken, 
		inst_out_b_BP_Taken,  
		inst_out_a_BP_targetPC,
		inst_out_b_BP_targetPC
               );
  input         clock;
  input         reset;
  input         ex_mem_take_branch;
  input  [63:0] ex_mem_target_pc;
  input  [63:0] ctr2proc_rd_data;
  input         ctr2proc_rd_valid;
  input  [1:0]  id_str_hazard;
  input	      pre_uncond_branch_1;
  input	      pre_uncond_branch_2;
  input	      pre_cond_branch_1;  
  input	      pre_cond_branch_2;
  input       pre_bsr_branch_1;  
  input       pre_bsr_branch_2;
  input       pre_ret_branch_1;
  input       pre_ret_branch_2;
  input [63:0]ex_BTB_NPC;         
  input       ex_Dirp_cond;      
  input	      ex_Dirp_T;         


  output [63:0]  proc2ctr_rd_addr;
  output [31:0]  inst_out_a;
  output [31:0]  inst_out_b;
  output         inst_out_a_en;
  output         inst_out_b_en;
  output [63:0]  inst_out_a_PC;
  output [63:0]  inst_out_b_PC;
  output         inst_out_a_BP_Taken;
  output         inst_out_b_BP_Taken;
  output [63:0]  inst_out_a_BP_targetPC;
  output [63:0]  inst_out_b_BP_targetPC;

  reg    [63:0] PC_reg;
  wire   [63:0] PC_plus_4;
  wire   [63:0] PC_plus_8;
  wire   [63:0] next_PC;
  wire          PC_enable;
  wire          double_br;
  wire          double_br_stall;
  wire          BP_PC2_convert_NOOP;//branch predictor




BPredictor     BP (       //input
			.clock(clock),
			.reset(reset),
			.PC1_input(PC_reg),
			.PC2_input(PC_plus_4),
			.PC1_en(inst_out_a_en),                           //new
			.PC2_en(inst_out_b_en),                           //new
			.PC1_branch(pre_uncond_branch_1),
			.PC2_branch(pre_uncond_branch_2),
			.PC1_Dirp_cond(pre_cond_branch_1),
			.PC2_Dirp_cond(pre_cond_branch_2),
			.PC1_RAS_bsr(pre_bsr_branch_1),
			.PC2_RAS_bsr(pre_bsr_branch_2),
			.PC1_RAS_ret(pre_ret_branch_1),
			.PC2_RAS_ret(pre_ret_branch_2),
			.ex_BTB_branch(ex_mem_take_branch),
			.ex_BTB_alu_result(ex_mem_target_pc),
			.ex_BTB_NPC(ex_BTB_NPC),
			.ex_Dirp_cond(ex_Dirp_cond),
			.ex_Dirp_T(ex_Dirp_T),
			.PC_enable(PC_enable),
			
			//output
			.BP_next_targetPC1(inst_out_a_BP_targetPC),
			.BP_next_targetPC2(inst_out_b_BP_targetPC),
			.BP_guess1_en(inst_out_a_BP_Taken),
			.BP_guess2_en(inst_out_b_BP_Taken),
			.BP_PC2_convert_NOOP(BP_PC2_convert_NOOP)
			);


  assign proc2ctr_rd_addr = {PC_reg[63:3], 3'b0};
  assign PC_plus_4 = PC_reg + 4;
  assign PC_plus_8 = PC_reg + 8;
  assign inst_out_a =  ctr2proc_rd_data[31:0]; 
  assign inst_out_b =  ctr2proc_rd_data[63:32]; 
  assign inst_out_a_PC = PC_reg[2]? 0:PC_reg + 4;
  assign inst_out_b_PC = PC_reg[2]? PC_reg + 4:PC_reg + 8;


 
  assign next_PC = (ex_mem_take_branch)? ex_mem_target_pc:
		   (inst_out_a_BP_Taken)? inst_out_a_BP_targetPC:   //branch predictor
		   (inst_out_b_BP_Taken)? inst_out_b_BP_targetPC:   //branch predictor
                   (id_str_hazard != 0 || !ctr2proc_rd_valid)? PC_reg:
                   (PC_reg[2])? PC_plus_4:
                   double_br_stall? PC_plus_4:
                   PC_plus_8;
  assign PC_enable= (id_str_hazard == 0 && ctr2proc_rd_valid);
  assign double_br = (pre_cond_branch_1 | pre_uncond_branch_1) & (pre_cond_branch_2 | pre_uncond_branch_2);
  assign double_br_stall = double_br & ctr2proc_rd_valid & id_str_hazard == 0 & PC_reg[2] == 0;

  assign inst_out_a_en = (id_str_hazard != 0)? `FALSE:
                         PC_reg[2]?            `FALSE:
                         ctr2proc_rd_valid ?   `TRUE:
                         `FALSE;
  assign inst_out_b_en = (id_str_hazard != 0)? `FALSE:
			 (inst_out_a_BP_Taken)? `FALSE:  //branch predictor
                         double_br_stall?      `FALSE:
                         ctr2proc_rd_valid ?   `TRUE:
                         `FALSE;
 
  always @(posedge clock)
  begin
    if(reset)
      PC_reg <= `SD 0;       // initial PC value is 0
    else if(ex_mem_take_branch || inst_out_a_BP_Taken || inst_out_b_BP_Taken)   //branch predictor
      PC_reg <= `SD next_PC;
    else if(id_str_hazard != 0)
      PC_reg <= `SD next_PC;
    else if(PC_enable)
      PC_reg <= `SD next_PC; // transition to next PC
  end  // always

  
endmodule  // module if_FB
