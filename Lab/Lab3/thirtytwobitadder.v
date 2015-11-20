
module thirtytwobitadder(
output [31:0] sum; 
input [31:0] a;
input [31:0] b; 
);
reg [31:0] sum;

always @(a || b)begin
	assign sum = a+b;
end
end module
