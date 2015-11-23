//test bench for $ra register
//comparch lab 3
//`include "concatenate.v"

module concatenate_test_bench_harness(
	output reg dutPassed,
	output reg testDone,
	input startTests);

	//wires for ra_register
	wire[31:0]	out;
	wire[3:0]	pc;
	wire[25:0]	instr;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the ra_register
	concatenate dut(
		.out(out),
		.pc(pc),
		.instr(instr)
		);

	//create an instance of the test bench
	concatenate_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.out(out),
		.pc(pc),
		.instr(instr)
		);

	//delay for 10 time steps and then begin test
	always @(posedge startTests)begin
			begintest = 0;
		#10
		begintest = 1;
	end
	
	//report final test results when endtest is high
	always @(posedge endtest) begin
		dutPassed = dutpassed;
		//$display("Concatenate DUT passed?: %b", dutpassed);
		testDone = endtest;
	end

endmodule

module concatenate_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[3:0] pc,
	output reg[25:0] instr,
	input[31:0] out
	);

	//initialize output from test bench
	initial begin
		pc = 0;
		instr = 0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing Concatenate now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	pc = 0;
	instr = 0;
//	$display("Testing concatenate case 0...");
	#10
	if (out !== 0) begin
		dutpassed = 0;
		$display("Test case 0 concatenate failed");
	end

	//test case 1
	//	if the JAL is high, the register should write
	pc = 4'b0011;
	instr = 26'b10110101011100010000111111;
//	$display("Testing concatenate case 1...");
	#10
	//concatenated
	if (out !== 32'b00111011010101110001000011111100) begin
		dutpassed = 0;
		$display("concatenate = %b", out);
		$display("Expected 00111011010101110001000011111100");
		$display("Test case 1 concatenate failed");
	end

	// if(dutpassed == 1)begin
	// 	$display("Concatenate passed!");
	// end

	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;

end

endmodule