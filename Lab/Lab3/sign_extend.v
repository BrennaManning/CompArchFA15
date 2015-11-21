//sign_extend.v
//comp arch lab 3

module sign_extend(
	input  	[15:0] instruction, //the msb bit is the sign bit
	output reg	[31:0] sign_ext_out
	);
	always@(instruction)
  	begin 
    	sign_ext_out <= $signed(instruction);
  	end
endmodule
