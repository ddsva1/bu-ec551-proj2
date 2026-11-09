module add4 (
input [2:0] inA,
input [2:0] inB,
output [2:0] outX,
);

always @(*) begin
if (inA < inB) begin
outX = 4'b0000;
end else begin
outX = inA - inB;
end
end

endmodule
