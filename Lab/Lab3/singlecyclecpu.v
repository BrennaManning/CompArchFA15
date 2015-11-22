`include alu.v
`include concatenate.v
`include datamemory.v
`include instruction_memory.v
`include instructiondecoder.v
`include mux32.v
`include pc_register.v
`include ra_register.v
`include register_file.v
`include shift_left.v
`include sign_extend.v


//currently just inputs and wires based on the day 10 slide 47
module high_level_cpu(
	input [31:0] instruction
);

wire instr_to_concat;
wire instr_to_sign_ext;
wire [4:0] instr_rd;
wire [4:0] instr_rt;
wire instr_rs;
wire instr_to_decoder:
wire sign_ext_imm_out;
wire pc_out;
wire pc_to_concat;
wire concat_to_jump;
wire jump_mux_out;
wire pc_new;
wire ra_out;
wire pc_plus4;
wire shift_left_out;
wire pc_plus4_plus_sl;
wire branchand;
wire branch_mux_to_jump_mux;
wire [4:0] aw_to_reg;
wire dw_reg;
wire da_reg_to_alu;
wire db_reg;
wire alu_mux_in;
wire alu_zeroflag;
wire alu_carryout;
wire alu_overflow;
wire alu_res;
wire datamem_addr;
wire datamem_out;


wire lsw_cntrl;
wire jal_cntrl;
wire regdst_cntrl;
wire branch_cntrl;
wire jump_cntrl;
wire jr_cntrl;
wire mem_to_reg_cntrl;
wire mem_write_cntrl;
wire [2:0] alu_op_cntrl;
wire alu_src_cntrl;
wire reg_wr_cntrl;


instructiondecoder cpu_instructiondecoder(
	jal_cntrl,
	regdst_cntrl,
	branch_cntrl,
	jump_cntrl,
	jr_cntrl,
	mem_to_reg_cntrl,
	mem_write_cntrl,
	alu_op_cntrl,
	alu_src_cntrl,
	reg_wr_cntrl,
	lsw_cntrl,
	instruction
	);


//when reg dst is 1, select rd, when reg dst is 0 select rt
mux5 reg_aw_mux(
	aw_to_reg,
	regdst_cntrl,
	instr_rt,
	instr_rd

	);




endmodule
