module addertestharness();

  wire [31:0] sum;
  wire [31:0] a;
  wire [31:0] b;

  reg		  begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  thirtytwobitadder DUT
  (    
    .sum(sum),
    .a(a),
    .b(b)
  );

  addertestbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .sum(sum),
    .a(a),
    .b(b)  
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10
    begintest=1;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule

module addertestbench
  (
    // Test bench driver signal connections
    input	   		begintest,	// Triggers start of testing
    output reg 		endtest,	// Raise once test completes
    output reg 		dutpassed,	// Signal test result

    // Register File DUT connections
    input [31:0] sum,

    output reg [31:0] a,
    output reg [31:0] b
  );

  //Initialize Driver Signals
	initial begin
		a = 'd0;
		b = 'd0;
	end

	always @(posedge begintest) begin
    	endtest = 0;
    	dutpassed = 1;
  #10

  //TEST CASE 1:
  a = 'd5;
  b = 'd2;

  if (sum !== 'd7) begin
    dutpassed = 0;
    $display("fail on 5+2 == 7");
    $display("a = %d", a);
    $display("b = %d", b);
    $display("sum = %d", sum);
  end
	
  // //TEST CASE 2:
  // a = 32'd10;
  // b = 32'd12;

  // if (sum == 32'd22) begin
  //   dutpassed = 0;
  //   $display("success on 10+12 == 22");
  //   $display("a = %d", a);
  //   $display("b = %d", b);
  //   $display("sum = %d", sum);
  // end

  // //TEST CASE 3:
  // a = 32'd0;
  // b = 32'd0;

  // if (sum !== 32'd0) begin
  // dutpassed = 0;
  //   $display("success on 0+0 == 0");
  //   $display("a = %d", a);
  //   $display("b = %d", b);
  //   $display("sum = %d", sum);
  // end

  // if (sum !== 32'd4) begin
    // 	dutpassed = 0;
    // 	$display("a = %b", a);
    // 	$display("b = %b", b);
    // 	$display("sum a + b = %b", sum);
    // 	$display("Test Case 1 Failed");
  // end

  if (dutpassed == 1) begin
    $display("Thirty-two bit adder passed");
  end

end
    
endmodule