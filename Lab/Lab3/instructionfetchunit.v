`include mux.v

module instructionfetchunit(
	input[31:0] pc,				//program counter
	input[31:0] targetInstr,	//target instruction	
	input jump,					//jump control signal

	);
endmodule

//we need to look up or build a concatentate(output, input1, input2)
concatentate pc_concat(pc_concat_out, pc[31:28], targetInstr[25:0]);

//make a sign extend?? input is imm16, output is sign_ext_out
signextend sign_ext(sign_ext_out, imm16);

//double check this (output, input1, input2)
AND branch_and(branch_and_out, branch, zero);

mux mux_branch(.muxcontrol(branch_and_zero_out),
				.muxin1(1'b0),
				.muxin2(sign_ext_out),
				.muxout(mux_branch_out));

//we need to make sure our ALU exists and the inputs order matches
//do we want to use an ALU or just an adder?
alu fetch_alu(alu_out, pc, mux_branch_out, alu_ctrl);

mux mux_jump(.muxcontrol(jump),
				.muxin1(pc_concat_out),
				.muxin2(alu_out),
				.muxout(mux_jump_out));

//reset the pc to mux_jump_out
//not sure exactly how to do this... maybe using a pc write enable?

//need to make an instruction memory (instr[31:0], addr[31:2], addr[1:0])
instmem pc_inst_mem(pc_inst_mem_out, pc[31:2], 2'b00);