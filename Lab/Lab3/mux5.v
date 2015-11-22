//general purpose 2 input 32bit mux
module mux5(
	output reg[5:0] muxout,
	input muxcontrol,
	input [5:0] muxin1,
	input [5:0] muxin2
	);
	

	always @ (muxin1 or muxin2 or muxcontrol)
	begin
	if (muxcontrol == 1'b0) muxout = muxin1;
	else muxout = muxin2;
	end
endmodule
	