// Drives the 8-digit 7-segment display of the Nexys 4 DDR.
// digits holds one 5-bit code per digit (digit 0 = rightmost = digits[4:0]):
//   0-15 shows the hex digit 0-F, 16 or more leaves the digit blank.
// Only one digit is lit at a time; at 100 MHz each digit is lit for 164 us and
// the whole display is refreshed about 760 times a second, so all digits appear lit.
// Segments and anodes are active low.
module sevenseg (
    input            clk,
    input     [39:0] digits,
    output reg [6:0] seg,      // {CG, CF, CE, CD, CC, CB, CA}
    output reg [7:0] an
);
    reg [16:0] refresh = 17'd0;
    always @(posedge clk) refresh <= refresh + 17'd1;

    wire [2:0] pos  = refresh[16:14];
    wire [4:0] code = digits[pos * 5 +: 5];

    always @(*) begin
        an = 8'hFF;
        an[pos] = 1'b0;
    end

    always @(*)
        case (code)
            5'd0:  seg = 7'b1000000;
            5'd1:  seg = 7'b1111001;
            5'd2:  seg = 7'b0100100;
            5'd3:  seg = 7'b0110000;
            5'd4:  seg = 7'b0011001;
            5'd5:  seg = 7'b0010010;
            5'd6:  seg = 7'b0000010;
            5'd7:  seg = 7'b1111000;
            5'd8:  seg = 7'b0000000;
            5'd9:  seg = 7'b0010000;
            5'd10: seg = 7'b0001000;   // A
            5'd11: seg = 7'b0000011;   // b
            5'd12: seg = 7'b1000110;   // C
            5'd13: seg = 7'b0100001;   // d
            5'd14: seg = 7'b0000110;   // E
            5'd15: seg = 7'b0001110;   // F
            default: seg = 7'b1111111; // blank
        endcase
endmodule
