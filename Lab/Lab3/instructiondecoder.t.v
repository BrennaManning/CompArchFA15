//`include "instructiondecoder.v"

module instructiondecodertestharness(
output reg dutPassed,
output reg testDone,
input startTests
);

	
	wire jal;
	wire regdst;
	wire branch;
	wire jump;
	wire jr;
	wire memtoreg;
	wire memwrite;
	wire [2:0] aluop;
	wire alusrc;
	wire regwrite;
	wire lsw;
	wire [31:0] instruction;
	
  


  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  instructiondecoder DUT
  (
    .jal(jal),
    .regdst(regdst),
    .branch(branch),
    .jump(jump),
    .jr(jr),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .aluop(aluop),
    .alusrc(alusrc),
    .regwrite(regwrite),
    .lsw(lsw),
    .instruction(instruction)
  );

  instructiondecodertestbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
     .jal(jal),
    .regdst(regdst),
    .branch(branch),
    .jump(jump),
    .jr(jr),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .aluop(aluop),
    .alusrc(alusrc),
    .regwrite(regwrite),
    .lsw(lsw),
    .instruction(instruction),
    .dutpassed(dutpassed)
  );

    // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
 always @(posedge startTests) begin
    begintest=0;
    dutPassed = 1;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    dutPassed = dutpassed;
    //$display("Instruction Decoder DUT passed?: %b", dutpassed);
    testDone = endtest;
  end

endmodule



module instructiondecodertestbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input jal,
input regdst,
input branch,
input jump,
input jr,
input memtoreg,
input memwrite,
input [2:0] aluop,
input alusrc,
input regwrite,
input lsw,
output reg [31:0] instruction

);

//Initialize Driver Signals
	initial begin
		instruction = 32'd0;
    	
	end

	always @(posedge begintest) begin
        $display("Testing Instruction Decoder now...");
    	endtest = 0;
    	dutpassed = 1;
    #10
	

    //TEST CASE 1: LW
    instruction = 32'b10001100000000000000000000000000;
	
    if (((((((((((jal != 1'b0)||(regdst != 1'b0))||(branch != 1'b0))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b1)) || (memwrite != 1'b0)) || (aluop != 3'b000)) || (alusrc != 1'b0)) || (regwrite != 1'b1)) || (lsw != 1'b1))begin
    	dutpassed = 0;
    	$display("Test Case 1 Failed: Load Word Instruction");
    end
    
    //TEST CASE 2: SW
    instruction = 32'b10101100000000000000000000000000;
	
    if (((((((((((jal != 1'b0)||(regdst != 1'b0))||(branch != 1'b0))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b0)) || (memwrite != 1'b1)) || (aluop != 3'b000)) || (alusrc != 1'b0)) || (regwrite != 1'b0)) || (lsw != 1'b1))begin
    	dutpassed = 0;
    	$display("Test Case 2 Failed: Store Word Instruction");
    end

    //TEST CASE 3: JUMP
    instruction = 32'b00001000000000000000000000000000;
    if (((jump != 1)||(jal != 0))||((lsw != 0)||(jr != 0)))begin
    	dutpassed = 0;
    	$display("Test Case 3 Failed: Jump Instruction");
    end

    //TEST CASE 4: JR
    instruction = 32'b00000000000000000000000000001000;
    if ((jal != 0) || (jr != 1))begin
    	dutpassed = 0;
    	$display("Test Case 4 Failed: Jump Register Instruction");
    end

    //TEST CASE 5: JAL
    instruction = 32'b00001100000000000000000000000000;
    if (((((branch != 0) || (jump != 1)) || (lsw != 0)) || (jal != 1))||(jr != 0))begin
    	dutpassed = 0;
    	$display("Test Case 5 Failed: Jump amd Link Instruction");
    end

    //TEST CASE 6: BNE 
    instruction = 32'b00010100000000000000000000000000;
    if (((((((((((jal != 1'b0)||(regdst != 1'b0))||(branch != 1'b1))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b0)) || (memwrite != 1'b1)) || (aluop != 3'b001)) || (alusrc != 1'b0)) || (regwrite != 1'b0)) || (lsw != 1'b0))begin
    	dutpassed = 0;
    	$display("Test Case 6 Failed: BNE Instruction");
    end

    //TEST CASE 7: XORI 
    instruction = 32'b00111000000000000000000000000000;
    if (((((((((((jal != 1'b0)||(regdst != 1'b0))||(branch != 1'b0))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b0)) || (memwrite != 1'b1)) || (aluop != 3'b010)) || (alusrc != 1'b0)) || (regwrite != 1'b0)) || (lsw != 1'b0))begin
    	dutpassed = 0;
    	$display("Test Case 7 Failed: XORI Instruction ");
    end


    //TEST CASE 8: ADD 
    instruction = 32'b00000000000000000000000000100000;
    if (((((((((((jal != 1'b0)||(regdst != 1'b1))||(branch != 1'b0))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b0)) || (memwrite != 1'b1)) || (aluop != 3'b000)) || (alusrc != 1'b1)) || (regwrite != 1'b0)) || (lsw != 1'b0))begin
    	dutpassed = 0;
    	$display("Test Case 8 Failed: Add Instruction ");
    end


    //TEST CASE 9: SUB
    instruction = 32'b00000000000000000000000000100010;
    if (((((((((((jal != 1'b0)||(regdst != 1'b1))||(branch != 1'b0))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b0)) || (memwrite != 1'b1)) || (aluop != 3'b001)) || (alusrc != 1'b1)) || (regwrite != 1'b0)) || (lsw != 1'b0))begin
    	dutpassed = 0;
    	$display("Test Case 9 Failed: Sub Instruction ");
    end


    //TEST CASE 10: SLT
    instruction = 32'b00000000000000000000000000001110;
    if (((((((((((jal != 1'b0)||(regdst != 1'b1))||(branch != 1'b0))||(jump != 1'b0))||(jr != 1'b0)) || (memtoreg != 1'b0)) || (memwrite != 1'b1)) || (aluop != 3'b011)) || (alusrc != 1'b1)) || (regwrite != 1'b0)) || (lsw != 1'b0))begin
    	dutpassed = 0;
    	$display("Test Case 10 Failed: SLT Instruction ");
    end

    //TEST CASE 11: False Instruction
    instruction = 32'b11111111111111111111111111111111;
    if (((((((((((jal == 1'b1)||(regdst == 1'b1))||(branch == 1'b1))||(jump == 1'b1))||(jr == 1'b1)) || (memtoreg == 1'b1)) || (memwrite == 1'b1)) || (aluop == 3'b000)) || (alusrc == 1'b1)) || (regwrite == 1'b0)) || (lsw == 1'b0))begin
    	dutpassed = 0;
	$display("Test Case 11 Failed: Returned High when given false instruction");
    end
    #100
    
    if (dutpassed == 1)begin
	// $display("Instruction Decoder passed!");
	   endtest = 1;
    end

    end
endmodule
