
`include "instructiondecoder.v"

module instructiondecodertestharness();

	
	//wire jal;
	//wire regdst;
	//wire branch;
	//wire jump;
	//wire jr;
	//wire memtoreg;
	//wire memwrite;
	//wire [1:0] aluop;
	//wire alusrc;
	//wire regwrite;
	//wire lsw;
	//wire [31:0] instruction;
	wire Clk;
  


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
    .Clk(Clk)
  );

    // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
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
input [1:0] aluop,
input alusrc,
input regwrite,
input lsw,
output reg [31:0] instruction,
output Clk
);

//Initialize Driver Signals
	initial begin
		instruction = 32'b00000000000000000000000000000000;
    	Clk=0;
	end

	always @(posedge begintest) begin
    	endtest = 0;
    	dutpassed = 1;
    #10


    //TEST CASE 1: LW
    instruction = 32'b10001100000000000000000000000000;
    #5 Clk=1; #5 Clk=0; //Clock Pulse

    if ((((jal != 1'b0) || (regdst != 1'b0)) || ((branch != 1'b0) || ((jr !=0 || (memtoreg!=1))))) || (((memwrite != 1'b0) || (aluop != 2'b00)) || ((alusrc != 0) || ((regwrite!= 1) || lsw != 1)) )) begin
    	dutpassed = 0;
    $display("Test Case 1 Failed: Load Word Instruction");
    end
    



endmodule
