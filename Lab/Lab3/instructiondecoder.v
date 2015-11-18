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
	output lw,
	input [31:0] instruction
	);

	//instructions to control signals

	wire opcode; //determines what instruction
	opcode <= instruction [31:26];

	//ALUOP
	//00 = ADD
	//01 = SUB
	//10 = SLT
	//11 = XORI  
	//*When the ALU is not used this does not matter



	if (opcode == 6'b000000) begin
		opcode = instruction [5:0]; //func for r-types
	end

	//LW
	if (opcode == 6'b100011)begin
		jal <= 1'b0;
 		regdst <= 1'b0;
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b1;
 		memwrite <= 1'b0;
 		aluop <= 2'b00;
 		alusrc <= 1'b0;
 		regwrite <= 1'b1;
 		lw <= 1'b1;
 	end

 	//SW
 	if (opcode == 6'b101011)begin
		jal <= 1'b0;
 		regdst <= 1'b0;
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b0;
 		memwrite <= 1'b1;
 		aluop <= 2'b00;
 		alusrc <= 1'b0;
 		regwrite <= 1'b0;
 		lw <= 1'b0;
 	end
 	
 	//J
 	if (opcode == 6'b000010)begin
		jal <= 1'b0;
 		regdst <= 1'b0;
 		branch <= 1'b0;
 		jump <= 1'b1;
 		jr <= 1'b0;
 		memtoreg <= 1'b0;
 		memwrite <= 1'b0;
 		aluop <= 2'b00;
 		alusrc <= 1'b0;
 		regwrite <= 1'b0;
 		lw <= 1'b0;
 	end
 	
 	//JR
 	if (opcode == 6'b000000)begin
		jal <= 1'b0;
 		regdst <= 1'b0;
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b1;
 		memtoreg <= 1'b0;
 		memwrite <= 1'b0;
 		aluop <= 2'b00;
 		alusrc <= 1'b0;
 		regwrite <= 1'b0;
 		lw <= 1'b0;
 	end

  	//JAL
 	if (opcode == 6'b000011)begin
		jal <= 1'b1;
 		regdst <= 1'b0;
 		branch <= 1'b0;
 		jump <= 1'b1;
 		jr <= 1'b0;
 		memtoreg <= 1'b0;
 		memwrite <= 1'b0;
 		aluop <= 2'b00;
 		alusrc <= 1'b0;
 		regwrite <= 1'b0;
 		lw <= 1'b0;
 	end

  	//BNE
 	if (opcode == 6'b000101)begin
		jal <= 1'b0;
 		regdst <= 1'b0; //0 because I-type
 		branch <= 1'b1;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b0;
 		memwrite <= 1'b0;
 		aluop <= 2'b01; //SUBTRACT
 		alusrc <= 1'b0; //must be 0 -> I-Type using ALU
 		regwrite <= 1'b0;
 		lw <= 1'b0;
 	end
 		 		
 	
  	//XORI
 	if (opcode == 6'b001110)begin
		jal <= 1'b0;
 		regdst <= 1'b0; //0 because I-Type
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b0; //False - writing from ALU, not memory
 		memwrite <= 1'b0;
 		aluop <= 2'b11; //xor
 		alusrc <= 1'b0; //0 because I-Type
 		regwrite <= 1'b1;
 		lw <= 1'b0;
 	end
 		

  	//ADD
 	if (opcode ==)begin
		jal <= 1'b0;
 		regdst <= 1'b1; //R-Type
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b0; //Writing to Reg from ALU not mem
 		memwrite <= 1'b0;
 		aluop <= 2'b00;
 		alusrc <= 1'b1; //R-Type
 		regwrite <= 1'b1;
 		lw <= 1'b0;
 	end
 		

   	//SUB
 	if (opcode ==)begin
		jal <= 1'b0;
 		regdst <= 1'b1; //R-Type
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b0; //Writing to Reg from ALU not mem
 		memwrite <= 1'b0;
 		aluop <= 2'b01;
 		alusrc <= 1'b1; //R-Type
 		regwrite <= 1'b1;
 		lw <= 1'b0;
 	end

  	//SLT
 	if (opcode ==)begin
		jal <= 1'b0;
 		regdst <= 1'b1; //R-Type
 		branch <= 1'b0;
 		jump <= 1'b0;
 		jr <= 1'b0;
 		memtoreg <= 1'b0; //Writing to Reg from ALU not mem
 		memwrite <= 1'b0;
 		aluop <= 2'b10;
 		alusrc <= 1'b1; //R-Type
 		regwrite <= 1'b1;
 		lw <= 1'b0;
 	end

 		
endmodule