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
//enable = single bit input
//address = 5 bit input (betwen 0-31) 
//out = 32 bit output: which bit is high is determined by address
//if enable is 0, ouput is 00000000000000000000000000000000
//if enable is 1, bit of output coressponding to the address is 1