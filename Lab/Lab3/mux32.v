//general purpose 2 input 32bit mux
module mux32(
	output reg[31:0] muxout,
	input muxcontrol,
	input [31:0] muxin1,
	input [31:0] muxin2
	);
	

	always @ (muxin1 or muxin2 or muxcontrol)
	begin
	if (muxcontrol == 1'b0) muxout = muxin1;
	else muxout = muxin2;
	end
endmodule
	