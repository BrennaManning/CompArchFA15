`include datamemory.v
`include instructionfetchunit.v

`include mux.v
`include alu.v

//currently just inputs and wires based on the day 10 slide 47
module cpu(
	input regdst,
	input regwr,
	input branch,
	input jump,
	input alucntrl,
	input alusrc,
	input memwr,
	input memtoreg
);
	wire rd;
	wire rt;
	wire regAw;
	wire rs;
	wire regAa; 
	wire regAb;
	wire regDa;
	wire regDb;
	wire regDw;
	wire imm16;
	wire signextendout;
	wire alusrcmuxout;
	wire aluzeroflag;
	wire alures;
	wire branch;
	wire jump;
	wire instrfetchout;
	wire datamemout;
	wire memmuxout;

endmodule
