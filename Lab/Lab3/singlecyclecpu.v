`include "alu_lab1.v"
`include "concatenate.v"
`include "datamemory.v"
`include "instruction_memory.v"
`include "instructiondecoder.v"
`include "mux32.v"
`include "pc_register.v"
`include "ra_register.v"
`include "register_file.v"
`include "shift_left.v"
`include "sign_extend.v"

module high_level_cpu(
	input [31:0] instruction,
	input clk
	);

reg  [25:0]		instr_to_concat;
reg  [15:0]		instr_to_sign_ext;
reg  [4:0]		instr_rd;
reg  [4:0]		instr_rt;
reg  [4:0]		instr_rs;
wire [31:0]		instr_to_decoder;
wire [31:0]		sign_ext_imm_out;
wire [31:0]		pc_out;
wire [3:0]		pc_to_concat;
wire [31:0]		concat_to_jump;
wire [31:0]		jump_mux_out;
wire [31:0]		pc_new;
wire [31:0]		ra_out;
wire [31:0]		pc_plus4;
wire [31:0]		shift_left_out;
wire [31:0]		pc_plus4_plus_sl;
wire			branchand;
wire [31:0]		branch_mux_to_jump_mux;
wire [4:0]		aw_to_reg;
wire [31:0]		dw_reg;
wire [31:0]		da_reg_to_alu;
wire [31:0]		db_reg;
wire [31:0]		alu_mux_out;
wire			alu_zeroflag;
wire			alu_carryout;
wire			alu_overflow;
wire [31:0]		alu_res;
wire [31:0]		datamem_addr;
wire [31:0]		datamem_out;

wire 		lsw_cntrl;
wire 		jal_cntrl;
wire 		regdst_cntrl;
wire 		branch_cntrl;
wire 		jump_cntrl;
wire 		jr_cntrl;
wire 		mem_to_reg_cntrl;
wire 		mem_write_cntrl;
wire [2:0] 	alu_op_cntrl;
wire 		alu_src_cntrl;
wire 		reg_wr_cntrl;

reg  [2:0] 	adderop;
reg  [31:0]	adder1a;

wire 		adderscarry;
wire 		adderszero;
wire 		addersoverflow;

initial begin
	instr_rd = instruction[15:11];
	instr_rt = instruction[20:16];
	instr_rs = instruction[25:21];
	instr_to_sign_ext = instruction[15:0];
	instr_to_concat = instruction[25:0];

	adderop = 3'b000;
	adder1a = 32'd4;
end

//instruction memory
instruction_memory cpu_instructionmemory(
	pc_out,
	instruction
	);

//controls from instruction
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

//register file
register_file cpu_reg_file(
	reg_wr_cntrl,
	dw_reg,
	aw_to_reg,
	instr_rs,
	instr_rt,
	da_reg_to_alu,
	db_reg, 
	clk
	);

//sign extend immediate
sign_extend cpu_sign_extend(
	instr_to_sign_ext,
	sign_ext_imm_out
	);

//mux for alu src select
mux32 alu_src_mux(
	alu_mux_out,
	alu_src_cntrl,
	sign_ext_imm_out,
	db_reg
	);

//alu
alu cpu_alu(
	alu_res,
	alu_carryout,
	alu_zeroflag,
	alu_overflow,
	da_reg_to_alu,
	db_reg,
	alu_op_cntrl
	);

//shift left
shift_left cpu_shift_left(
	sign_ext_imm_out,
	shift_left_out
	);

//adder 1
alu cpu_adder1(
	pc_plus4,
	adderscarry,
	adderszero,
	addersoverflow,
	adder1a,
	pc_out,
	adderop
	);

//ra register
ra_register cpu_ra(
	pc_plus4,
	jal_cntrl,
	ra_out
	);

//adder 2
alu cpu_adder2(
	pc_plus4_plus_sl,
	adderscarry,
	adderszero,
	addersoverflow,
	pc_plus4,
	shift_left_out,
	adderop
	);

//branch and gate
`AND(branchand, branch_cntrl, alu_zeroflag);

//branch mux
mux32 branch_mux(
	branch_mux_to_jump_mux,
	branchand,
	pc_p,
	pc_plus4_plus_sl
	);

//concatenate
concatenate cpu_concat(
	concat_to_jump,
	pc_to_concat,
	instr_to_concat
	);

//jump mux
mux32 jump_mux(
	jump_mux_out,
	jump_cntrl,
	branch_mux_to_jump_mux,
	concat_to_jump
	);

//jr mux
mux32 jr_mux(
	pc_new,
	jr_cntrl,
	jump_mux_out,
	ra_out
	);

//pc
pc_register cpu_pc(
	pc_new,
	pc_out
	);

//lsw mux
mux32 lsw_mux(
	datamem_addr,
	lsw_cntrl,
	alu_res,
	sign_ext_imm_out
	);

//data memory
datamemory cpu_datamem(
	clk,
	datamem_out,
	datamem_addr,
	mem_write_cntrl,
	db_reg
	);

//mem to reg mux
mux32 mem_to_reg_mux(
	dw_reg,
	mem_to_reg_cntrl,
	alu_res,
	datamem_out
	);

endmodule