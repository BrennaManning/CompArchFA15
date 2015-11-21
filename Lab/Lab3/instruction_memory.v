//instruction memory
//input: .dat hex file exported from MARS
//output: instruction

module instruction_memory(
	input[31:0] address,
	output[31:0] instr_mem_out
	);
	
	reg [31:0] memory[1023:0];
	initial $readmemh("file.dat", memory);
	assign instr_mem_out = memory[address];

endmodule