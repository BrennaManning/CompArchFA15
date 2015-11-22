
`include "mux5.v"

module mux5testharness(
    output reg dutPassed,
    output reg testDone,
    input startTests);

    wire [4:0] muxout;
    wire muxcontrol;
    wire [4:0] muxin1;
    wire [4:0] muxin2;
	
  


  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  mux5 DUT
  (
    .muxout(muxout),
    .muxcontrol(muxcontrol),
    .muxin1(muxin1),
    .muxin2(muxin2)
  );

  mux5testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .muxout(muxout),
    .muxcontrol(muxcontrol),
    .muxin1(muxin1),
    .muxin2(muxin2), 
    .dutpassed(dutpassed)
  );

    // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  always @(posedge startTests) begin
    begintest=0;
    dutPassed = 1;
	#10
    begintest=1;
 	
  end
  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
	dutPassed = dutpassed;
	testDone = endtest;
    $display("DUT passed?: %b", dutpassed);
  end

endmodule



module mux5testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input [5:0] muxout,
output reg [5:0] muxin1,
output reg [5:0] muxin2,
output reg muxcontrol

);

//Initialize Driver Signals
	initial begin
		muxcontrol = 5'd0;
    	
	end

	always @(posedge begintest) begin
    	endtest = 0;
    	dutpassed = 1;
    #10
	

    //TEST CASE 1: 
    muxcontrol = 0;
	
    if (muxout != muxin1)begin
    	dutpassed = 0;
    	$display("Test Case 1 Failed");
    end
    
    //TEST CASE 2:
    muxcontrol =1;

    if (muxout != muxin2) begin
	dutpassed = 0;
	$display("Test Case 2 Failed");
    end

   if (dutpassed == 1) begin
	$display("Mux testbench passed!");
	endtest = 1;
	end
end
endmodule
