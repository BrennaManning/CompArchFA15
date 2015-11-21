`include "shift_left.v"
module shift_left_test_bench_harness(
output reg dutPassed,
output reg testDone,
input startTests
);

	//wires for shift_left
	wire[31:0]	sign_ext;
	wire[31:0]	shift_left_out;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the shift_left
	shift_left dut(
		.sign_ext(sign_ext),
		.shift_left_out(shift_left_out)
		);

	//create an instance of the test bench
	shift_left_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.sign_ext(sign_ext),
		.shift_left_out(shift_left_out)
		);

	//delay for 10 time steps and then begin test
	always@(posedge startTests)begin
		begintest = 0;
		dutPassed =1;
		#10
		begintest = 1;
	end

	//report final test results when endtest is high
	always @(posedge endtest) begin
		dutPassed = dutpassed;
		$display("DUT passed?: %b", dutpassed);
		testDone = endtest;
	end

endmodule

module shift_left_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[31:0] sign_ext,
	input[31:0] shift_left_out
	);

	//initialize output from test bench
	initial begin
		sign_ext = 32'b0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing shift left now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	//	all ones moved over two left has two zeros at the end
	sign_ext = 34'b11111111111111111111111111111111;
	$display("Testing case 0...");
	#10
	if (shift_left_out !== 34'b11111111111111111111111111111100) begin
		dutpassed = 0;
		$display("Test case 0 failed");
	end

	//test case 1
	//	zero moved over two left is still zero
	sign_ext = 34'b00000000000000000000000000000000;
	$display("Testing case 1...");
	#10	
	if (shift_left_out !== 34'b00000000000000000000000000000000) begin
		dutpassed = 0;
		$display("Test case 1 failed");
	end

	//test case 2
	//	a mixture of 0s and 1s still adds two zeros on the right
	sign_ext = 34'b11001101011010101010010110101101;
	$display("Testing case 2...");
	#10	
	if (shift_left_out !== 34'b00110101101010101001011010110100) begin
		dutpassed = 0;
		$display("Test case 2 failed");
	end

	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;

end

endmodule