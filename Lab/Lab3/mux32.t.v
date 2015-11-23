//`include "mux32.v"

module mux32testharness(
    output reg dutPassed,
    output reg testDone,
    input startTests);

    wire [31:0] muxout;
    wire muxcontrol;
    wire [31:0] muxin1;
    wire [31:0] muxin2;
	
  
  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  mux32 DUT
  (
    .muxout(muxout),
    .muxcontrol(muxcontrol),
    .muxin1(muxin1),
    .muxin2(muxin2)
  );

  mux32testbench tester
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
    //$display("Mux 32 DUT passed?: %b", dutpassed);
  end

endmodule


module mux32testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input [31:0] muxout,
output reg [31:0] muxin1,
output reg [31:0] muxin2,
output reg muxcontrol

);

//Initialize Driver Signals
	initial begin
		muxcontrol = 32'd0;
	end

	always @(posedge begintest) begin
      $display("Testing Mux32 now...");
    	endtest = 0;
    	dutpassed = 1;
    #10
	
  
    //TEST CASE 0: 
    muxcontrol = 0;
	
    if (muxout != muxin1)begin
    	dutpassed = 0;
    	$display("Test Case 0 Mux32 Failed");
    end
    
    //TEST CASE 1:
    muxcontrol =1;

    if (muxout != muxin2) begin
      dutpassed = 0;
      $display("Test Case 1 Mux32 Failed");
    end

    if (dutpassed == 1) begin
      // $display("Mux32 passed!");
      endtest = 1;
    end

end
endmodule
