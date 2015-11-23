//test bench for sign extension
//comparch lab 3

//`include "sign_extend.v"

module sign_extend_test_bench_harness(
	output reg dutPassed,
	output reg testDone,
	input startTests);

	//wires for sign_extend
	wire[15:0]	instruction;
	wire[15:0]	immediate;
	wire[31:0]	sign_ext_out;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the sign_extend
	sign_extend dut(
		.instruction(instruction),
		.sign_ext_out(sign_ext_out)
		);

	//create an instance of the test bench
	sign_extend_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.instruction(instruction),
		.sign_ext_out(sign_ext_out)
		);

	//delay for 10 time steps and then begin test
	always@(posedge startTests)begin
		begintest = 0;
		#10
		begintest = 1;
	end

	//report final test results when endtest is high
	always @(posedge endtest) begin
		dutPassed = dutpassed;
		//$display("Sign Extend DUT passed?: %b", dutpassed);
		testDone = endtest;
	end

endmodule

module sign_extend_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[15:0] instruction,
	input [31:0] sign_ext_out
	);

	//initialize output from test bench
	initial begin
		instruction = 16'd0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing Sign Extend now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	//	if the instruction is 0, the output should be all zeros
	instruction = 16'b0010101010101010;
//	$display("Testing sign extend case 0...");
	#10
	
	#10
	if (sign_ext_out !== 32'b00000000000000000010101010101010)begin
		dutpassed = 0;
		$display("Test case 0 sign extend failed");
	end

	// //test case 1
	// //	if the MSB of the instruction is one, the output should be sixteen zeros and then the instruction
	 instruction = 16'b1001100110011001; //39,321
//	$display("Testing sign extend case 1...");
	 #10
	if (sign_ext_out !== 32'b11111111111111111001100110011001) begin
	 	dutpassed = 0;
	 	$display("Test case 1 sign extend failed");
	 end

	//test case 2
	// //	if the MSB of the instruction is zero, output should be sixteen ones and then the instruction
	 instruction = 16'b0101110110101000; //23,976
	#10
//	 $display("Testing sign extend case 2...");
	if (sign_ext_out !== 32'b00000000000000000101110110101000) begin
	 	dutpassed = 0;
	 	$display("Test case 2 sign extend failed");
	 end
	
	// if(dutpassed == 1)begin
	// 	$display("Sign Extend passed!");
	// end
	
	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;

end

endmodule