// Top level of the synthesized design (board independent).
//   btn_step : each press advances the FSM by one state (clock enable)
//   btn_rst  : back to IDLE
//   inputs   : loaded from the switches when leaving IDLE
//     sw[3:0]  -> B
//     sw[7:4]  -> C
//     sw[11:8]  -> E
//     F = 1 (hardcoded)
//     H = 1 (hardcoded)
//     I = 1 (hardcoded)
//     K = 1 (hardcoded)
//     L = 1 (hardcoded)
//     N = 1 (hardcoded)
//     O = 1 (hardcoded)
//     Q = 1 (hardcoded)
//     R = 1 (hardcoded)
//     T = 1 (hardcoded)
//     U = 1 (hardcoded)
//     W = 1 (hardcoded)
//     X = 1 (hardcoded)
//     Z = 1 (hardcoded)
//     A1 = 1 (hardcoded)
//     A3 = 1 (hardcoded)
//     A4 = 1 (hardcoded)
//     A6 = 1 (hardcoded)
//     A7 = 1 (hardcoded)
//     A9 = 1 (hardcoded)
//     A10 = 1 (hardcoded)
//     A_1 = 1 (hardcoded)
//     A_2 = 1 (hardcoded)
//     A_4 = 1 (hardcoded)
//     A_5 = 1 (hardcoded)
//     AAAAAA1 = 1 (hardcoded)
//     AAAAAA2 = 1 (hardcoded)
//     AAAAAA4 = 1 (hardcoded)
//     AAAAAA5 = 1 (hardcoded)
//     AA_E = 1 (hardcoded)
//     A_EE = 1 (hardcoded)
//     ABB2 = 1 (hardcoded)
//     AC1 = 1 (hardcoded)
//     AE2 = 1 (hardcoded)
//     AF3 = 1 (hardcoded)
//     AG2 = 1 (hardcoded)
//     AG1 = 1 (hardcoded)
//   sw[15:12] selects obs_val:
//      0: add0 (adder) output
//      1: add1 (adder) output
//      2: add2 (adder) output
//      3: add3 (adder) output
//      4: add4 (adder) output
//      5: add5 (adder) output
//      6: add6 (adder) output
//      7: add7 (adder) output
//      8: add8 (adder) output
//      9: add9 (adder) output
//     10: sub0 (subtractor) output
//     11: sub1 (subtractor) output
//     12: sub2 (subtractor) output
//     13: sub3 (subtractor) output
//     14: sub4 (subtractor) output
//     15: sub5 (subtractor) output
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
    wire [W-1:0] in_B = sw[3:0];
    wire [W-1:0] in_C = sw[7:4];
    wire [W-1:0] in_E = sw[11:8];
    wire [W-1:0] in_F = 4'd1;
    wire [W-1:0] in_H = 4'd1;
    wire [W-1:0] in_I = 4'd1;
    wire [W-1:0] in_K = 4'd1;
    wire [W-1:0] in_L = 4'd1;
    wire [W-1:0] in_N = 4'd1;
    wire [W-1:0] in_O = 4'd1;
    wire [W-1:0] in_Q = 4'd1;
    wire [W-1:0] in_R = 4'd1;
    wire [W-1:0] in_T = 4'd1;
    wire [W-1:0] in_U = 4'd1;
    wire [W-1:0] in_W = 4'd1;
    wire [W-1:0] in_X = 4'd1;
    wire [W-1:0] in_Z = 4'd1;
    wire [W-1:0] in_A1 = 4'd1;
    wire [W-1:0] in_A3 = 4'd1;
    wire [W-1:0] in_A4 = 4'd1;
    wire [W-1:0] in_A6 = 4'd1;
    wire [W-1:0] in_A7 = 4'd1;
    wire [W-1:0] in_A9 = 4'd1;
    wire [W-1:0] in_A10 = 4'd1;
    wire [W-1:0] in_A_1 = 4'd1;
    wire [W-1:0] in_A_2 = 4'd1;
    wire [W-1:0] in_A_4 = 4'd1;
    wire [W-1:0] in_A_5 = 4'd1;
    wire [W-1:0] in_AAAAAA1 = 4'd1;
    wire [W-1:0] in_AAAAAA2 = 4'd1;
    wire [W-1:0] in_AAAAAA4 = 4'd1;
    wire [W-1:0] in_AAAAAA5 = 4'd1;
    wire [W-1:0] in_AA_E = 4'd1;
    wire [W-1:0] in_A_EE = 4'd1;
    wire [W-1:0] in_ABB2 = 4'd1;
    wire [W-1:0] in_AC1 = 4'd1;
    wire [W-1:0] in_AE2 = 4'd1;
    wire [W-1:0] in_AF3 = 4'd1;
    wire [W-1:0] in_AG2 = 4'd1;
    wire [W-1:0] in_AG1 = 4'd1;

    wire [W-1:0] out_A, out_D, out_G, out_J, out_M, out_P, out_S, out_V, out_Y, out_A2, out_A5, out_A8, out_A_0, out_A_3, out_AAAAAA0, out_AAAAAA3, out_A_E, out_AB1, out_AD1, out_AG3, fu_add0_y, fu_add1_y, fu_add2_y, fu_add3_y, fu_add4_y, fu_add5_y, fu_add6_y, fu_add7_y, fu_add8_y, fu_add9_y, fu_sub0_y, fu_sub1_y, fu_sub2_y, fu_sub3_y, fu_sub4_y, fu_sub5_y, fu_sub6_y, fu_sub7_y, fu_sub8_y, fu_sub9_y;
    wire [1:0] core_state;
    hls_core u_core (
        .clk(clk),
        .rst(rst),
        .en(step),
        .start(1'b1),
        .in_B(in_B),
        .in_C(in_C),
        .in_E(in_E),
        .in_F(in_F),
        .in_H(in_H),
        .in_I(in_I),
        .in_K(in_K),
        .in_L(in_L),
        .in_N(in_N),
        .in_O(in_O),
        .in_Q(in_Q),
        .in_R(in_R),
        .in_T(in_T),
        .in_U(in_U),
        .in_W(in_W),
        .in_X(in_X),
        .in_Z(in_Z),
        .in_A1(in_A1),
        .in_A3(in_A3),
        .in_A4(in_A4),
        .in_A6(in_A6),
        .in_A7(in_A7),
        .in_A9(in_A9),
        .in_A10(in_A10),
        .in_A_1(in_A_1),
        .in_A_2(in_A_2),
        .in_A_4(in_A_4),
        .in_A_5(in_A_5),
        .in_AAAAAA1(in_AAAAAA1),
        .in_AAAAAA2(in_AAAAAA2),
        .in_AAAAAA4(in_AAAAAA4),
        .in_AAAAAA5(in_AAAAAA5),
        .in_AA_E(in_AA_E),
        .in_A_EE(in_A_EE),
        .in_ABB2(in_ABB2),
        .in_AC1(in_AC1),
        .in_AE2(in_AE2),
        .in_AF3(in_AF3),
        .in_AG2(in_AG2),
        .in_AG1(in_AG1),
        .out_A(out_A),
        .out_D(out_D),
        .out_G(out_G),
        .out_J(out_J),
        .out_M(out_M),
        .out_P(out_P),
        .out_S(out_S),
        .out_V(out_V),
        .out_Y(out_Y),
        .out_A2(out_A2),
        .out_A5(out_A5),
        .out_A8(out_A8),
        .out_A_0(out_A_0),
        .out_A_3(out_A_3),
        .out_AAAAAA0(out_AAAAAA0),
        .out_AAAAAA3(out_AAAAAA3),
        .out_A_E(out_A_E),
        .out_AB1(out_AB1),
        .out_AD1(out_AD1),
        .out_AG3(out_AG3),
        .fu_add0_y(fu_add0_y),
        .fu_add1_y(fu_add1_y),
        .fu_add2_y(fu_add2_y),
        .fu_add3_y(fu_add3_y),
        .fu_add4_y(fu_add4_y),
        .fu_add5_y(fu_add5_y),
        .fu_add6_y(fu_add6_y),
        .fu_add7_y(fu_add7_y),
        .fu_add8_y(fu_add8_y),
        .fu_add9_y(fu_add9_y),
        .fu_sub0_y(fu_sub0_y),
        .fu_sub1_y(fu_sub1_y),
        .fu_sub2_y(fu_sub2_y),
        .fu_sub3_y(fu_sub3_y),
        .fu_sub4_y(fu_sub4_y),
        .fu_sub5_y(fu_sub5_y),
        .fu_sub6_y(fu_sub6_y),
        .fu_sub7_y(fu_sub7_y),
        .fu_sub8_y(fu_sub8_y),
        .fu_sub9_y(fu_sub9_y),
        .state(core_state),
        .done(done)
    );

    assign state = core_state;

    // observability: which FU output / result is shown
    always @(*)
        case (sw[15:12])
            4'd0: obs_val = fu_add0_y;   // add0 (adder) output
            4'd1: obs_val = fu_add1_y;   // add1 (adder) output
            4'd2: obs_val = fu_add2_y;   // add2 (adder) output
            4'd3: obs_val = fu_add3_y;   // add3 (adder) output
            4'd4: obs_val = fu_add4_y;   // add4 (adder) output
            4'd5: obs_val = fu_add5_y;   // add5 (adder) output
            4'd6: obs_val = fu_add6_y;   // add6 (adder) output
            4'd7: obs_val = fu_add7_y;   // add7 (adder) output
            4'd8: obs_val = fu_add8_y;   // add8 (adder) output
            4'd9: obs_val = fu_add9_y;   // add9 (adder) output
            4'd10: obs_val = fu_sub0_y;   // sub0 (subtractor) output
            4'd11: obs_val = fu_sub1_y;   // sub1 (subtractor) output
            4'd12: obs_val = fu_sub2_y;   // sub2 (subtractor) output
            4'd13: obs_val = fu_sub3_y;   // sub3 (subtractor) output
            4'd14: obs_val = fu_sub4_y;   // sub4 (subtractor) output
            4'd15: obs_val = fu_sub5_y;   // sub5 (subtractor) output
            default: obs_val = 8'd0;
        endcase
endmodule
