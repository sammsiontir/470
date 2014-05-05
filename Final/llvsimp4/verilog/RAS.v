/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  RAS                                                 //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`timescale 1ns/100ps
`define NULL_PC 64'hFFFF_FFFF_FFFF_FFFF
module RAS    (// Inputs
		clock,
		reset,
		PC1_input,
		PC2_input,
		PC1_en,
		PC2_en,
		PC1_RAS_bsr,
		PC2_RAS_bsr,
		PC1_RAS_ret,
		PC2_RAS_ret,
		PC_enable,

		// Outputs
		RAS_nextPC_return_PC1,
		RAS_nextPC_return_PC2,
		RAS_nextPC_return_en1,
		RAS_nextPC_return_en2
              		);

input	      clock;
input	      reset;
input [63:0]  PC1_input; //the input of PC to check if it is a branch
input [63:0]  PC2_input;
input         PC1_en;
input         PC2_en;
input         PC1_RAS_bsr;
input         PC2_RAS_bsr;
input         PC1_RAS_ret;
input         PC2_RAS_ret;
input	      PC_enable;

output [63:0] RAS_nextPC_return_PC1;
output [63:0] RAS_nextPC_return_PC2;
output        RAS_nextPC_return_en1;
output        RAS_nextPC_return_en2;





reg   [63:0]cache_return_PC [0:127];
reg         cache_valid     [0:127];
reg [6:0]  pointer;

wire [6:0] pointer_plus1;
wire [6:0] pointer_minus1;
wire [63:0]PC1_NPC;
wire [63:0]PC2_NPC;


assign RAS_nextPC_return_PC1 = cache_return_PC[pointer];
assign RAS_nextPC_return_PC2 = cache_return_PC[pointer];
assign RAS_nextPC_return_en1 = (PC1_RAS_ret)? 1'b1 : 1'b0;
assign RAS_nextPC_return_en2 = (PC2_RAS_ret)? 1'b1 : 1'b0;

assign pointer_plus1 = pointer + 7'd1;
assign pointer_minus1 = pointer - 7'd1;
assign PC1_NPC = PC1_input + 64'd4;
assign PC2_NPC = PC2_input + 64'd4;

assign RAS_str_hazard = (pointer == 7'd126);
/////////////////////////
//        reset        //
/////////////////////////
always @(posedge clock)begin
if(reset)begin
pointer		   <= `SD 7'd0;
cache_return_PC[0] <= `SD `NULL_PC;
cache_return_PC[1] <= `SD `NULL_PC;
cache_return_PC[2] <= `SD `NULL_PC;
cache_return_PC[3] <= `SD `NULL_PC;
cache_return_PC[4] <= `SD `NULL_PC;
cache_return_PC[5] <= `SD `NULL_PC;
cache_return_PC[6] <= `SD `NULL_PC;
cache_return_PC[7] <= `SD `NULL_PC;
cache_return_PC[8] <= `SD `NULL_PC;
cache_return_PC[9] <= `SD `NULL_PC;
cache_return_PC[10] <= `SD `NULL_PC;
cache_return_PC[11] <= `SD `NULL_PC;
cache_return_PC[12] <= `SD `NULL_PC;
cache_return_PC[13] <= `SD `NULL_PC;
cache_return_PC[14] <= `SD `NULL_PC;
cache_return_PC[15] <= `SD `NULL_PC;
cache_return_PC[16] <= `SD `NULL_PC;
cache_return_PC[17] <= `SD `NULL_PC;
cache_return_PC[18] <= `SD `NULL_PC;
cache_return_PC[19] <= `SD `NULL_PC;
cache_return_PC[20] <= `SD `NULL_PC;
cache_return_PC[21] <= `SD `NULL_PC;
cache_return_PC[22] <= `SD `NULL_PC;
cache_return_PC[23] <= `SD `NULL_PC;
cache_return_PC[24] <= `SD `NULL_PC;
cache_return_PC[25] <= `SD `NULL_PC;
cache_return_PC[26] <= `SD `NULL_PC;
cache_return_PC[27] <= `SD `NULL_PC;
cache_return_PC[28] <= `SD `NULL_PC;
cache_return_PC[29] <= `SD `NULL_PC;
cache_return_PC[30] <= `SD `NULL_PC;
cache_return_PC[31] <= `SD `NULL_PC;
cache_return_PC[32] <= `SD `NULL_PC;
cache_return_PC[33] <= `SD `NULL_PC;
cache_return_PC[34] <= `SD `NULL_PC;
cache_return_PC[35] <= `SD `NULL_PC;
cache_return_PC[36] <= `SD `NULL_PC;
cache_return_PC[37] <= `SD `NULL_PC;
cache_return_PC[38] <= `SD `NULL_PC;
cache_return_PC[39] <= `SD `NULL_PC;
cache_return_PC[40] <= `SD `NULL_PC;
cache_return_PC[41] <= `SD `NULL_PC;
cache_return_PC[42] <= `SD `NULL_PC;
cache_return_PC[43] <= `SD `NULL_PC;
cache_return_PC[44] <= `SD `NULL_PC;
cache_return_PC[45] <= `SD `NULL_PC;
cache_return_PC[46] <= `SD `NULL_PC;
cache_return_PC[47] <= `SD `NULL_PC;
cache_return_PC[48] <= `SD `NULL_PC;
cache_return_PC[49] <= `SD `NULL_PC;
cache_return_PC[50] <= `SD `NULL_PC;
cache_return_PC[51] <= `SD `NULL_PC;
cache_return_PC[52] <= `SD `NULL_PC;
cache_return_PC[53] <= `SD `NULL_PC;
cache_return_PC[54] <= `SD `NULL_PC;
cache_return_PC[55] <= `SD `NULL_PC;
cache_return_PC[56] <= `SD `NULL_PC;
cache_return_PC[57] <= `SD `NULL_PC;
cache_return_PC[58] <= `SD `NULL_PC;
cache_return_PC[59] <= `SD `NULL_PC;
cache_return_PC[60] <= `SD `NULL_PC;
cache_return_PC[61] <= `SD `NULL_PC;
cache_return_PC[62] <= `SD `NULL_PC;
cache_return_PC[63] <= `SD `NULL_PC;
cache_return_PC[64] <= `SD `NULL_PC;
cache_return_PC[65] <= `SD `NULL_PC;
cache_return_PC[66] <= `SD `NULL_PC;
cache_return_PC[67] <= `SD `NULL_PC;
cache_return_PC[68] <= `SD `NULL_PC;
cache_return_PC[69] <= `SD `NULL_PC;
cache_return_PC[70] <= `SD `NULL_PC;
cache_return_PC[71] <= `SD `NULL_PC;
cache_return_PC[72] <= `SD `NULL_PC;
cache_return_PC[73] <= `SD `NULL_PC;
cache_return_PC[74] <= `SD `NULL_PC;
cache_return_PC[75] <= `SD `NULL_PC;
cache_return_PC[76] <= `SD `NULL_PC;
cache_return_PC[77] <= `SD `NULL_PC;
cache_return_PC[78] <= `SD `NULL_PC;
cache_return_PC[79] <= `SD `NULL_PC;
cache_return_PC[80] <= `SD `NULL_PC;
cache_return_PC[81] <= `SD `NULL_PC;
cache_return_PC[82] <= `SD `NULL_PC;
cache_return_PC[83] <= `SD `NULL_PC;
cache_return_PC[84] <= `SD `NULL_PC;
cache_return_PC[85] <= `SD `NULL_PC;
cache_return_PC[86] <= `SD `NULL_PC;
cache_return_PC[87] <= `SD `NULL_PC;
cache_return_PC[88] <= `SD `NULL_PC;
cache_return_PC[89] <= `SD `NULL_PC;
cache_return_PC[90] <= `SD `NULL_PC;
cache_return_PC[91] <= `SD `NULL_PC;
cache_return_PC[92] <= `SD `NULL_PC;
cache_return_PC[93] <= `SD `NULL_PC;
cache_return_PC[94] <= `SD `NULL_PC;
cache_return_PC[95] <= `SD `NULL_PC;
cache_return_PC[96] <= `SD `NULL_PC;
cache_return_PC[97] <= `SD `NULL_PC;
cache_return_PC[98] <= `SD `NULL_PC;
cache_return_PC[99] <= `SD `NULL_PC;
cache_return_PC[100] <= `SD `NULL_PC;
cache_return_PC[101] <= `SD `NULL_PC;
cache_return_PC[102] <= `SD `NULL_PC;
cache_return_PC[103] <= `SD `NULL_PC;
cache_return_PC[104] <= `SD `NULL_PC;
cache_return_PC[105] <= `SD `NULL_PC;
cache_return_PC[106] <= `SD `NULL_PC;
cache_return_PC[107] <= `SD `NULL_PC;
cache_return_PC[108] <= `SD `NULL_PC;
cache_return_PC[109] <= `SD `NULL_PC;
cache_return_PC[110] <= `SD `NULL_PC;
cache_return_PC[111] <= `SD `NULL_PC;
cache_return_PC[112] <= `SD `NULL_PC;
cache_return_PC[113] <= `SD `NULL_PC;
cache_return_PC[114] <= `SD `NULL_PC;
cache_return_PC[115] <= `SD `NULL_PC;
cache_return_PC[116] <= `SD `NULL_PC;
cache_return_PC[117] <= `SD `NULL_PC;
cache_return_PC[118] <= `SD `NULL_PC;
cache_return_PC[119] <= `SD `NULL_PC;
cache_return_PC[120] <= `SD `NULL_PC;
cache_return_PC[121] <= `SD `NULL_PC;
cache_return_PC[122] <= `SD `NULL_PC;
cache_return_PC[123] <= `SD `NULL_PC;
cache_return_PC[124] <= `SD `NULL_PC;
cache_return_PC[125] <= `SD `NULL_PC;
cache_return_PC[126] <= `SD `NULL_PC;
cache_return_PC[127] <= `SD `NULL_PC;

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
cache_valid[32]  <= `SD 1'b0;
cache_valid[33]  <= `SD 1'b0;
cache_valid[34]  <= `SD 1'b0;
cache_valid[35]  <= `SD 1'b0;
cache_valid[36]  <= `SD 1'b0;
cache_valid[37]  <= `SD 1'b0;
cache_valid[38]  <= `SD 1'b0;
cache_valid[39]  <= `SD 1'b0;
cache_valid[40]  <= `SD 1'b0;
cache_valid[41]  <= `SD 1'b0;
cache_valid[42]  <= `SD 1'b0;
cache_valid[43]  <= `SD 1'b0;
cache_valid[44]  <= `SD 1'b0;
cache_valid[45]  <= `SD 1'b0;
cache_valid[46]  <= `SD 1'b0;
cache_valid[47]  <= `SD 1'b0;
cache_valid[48]  <= `SD 1'b0;
cache_valid[49]  <= `SD 1'b0;
cache_valid[50]  <= `SD 1'b0;
cache_valid[51]  <= `SD 1'b0;
cache_valid[52]  <= `SD 1'b0;
cache_valid[53]  <= `SD 1'b0;
cache_valid[54]  <= `SD 1'b0;
cache_valid[55]  <= `SD 1'b0;
cache_valid[56]  <= `SD 1'b0;
cache_valid[57]  <= `SD 1'b0;
cache_valid[58]  <= `SD 1'b0;
cache_valid[59]  <= `SD 1'b0;
cache_valid[60]  <= `SD 1'b0;
cache_valid[61]  <= `SD 1'b0;
cache_valid[62]  <= `SD 1'b0;
cache_valid[63]  <= `SD 1'b0;
cache_valid[64]  <= `SD 1'b0;
cache_valid[65]  <= `SD 1'b0;
cache_valid[66]  <= `SD 1'b0;
cache_valid[67]  <= `SD 1'b0;
cache_valid[68]  <= `SD 1'b0;
cache_valid[69]  <= `SD 1'b0;
cache_valid[70]  <= `SD 1'b0;
cache_valid[71]  <= `SD 1'b0;
cache_valid[72]  <= `SD 1'b0;
cache_valid[73]  <= `SD 1'b0;
cache_valid[74]  <= `SD 1'b0;
cache_valid[75]  <= `SD 1'b0;
cache_valid[76]  <= `SD 1'b0;
cache_valid[77]  <= `SD 1'b0;
cache_valid[78]  <= `SD 1'b0;
cache_valid[79]  <= `SD 1'b0;
cache_valid[80]  <= `SD 1'b0;
cache_valid[81]  <= `SD 1'b0;
cache_valid[82]  <= `SD 1'b0;
cache_valid[83]  <= `SD 1'b0;
cache_valid[84]  <= `SD 1'b0;
cache_valid[85]  <= `SD 1'b0;
cache_valid[86]  <= `SD 1'b0;
cache_valid[87]  <= `SD 1'b0;
cache_valid[88]  <= `SD 1'b0;
cache_valid[89]  <= `SD 1'b0;
cache_valid[90]  <= `SD 1'b0;
cache_valid[91]  <= `SD 1'b0;
cache_valid[92]  <= `SD 1'b0;
cache_valid[93]  <= `SD 1'b0;
cache_valid[94]  <= `SD 1'b0;
cache_valid[95]  <= `SD 1'b0;
cache_valid[96]  <= `SD 1'b0;
cache_valid[97]  <= `SD 1'b0;
cache_valid[98]  <= `SD 1'b0;
cache_valid[99]  <= `SD 1'b0;
cache_valid[100]  <= `SD 1'b0;
cache_valid[101]  <= `SD 1'b0;
cache_valid[102]  <= `SD 1'b0;
cache_valid[103]  <= `SD 1'b0;
cache_valid[104]  <= `SD 1'b0;
cache_valid[105]  <= `SD 1'b0;
cache_valid[106]  <= `SD 1'b0;
cache_valid[107]  <= `SD 1'b0;
cache_valid[108]  <= `SD 1'b0;
cache_valid[109]  <= `SD 1'b0;
cache_valid[110]  <= `SD 1'b0;
cache_valid[111]  <= `SD 1'b0;
cache_valid[112]  <= `SD 1'b0;
cache_valid[113]  <= `SD 1'b0;
cache_valid[114]  <= `SD 1'b0;
cache_valid[115]  <= `SD 1'b0;
cache_valid[116]  <= `SD 1'b0;
cache_valid[117]  <= `SD 1'b0;
cache_valid[118]  <= `SD 1'b0;
cache_valid[119]  <= `SD 1'b0;
cache_valid[120]  <= `SD 1'b0;
cache_valid[121]  <= `SD 1'b0;
cache_valid[122]  <= `SD 1'b0;
cache_valid[123]  <= `SD 1'b0;
cache_valid[124]  <= `SD 1'b0;
cache_valid[125]  <= `SD 1'b0;
cache_valid[126]  <= `SD 1'b0;
cache_valid[127]  <= `SD 1'b0;
end


//////////////////////////////////////
//  1st inst is bsr     	    //
//  or 2 branches with same index   //
//////////////////////////////////////
else if(PC_enable &&PC1_RAS_bsr && PC1_en)begin//PC1 is bsr
pointer                  <= `SD pointer_plus1;
cache_return_PC[pointer] <= `SD PC1_NPC;
cache_valid[pointer]	 <= `SD 1'b1;
end
else if(PC_enable &&PC2_RAS_bsr && PC2_en)begin//PC2 is bsr
pointer			 <= `SD pointer_plus1;
cache_return_PC[pointer] <= `SD PC2_NPC;
cache_valid[pointer]	 <= `SD 1'b1;
end
else if(PC_enable &&PC1_RAS_ret && PC1_en)begin//PC1 is ret
pointer			 <= `SD pointer_minus1;
cache_return_PC[pointer] <= `SD `NULL_PC;
cache_valid[pointer]	 <= `SD 1'b0;
end
else if(PC_enable &&PC2_RAS_ret && PC2_en)begin//PC2 is ret
pointer			 <= `SD pointer_minus1;
cache_return_PC[pointer] <= `SD `NULL_PC;
cache_valid[pointer]	 <= `SD 1'b0;
end

end//always


endmodule
