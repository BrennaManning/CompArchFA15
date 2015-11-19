//general purpose 2 input mux
module mux32(
	output[31:0] muxout,
	input muxcontrol,
	input [31:0] muxin1,
	input [31:0] muxin2
	);
	integer i;
	

		if (muxcontrol == 0) begin
			for (i = 0; i < 32; i = i + 1)begin
				muxout [i]   = muxin1 [i]  ;
			end
		end
	
		else begin
			for (i = 0; i < 32; i = i + 1)begin
				muxout[i] = muxin2 [i];
			end

		end
	end

endmodule