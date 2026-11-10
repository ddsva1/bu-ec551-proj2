module sub4 (
    input [3:0] inA,
    input [3:0] inB,
    output [3:0] outX
);
always @(*) begin
    if (inA < inB) begin
        outX = 4'b0000; assured that no negative results, 
    end else begin
        outX = inA - inB;
    end
end
endmodule