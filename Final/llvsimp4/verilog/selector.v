module selector(//input
		idx,

		//output
		issue1,
		issue1_en,
		issue2,
		issue2_en);

input  [15:0] idx;
output [3:0] issue1;
output [3:0] issue2;
output	     issue1_en;
output	     issue2_en;
wire   [4:0] issue_choose1;//if the top digit = 1, then means there's no istn to issue
wire   [4:0] issue_choose2;//if the top digit = 1, then means there's no istn to issue


assign issue_choose1 =idx[0]? 5'd0
		     :idx[1]? 5'd1
		     :idx[2]? 5'd2
		     :idx[3]? 5'd3
		     :idx[4]? 5'd4
		     :idx[5]? 5'd5
		     :idx[6]? 5'd6
		     :idx[7]? 5'd7
		     :idx[8]? 5'd8
		     :idx[9]? 5'd9
		     :idx[10]? 5'd10
		     :idx[11]? 5'd11
		     :idx[12]? 5'd12
		     :idx[13]? 5'd13
		     :idx[14]? 5'd14
		     :idx[15]? 5'd15
		     :5'b10000;
assign issue_choose2 = idx[15]? 5'd15
		     :idx[14]? 5'd14
		     :idx[13]? 5'd13
		     :idx[12]? 5'd12
		     :idx[11]? 5'd11
		     :idx[10]? 5'd10
		     :idx[9]? 5'd9
		     :idx[8]? 5'd8
		     :idx[7]? 5'd7
		     :idx[6]? 5'd6
		     :idx[5]? 5'd5
		     :idx[4]? 5'd4
		     :idx[3]? 5'd3
		     :idx[2]? 5'd2
		     :idx[1]? 5'd1
		     :idx[0]? 5'd0
		     :5'b10000;

assign issue1 = issue_choose1[3:0];
assign issue2 = issue_choose2[3:0];
assign issue1_en = (issue_choose1[4]==1)? 1'b0 : 1'b1;
assign issue2_en = (issue_choose2[4]==1 | issue_choose1==issue_choose2)? 1'b0 : 1'b1; 

endmodule
