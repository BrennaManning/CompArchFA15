//register file for the single cycle cpu
module register
#(
    parameter width = 32
)
(
input WrEn,
input[width-1:0] Dw,
input[width-1:0] Aw,
input[width-1:0] Aa,
input[width-1:0] Ab,
output[width-1:0] Da,
output[width-1:0] Db 
);

endmodule