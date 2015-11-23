
//test bench for the data memory
//comparch lab 3
//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

module registerfiletestbenchharness(
output reg dutPassed,
output reg testDone,
input startTests
);
  //instantiate the wires for the register
wire WrEn;
wire[31:0] Dw;
wire[4:0] Aw;
wire[4:0] Aa;
wire[4:0] Ab;
wire[31:0] Da;
wire[31:0] Db; // Enable writing of register when High
wire clk;
  
  //wires for the tester
  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the data memory being tested.  DUT = Device Under Test
  register_file DUT
  (
    .WrEn(WrEn),
    .Dw(Dw),
    .Aw(Aw),
    .Aa(Aa),
    .Ab(Ab),
    .Da(Da),
    .Db(Db),
    .clk(clk)
  );

  // Instantiate test bench to test the DUT
  registerFileTestBench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .WrEn(WrEn),
    .Dw(Dw),
    .Aw(Aw),
    .Aa(Aa),
    .Ab(Ab),
    .Da(Da),
    .Db(Db),
    .clk(clk)
  );

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
    //$display("Register File DUT passed?: %b", dutpassed);
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

module registerFileTestBench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
output reg WrEn,
output reg[31:0] Dw,
output reg[4:0] Aw,
output reg[4:0] Aa,
output reg[4:0] Ab,
input[31:0] Da,
input[31:0] Db,
output reg clk
);


  // Initialize outputs from the test bench
  initial begin
    WrEn=0;
    Dw=32'd0;
    Aw=5'd0;
    Aa=5'd0;
    Ab=5'd0;
    clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    $display("Testing Register File now...");
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 0: 
  //   Write '69' to address 4, then read it back
  Aw=5'd4;
  Dw=32'd69;
  WrEn=1;
  Aa=5'd4;
  Ab=5'd4;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	// Generate double

  // Verify expectations and report test result
  if((Da !== 69) || (Db !== 69)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Register File test case 0 failed, da=%b", Da);
  end
  
  // Test Case 1: 
  //   attempt to Write '69' to address 0, should read back 0
  Aw=5'd0;
  Dw=32'd69;
  WrEn=1;
  Aa=5'd0;
  Ab=5'd0;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	// Generate double
  // Verify expectations and report test result
  if((Da !== 0) || (Db !== 0)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Register File test case 1 failed");
  end
  
  // Test Case 2: 
  //   write 420 to address 25, then read it back and read 69 from address 4
  Aw=5'd25;
  Dw=32'd420;
  WrEn=1; 
  Aa=5'd4;
  Ab=5'd25;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	// Generate double
  //$display("Register error checking - Aw is %d, Ab is %d", Aw, Ab);
  // Verify expectations and report test result
  if((Da !== 69) || (Db !== 420)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Register file Test case 2 failed, Da=%b, Db=%b",Da, Db);
  end

 // Test Case 3: 
  //   test to see if the WrEn flag works
  Aw=5'd25;
  Dw=32'd42;
  WrEn=0;
  Aa=5'd25;
  Ab=5'd25;
  #5 clk=1; #5 clk=0; #5 clk=1; #5 clk=0;	// Generate double

  // Verify expectations and report test result
  if((Da !== 420) || (Db !== 420)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Register file Test case 3 failed, Da=%b",Da);
  end

    if (dutpassed == 1) begin
      // $display("Register File passed!");
      endtest = 1;
    end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule