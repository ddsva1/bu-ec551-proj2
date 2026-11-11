// Board wrapper for the Digilent Nexys 4 DDR (the same for every design).
//
// Connects the generated hls_top to the board:
//   BTNC (centre button)   step: advance the FSM by one state
//   CPU_RESETN (red)       reset: back to IDLE
//   sw[11:0]               inputs (sw[3:0], sw[7:4], sw[11:8]; see hls_top.v)
//   sw[15:12]              which FU output / result is shown
//   7-segment display      digit 7    : selected index sw[15:12] (hex)
//                          digits 5-4 : FSM state (0 = IDLE, last = DONE)
//                          digits 2-0 : selected value (decimal)
//   led[11:0]              mirror sw[11:0] (the entered inputs)
//   led[15]                done
module top (
    input         CLK100MHZ,
    input         CPU_RESETN,
    input         BTNC,
    input  [15:0] sw,
    output [15:0] led,
    output        CA, CB, CC, CD, CE, CF, CG, DP,
    output [7:0]  AN
);
    wire [7:0] obs_val;
    wire [7:0] state;
    wire       done;

    hls_top u_hls (
        .clk(CLK100MHZ),
        .btn_rst(~CPU_RESETN),
        .btn_step(BTNC),
        .sw(sw),
        .obs_val(obs_val),
        .state(state),
        .done(done)
    );

    assign led = {done, 3'b000, sw[11:0]};

    // decimal digits; leading zeros of the value are blanked (code 16 = blank)
    localparam [4:0] BLANK = 5'd16;
    wire [4:0] val_hundreds = (obs_val >= 8'd100) ? obs_val / 8'd100 : BLANK;
    wire [4:0] val_tens     = (obs_val >= 8'd10) ? (obs_val / 8'd10) % 8'd10 : BLANK;
    wire [4:0] val_ones     = obs_val % 8'd10;
    wire [4:0] st_tens      = (state >= 8'd10) ? (state / 8'd10) % 8'd10 : BLANK;
    wire [4:0] st_ones      = state % 8'd10;

    sevenseg u_seg (
        .clk(CLK100MHZ),
        .digits({{1'b0, sw[15:12]}, BLANK, st_tens, st_ones,
                 BLANK, val_hundreds, val_tens, val_ones}),
        .seg({CG, CF, CE, CD, CC, CB, CA}),
        .an(AN)
    );
    assign DP = 1'b1;   // decimal points off
endmodule
