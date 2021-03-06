/*
USING ALU  FROM LAB 1
*/

//define gate delays
`define AND and #30
`define OR or #30
`define NOT not #10
`define NOR nor #20
`define NAND nand #20
`define XOR xor #80

//define operations
`define ADD_OP  3'd0
`define SUB_OP  3'd1
`define XOR_OP  3'd2
`define SLT_OP  3'd3
`define AND_OP  3'd4
`define NAND_OP 3'd5
`define NOR_OP  3'd6
`define OR_OP   3'd7

// Control Logic LUT using behavorial verilog
module ALUcontrolLUT
(
output reg[2:0] muxindex,
output reg  inv_a,
output reg  inv_b,
input[2:0]  ALUcommand
);
  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD_OP:  begin muxindex = 0; inv_b=0; inv_a = 0; end
      `SUB_OP:  begin muxindex = 0; inv_b=1; inv_a = 0; end
      `XOR_OP:  begin muxindex = 1; inv_b=0; inv_a = 0; end
      `SLT_OP:  begin muxindex = 2; inv_b=1; inv_a = 0; end
      `AND_OP:  begin muxindex = 4; inv_b=1; inv_a = 1; end
      `NOR_OP:  begin muxindex = 4; inv_b=0; inv_a = 0; end
      `NAND_OP: begin muxindex = 3; inv_b=0; inv_a = 0; end
      `OR_OP:   begin muxindex = 3; inv_b=1; inv_a = 1; end
    endcase
  end
endmodule

// Decide whether or not to invert the inputs before putting them into operation modules
module inputInverter
(
output[31:0] Output,
input[31:0] Input,
input invertSignal
);
  wire doNotInvertSignal;
  wire[31:0] notInvertedSignal;
  wire[31:0] notInput;
  wire[31:0] invertedSignal;
  `NOT invertInverterSignal(doNotInvertSignal, invertSignal);
  genvar index;
  generate
    for (index = 0; index < 32; index = index + 1) begin: inverterGen
        `AND checkNotInvert(notInvertedSignal[index], Input[index], doNotInvertSignal);
        `NOT invertInput(notInput[index], Input[index]);
        `AND checkInvert(invertedSignal[index], notInput[index], invertSignal) ;
        `OR outputOr(Output[index], invertedSignal[index], notInvertedSignal[index]);
  	end
  endgenerate
endmodule

// Using a MUX to choose which operation output is the desired final output
module muxer
(
output[31:0] result,
input[2:0] muxindex,
input[31:0] adderOutput,
input[31:0] xorOutput,
input[31:0] sltOutput,
input[31:0] andOutput,
input[31:0] orOutput
);
  wire enableAdder;
  wire enableXor;
  wire enableSLT;
  wire enableAnd;
  wire enableOr;
  wire[31:0] isAdder;
  wire[31:0] isXor;
  wire[31:0] isSLT;
  wire[31:0] isAnd;
  wire[31:0] isOr;
  wire[2:0] invertedMuxIndex;

  generate
  genvar index;
    for (index = 0; index < 3; index = index + 1) begin: invert
        `NOT invertMuxIndexGate(invertedMuxIndex[index], muxindex[index]);
	  end
  endgenerate

  `AND checkEnableAdder(enableAdder, invertedMuxIndex[0], invertedMuxIndex[1], invertedMuxIndex[2]);
  `AND checkEnableXor(enableXor, muxindex[0], invertedMuxIndex[1], invertedMuxIndex[2]);
  `AND checkEnableSLT(enableSLT, invertedMuxIndex[0], muxindex[1], invertedMuxIndex[2]);
  `AND checkEnableAnd(enableAnd, muxindex[0], muxindex[1], invertedMuxIndex[2]);
  `AND checkEnableOr(enableOr, invertedMuxIndex[0], invertedMuxIndex[1], muxindex[2]);

  genvar index2;
  generate
    for (index2 = 0; index2 < 32; index2 = index2 + 1) begin: muxGenerate
      `AND checkIfAdder(isAdder[index2], adderOutput[index2], enableAdder);
      `AND checkIfXor(isXor[index2], xorOutput[index2], enableXor);
      `AND checkIfSLT(isSLT[index2], sltOutput[index2], enableSLT);
      `AND checkIfAnd(isAnd[index2], andOutput[index2], enableAnd);
      `AND checkIfOr(isOr[index2], orOutput[index2], enableOr);
      `OR finalOutput(result[index2], isAdder[index2], isXor[index2], isSLT[index2], isAnd[index2], isOr[index2]);
    end
  endgenerate
endmodule

// 1 bit adder used to construct the 32 bit adder
module structuralFullAdder
(
output out,
output carryout,
input a,
input b,
input carryin
);
	wire axorb, axorbandcarryin, aandb;
	`XOR xorgate1(axorb, a, b);
	`XOR xorgate2(out, axorb, carryin);
	`AND andgate1(axorbandcarryin, axorb, carryin);
	`AND andgate2(aandb, a, b);
	`OR orgate1(carryout, axorbandcarryin, aandb);
endmodule

// 32 bit adder
module adder
(
  output[31:0] sum,
  output carryout,
  output overflow,
  input[31:0] a,
  input[31:0] b,
  input inv_b
);
  wire co[31:0]; // Wiring the 32 1 bit adders together by assigning the previous carryout as the next carryin

  structuralFullAdder adder (sum[0], co[0], a[0], b[0], inv_b); // Instantiate the first 1 bit full adders, pass inv_b as carryin (1 if b is inverted, 0 if not)
  genvar index;
  generate
    for (index=1; index<31; index = index+1) begin: fullAdderGenerate
      structuralFullAdder adder (sum[index], co[index], a[index], b[index], co[index-1]); // Instantiate the middle 30 1 bit full adders
    end
  endgenerate
  structuralFullAdder adderlast (sum[31], carryout, a[31], b[31], co[30]); // Instantiate the last 1 bit full adders
  `XOR xorgate(overflow, co[30], carryout); // xor gate produces overflow from carryin to the most significant bit and carryout
endmodule

//Outputs a single bit (1 if input a is less than input b)
module setlessthanmodule
(
output[31:0] sltout,
input[31:0] sum,
input overflow
);

  //XOR Overflow and SumMSB output from 32bitAdder/Subtractor
  //If a < b: If no overflow, msb of sum = 1; If overflow, msb of sum will = 0
  `XOR xorgate_slt(sltout[0], sum[31], overflow);
  genvar index;
  generate
    for (index = 1; index < 32; index = index + 1) begin: zeroPadGenerate
      assign sltout[index] = 0;
    end
  endgenerate
endmodule

module xormodule
(
output [31:0] out,
input wire [31:0] a,
input wire[31:0] b
);

  genvar index;
  generate
    for (index=0; index<32; index = index+1) begin: xorgen
        `XOR xorgate(out[index], a[index], b[index]);
    end
  endgenerate
endmodule

//becomes NOR gate if the inputs a and b are both inverted
module nandmodule
(
output[31:0] out,
input[31:0] a,
input[31:0] b
);

  genvar index;
  generate
    for (index = 0; index<32; index = index + 1) begin: nandgen
    	`NAND nandgate(out[index], a[index], b[index]);
    end
  endgenerate
endmodule

//becomes NAND gate if a and b are both inverted
module normodule
(
output[31:0] out,
input[31:0] a,
input [31:0] b
);

  genvar index;
  generate
    for (index = 0; index<32; index = index + 1) begin: norgen
    	`NOR norgate(out[index], a[index], b[index]);
    end
  endgenerate
endmodule

module alu
(
output[31:0]    result,
output          carryout,
output          zero,
output          overflow,
input[31:0]     operandA,
input[31:0]     operandB,
input[2:0]      command
);

  // Wiring the individual operation modules to the MUX and Control LUT
  // set up LUT
  wire inv_a;
  wire inv_b;
  wire[2:0] muxindex;

  ALUcontrolLUT ourLut (muxindex, inv_a, inv_b, command);

  // invert our mux index so we can see if what flags to turn on
  wire[2:0] invertedMuxIndex;

  genvar index3;
  generate
    for (index3 = 0; index3 < 3; index3 = index3 + 1) begin: invertMuxGen
        `NOT invertMuxIndexGate(invertedMuxIndex[index3], muxindex[index3]);
    end
  endgenerate

  // set up input inverters
  wire[31:0] inputA, inputB;

  inputInverter inverterA (inputA, operandA, inv_a);
  inputInverter inverterB (inputB, operandB, inv_b);

  // set up adder
  wire[31:0] adderOutput;
  wire adderCarryout;
  wire adderOverflow;

  adder adderMod (adderOutput, adderCarryout, adderOverflow, inputA, inputB, inv_b);

  // set up xor
  wire[31:0] xorOutput;

  xormodule xorMod (xorOutput, inputA, inputB);

  // set up SLT
  wire[31:0] sltOutput;

  setlessthanmodule sltMod (sltOutput, adderOutput, adderOverflow);

  // set up nand
  wire[31:0] nandOutput;

  nandmodule nandMod (nandOutput, inputA, inputB);

  // set up nor
  wire[31:0] norOutput;

  normodule norMod (norOutput, inputA, inputB);

  // set up mux
  muxer ourMux (result, muxindex, adderOutput, xorOutput, sltOutput, nandOutput, norOutput);

  `AND checkIfOutputOverflow(overflow, adderOverflow, invertedMuxIndex[0], invertedMuxIndex[1], invertedMuxIndex[2]);
  `AND checkIfOutputCarryout(carryout, adderCarryout, invertedMuxIndex[0], invertedMuxIndex[1], invertedMuxIndex[2]);

  // zero check
  wire[30:0] notZero;

  // let's see if there are any highs in our result
  `OR orCheck0(notZero[0], result[0], result[1]);
  genvar index;
  generate
    for(index = 1; index<31; index = index + 1) begin: orCheckGen
      `OR orCheck(notZero[index], notZero[index - 1], result[index + 1]);
    end
  endgenerate

  // if there is a high, than it's not zero
  `NOT invertNotZero(zero, notZero[30]);
endmodule

module testALU;
wire[31:0]    result;
wire          carryout;
wire          zero;
wire          overflow;
reg[31:0]     operandA;
reg[31:0]     operandB;
reg[2:0]      command;

ALU testingALU(result, carryout, zero, overflow, operandA, operandB, command);

initial begin
//Adder
$display("");
$display("Adder:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb00111010_01110100_01110000_10110011 ;operandB=32'sb00101100_10011110_00010110_10110100;command=3'b0; #3870
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 01100111 00010010 10000111 01100111 with carryout = 0, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb11000100_11000000_10110011_01001001 ;operandB=32'sb11100000_10100101_11000110_01001000;command=3'b0; #3870
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10100101 01100110 01111001 10010001 with carryout = 1, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb00111010_01110100_01110000_10110011 ;operandB=32'sb11100000_10100101_11000110_01001000;command=3'b0; #3870
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 00011011 00011010 00110110 11111011 with carryout = 1, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb11000100_11000000_10110011_01001001 ;operandB=32'sb00101100_10011110_00010110_10110100;command=3'b0; #3870
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 11110001 01011110 11001001 11111101 with carryout = 0, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb01000101_11000111_00100111_11010100 ;operandB=32'sb01000001_10001110_10101000_10011011;command=3'b0; #3870
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10000111 01010101 11010000 01101111 with carryout = 0, overflow = 1", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10101011_11010101_01011000_11101110 ;operandB=32'sb10000111_10011100_11000001_11000100;command=3'b0; #3870
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 00110011 01110010 00011010 10110010 with carryout = 1, overflow = 1", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//Subtract
$display("Subtract:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b001; #4190
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 00110111 01100001 00100110 01010101 with carryout = 1, overflow = 1", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b001; #4190
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 11011011 11000111 01101000 11010110 with carryout = 0, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb00110111_00001010_01100010_11101001 ;operandB=32'sb11101011_10010100_10110001_01010100;command=3'b001; #4190
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 01001011 01110101 10110001 10010101 with carryout = 0, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb11110001_11110100_01100010_00110110 ;operandB=32'sb00111011_10010000_01110111_01101011;command=3'b001; #4190
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10110110 01100011 11101010 11001011 with carryout = 1, overflow = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb01000101_11000111_00100111_11010100 ;operandB=32'sb10111110_01110001_01010111_01100101;command=3'b001; #4190
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10000111 01010101 11010000 01101111 with carryout = 0, overflow = 1", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10101011_11010101_01011000_11101110 ;operandB=32'sb01111000_01100011_00111110_00111100;command=3'b001; #4190
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 00110011 01110010 00011010 10110010 with overflow = 1, carryout = 1", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//SLT
$display("SLT:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b11; #4250
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 0, zero = 1", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb00101110_00001011_10001001_00111110 ;operandB=32'sb00110111_01101010_01111010_11101001;command=3'b11; #4250
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 1, zero = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b11; #4250
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 1, zero = 0", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb11100111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b11; #4250
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 0, zero = 1", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb00110111_00001010_01100010_11101001 ;operandB=32'sb11101011_10010100_10110001_01010100;command=3'b11; #4250
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 0, zero = 1", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb11110001_11110100_01100010_00110110 ;operandB=32'sb00111011_10010000_01110111_01101011;command=3'b11; #4250
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 1, zero = 0", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//XOR
$display("XOR:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b010; #1920
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 01011001 01100001 11101011 11010111", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b010; #1920
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 00101100 01001001 10011001 00101010", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//AND
$display("AND:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b100; #960
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 00100110 00001010 00000000 00101000", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b100; #960
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10000011 10010100 01000000 11000100", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//NAND
$display("NAND:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b101; #640
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 11011001 11110101 11111111 11010111", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b101; #640
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 01111100 01101011 10111111 00111011", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//NOR
$display("NOR:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b110; #640
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10000000 10010100 00010100 00000000", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b110; #640
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 01010000 00100010 00100110 00010001", operandA, operandB, command, result, carryout, zero, overflow);
$display("");

//OR
$display("OR:");
$display("opA opB cmd| Result Carryout Zero Overflow | Expected Output");
operandA=32'sb01101110_01101011_10001001_00111110 ;operandB=32'sb00110111_00001010_01100010_11101001;command=3'b111; #960
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 01111111 01101011 11101011 11111111", operandA, operandB, command, result, carryout, zero, overflow);
operandA=32'sb10000111_10011100_11000001_11000100 ;operandB=32'sb10101011_11010101_01011000_11101110;command=3'b111; #960
$display("%b  %b  %b |  %b  %b  %b  %b | Output = 10101111 11011101 11011001 11101110 ", operandA, operandB, command, result, carryout, zero, overflow);
$display("");
end
endmodule
