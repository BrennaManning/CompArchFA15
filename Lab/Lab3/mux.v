//general purpose mux
module mux(
	output[31:0] muxout,
	input muxcontrol,
	input [31:0] muxin1,
	input [31:0] muxin2,
	);
	if (muxcontrol == 0) begin
		muxout <= muxin1
	end
	if(muxcontrol == 0) begin
		muxout <= muxin2
	end

endmodule