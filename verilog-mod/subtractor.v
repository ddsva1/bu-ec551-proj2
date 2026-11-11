// Subtractor functional unit: y = a - b.
// The assignment guarantees results are never negative; if a < b anyway,
// the output is clamped to 0 instead of wrapping around.
module subtractor #(parameter W = 4) (
    input  [W-1:0] a,
    input  [W-1:0] b,
    output [W-1:0] y
);
    assign y = (a < b) ? {W{1'b0}} : a - b;
endmodule
