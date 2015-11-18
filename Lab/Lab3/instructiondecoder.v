//INSTRUCTION DECODER FOR SINGLE CYCLE CPU


module instructiondecoder(
	output jal,
	output regdst,
	output branch,
	output jump,
	output jr,
	output memtoreg,
	output memwrite,
	output [1:0] aluop,
	output alusrc,
	output regwrite,
	output lsw,
	input [31:0] instruction
	);

	//instructions to control signals

	wire opcode[5:0]; //determines what instruction
	assign opcode[5:0] = instruction [31:26];

	//ALUOP
	//00 = ADD
	//01 = SUB
	//10 = SLT
	//11 = XORI  
	//*When the ALU is not used this does not matter



	if (instruction [31:26] == 6'b000000) begin
		assign instruction[31:26] = instruction [5:0]; //func for r-types
	end

	//LW
	if (instruction [31:26] == 6'b100011)begin
		assign jal = 1'b0;
 		assign regdst = 1'b0;
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b1;
 		assign memwrite = 1'b0;
 		assign aluop = 2'b00;
 		assign alusrc = 1'b0;
 		assign regwrite = 1'b1;
 		assign lsw = 1'b1;
 	end

 	//SW
 	if (instruction [31:26] == 6'b101011)begin
		assign jal = 1'b0;
 		assign regdst = 1'b0;
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0;
 		assign memwrite = 1'b1;
 		assign aluop = 2'b00;
 		assign alusrc = 1'b0;
 		assign regwrite = 1'b0;
 		assign lsw = 1'b1;
 	end
 	
 	//J
 	if (instruction [31:26] == 6'b000010)begin
		assign jal = 1'b0;
 		assign regdst = 1'b0;
 		assign branch = 1'b0;
 		assign jump = 1'b1;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0;
 		assign memwrite = 1'b0;
 		assign aluop = 2'b00;
 		assign alusrc = 1'b0;
 		assign regwrite = 1'b0;
 		assign lsw = 1'b0;
 	end
 	
 	//JR
 	if (instruction [31:26] == 6'b000000)begin
		assign jal = 1'b0;
 		assign regdst = 1'b0;
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b1;
 		assign memtoreg = 1'b0;
 		assign memwrite = 1'b0;
 		assign aluop = 2'b00;
 		assign alusrc = 1'b0;
 		assign regwrite = 1'b0;
 		assign lsw = 1'b0;
 	end

  	//JAL
 	if (instruction [31:26] == 6'b000011)begin
		assign jal = 1'b1;
 		assign regdst = 1'b0;
 		assign branch = 1'b0;
 		assign jump = 1'b1;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0;
 		assign memwrite = 1'b0;
 		assign aluop = 2'b00;
 		assign alusrc = 1'b0;
 		assign regwrite = 1'b0;
 		assign lsw = 1'b0;
 	end

  	//BNE
 	if (instruction [31:26] == 6'b000101)begin
		assign jal = 1'b0;
 		assign regdst = 1'b0; //0 because I-type
 		assign branch = 1'b1;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0;
 		assign memwrite = 1'b0;
 		assign aluop = 2'b01; //SUBTRACT
 		assign alusrc = 1'b0; //must be 0 -> I-Type using ALU
 		assign regwrite = 1'b0;
 		assign lsw = 1'b0;
 	end
 		 		
 	
  	//XORI
 	if (instruction [31:26] == 6'b001110)begin
		assign jal = 1'b0;
 		assign regdst = 1'b0; //0 because I-Type
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0; //False - writing from ALU, not memory
 		assign memwrite = 1'b0;
 		assign aluop = 2'b11; //xor
 		assign alusrc = 1'b0; //0 because I-Type
 		assign regwrite = 1'b1;
 		assign lsw = 1'b0;
 	end
 		

  	//ADD
 	if (instruction [31:26] == 6'b100000)begin
		assign jal = 1'b0;
 		assign regdst = 1'b1; //R-Type
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		assign memwrite = 1'b0;
 		assign aluop = 2'b00;
 		assign alusrc = 1'b1; //R-Type
 		assign regwrite = 1'b1;
 		assign lsw = 1'b0;
 	end
 		

   	//SUB
 	if (instruction [31:26] == 100010)begin
		assign jal = 1'b0;
 		assign regdst = 1'b1; //R-Type
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		assign memwrite = 1'b0;
 		assign aluop = 2'b01;
 		assign alusrc = 1'b1; //R-Type
 		assign regwrite = 1'b1;
 		assign lsw = 1'b0;
 	end

  	//SLT
 	if (instruction [31:26] == 6'b101010)begin
		assign jal = 1'b0;
 		assign regdst = 1'b1; //R-Type
 		assign branch = 1'b0;
 		assign jump = 1'b0;
 		assign jr = 1'b0;
 		assign memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		assign memwrite = 1'b0;
 		assign aluop = 2'b10;
 		assign alusrc = 1'b1; //R-Type
 		assign regwrite = 1'b1;
 		assign lsw = 1'b0;
 	end

 		
endmodule
