module register32
(
output reg  q,
input       d,
input       wrenable,
input       clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule