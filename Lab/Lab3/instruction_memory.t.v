//test bench for instruction memory
//comparch lab 3

module instruction_memory_test_bench_harness();

	//wires for instruction_memory
	wire[31:0]	address;
	wire[31:0]	instr_mem_out;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the instruction_memory
	instruction_memory dut(
		.address(address),
		.instr_mem_out(instr_mem_out)
		);

	//create an instance of the test bench
	instr_mem_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.address(address),
		.instr_mem_out(instr_mem_out)
		);

	//delay for 10 time steps and then begin test
	initial begin
		begintest = 0;
		#10
		begintest = 1;
	end
	
	//report final test results when endtest is high
	always @(posedge endtest) begin
		//$display("Instruction Memory DUT passed?: %b", dutpassed);
	end

endmodule

module instr_mem_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for ra_reg (outputs + inputs switch labels)
	output reg[31:0] address,
	input[31:0] instr_mem_out
	);

	//initialize output from test bench
	initial begin
		address = 32'd0;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing Instruction Memory now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test case 0
	address = 32'b0;
	//$display("Testing instruction memory case 0...");
	#10
	$display(address);
	$display(instr_mem_out);
	if (instr_mem_out == 32'b0) begin
		dutpassed = 0;
		$display("Test case 0 instruction memory failed");
	end

	// if(dutpassed == 1)begin
	// 	$display("Instruction Memory passed!");
	// end
	
	//All done! Short delay and then signal that the test is completed
	#5
	endtest = 1;

end

endmodule