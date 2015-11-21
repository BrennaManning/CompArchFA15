module shift_left(
	input		[31:0] sign_ext,
	output reg	[31:0] shift_left_out
	);
	
	initial begin
		assign shift_left_out = sign_ext << 2;	//shift left by two
	end

endmodule
