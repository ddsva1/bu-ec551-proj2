module add4 (
    input [3:0] inA,
    input [3:0] inB,
    input cin
    output [3:0] outX
    output cout
);

assign {cout, sum} = inA + inB + cin;

endmodule