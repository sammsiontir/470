//TESTBENCH FOR 1-BIT FULL ADDER
//Class:		EECS470
//Specific:		Lab 2
//Description:	This file contains the testbench for a 1-bit full adder.

module testbench;

// I/O of the full_adder_1bit module
reg		A, B, Cin;
wire		Sum, Cout;

reg		clock;
wire	[1:0]	GOLDEN_SUM;
wire		correct;

// Don't forget to wire in your signals to the module instantiation here!
full_adder_1bit fa_test_1(
	.A(A),
	.B(B),
	.carry_in(Cin),
	.S(Sum),
	.carry_out(Cout)
);

// Golden output
assign		GOLDEN_SUM = A + B + Cin;

// Comparison between the output of the module and golden output
assign		correct = ( Sum === GOLDEN_SUM[0] ) && ( Cout === GOLDEN_SUM[1] );

always@(correct)
begin
	#2
	if(!correct)
	begin
		$display("@@@ Incorrect at time %4.0f", $time);
		$display("@@@ Time:%4.0f clock:%b A:%h B:%h CIN:%b SUM:%h COUT:%b", $time, clock, A, B, Cin, Sum, Cout);
		$display("@@@ expected sum=%b cout=%b", GOLDEN_SUM[0],GOLDEN_SUM[1] );
		$finish;
	end
end

always
	#5 clock=~clock;

initial
begin
	clock	=	0;
	A	=	0;
	B	=	0;
	Cin	=	0;

	$monitor("Time:%4.0f clock:%b A:%h B:%h CIN:%b SUM:%h COUT:%b", $time, clock, A, B, Cin, Sum, Cout);

	@(negedge clock)	// How many unique inputs are possible for a full adder?
	A = 0;
	B = 0;
	Cin = 1;
	@(negedge clock)
	A = 0;
	B = 1;
	Cin = 0;
	@(negedge clock)
	A = 0;
	B = 1;
	Cin = 1;
	@(negedge clock)
	A = 1;
	B = 0;
	Cin = 0;
	@(negedge clock)
	A = 1;
	B = 0;
	Cin = 1;
	@(negedge clock)
	A = 1;
	B = 1;
	Cin = 0;
	@(negedge clock)
	A = 1;
	B = 1;
	Cin = 1;
	@(negedge clock)
	@(negedge clock)
	$finish;
end

endmodule
