//sign_extend.v
//comp arch lab 3

module sign_extend(
	input 		[15:0] instruction,
	output reg	[15:0] immediate,
	output reg	[31:0] sign_ext_out
	);
	
	initial begin
		//if the MSB of the instruction is zero, extend the immediate to be zeros
		if (instruction[15] == 0) begin
			assign immediate = 16'b0000000000000000;
		end
		//if the MSB of the instruction is one, extend the immediate to be ones
		if (instruction[15] == 1) begin
			assign immediate = 16'b1111111111111111;
		end

		sign_ext_out = instruction + immediate;
	end

endmodule