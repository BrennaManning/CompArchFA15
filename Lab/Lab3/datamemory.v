//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

//Data Memory module reused from CompArch Lab 2

module datamemory
(
    input  clk,
    output reg [31:0]      dataOut,
    input [31:0]    address,
    input                writeEnable,
    input [31:0]           dataIn
);


    reg [31:0] memory [4294967295:0];

    always @(posedge clk) begin
        if(writeEnable) begin
            memory[address] <= dataIn;
        end
        dataOut <= memory[address];
    end

endmodule
