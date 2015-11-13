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





module cpu
(

);
	wire rd;
	wire rt;
	wire regdst;
	wire regAw;
	wire rs;
	wire regAa; 
	wire regAb;
	wire regDa;
	wire regDb;
	wire regDw;
	wire regWrEn;
	wire imm16;
	wire signextendout;
	wire alusrc;
	wire alusrcmuxout;
	wire alucntrl;
	wire aluzeroflag;
	wire alures;
	wire branch;
	wire jump;
	wire instrfetchout;
	wire memwr;
	wire datamemout;
	wire memtoreg;
	wire memmuxout;





 


`
