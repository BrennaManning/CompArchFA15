module thirtytwobitadder(
output reg [31:0] sum,
input [31:0] a,
input [31:0] b 
);

always @(a || b)begin
	assign sum = a+b;
end
endmodule
