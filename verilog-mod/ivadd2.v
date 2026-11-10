module add4 (
input [2:0] inA,
input [2:0] inB,
input cin,
output [2:0] outX,
output cout
);

assign {cout, sum} = inA + inB + cin;

endmodule
