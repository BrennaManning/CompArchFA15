//test bench for the program counter register
//comparch lab 3
`include "pc_register.v"
module pc_register_test_bench_harness(
output reg dutPassed,
output reg testDone,
input startTests
);

	//wires needed for the pc_register
	wire[31:0] pc_reg_in;
	wire[31:0] pc_reg_out;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//instantiate the pc_reg being tested
	pc_register dut(
			.pc_reg_in(pc_reg_in),
			.pc_reg_out(pc_reg_out)
		);

	//instantiate the test bench
	pc_reg_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.pc_reg_in(pc_reg_in),
		.pc_reg_out(pc_reg_out)
		);

	//delay 10 time steps and then begin test
	always@(posedge startTests)begin
		begintest = 0;
		#10;
		begintest = 1;
	end

	//final test results displayed when 'endtest' is high
	always @(posedge endtest) begin
		dutPassed = dutpassed;
		$display("DUT passed?: %b", dutpassed);
		testDone = endtest;
	end

endmodule

module pc_reg_test_bench
(
	//test bench driver signal connections
	input begintest,		//triggers start of testing
	output reg endtest,		//raise when testing is done
	output reg dutpassed,	//shows result (pass/fail)

	//connections for pc_reg
	//label the inputs as outputs and the outputs as inputs
	output reg[31:0] pc_reg_in,
	input[31:0] pc_reg_out
);

	//initialize output from test bench
	initial begin
		pc_reg_in = 32'd0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing PC register now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	//	write 4 to the pc. wait. read it back
	pc_reg_in = 32'd4;
	#5	//delay for a little bit
	if(pc_reg_out !== 32'd4) begin
		dutpassed = 0;
		$display("Test case 0 failed");
	end

	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;
end

endmodule
