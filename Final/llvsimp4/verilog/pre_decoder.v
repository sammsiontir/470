`define JSR_GRP		6'h1a
`define LDQ_INST	6'h29
`define LDQ_L_INST	6'h2b
`define BR_INST		6'h30
`define BSR_INST	6'h34
`define FBEQ_INST	6'h31
`define FBLT_INST	6'h32
`define FBLE_INST	6'h33
`define FBNE_INST	6'h35
`define FBGE_INST	6'h36
`define FBGT_INST	6'h37

module pre_decoder( inst_1,
                    inst_2,

                    cond_branch_1,
                    cond_branch_2,
                    uncond_branch_1,
                    uncond_branch_2,
		    bsr_branch_1,
		    bsr_branch_2,
		    ret_branch_1,
		    ret_branch_2,
                    is_ldq_1,
                    is_ldq_2                    
                  );

input [31:0] inst_1;
input [31:0] inst_2;

output reg cond_branch_1;
output reg cond_branch_2;
output reg uncond_branch_1;
output reg uncond_branch_2;
output reg bsr_branch_1;
output reg bsr_branch_2;
output reg ret_branch_1;
output reg ret_branch_2;
output reg is_ldq_1;
output reg is_ldq_2;

always@* begin
   cond_branch_1   = `FALSE;
   uncond_branch_1 = `FALSE;
   is_ldq_1        = `FALSE;
   bsr_branch_1    = `FALSE;
   ret_branch_1    = `FALSE;
   case({inst_1[31:29], 3'b0})
     6'h18:begin
       if(inst_1[31:26] == `JSR_GRP) begin
	uncond_branch_1 = `TRUE;
	if(inst_1[15:14]==2'h2)
	ret_branch_1 = `TRUE;
	end
	end
     6'h08, 6'h20, 6'h28:
       if((inst_1[31:26] == `LDQ_INST) | (inst_1[31:26] == `LDQ_L_INST)) is_ldq_1 = `TRUE;

     6'h30, 6'h38:
	begin
	if(inst_1[31:26]==`BSR_INST) bsr_branch_1 = `TRUE;
       if((inst_1[31:26] == `BR_INST) | (inst_1[31:26] == `BSR_INST)) uncond_branch_1 = `TRUE;
       else if((inst_1[31:26] != `FBEQ_INST) & (inst_1[31:26] != `FBLT_INST) & (inst_1[31:26] != `FBLE_INST) & (inst_1[31:26] != `FBNE_INST) & (inst_1[31:26] != `FBGE_INST) & (inst_1[31:26] != `FBGT_INST)) cond_branch_1 = `TRUE;
       end
   endcase
end

always@* begin
   cond_branch_2   = `FALSE;
   uncond_branch_2 = `FALSE;
   is_ldq_2        = `FALSE;
   bsr_branch_2    = `FALSE;
   ret_branch_2    = `FALSE;

   case({inst_2[31:29], 3'b0})
     6'h18:begin
       if(inst_2[31:26] == `JSR_GRP) begin
	uncond_branch_2 = `TRUE;
	if(inst_2[15:14]==2'h2)
	ret_branch_2 = `TRUE;
	end
       end
     6'h08, 6'h20, 6'h28:
       if((inst_2[31:26] == `LDQ_INST) | (inst_2[31:26] == `LDQ_L_INST)) is_ldq_2 = `TRUE;

     6'h30, 6'h38:
	begin
	if(inst_2[31:26]==`BSR_INST) bsr_branch_2 = `TRUE;
       if((inst_2[31:26] == `BR_INST) | (inst_2[31:26] == `BSR_INST)) uncond_branch_2 = `TRUE;
       else if((inst_2[31:26] != `FBEQ_INST) & (inst_2[31:26] != `FBLT_INST) & (inst_2[31:26] != `FBLE_INST) & (inst_2[31:26] != `FBNE_INST) & (inst_2[31:26] != `FBGE_INST) & (inst_2[31:26] != `FBGT_INST)) cond_branch_2 = `TRUE;
       end
   endcase
end


endmodule
