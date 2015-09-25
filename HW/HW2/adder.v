//define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50


module behavioralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
output out, carryout;
input a, b, carryin;
  // Your adder code here
	xor XorGateBC(bcXor, b, carryin);
	xor XorGateSum(out, a, bcXor);
	and AndGateBC(bcAnd, b, carryin);
	and AndGateAB(abAnd, a, b);
	and AndGateAC(acAnd, a, carryin);
	or OrGateC(carryout, bcAnd, abAnd, acAnd);
	
	
	
endmodule

module testFullAdder;
reg a, b, carryin;
wire sum, carryout;
//behavioralFullAdder adder (sum, carryout, a, b, carryin);
structuralFullAdder adder (sum, carryout, a, b, carryin);

initial begin
  // Your test code here
$display("A B  CIn|Sum COut| Expected Output");
a=0; b=0; carryin=0; #1000 
$display("%b  %b  %b |  %b  %b  |  0  0  ", a, b, carryin, sum, carryout);
a=1;b=0;carryin=0; #1000
$display("%b  %b  %b |  %b  %b  |  1  0  ", a, b, carryin, sum, carryout);
a=0;b=1;carryin=0; #1000
$display("%b  %b  %b |  %b  %b  |  1  0  ", a, b, carryin, sum, carryout);
a=1;b=1;carryin=0; #1000
$display("%b  %b  %b |  %b  %b  |  0  1  ", a, b, carryin, sum, carryout);
a=0; b=0; carryin=1; #1000 
$display("%b  %b  %b |  %b  %b  |  1  0  ", a, b, carryin, sum, carryout);
a=1;b=0;carryin=1; #1000
$display("%b  %b  %b |  %b  %b  |  0  1  ", a, b, carryin, sum, carryout);
a=0;b=1;carryin=1; #1000
$display("%b  %b  %b |  %b  %b  |  0  1  ", a, b, carryin, sum, carryout);
a=1;b=1;carryin=1; #1000
$display("%b  %b  %b |  %b  %b  |  1  1  ", a, b, carryin, sum, carryout);
end
endmodule
