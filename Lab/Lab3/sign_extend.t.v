//test bench for sign extension
//comparch lab 3

module sign_extend_test_bench_harness();

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
		.immediate(immediate),
		.sign_ext_out(sign_ext_out)
		);

	//create an instance of the test bench
	sign_extend_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.instruction(instruction),
		.immediate(immediate),
		.sign_ext_out(sign_ext_out)
		);

	//delay for 10 time steps and then begin test
	initial begin
		begintest = 0;
		#10
		begintest = 1;
	end

	//report final test results when endtest is high
	always @(posedge endtest) begin
		$display("DUT passed?: %b", dutpassed);
	end

endmodule

module sign_extend_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[15:0] instruction,
	input [15:0] immediate,
	input [31:0] sign_ext_out
	);

	//initialize output from test bench
	initial begin
		instruction = 16'd0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing sign extend now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	//	if the instruction is 0, the output should be all zeros
	instruction = 16'b0010101010101010;
	$display("Testing case 0...");
	#10
	$display("binary instruction %b", instruction[15]);
	$display("binary immediate %b", immediate);
	$display("binary sign_ext_out %b", sign_ext_out);
	if (instruction[15] == 0) begin
		$display("MSB is 1");
	end
	$display("sign ext %b", sign_ext_out);
	#10
	if (sign_ext_out !== 32'd0) begin
		dutpassed = 0;
		$display("Test case 0 failed");
	end

	// //test case 1
	// //	if the MSB of the instruction is one, the output should be sixteen zeros and then the instruction
	// instruction = 16'b1001100110011001; //39,321
	// $display("Testing case 1...");
	// #10
	// if (sign_ext_out !== 32'b11111111111111111001100110011001) begin
	// 	dutpassed = 0;
	// 	$display("Test case 1 failed");
	// end

	// //test case 2
	// //	if the MSB of the instruction is zero, output should be sixteen ones and then the instruction
	// instruction = 16'b0101110110101000; //23,976
	// $display("Testing case 2...");
	// if (sign_ext_out !== 32'b00000000000000000101110110101000) begin
	// 	dutpassed = 0;
	// 	$display("Test case 2 failed");
	// end

	//All done! Short delay and then signal that the test is completed
	#5
	$display(endtest);

end

endmodule