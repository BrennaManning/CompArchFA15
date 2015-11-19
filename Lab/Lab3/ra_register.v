// ra_register
// comp arch lab 3

module ra_register(
	input [31:0] ra_reg_in,
	input jal,
	output reg [31:0] ra_reg_out
	);

	always @(posedge jal) begin
		assign ra_reg_out = ra_reg_in;
	end

endmodule