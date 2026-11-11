// Top level of the synthesized design (board independent).
//   btn_step : each press advances the FSM by one state (clock enable)
//   btn_rst  : back to IDLE
//   inputs   : loaded from the switches when leaving IDLE
//     sw[3:0]  -> A
//   sw[15:12] selects obs_val:
//      0: mul0 (multiplier) output
//      1: output A (A_20)
module hls_top #(parameter DEBOUNCE = 1_000_000) (
    input clk,
    input btn_rst,
    input btn_step,
    input [15:0] sw,
    output reg [7:0] obs_val,
    output [7:0] state,
    output done
);
    localparam W = 4;

    // reset synchronizer and debounced step pulse
    reg [1:0] rst_sync = 2'b11;
    always @(posedge clk) rst_sync <= {rst_sync[0], btn_rst};
    wire rst = rst_sync[1];
    wire step;
    step_pulse #(.DEBOUNCE(DEBOUNCE)) u_step (.clk(clk), .btn(btn_step), .pulse(step));

    // primary inputs
    wire [W-1:0] in_A = sw[3:0];

    wire [W-1:0] out_A, fu_mul0_y;
    wire [4:0] core_state;
    hls_core u_core (
        .clk(clk),
        .rst(rst),
        .en(step),
        .start(1'b1),
        .in_A(in_A),
        .out_A(out_A),
        .fu_mul0_y(fu_mul0_y),
        .state(core_state),
        .done(done)
    );

    assign state = core_state;

    // observability: which FU output / result is shown
    always @(*)
        case (sw[15:12])
            4'd0: obs_val = fu_mul0_y;   // mul0 (multiplier) output
            4'd1: obs_val = out_A;   // output A (A_20)
            default: obs_val = 8'd0;
        endcase
endmodule
