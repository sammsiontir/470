module arbiter(clock, reset, A, B, grant); 

input clock, reset, A, B; 
output [1:0] grant; 

reg [1:0] state; 
reg [1:0] next_state;

assign grant = state; 

always @* 
begin 
  case(state) 
    2'b00 : 
      if (A==1) next_state = 2'b10;
      else if (A==0 && B==1) next_state = 2'b01;
      else next_state = 2'b00;
    2'b10 : next_state = A ? 2'b10:2'b00;
    2'b01 : next_state = B ? 2'b01:2'b00;
    default: next_state = 2'b00;
  endcase 
end 

always @(posedge clock) 
begin 
  if(reset) 
    state <= 2'b00; 
  else  
    state <= next_state; 
end 

endmodule
