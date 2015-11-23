//test bench for full single cycle cpu
//comparch lab 3

`include "singlecyclecpu.v"

module singlecyclecpu_test_bench_harness();

	//wires for singlecyclecpu
	wire[31:0]	instruction;
	wire		clk;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the singlecyclecpu
	high_level_cpu dut(
		.instruction(instruction),
		.clk(clk)
		);

	//create an instance of the test bench
	single_cycle_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.instruction(instruction),
		.clk(clk)
		);

	//delay for 10 time steps and then begin test
	initial begin
		begintest = 0;
		#10
		begintest = 1;
		$display("begin");
	end
	
	//report final test results when endtest is high
	always @(posedge endtest) begin
		//$display("Instruction Memory DUT passed?: %b", dutpassed);
	end

endmodule

module single_cycle_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[31:0] instruction,
	output reg clk
	);

	//initialize output from test bench
	initial begin
		instruction = 32'd0;
		clk = 0;
	end

	always
		#5 clk = !clk;

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing Single Cycle CPU now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	//	this is just a baby test, where I check to see if the instruction is still the instruction
	instruction = 32'd16;
	// dut.
	// initial $readmemh("patrick_team_asm.dat", memory);

	$display("Testing singlecyclecpu case 0...");

	#10
	$display(instruction);
	dut.da_reg_to_alu = 32'd4;
	dut.db_reg = 32'd6;
	dut.alu_src_cntrl = 1'd1;
	$display(dut.alu_res);
	if (instruction != 32'd16) begin
		dutpassed = 0;
		$display("Test case 0 singlecyclecpu failed");
	end

	if(dutpassed == 1)begin
		$display("Single Cycle CPU passed!");
	end
	
	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;

end

endmodule