//register file for the single cycle cpu
module register_file
(
input WrEn,
input[31:0] Dw,
input[4:0] Aw,
input[4:0] Aa,
input[4:0] Ab,
output reg[31:0] Da,
output reg[31:0] Db,
input clk 
);

reg [31:0] memory [32:0];

    always @(posedge clk) begin
        if(WrEn) begin //if we're writing to the register
            memory[Aw] <= Dw;
        end
	memory[0] <= 32'd0;
        Da <= memory[Aa];
	Db <= memory[Ab];
    end

endmodule