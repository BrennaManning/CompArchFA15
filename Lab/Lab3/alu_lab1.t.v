//`include "alu_lab1.v"

module alu_test_bench_harness(
	output reg dutPassed,
	output reg testDone,
	input startTests
);

	//wires for ra_register
	wire[31:0]    result;
	wire          carryout;
	wire          zero;
	wire          overflow;
	wire[31:0]     operandA;
	wire[31:0]     operandB;
	wire[2:0]      command;

	//wires for testing
	reg begintest;
	wire dutpassed;

	//create an instance of the ra_register
	alu dut(
		.result(result),
		.carryout(carryout),
		.zero(zero),
		.overflow(overflow),
		.operandA(operandA),
		.operandB(operandB),
		.command(command)

		);

	//create an instance of the test bench
	alu_test_bench tester(
		.begintest(begintest),
		.endtest(endtest),
		.dutpassed(dutpassed),
		.result(result),
		.carryout(carryout),
		.zero(zero),
		.overflow(overflow),
		.operandA(operandA),
		.operandB(operandB),
		.command(command)
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
		//$display("ALU DUT passed?: %b", dutpassed);
		testDone = endtest;
	end

endmodule

module alu_test_bench(
	//test bench drivers
	input begintest,
	output reg endtest,
	output reg dutpassed,

	//connections for alu (outputs + inputs  labels)
	output reg[31:0] operandA,
	output reg[31:0] operandB,
	output reg [2:0] command,
	input[31:0] result,
	input carryout,
	input overflow,
	input zero
	);
	
	//initialize output from test bench
	initial begin
		operandA = 32'd0;
		operandB = 32'd0;
		command = 2'b00;
	end

	//once 'begintest' is high, run test cases
	always @(posedge begintest) begin
		$display("Testing ALU now...");
		endtest = 0;
		dutpassed = 1;
		#10

	//test adder
	//0+0
	operandA = 32'b00000000000000000000000000000000;
	operandB = 32'b00000000000000000000000000000000;
	command = 3'b000; //ADD COMMAND 
	#5
	if (result != 32'd0) begin
		dutpassed = 0;
		$display("Adder Failed 0 + 0");
	end
	//positive + positive
	operandA = 32'b00100001000001000001000001000100;
	operandB = 32'b00010000100000000000000100000001;
	command = 3'b000; //ADD COMMAND 
	#5
	if (result != 32'b00110001100001000001000101000101) begin
		dutpassed = 0;
		$display("Adder Failed pos + pos");
	end
	//positive + negative
	operandA = 32'sb11111111111111111111111111110110; //-10
	operandB = 32'sb00000000000010011110110000001010; //650250
	command = 3'b000; //ADD COMMAND 
	#5
	//expected 650240
	if (result != 32'sb00000000000010011110110000000000) begin
		dutpassed = 0;
		$display("Adder Failed pos + neg");
	end

	//negative + negative
	operandA = 32'sb11111111111111111111111111110110; //-10
	operandB = 32'sb00000000000010011110110000001010; //-10
	command = 3'b000; //ADD COMMAND 
	#5
	//expected -20
	if (result != 32'sb11111111111111111111111111101100) begin
		dutpassed = 0;
		$display("Adder Failed neg + neg");
	end



	//test subtractor
	//0 - 0
	operandA = 32'b00000000000000000000000000000000; //0
	operandB = 32'b00000000000000000000000000000000; //0
	command = 3'b001; //SUB COMMAND 
	#5
	if (result != 32'd0) begin
		dutpassed = 0;
		$display("Subtractor Failed 0 + 0");
	end

	//positive - positive
	operandA = 32'b01000101000001000101000001000100; //1157910596
	operandB = 32'b00010000100000111100000100000001; //277070081
	command = 3'b001; //SUB COMMAND 
	#5
	//expected 880840509
	if (result != 32'b110100100000001000111100111101) begin
		dutpassed = 0;
		$display("Subtractor Failed pos - pos");
	end

	//positive - negative
	operandA = 32'b01000101000001000101000001000100; //1157910596
	operandB = 32'sb11100000111011001110010111000000; //-521345600 
	command = 3'b001; //SUB COMMAND 
	#5
	//expected 1679256196
	if (result != 32'b01100100000101110110101010000100) begin
		dutpassed = 0;
		$display("Subtractor Failed pos - neg");
	end

	//negative - negative
	operandA = 32'sb10111010111110111010111110111100; //-1157910596
	operandB = 32'sb11100000111011001110010111000000; //-521345600 
	command = 3'b001; //SUB COMMAND 
	#5
	//expected -636564996
	if (result != 32'sb11011010000011101100100111111100) begin
		dutpassed = 0;
		$display("Subtractor Failed neg - neg");
	end



	//test XORI
	//0 xor 0
	operandA = 32'b00000000000000000000000000000000; //0
	operandB = 32'b00000000000000000000000000000000; //0
	command = 3'b010; //XORI COMMAND 
	#5
	if (result != 32'd0) begin
		dutpassed = 0;
		$display("XORI Failed 0 xor 0");
	end

	//positive xor positive
	operandA = 32'b01000101000001000101000001000100; //1157910596
	operandB = 32'b00010000100000111100000100000001; //277070081
	command = 3'b010; //XORI COMMAND 
	#5
	
	if (result != 32'b01010101100001111001000101000101) begin
		dutpassed = 0;
		$display("XORI Failed pos xor pos");
	end

	//positive xor negative
	operandA = 32'b01000101000001000101000001000100; //1157910596
	operandB = 32'sb11100000111011001110010111000000; //-521345600 
	command = 3'b010; //XORI COMMAND 
	#5
	
	if (result != 32'b10100101111010001011010110000100) begin
		dutpassed = 0;
		$display("XORI Failed pos xor neg");
	end

	//negative xor negative
	operandA = 32'sb10111010111110111010111110111100; //-1157910596
	operandB = 32'sb11100000111011001110010111000000; //-521345600 
	command = 3'b010; //XORI COMMAND 
	#5

	if (result != 32'sb01011010000101110100101001111100) begin
		dutpassed = 0;
		$display("XORI Failed neg xor neg");
	end



	//test SLT
	//0 slt 0
	operandA = 32'b00000000000000000000000000000000; //0
	operandB = 32'b00000000000000000000000000000000; //0
	command = 3'b011; //SLT COMMAND 
	#5
	if (result != 0) begin
		dutpassed = 0;
		$display("SLT Failed 0 slt 0");
	end

	//positive slt positive
	operandA = 32'b01000101000001000101000001000100; //1157910596
	operandB = 32'b00010000100000111100000100000001; //277070081
	command = 3'b011; //SLT COMMAND 
	#5
	
	if (result != 0) begin
		dutpassed = 0;
		$display("SLT Failed pos slt pos");
	end

	//positive slt negative
	operandA = 32'b01000101000001000101000001000100; //1157910596
	operandB = 32'sb11100000111011001110010111000000; //-521345600 
	command = 3'b011; //SLT COMMAND 
	#5
	
	if (result != 0) begin
		dutpassed = 0;
		$display("SLT Failed pos slt neg");
	end

	//negative slt negative
	operandA = 32'sb10111010111110111010111110111100; //-1157910596
	operandB = 32'sb11100000111011001110010111000000; //-521345600 
	command = 3'b011; //SLT COMMAND 
	#5

	if (result != 1) begin
		dutpassed = 0;
		$display("SLT Failed neg slt neg");
	end

	// if(dutpassed == 1)begin
	// 	$display("ALU passed!");
	// end

// Short delay and then signal that the test is completed
	#5
	endtest = 1;
end

endmodule