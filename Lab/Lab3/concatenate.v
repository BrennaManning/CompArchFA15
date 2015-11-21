module concatenate(
	output reg [32:0] out,
	input [3:0] pc,
	input [25:0] instr
	);
	
	wire zeros;
	assign zeros = 1'b0;
	
	always @(pc or instr)begin
	
	assign out = {pc, instr, zeros, zeros};
	end
	

	
endmodule