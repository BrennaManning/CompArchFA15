// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0

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
