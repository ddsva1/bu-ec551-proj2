// Multiplier functional unit: y = a * b, truncated to W bits.
module multiplier #(parameter W = 4) (
    input  [W-1:0] a,
    input  [W-1:0] b,
    output [W-1:0] y
);
    assign y = a * b;
endmodule
