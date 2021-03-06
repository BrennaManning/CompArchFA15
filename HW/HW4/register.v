// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end

endmodule

// DELIVERABLE 2: 32-bit Register

module register32
(
output reg[31:0]	q,
input[31:0]		d,
input			wrenable,
input			clk
);

	always @(posedge clk) begin
		if(wrenable) begin
			q = d;
		end
	end
endmodule


//DELIVERABLE 3: ignore inputs always output zero

module register32zero
(
output reg[31:0]	q,
input[31:0]		d,
input			wrenable,
input			clk
);

	always @(posedge clk) begin
		if(wrenable) begin
			q = 0;
		end
	end
endmodule


//DELIVERABLE 4: 32:1 multiplexer
module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);
assign out=inputs[address];
endmodule


//DELLIVERABLE 5: multiplexer 32 bits wide and 32 inputs deep

module mux32to1by32
(
output[31:0]    out,
input[4:0]      address,
input[31:0]     input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31
);

  wire[31:0] mux[31:0];         // Create a 2D array of wires
  assign mux[0] = input0;       // Connect the sources of the array
  assign mux[1] = input1;
  assign mux[2] = input2;
  assign mux[3] = input3;
  assign mux[4] = input4;
  assign mux[5] = input5;
  assign mux[6] = input6;
  assign mux[7] = input7;
  assign mux[8] = input8;
  assign mux[9] = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;
  assign mux[20] = input20;
  assign mux[21] = input21;
  assign mux[22] = input22;
  assign mux[23] = input23;
  assign mux[24] = input24;
  assign mux[25] = input25;
  assign mux[26] = input26;
  assign mux[27] = input27;
  assign mux[28] = input28;
  assign mux[29] = input29;
  assign mux[30] = input30;
  assign mux[31] = input31;
  assign out = mux[address];    // Connect the output of the array
endmodule




//DELIVERABLE6: Explain decoder module

module decoder1to32
(
output[31:0]    out,
input           enable,
input[4:0]      address
);
    assign out = enable<<address; 
endmodule
//left shifts enable bit (# of bits determined by address)
//enable = single bit input
//address = 5 bit input (betwen 0-31) 
//out = 32 bit output: which bit is high is determined by address
//if enable is 0, ouput is 00000000000000000000000000000000
//if enable is 1, bit of output coressponding to the address is 1