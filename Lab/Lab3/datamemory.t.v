//test bench for the data memory
//comparch lab 3
//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

module datamemorytestbenchharness(
output reg dutPassed,
output reg testDone,
input startTests
);

  //instantiate the wires for the data memory
  wire clk;
  wire[31:0] dataOut;
  wire[31:0] address;
  wire[31:0] dataIn;
  wire writeEnable;	// Enable writing of register when High
  
  //wires for the tester
  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the data memory being tested.  DUT = Device Under Test
  datamemory DUT
  (
    .dataOut(dataOut),
    .address(address),
    .dataIn(dataIn),
    .writeEnable(writeEnable),
    .clk(clk)
  );

  // Instantiate test bench to test the DUT
  dataMemoryTestBench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .dataOut(dataOut),
    .address(address),
    .dataIn(dataIn),
    .writeEnable(writeEnable),
    .clk(clk)
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
    $display("DUT passed?: %b", dutpassed);
    testDone = endtest;
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module dataMemoryTestBench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		dataOut,
output reg[31:0]	address,
output reg[31:0]	dataIn,
output reg 		writeEnable,
output reg		clk
);


  // Initialize register driver signals
  initial begin
    address=32'd0;
    dataIn=32'd0;
    writeEnable=0;
    clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    $display("testing datamemory now");
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 0: 
  //   Write '42' to address 0, then read it back
  address=32'd0;
  dataIn=32'd42;
  writeEnable=1;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	// Generate double

  // Verify expectations and report test result
  if((dataOut !== 42) || (dataOut !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test case 0 failed");
  end
  
   // Test Case 1: 
  //  try to write 48 to address 0, but writeenable is off,should stil be 42
  address=32'd0;
  dataIn=32'd48;
  writeEnable=0;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	// Generate double clock pulse

  // Verify expectations and report test result
  if((dataOut !== 42) || (dataOut !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test case 1 failed");
  end
  
   // Test Case 2: 
  //  try to write 48 to address 1 and overwrite the old value, then read from address 0
  address=32'd1;
  dataIn=32'd48;
  writeEnable=1;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	 // Generate double clock pulse
  //now we read from address 0
  writeEnable = 0;
  address = 32'd0;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	 // Generate double clock pulse
  // Verify expectations and report test result
  if((dataOut !== 42) || (dataOut !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test case 2 failed");
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule