`define DEBUG_OUT
module fsm_ab(clock, reset, in, out
`ifdef DEBUG_OUT
,state_out
`endif
);

input clock, reset, in;
output reg out;

reg [1:0] next_state;
reg [1:0] state;

`ifdef DEBUG_OUT
output wire [1:0] state_out;
assign state_out = state;
`endif

always@* begin
	case(state)
		2'b00: begin
			out = 0;
			if(in) next_state = 2'b01;
			else next_state = 2'b00;
		end
		2'b01: begin
			out = 0;
			if(in) next_state = 2'b01;
			else next_state = 2'b10;
		end
		2'b10: begin
			out = 0;
			if(in) next_state = 2'b11;
			else next_state = 2'b00;
		end
		2'b11: begin
			out = 1;
			if(in) next_state = 2'b01;
			else next_state = 2'b10;
		end
	endcase
end

always@(posedge clock) begin
	if(reset) begin
		state <= 2'b00;
	end
	else begin
		state <= next_state;
	end
end


endmodule
