
`include "instructiondecoder.v"

module addertestharness();


	wire [31:0] sum;
	
	wire [31:0] b;
	wire [31:0] a;
	
  reg		begintest;	// Set High to begin testing register file
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
    
    .sum(sum),
    .a(a),
    .b(b),
    
    .dutpassed(dutpassed)
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
		a = 32'd0;
		b = 32'd0;
    	
	end

	always @(posedge begintest) begin
    	endtest = 0;
    	dutpassed = 1;
    #10
	

    //TEST CASE 1: 
    //a = 32'd1;
    a = 32'b00000000000000000000000000000001;
    //b = 32'd2;
    b = 32'b00000000000000000000000000000010;
	
    if ((sum!= 32'b00000000000000000000000000000011))begin
	dutpassed = 0;
	$display("a = %b", a);
	$display("b = %b", b);
	$display("sum 1 + 2 = %b", sum);
    	$display("Test Case 1 Failed:");
    end
    else begin
	$display ("1+2=3");
    end
    
    end

endmodule
