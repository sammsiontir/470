module testbench; 

reg clock, reset, A, B; 

wire [1:0] grant; 

arbiter test(.clock(clock), .reset(reset), .A(A), .B(B), .grant(grant)); 

always 
begin 
  #5; 
  clock=~clock; 
end 

initial 
begin 

  $monitor("Time:%4.0f clock:%b reset:%b A:%b B:%b grant:%b", 
           $time, clock, reset, A, B, grant); 


  clock = 1'b0; 
  reset = 1'b1; 
  A = 1'b0; 
  B = 1'b0; 

  @(negedge clock); 
  reset = 1'b0; // Grant = 00;
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b0; // Grant = 10
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b0; // Grant = 10
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b1; // Grant = 10
  @(negedge clock); 
  A = 1'b0; 
  B = 1'b0; // Grant = 00
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b1; // Grant = 10
  @(negedge clock); 
  A = 1'b0; 
  B = 1'b1; // Grant = 00
  // finish testing Grant to A
  @(negedge clock); 
  A = 1'b0; 
  B = 1'b1; // Grant = 01
  @(negedge clock); 
  A = 1'b0; 
  B = 1'b1; // Grant = 01
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b1; // Grant = 01
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b0; // Grant = 00
  @(negedge clock); 
  A = 1'b0; 
  B = 1'b1; // Grant = 01
  @(negedge clock); 
  A = 1'b1; 
  B = 1'b0; // Grant = 00
  @(negedge clock); 
  A = 1'b0; 
  B = 1'b0; // Grant = 00
  @(negedge clock); 
  @(negedge clock); 
  $finish; 

end 

endmodule
