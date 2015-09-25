//define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50


module behavioralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire[3:0] inputs = {in3, in2, in1, in0};
wire[1:0] address = {address1, address0};
assign out = inputs[address];
endmodule

module structuralMultiplexer(out, address0,address1, in0,in1,in2,in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
  // Multiplexer code
	not NotGate0(address0_n, address0);
	not NotGate1(address1_n, address1);

	and AndGate0(out0, address1, address0, in0);
	and AndGate1(out1, address1_n, address0, in1);
	and AndGate2(out2, address1, address0_n, in2);
	and AndGate3(out3, address1_n, address0_n, in3);

	or OrGateFinal(out, out0, out1, out2, out3);
endmodule
	

module testMultiplexer;
  //test code 

reg addr0, addr1;
reg in0, in1, in2, in3;
wire out;
//behavioralMultiplexer multiplexer (out,addr0,addr1,in0,in1,in2,in3);
structuralMultiplexer multiplexer (out, addr0,addr1, in0,in1,in2,in3);
//swap after testing

initial begin
$display("A0 A1 In0 In1 In2 In3 | Out | Expected Output");
addr0=0;addr1=0;in0=0;in1=0;in2=0;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  0", addr0, addr1, in0, in1, in2, in3, out);
addr0=0;addr1=0;in0=0;in1=0;in2=0;in3=1; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  1", addr0, addr1, in0, in1, in2, in3, out);
addr0=0;addr1=1;in0=0;in1=0;in2=0;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  0", addr0, addr1, in0, in1, in2, in3, out);
addr0=0;addr1=1;in0=0;in1=0;in2=1;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  1", addr0, addr1, in0, in1, in2, in3, out);
addr0=1;addr1=0;in0=0;in1=0;in2=0;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  0", addr0, addr1, in0, in1, in2, in3, out);
addr0=1;addr1=0;in0=0;in1=1;in2=0;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  1", addr0, addr1, in0, in1, in2, in3, out);
addr0=1;addr1=1;in0=0;in1=0;in2=0;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  0", addr0, addr1, in0, in1, in2, in3, out);
addr0=1;addr1=1;in0=1;in1=0;in2=0;in3=0; #1000
$display("%b  %b  %b  %b  %b  %b  |  %b  |  1", addr0, addr1, in0, in1, in2, in3, out);
end
//A0 and A1 inputs of multiplexer determine which input changes the output. Other inputs do not matter.
//Ex Truth Table:
//A0 A1 in0 in1 in2 in3 out
//0  0   x   x   x   1   1
//0  1   x   x   1   x   1
//1  0   x   1   x   x   1
//1  1   1   x   x   x   1 

endmodule
