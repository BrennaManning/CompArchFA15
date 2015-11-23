//INSTRUCTION DECODER FOR SINGLE CYCLE CPU


module instructiondecoder(
	output reg jal,
	output reg regdst,
	output reg branch,
	output reg jump,
	output reg jr,
	output reg memtoreg,
	output reg memwrite,
	output reg [2:0] aluop,
	output reg alusrc,
	output reg regwrite,
	output reg lsw,
	input [31:0] instruction
	);

	//instructions to control signals

	reg [5:0] opcode; //determines what instruction
	//assign opcode[5:0] = instruction[31:26];

	//ALUOP
	//000 = ADD
	//01 = SUB
	//10 = SLT
	//11 = XORI  
	//*When the ALU is not used this does not matter
	
	always @(instruction) begin
	
	if (instruction [31:26] == 6'b000000) begin
		opcode = instruction [5:0]; //func for r-types
		end
	else
		opcode = instruction[31:26];


	//LW
	if (instruction [31:26] == 6'b100011)begin
		jal = 1'b0;
 		regdst = 1'b0;
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b1;
 		memwrite = 1'b0;
 		aluop = 3'b000;
 		alusrc = 1'b0;
 		regwrite = 1'b1;
 		lsw = 1'b1;
 	end

 	//SW
 	if (instruction [31:26] == 6'b101011)begin
		jal = 1'b0;
 		regdst = 1'b0;
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0;
 		memwrite = 1'b1;
 		aluop = 3'b000;
 		alusrc = 1'b0;
 		regwrite = 1'b0;
 		lsw = 1'b1;
 	end
 	
 	//J
 	if (instruction [31:26] == 6'b000010)begin
		jal = 1'b0;
 		regdst = 1'b0;
 		branch = 1'b0;
 		jump = 1'b1;
 		jr = 1'b0;
 		memtoreg = 1'b0;
 		memwrite = 1'b0;
 		aluop = 3'b000;
 		alusrc = 1'b0;
 		regwrite = 1'b0;
 		lsw = 1'b0;
 	end
 	
 	//JR
 	if (instruction [31:26] == 6'b001000)begin
		jal = 1'b0;
 		regdst = 1'b0;
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b1;
 		memtoreg = 1'b0;
 		memwrite = 1'b0;
 		aluop = 3'b000;
 		alusrc = 1'b0;
 		regwrite = 1'b0;
 		lsw = 1'b0;
 	end

  	//JAL
 	if (instruction [31:26] == 6'b000011)begin
		jal = 1'b1;
 		regdst = 1'b0;
 		branch = 1'b0;
 		jump = 1'b1;
 		jr = 1'b0;
 		memtoreg = 1'b0;
 		memwrite = 1'b0;
 		aluop = 3'b000;
 		alusrc = 1'b0;
 		regwrite = 1'b0;
 		lsw = 1'b0;
 	end

  	//BNE
 	if (instruction [31:26] == 6'b000101)begin
		jal = 1'b0;
 		regdst = 1'b0; //0 because I-type
 		branch = 1'b1;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0;
 		memwrite = 1'b0;
 		aluop = 3'b001; //SUBTRACT
 		alusrc = 1'b0; //must be 0 -> I-Type using ALU
 		regwrite = 1'b0;
 		lsw = 1'b0;
 	end
 		 		
 	
  	//XORI
 	if (instruction [31:26] == 6'b001110)begin
		jal = 1'b0;
 		regdst = 1'b0; //0 because I-Type
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0; //False - writing from ALU, not memory
 		memwrite = 1'b0;
 		aluop = 3'b010; //xor
 		alusrc = 1'b0; //0 because I-Type
 		regwrite = 1'b1;
 		lsw = 1'b0;
 	end
 		

  	//ADD
 	if (instruction [31:26] == 6'b100000)begin
		jal = 1'b0;
 		regdst = 1'b1; //R-Type
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		memwrite = 1'b0;
 		aluop = 3'b000;
 		alusrc = 1'b1; //R-Type
 		regwrite = 1'b1;
 		lsw = 1'b0;
 	end
 		

   	//SUB
 	if (instruction [31:26] == 100010)begin
		jal = 1'b0;
 		regdst = 1'b1; //R-Type
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		memwrite = 1'b0;
 		aluop = 3'b001;
 		alusrc = 1'b1; //R-Type
 		regwrite = 1'b1;
 		lsw = 1'b0;
 	end

  	//SLT
 	if (instruction [31:26] == 6'b101010)begin
		jal = 1'b0;
 		regdst = 1'b1; //R-Type
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		memwrite = 1'b0;
 		aluop = 2'b011;
 		alusrc = 1'b1; //R-Type
 		regwrite = 1'b1;
 		lsw = 1'b0;
 	end




 	  	//ADDI
 	if (instruction [31:26] == 6'b100000)begin
		jal = 1'b0;
 		regdst = 1'b1; //R-Type
 		branch = 1'b0;
 		jump = 1'b0;
 		jr = 1'b0;
 		memtoreg = 1'b0; //Writing to Reg from ALU not mem
 		memwrite = 1'b0;
 		aluop = 3'b000;
 		alusrc = 1'b0; //R-Type
 		regwrite = 1'b1;
 		lsw = 1'b0;
 	end
	end

 		
endmodule
