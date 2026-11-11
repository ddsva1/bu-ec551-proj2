// Controller / sequencer: one state per control step.
// The state only advances when en=1 (one button press on the board).
module hls_controller (
    input clk,
    input rst,
    input en,
    input start,
    output reg [1:0] state,
    output reg done,
    output reg sel_r0,
    output reg sel_r1,
    output reg sel_r2,
    output reg sel_r3,
    output reg sel_r4,
    output reg sel_r5,
    output reg sel_r6,
    output reg sel_r7,
    output reg sel_r8,
    output reg sel_r9,
    output reg sel_r10,
    output reg sel_r11,
    output reg sel_r12,
    output reg sel_r13,
    output reg sel_r14,
    output reg sel_r15,
    output reg sel_r16,
    output reg sel_r17,
    output reg sel_r18,
    output reg sel_r19,
    output reg we_r0,
    output reg we_r1,
    output reg we_r2,
    output reg we_r3,
    output reg we_r4,
    output reg we_r5,
    output reg we_r6,
    output reg we_r7,
    output reg we_r8,
    output reg we_r9,
    output reg we_r10,
    output reg we_r11,
    output reg we_r12,
    output reg we_r13,
    output reg we_r14,
    output reg we_r15,
    output reg we_r16,
    output reg we_r17,
    output reg we_r18,
    output reg we_r19,
    output reg we_r20,
    output reg we_r21,
    output reg we_r22,
    output reg we_r23,
    output reg we_r24,
    output reg we_r25,
    output reg we_r26,
    output reg we_r27,
    output reg we_r28,
    output reg we_r29,
    output reg we_r30,
    output reg we_r31,
    output reg we_r32,
    output reg we_r33,
    output reg we_r34,
    output reg we_r35,
    output reg we_r36,
    output reg we_r37,
    output reg we_r38,
    output reg we_r39
);
    localparam ST_IDLE = 2'd0;
    localparam ST_S1 = 2'd1;
    localparam ST_DONE = 2'd2;

    always @(posedge clk) begin
        if (rst)
            state <= ST_IDLE;
        else if (en)
            case (state)
                ST_IDLE: if (start) state <= ST_S1;
                ST_S1: state <= ST_DONE;
                ST_DONE: if (start) state <= ST_IDLE;
                default: state <= ST_IDLE;
            endcase
    end

    always @(*) begin
        done = 1'b0;
        sel_r0 = 1'd0;
        sel_r1 = 1'd0;
        sel_r2 = 1'd0;
        sel_r3 = 1'd0;
        sel_r4 = 1'd0;
        sel_r5 = 1'd0;
        sel_r6 = 1'd0;
        sel_r7 = 1'd0;
        sel_r8 = 1'd0;
        sel_r9 = 1'd0;
        sel_r10 = 1'd0;
        sel_r11 = 1'd0;
        sel_r12 = 1'd0;
        sel_r13 = 1'd0;
        sel_r14 = 1'd0;
        sel_r15 = 1'd0;
        sel_r16 = 1'd0;
        sel_r17 = 1'd0;
        sel_r18 = 1'd0;
        sel_r19 = 1'd0;
        we_r0 = 1'b0;
        we_r1 = 1'b0;
        we_r2 = 1'b0;
        we_r3 = 1'b0;
        we_r4 = 1'b0;
        we_r5 = 1'b0;
        we_r6 = 1'b0;
        we_r7 = 1'b0;
        we_r8 = 1'b0;
        we_r9 = 1'b0;
        we_r10 = 1'b0;
        we_r11 = 1'b0;
        we_r12 = 1'b0;
        we_r13 = 1'b0;
        we_r14 = 1'b0;
        we_r15 = 1'b0;
        we_r16 = 1'b0;
        we_r17 = 1'b0;
        we_r18 = 1'b0;
        we_r19 = 1'b0;
        we_r20 = 1'b0;
        we_r21 = 1'b0;
        we_r22 = 1'b0;
        we_r23 = 1'b0;
        we_r24 = 1'b0;
        we_r25 = 1'b0;
        we_r26 = 1'b0;
        we_r27 = 1'b0;
        we_r28 = 1'b0;
        we_r29 = 1'b0;
        we_r30 = 1'b0;
        we_r31 = 1'b0;
        we_r32 = 1'b0;
        we_r33 = 1'b0;
        we_r34 = 1'b0;
        we_r35 = 1'b0;
        we_r36 = 1'b0;
        we_r37 = 1'b0;
        we_r38 = 1'b0;
        we_r39 = 1'b0;
        case (state)
            ST_IDLE: if (start) begin   // load the primary inputs
                we_r0 = 1'b1;
                sel_r0 = 1'd0;
                we_r1 = 1'b1;
                sel_r1 = 1'd0;
                we_r2 = 1'b1;
                sel_r2 = 1'd0;
                we_r3 = 1'b1;
                sel_r3 = 1'd0;
                we_r4 = 1'b1;
                sel_r4 = 1'd0;
                we_r5 = 1'b1;
                sel_r5 = 1'd0;
                we_r6 = 1'b1;
                sel_r6 = 1'd0;
                we_r7 = 1'b1;
                sel_r7 = 1'd0;
                we_r8 = 1'b1;
                sel_r8 = 1'd0;
                we_r9 = 1'b1;
                sel_r9 = 1'd0;
                we_r10 = 1'b1;
                sel_r10 = 1'd0;
                we_r11 = 1'b1;
                sel_r11 = 1'd0;
                we_r12 = 1'b1;
                sel_r12 = 1'd0;
                we_r13 = 1'b1;
                sel_r13 = 1'd0;
                we_r14 = 1'b1;
                sel_r14 = 1'd0;
                we_r15 = 1'b1;
                sel_r15 = 1'd0;
                we_r16 = 1'b1;
                sel_r16 = 1'd0;
                we_r17 = 1'b1;
                sel_r17 = 1'd0;
                we_r18 = 1'b1;
                sel_r18 = 1'd0;
                we_r19 = 1'b1;
                sel_r19 = 1'd0;
                we_r20 = 1'b1;
                we_r21 = 1'b1;
                we_r22 = 1'b1;
                we_r23 = 1'b1;
                we_r24 = 1'b1;
                we_r25 = 1'b1;
                we_r26 = 1'b1;
                we_r27 = 1'b1;
                we_r28 = 1'b1;
                we_r29 = 1'b1;
                we_r30 = 1'b1;
                we_r31 = 1'b1;
                we_r32 = 1'b1;
                we_r33 = 1'b1;
                we_r34 = 1'b1;
                we_r35 = 1'b1;
                we_r36 = 1'b1;
                we_r37 = 1'b1;
                we_r38 = 1'b1;
                we_r39 = 1'b1;
            end
            ST_S1: begin
                // op0: A_0 = B_0 + C_0  on add0
                // op1: D_0 = E_0 - F_0  on sub0
                // op2: G_0 = H_0 + I_0  on add1
                // op3: J_0 = K_0 - L_0  on sub1
                // op4: M_0 = N_0 + O_0  on add2
                // op5: P_0 = Q_0 - R_0  on sub2
                // op6: S_0 = T_0 + U_0  on add3
                // op7: V_0 = W_0 - X_0  on sub3
                // op8: Y_0 = Z_0 + A1_0  on add4
                // op9: A2_0 = A3_0 - A4_0  on sub4
                // op10: A5_0 = A6_0 + A7_0  on add5
                // op11: A8_0 = A9_0 - A10_0  on sub5
                // op12: A_0_0 = A_1_0 + A_2_0  on add6
                // op13: A_3_0 = A_4_0 - A_5_0  on sub6
                // op14: AAAAAA0_0 = AAAAAA1_0 + AAAAAA2_0  on add7
                // op15: AAAAAA3_0 = AAAAAA4_0 - AAAAAA5_0  on sub7
                // op16: A_E_0 = AA_E_0 + A_EE_0  on add8
                // op17: AB1_0 = ABB2_0 - AC1_0  on sub8
                // op18: AD1_0 = AE2_0 + AF3_0  on add9
                // op19: AG3_0 = AG2_0 - AG1_0  on sub9
                we_r0 = 1'b1;
                sel_r0 = 1'd1;
                we_r1 = 1'b1;
                sel_r1 = 1'd1;
                we_r2 = 1'b1;
                sel_r2 = 1'd1;
                we_r3 = 1'b1;
                sel_r3 = 1'd1;
                we_r4 = 1'b1;
                sel_r4 = 1'd1;
                we_r5 = 1'b1;
                sel_r5 = 1'd1;
                we_r6 = 1'b1;
                sel_r6 = 1'd1;
                we_r7 = 1'b1;
                sel_r7 = 1'd1;
                we_r8 = 1'b1;
                sel_r8 = 1'd1;
                we_r9 = 1'b1;
                sel_r9 = 1'd1;
                we_r10 = 1'b1;
                sel_r10 = 1'd1;
                we_r11 = 1'b1;
                sel_r11 = 1'd1;
                we_r12 = 1'b1;
                sel_r12 = 1'd1;
                we_r13 = 1'b1;
                sel_r13 = 1'd1;
                we_r14 = 1'b1;
                sel_r14 = 1'd1;
                we_r15 = 1'b1;
                sel_r15 = 1'd1;
                we_r16 = 1'b1;
                sel_r16 = 1'd1;
                we_r17 = 1'b1;
                sel_r17 = 1'd1;
                we_r18 = 1'b1;
                sel_r18 = 1'd1;
                we_r19 = 1'b1;
                sel_r19 = 1'd1;
            end
            ST_DONE: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end
endmodule

// Datapath generated from the schedule:
//   10 adder(s), 10 subtractor(s), 0 multiplier(s), 40 registers, 3 FSM states
// Registers sit at the cycle boundaries; muxes route registers/constants
// to the shared functional units and FU outputs back to the registers.
module hls_core (
    input clk,
    input rst,
    input en,
    input start,
    input  [3:0] in_B,
    input  [3:0] in_C,
    input  [3:0] in_E,
    input  [3:0] in_F,
    input  [3:0] in_H,
    input  [3:0] in_I,
    input  [3:0] in_K,
    input  [3:0] in_L,
    input  [3:0] in_N,
    input  [3:0] in_O,
    input  [3:0] in_Q,
    input  [3:0] in_R,
    input  [3:0] in_T,
    input  [3:0] in_U,
    input  [3:0] in_W,
    input  [3:0] in_X,
    input  [3:0] in_Z,
    input  [3:0] in_A1,
    input  [3:0] in_A3,
    input  [3:0] in_A4,
    input  [3:0] in_A6,
    input  [3:0] in_A7,
    input  [3:0] in_A9,
    input  [3:0] in_A10,
    input  [3:0] in_A_1,
    input  [3:0] in_A_2,
    input  [3:0] in_A_4,
    input  [3:0] in_A_5,
    input  [3:0] in_AAAAAA1,
    input  [3:0] in_AAAAAA2,
    input  [3:0] in_AAAAAA4,
    input  [3:0] in_AAAAAA5,
    input  [3:0] in_AA_E,
    input  [3:0] in_A_EE,
    input  [3:0] in_ABB2,
    input  [3:0] in_AC1,
    input  [3:0] in_AE2,
    input  [3:0] in_AF3,
    input  [3:0] in_AG2,
    input  [3:0] in_AG1,
    output [3:0] out_A,
    output [3:0] out_D,
    output [3:0] out_G,
    output [3:0] out_J,
    output [3:0] out_M,
    output [3:0] out_P,
    output [3:0] out_S,
    output [3:0] out_V,
    output [3:0] out_Y,
    output [3:0] out_A2,
    output [3:0] out_A5,
    output [3:0] out_A8,
    output [3:0] out_A_0,
    output [3:0] out_A_3,
    output [3:0] out_AAAAAA0,
    output [3:0] out_AAAAAA3,
    output [3:0] out_A_E,
    output [3:0] out_AB1,
    output [3:0] out_AD1,
    output [3:0] out_AG3,
    output [3:0] fu_add0_y,
    output [3:0] fu_add1_y,
    output [3:0] fu_add2_y,
    output [3:0] fu_add3_y,
    output [3:0] fu_add4_y,
    output [3:0] fu_add5_y,
    output [3:0] fu_add6_y,
    output [3:0] fu_add7_y,
    output [3:0] fu_add8_y,
    output [3:0] fu_add9_y,
    output [3:0] fu_sub0_y,
    output [3:0] fu_sub1_y,
    output [3:0] fu_sub2_y,
    output [3:0] fu_sub3_y,
    output [3:0] fu_sub4_y,
    output [3:0] fu_sub5_y,
    output [3:0] fu_sub6_y,
    output [3:0] fu_sub7_y,
    output [3:0] fu_sub8_y,
    output [3:0] fu_sub9_y,
    output [1:0] state,
    output done
);
    localparam W = 4;

    // control signals
    wire sel_r0;
    wire sel_r1;
    wire sel_r2;
    wire sel_r3;
    wire sel_r4;
    wire sel_r5;
    wire sel_r6;
    wire sel_r7;
    wire sel_r8;
    wire sel_r9;
    wire sel_r10;
    wire sel_r11;
    wire sel_r12;
    wire sel_r13;
    wire sel_r14;
    wire sel_r15;
    wire sel_r16;
    wire sel_r17;
    wire sel_r18;
    wire sel_r19;
    wire we_r0;
    wire we_r1;
    wire we_r2;
    wire we_r3;
    wire we_r4;
    wire we_r5;
    wire we_r6;
    wire we_r7;
    wire we_r8;
    wire we_r9;
    wire we_r10;
    wire we_r11;
    wire we_r12;
    wire we_r13;
    wire we_r14;
    wire we_r15;
    wire we_r16;
    wire we_r17;
    wire we_r18;
    wire we_r19;
    wire we_r20;
    wire we_r21;
    wire we_r22;
    wire we_r23;
    wire we_r24;
    wire we_r25;
    wire we_r26;
    wire we_r27;
    wire we_r28;
    wire we_r29;
    wire we_r30;
    wire we_r31;
    wire we_r32;
    wire we_r33;
    wire we_r34;
    wire we_r35;
    wire we_r36;
    wire we_r37;
    wire we_r38;
    wire we_r39;

    hls_controller ctrl (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .state(state),
        .done(done),
        .sel_r0(sel_r0),
        .sel_r1(sel_r1),
        .sel_r2(sel_r2),
        .sel_r3(sel_r3),
        .sel_r4(sel_r4),
        .sel_r5(sel_r5),
        .sel_r6(sel_r6),
        .sel_r7(sel_r7),
        .sel_r8(sel_r8),
        .sel_r9(sel_r9),
        .sel_r10(sel_r10),
        .sel_r11(sel_r11),
        .sel_r12(sel_r12),
        .sel_r13(sel_r13),
        .sel_r14(sel_r14),
        .sel_r15(sel_r15),
        .sel_r16(sel_r16),
        .sel_r17(sel_r17),
        .sel_r18(sel_r18),
        .sel_r19(sel_r19),
        .we_r0(we_r0),
        .we_r1(we_r1),
        .we_r2(we_r2),
        .we_r3(we_r3),
        .we_r4(we_r4),
        .we_r5(we_r5),
        .we_r6(we_r6),
        .we_r7(we_r7),
        .we_r8(we_r8),
        .we_r9(we_r9),
        .we_r10(we_r10),
        .we_r11(we_r11),
        .we_r12(we_r12),
        .we_r13(we_r13),
        .we_r14(we_r14),
        .we_r15(we_r15),
        .we_r16(we_r16),
        .we_r17(we_r17),
        .we_r18(we_r18),
        .we_r19(we_r19),
        .we_r20(we_r20),
        .we_r21(we_r21),
        .we_r22(we_r22),
        .we_r23(we_r23),
        .we_r24(we_r24),
        .we_r25(we_r25),
        .we_r26(we_r26),
        .we_r27(we_r27),
        .we_r28(we_r28),
        .we_r29(we_r29),
        .we_r30(we_r30),
        .we_r31(we_r31),
        .we_r32(we_r32),
        .we_r33(we_r33),
        .we_r34(we_r34),
        .we_r35(we_r35),
        .we_r36(we_r36),
        .we_r37(we_r37),
        .we_r38(we_r38),
        .we_r39(we_r39)
    );

    // registers
    reg [W-1:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31, r32, r33, r34, r35, r36, r37, r38, r39;

    // functional units and their input muxes
    reg [W-1:0] add0_a, add0_b;
    always @(*) add0_a = r0;
    always @(*) add0_b = r1;
    adder #(.W(W)) u_add0 (.a(add0_a), .b(add0_b), .y(fu_add0_y));

    reg [W-1:0] add1_a, add1_b;
    always @(*) add1_a = r4;
    always @(*) add1_b = r5;
    adder #(.W(W)) u_add1 (.a(add1_a), .b(add1_b), .y(fu_add1_y));

    reg [W-1:0] add2_a, add2_b;
    always @(*) add2_a = r8;
    always @(*) add2_b = r9;
    adder #(.W(W)) u_add2 (.a(add2_a), .b(add2_b), .y(fu_add2_y));

    reg [W-1:0] add3_a, add3_b;
    always @(*) add3_a = r12;
    always @(*) add3_b = r13;
    adder #(.W(W)) u_add3 (.a(add3_a), .b(add3_b), .y(fu_add3_y));

    reg [W-1:0] add4_a, add4_b;
    always @(*) add4_a = r16;
    always @(*) add4_b = r17;
    adder #(.W(W)) u_add4 (.a(add4_a), .b(add4_b), .y(fu_add4_y));

    reg [W-1:0] add5_a, add5_b;
    always @(*) add5_a = r20;
    always @(*) add5_b = r21;
    adder #(.W(W)) u_add5 (.a(add5_a), .b(add5_b), .y(fu_add5_y));

    reg [W-1:0] add6_a, add6_b;
    always @(*) add6_a = r24;
    always @(*) add6_b = r25;
    adder #(.W(W)) u_add6 (.a(add6_a), .b(add6_b), .y(fu_add6_y));

    reg [W-1:0] add7_a, add7_b;
    always @(*) add7_a = r28;
    always @(*) add7_b = r29;
    adder #(.W(W)) u_add7 (.a(add7_a), .b(add7_b), .y(fu_add7_y));

    reg [W-1:0] add8_a, add8_b;
    always @(*) add8_a = r32;
    always @(*) add8_b = r33;
    adder #(.W(W)) u_add8 (.a(add8_a), .b(add8_b), .y(fu_add8_y));

    reg [W-1:0] add9_a, add9_b;
    always @(*) add9_a = r36;
    always @(*) add9_b = r37;
    adder #(.W(W)) u_add9 (.a(add9_a), .b(add9_b), .y(fu_add9_y));

    reg [W-1:0] sub0_a, sub0_b;
    always @(*) sub0_a = r2;
    always @(*) sub0_b = r3;
    subtractor #(.W(W)) u_sub0 (.a(sub0_a), .b(sub0_b), .y(fu_sub0_y));

    reg [W-1:0] sub1_a, sub1_b;
    always @(*) sub1_a = r6;
    always @(*) sub1_b = r7;
    subtractor #(.W(W)) u_sub1 (.a(sub1_a), .b(sub1_b), .y(fu_sub1_y));

    reg [W-1:0] sub2_a, sub2_b;
    always @(*) sub2_a = r10;
    always @(*) sub2_b = r11;
    subtractor #(.W(W)) u_sub2 (.a(sub2_a), .b(sub2_b), .y(fu_sub2_y));

    reg [W-1:0] sub3_a, sub3_b;
    always @(*) sub3_a = r14;
    always @(*) sub3_b = r15;
    subtractor #(.W(W)) u_sub3 (.a(sub3_a), .b(sub3_b), .y(fu_sub3_y));

    reg [W-1:0] sub4_a, sub4_b;
    always @(*) sub4_a = r18;
    always @(*) sub4_b = r19;
    subtractor #(.W(W)) u_sub4 (.a(sub4_a), .b(sub4_b), .y(fu_sub4_y));

    reg [W-1:0] sub5_a, sub5_b;
    always @(*) sub5_a = r22;
    always @(*) sub5_b = r23;
    subtractor #(.W(W)) u_sub5 (.a(sub5_a), .b(sub5_b), .y(fu_sub5_y));

    reg [W-1:0] sub6_a, sub6_b;
    always @(*) sub6_a = r26;
    always @(*) sub6_b = r27;
    subtractor #(.W(W)) u_sub6 (.a(sub6_a), .b(sub6_b), .y(fu_sub6_y));

    reg [W-1:0] sub7_a, sub7_b;
    always @(*) sub7_a = r30;
    always @(*) sub7_b = r31;
    subtractor #(.W(W)) u_sub7 (.a(sub7_a), .b(sub7_b), .y(fu_sub7_y));

    reg [W-1:0] sub8_a, sub8_b;
    always @(*) sub8_a = r34;
    always @(*) sub8_b = r35;
    subtractor #(.W(W)) u_sub8 (.a(sub8_a), .b(sub8_b), .y(fu_sub8_y));

    reg [W-1:0] sub9_a, sub9_b;
    always @(*) sub9_a = r38;
    always @(*) sub9_b = r39;
    subtractor #(.W(W)) u_sub9 (.a(sub9_a), .b(sub9_b), .y(fu_sub9_y));

    // register input muxes
    reg [W-1:0] r0_d;
    always @(*)
        case (sel_r0)
            1'd0: r0_d = in_B;
            1'd1: r0_d = fu_add0_y;
            default: r0_d = {W{1'b0}};
        endcase
    reg [W-1:0] r1_d;
    always @(*)
        case (sel_r1)
            1'd0: r1_d = in_C;
            1'd1: r1_d = fu_sub0_y;
            default: r1_d = {W{1'b0}};
        endcase
    reg [W-1:0] r2_d;
    always @(*)
        case (sel_r2)
            1'd0: r2_d = in_E;
            1'd1: r2_d = fu_add1_y;
            default: r2_d = {W{1'b0}};
        endcase
    reg [W-1:0] r3_d;
    always @(*)
        case (sel_r3)
            1'd0: r3_d = in_F;
            1'd1: r3_d = fu_sub1_y;
            default: r3_d = {W{1'b0}};
        endcase
    reg [W-1:0] r4_d;
    always @(*)
        case (sel_r4)
            1'd0: r4_d = in_H;
            1'd1: r4_d = fu_add2_y;
            default: r4_d = {W{1'b0}};
        endcase
    reg [W-1:0] r5_d;
    always @(*)
        case (sel_r5)
            1'd0: r5_d = in_I;
            1'd1: r5_d = fu_sub2_y;
            default: r5_d = {W{1'b0}};
        endcase
    reg [W-1:0] r6_d;
    always @(*)
        case (sel_r6)
            1'd0: r6_d = in_K;
            1'd1: r6_d = fu_add3_y;
            default: r6_d = {W{1'b0}};
        endcase
    reg [W-1:0] r7_d;
    always @(*)
        case (sel_r7)
            1'd0: r7_d = in_L;
            1'd1: r7_d = fu_sub3_y;
            default: r7_d = {W{1'b0}};
        endcase
    reg [W-1:0] r8_d;
    always @(*)
        case (sel_r8)
            1'd0: r8_d = in_N;
            1'd1: r8_d = fu_add4_y;
            default: r8_d = {W{1'b0}};
        endcase
    reg [W-1:0] r9_d;
    always @(*)
        case (sel_r9)
            1'd0: r9_d = in_O;
            1'd1: r9_d = fu_sub4_y;
            default: r9_d = {W{1'b0}};
        endcase
    reg [W-1:0] r10_d;
    always @(*)
        case (sel_r10)
            1'd0: r10_d = in_Q;
            1'd1: r10_d = fu_add5_y;
            default: r10_d = {W{1'b0}};
        endcase
    reg [W-1:0] r11_d;
    always @(*)
        case (sel_r11)
            1'd0: r11_d = in_R;
            1'd1: r11_d = fu_sub5_y;
            default: r11_d = {W{1'b0}};
        endcase
    reg [W-1:0] r12_d;
    always @(*)
        case (sel_r12)
            1'd0: r12_d = in_T;
            1'd1: r12_d = fu_add6_y;
            default: r12_d = {W{1'b0}};
        endcase
    reg [W-1:0] r13_d;
    always @(*)
        case (sel_r13)
            1'd0: r13_d = in_U;
            1'd1: r13_d = fu_sub6_y;
            default: r13_d = {W{1'b0}};
        endcase
    reg [W-1:0] r14_d;
    always @(*)
        case (sel_r14)
            1'd0: r14_d = in_W;
            1'd1: r14_d = fu_add7_y;
            default: r14_d = {W{1'b0}};
        endcase
    reg [W-1:0] r15_d;
    always @(*)
        case (sel_r15)
            1'd0: r15_d = in_X;
            1'd1: r15_d = fu_sub7_y;
            default: r15_d = {W{1'b0}};
        endcase
    reg [W-1:0] r16_d;
    always @(*)
        case (sel_r16)
            1'd0: r16_d = in_Z;
            1'd1: r16_d = fu_add8_y;
            default: r16_d = {W{1'b0}};
        endcase
    reg [W-1:0] r17_d;
    always @(*)
        case (sel_r17)
            1'd0: r17_d = in_A1;
            1'd1: r17_d = fu_sub8_y;
            default: r17_d = {W{1'b0}};
        endcase
    reg [W-1:0] r18_d;
    always @(*)
        case (sel_r18)
            1'd0: r18_d = in_A3;
            1'd1: r18_d = fu_add9_y;
            default: r18_d = {W{1'b0}};
        endcase
    reg [W-1:0] r19_d;
    always @(*)
        case (sel_r19)
            1'd0: r19_d = in_A4;
            1'd1: r19_d = fu_sub9_y;
            default: r19_d = {W{1'b0}};
        endcase
    reg [W-1:0] r20_d;
    always @(*) r20_d = in_A6;
    reg [W-1:0] r21_d;
    always @(*) r21_d = in_A7;
    reg [W-1:0] r22_d;
    always @(*) r22_d = in_A9;
    reg [W-1:0] r23_d;
    always @(*) r23_d = in_A10;
    reg [W-1:0] r24_d;
    always @(*) r24_d = in_A_1;
    reg [W-1:0] r25_d;
    always @(*) r25_d = in_A_2;
    reg [W-1:0] r26_d;
    always @(*) r26_d = in_A_4;
    reg [W-1:0] r27_d;
    always @(*) r27_d = in_A_5;
    reg [W-1:0] r28_d;
    always @(*) r28_d = in_AAAAAA1;
    reg [W-1:0] r29_d;
    always @(*) r29_d = in_AAAAAA2;
    reg [W-1:0] r30_d;
    always @(*) r30_d = in_AAAAAA4;
    reg [W-1:0] r31_d;
    always @(*) r31_d = in_AAAAAA5;
    reg [W-1:0] r32_d;
    always @(*) r32_d = in_AA_E;
    reg [W-1:0] r33_d;
    always @(*) r33_d = in_A_EE;
    reg [W-1:0] r34_d;
    always @(*) r34_d = in_ABB2;
    reg [W-1:0] r35_d;
    always @(*) r35_d = in_AC1;
    reg [W-1:0] r36_d;
    always @(*) r36_d = in_AE2;
    reg [W-1:0] r37_d;
    always @(*) r37_d = in_AF3;
    reg [W-1:0] r38_d;
    always @(*) r38_d = in_AG2;
    reg [W-1:0] r39_d;
    always @(*) r39_d = in_AG1;

    always @(posedge clk) begin
        if (rst) begin
            r0 <= {W{1'b0}};
            r1 <= {W{1'b0}};
            r2 <= {W{1'b0}};
            r3 <= {W{1'b0}};
            r4 <= {W{1'b0}};
            r5 <= {W{1'b0}};
            r6 <= {W{1'b0}};
            r7 <= {W{1'b0}};
            r8 <= {W{1'b0}};
            r9 <= {W{1'b0}};
            r10 <= {W{1'b0}};
            r11 <= {W{1'b0}};
            r12 <= {W{1'b0}};
            r13 <= {W{1'b0}};
            r14 <= {W{1'b0}};
            r15 <= {W{1'b0}};
            r16 <= {W{1'b0}};
            r17 <= {W{1'b0}};
            r18 <= {W{1'b0}};
            r19 <= {W{1'b0}};
            r20 <= {W{1'b0}};
            r21 <= {W{1'b0}};
            r22 <= {W{1'b0}};
            r23 <= {W{1'b0}};
            r24 <= {W{1'b0}};
            r25 <= {W{1'b0}};
            r26 <= {W{1'b0}};
            r27 <= {W{1'b0}};
            r28 <= {W{1'b0}};
            r29 <= {W{1'b0}};
            r30 <= {W{1'b0}};
            r31 <= {W{1'b0}};
            r32 <= {W{1'b0}};
            r33 <= {W{1'b0}};
            r34 <= {W{1'b0}};
            r35 <= {W{1'b0}};
            r36 <= {W{1'b0}};
            r37 <= {W{1'b0}};
            r38 <= {W{1'b0}};
            r39 <= {W{1'b0}};
        end else if (en) begin
            if (we_r0) r0 <= r0_d;
            if (we_r1) r1 <= r1_d;
            if (we_r2) r2 <= r2_d;
            if (we_r3) r3 <= r3_d;
            if (we_r4) r4 <= r4_d;
            if (we_r5) r5 <= r5_d;
            if (we_r6) r6 <= r6_d;
            if (we_r7) r7 <= r7_d;
            if (we_r8) r8 <= r8_d;
            if (we_r9) r9 <= r9_d;
            if (we_r10) r10 <= r10_d;
            if (we_r11) r11 <= r11_d;
            if (we_r12) r12 <= r12_d;
            if (we_r13) r13 <= r13_d;
            if (we_r14) r14 <= r14_d;
            if (we_r15) r15 <= r15_d;
            if (we_r16) r16 <= r16_d;
            if (we_r17) r17 <= r17_d;
            if (we_r18) r18 <= r18_d;
            if (we_r19) r19 <= r19_d;
            if (we_r20) r20 <= r20_d;
            if (we_r21) r21 <= r21_d;
            if (we_r22) r22 <= r22_d;
            if (we_r23) r23 <= r23_d;
            if (we_r24) r24 <= r24_d;
            if (we_r25) r25 <= r25_d;
            if (we_r26) r26 <= r26_d;
            if (we_r27) r27 <= r27_d;
            if (we_r28) r28 <= r28_d;
            if (we_r29) r29 <= r29_d;
            if (we_r30) r30 <= r30_d;
            if (we_r31) r31 <= r31_d;
            if (we_r32) r32 <= r32_d;
            if (we_r33) r33 <= r33_d;
            if (we_r34) r34 <= r34_d;
            if (we_r35) r35 <= r35_d;
            if (we_r36) r36 <= r36_d;
            if (we_r37) r37 <= r37_d;
            if (we_r38) r38 <= r38_d;
            if (we_r39) r39 <= r39_d;
        end
    end

    // outputs (valid in state DONE)
    assign out_A = r0;   // A_0
    assign out_D = r1;   // D_0
    assign out_G = r2;   // G_0
    assign out_J = r3;   // J_0
    assign out_M = r4;   // M_0
    assign out_P = r5;   // P_0
    assign out_S = r6;   // S_0
    assign out_V = r7;   // V_0
    assign out_Y = r8;   // Y_0
    assign out_A2 = r9;   // A2_0
    assign out_A5 = r10;   // A5_0
    assign out_A8 = r11;   // A8_0
    assign out_A_0 = r12;   // A_0_0
    assign out_A_3 = r13;   // A_3_0
    assign out_AAAAAA0 = r14;   // AAAAAA0_0
    assign out_AAAAAA3 = r15;   // AAAAAA3_0
    assign out_A_E = r16;   // A_E_0
    assign out_AB1 = r17;   // AB1_0
    assign out_AD1 = r18;   // AD1_0
    assign out_AG3 = r19;   // AG3_0
endmodule
