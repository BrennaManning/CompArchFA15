//test bench for $ra register
//comparch lab 3

//`include "ra_register.v"

module ra_register_test_bench_harness(
	output reg dutPassed,
	output reg testDone,
	input startTests
);

	//wires for ra_register
	wire[31:0]	ra_reg_in;
	wire		jal;
	wire[31:0]	ra_reg_out;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the ra_register
	ra_register dut(
		.ra_reg_in(ra_reg_in),
		.jal(jal),
		.ra_reg_out(ra_reg_out)
		);

	//create an instance of the test bench
	ra_reg_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.ra_reg_in(ra_reg_in),
		.jal(jal),
		.ra_reg_out(ra_reg_out)
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
		//$display("$RA Register DUT passed?: %b", dutpassed);
		testDone = endtest;
	end

endmodule

module ra_reg_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[31:0] ra_reg_in,
	output reg jal,
	input[31:0] ra_reg_out
	);

	//initialize output from test bench
	initial begin
		jal = 0;
		ra_reg_in = 32'd0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing $RA Register now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	//	if the JAL is low, the reg in should not be written
	jal = 0;
	ra_reg_in = 34'd6;
	//$display("Testing $RA register case 0...");
	#10
	if (ra_reg_out == 34'd6) begin
		dutpassed = 0;
		$display("Test case 0 $RA register failed");
	end

	//test case 1
	//	if the JAL is high, the register should write
	jal = 1;
	ra_reg_in = 34'd12;
	//$display("Testing $RA register case 1...");
	#10
	if (ra_reg_out !== 34'd12) begin
		dutpassed = 0;
		$display("Test case 1 $RA register failed");
	end

    if (dutpassed == 1) begin
      // $display("$RA Register passed!");
      endtest = 1;
    end

	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;

end

endmodule