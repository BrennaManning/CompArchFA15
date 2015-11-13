`include datamemory.v
`include instructionfetchunit.v



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





 


`
