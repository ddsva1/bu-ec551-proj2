// Self-checking testbench, generated together with hls_core.v / hls_top.v.
//   part 1: hls_core with en=1, one run per input vector, every output checked
//   part 2: hls_top stepped with the button; state advance and the
//           observability mux are checked
module testbench;
    localparam W = 4;
    localparam LATENCY = 1;
    reg clk = 1'b0;
    always #5 clk = ~clk;
    integer errors = 0;

    task check(input [8*40-1:0] what, input [31:0] got, input [31:0] expected);
        if (got !== expected) begin
            $display("FAIL %0s: got %0d, expected %0d", what, got, expected);
            errors = errors + 1;
        end
    endtask

    // ---- device under test 1: hls_core
    reg rst = 1'b1, en = 1'b1, start = 1'b0;
    reg  [W-1:0] in_B = 0;
    reg  [W-1:0] in_C = 0;
    reg  [W-1:0] in_E = 0;
    reg  [W-1:0] in_F = 0;
    reg  [W-1:0] in_H = 0;
    reg  [W-1:0] in_I = 0;
    reg  [W-1:0] in_K = 0;
    reg  [W-1:0] in_L = 0;
    reg  [W-1:0] in_N = 0;
    reg  [W-1:0] in_O = 0;
    reg  [W-1:0] in_Q = 0;
    reg  [W-1:0] in_R = 0;
    reg  [W-1:0] in_T = 0;
    reg  [W-1:0] in_U = 0;
    reg  [W-1:0] in_W = 0;
    reg  [W-1:0] in_X = 0;
    reg  [W-1:0] in_Z = 0;
    reg  [W-1:0] in_A1 = 0;
    reg  [W-1:0] in_A3 = 0;
    reg  [W-1:0] in_A4 = 0;
    reg  [W-1:0] in_A6 = 0;
    reg  [W-1:0] in_A7 = 0;
    reg  [W-1:0] in_A9 = 0;
    reg  [W-1:0] in_A10 = 0;
    reg  [W-1:0] in_A_1 = 0;
    reg  [W-1:0] in_A_2 = 0;
    reg  [W-1:0] in_A_4 = 0;
    reg  [W-1:0] in_A_5 = 0;
    reg  [W-1:0] in_AAAAAA1 = 0;
    reg  [W-1:0] in_AAAAAA2 = 0;
    reg  [W-1:0] in_AAAAAA4 = 0;
    reg  [W-1:0] in_AAAAAA5 = 0;
    reg  [W-1:0] in_AA_E = 0;
    reg  [W-1:0] in_A_EE = 0;
    reg  [W-1:0] in_ABB2 = 0;
    reg  [W-1:0] in_AC1 = 0;
    reg  [W-1:0] in_AE2 = 0;
    reg  [W-1:0] in_AF3 = 0;
    reg  [W-1:0] in_AG2 = 0;
    reg  [W-1:0] in_AG1 = 0;
    wire [W-1:0] out_A;
    wire [W-1:0] out_D;
    wire [W-1:0] out_G;
    wire [W-1:0] out_J;
    wire [W-1:0] out_M;
    wire [W-1:0] out_P;
    wire [W-1:0] out_S;
    wire [W-1:0] out_V;
    wire [W-1:0] out_Y;
    wire [W-1:0] out_A2;
    wire [W-1:0] out_A5;
    wire [W-1:0] out_A8;
    wire [W-1:0] out_A_0;
    wire [W-1:0] out_A_3;
    wire [W-1:0] out_AAAAAA0;
    wire [W-1:0] out_AAAAAA3;
    wire [W-1:0] out_A_E;
    wire [W-1:0] out_AB1;
    wire [W-1:0] out_AD1;
    wire [W-1:0] out_AG3;
    wire [1:0] state;
    wire done;
    hls_core dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
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
        .fu_add0_y(),
        .fu_add1_y(),
        .fu_add2_y(),
        .fu_add3_y(),
        .fu_add4_y(),
        .fu_add5_y(),
        .fu_add6_y(),
        .fu_add7_y(),
        .fu_add8_y(),
        .fu_add9_y(),
        .fu_sub0_y(),
        .fu_sub1_y(),
        .fu_sub2_y(),
        .fu_sub3_y(),
        .fu_sub4_y(),
        .fu_sub5_y(),
        .fu_sub6_y(),
        .fu_sub7_y(),
        .fu_sub8_y(),
        .fu_sub9_y(),
        .state(state),
        .done(done)
    );

    // ---- device under test 2: hls_top (fast debounce for simulation)
    reg t_rst = 1'b1, t_step = 1'b0;
    reg [15:0] sw = 16'd0;
    wire [7:0] obs_val, t_state;
    wire t_done;
    hls_top #(.DEBOUNCE(2)) top_dut (.clk(clk), .btn_rst(t_rst), .btn_step(t_step), .sw(sw),
                                    .obs_val(obs_val), .state(t_state), .done(t_done));

    task press;
        begin
            t_step = 1'b1; repeat (8) @(posedge clk); #1;
            t_step = 1'b0; repeat (8) @(posedge clk); #1;
        end
    endtask

    initial begin
        #1;
        // vector 0: B=0 C=0 E=0 F=0 H=0 I=0 K=0 L=0 N=0 O=0 Q=0 R=0 T=0 U=0 W=0 X=0 Z=0 A1=0 A3=0 A4=0 A6=0 A7=0 A9=0 A10=0 A_1=0 A_2=0 A_4=0 A_5=0 AAAAAA1=0 AAAAAA2=0 AAAAAA4=0 AAAAAA5=0 AA_E=0 A_EE=0 ABB2=0 AC1=0 AE2=0 AF3=0 AG2=0 AG1=0
        in_B = 4'd0; in_C = 4'd0; in_E = 4'd0; in_F = 4'd0; in_H = 4'd0; in_I = 4'd0; in_K = 4'd0; in_L = 4'd0; in_N = 4'd0; in_O = 4'd0; in_Q = 4'd0; in_R = 4'd0; in_T = 4'd0; in_U = 4'd0; in_W = 4'd0; in_X = 4'd0; in_Z = 4'd0; in_A1 = 4'd0; in_A3 = 4'd0; in_A4 = 4'd0; in_A6 = 4'd0; in_A7 = 4'd0; in_A9 = 4'd0; in_A10 = 4'd0; in_A_1 = 4'd0; in_A_2 = 4'd0; in_A_4 = 4'd0; in_A_5 = 4'd0; in_AAAAAA1 = 4'd0; in_AAAAAA2 = 4'd0; in_AAAAAA4 = 4'd0; in_AAAAAA5 = 4'd0; in_AA_E = 4'd0; in_A_EE = 4'd0; in_ABB2 = 4'd0; in_AC1 = 4'd0; in_AE2 = 4'd0; in_AF3 = 4'd0; in_AG2 = 4'd0; in_AG1 = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v0: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v0: done after 2 cycles", done, 1);
        check("v0: out_A", out_A, 0);
        check("v0: out_D", out_D, 0);
        check("v0: out_G", out_G, 0);
        check("v0: out_J", out_J, 0);
        check("v0: out_M", out_M, 0);
        check("v0: out_P", out_P, 0);
        check("v0: out_S", out_S, 0);
        check("v0: out_V", out_V, 0);
        check("v0: out_Y", out_Y, 0);
        check("v0: out_A2", out_A2, 0);
        check("v0: out_A5", out_A5, 0);
        check("v0: out_A8", out_A8, 0);
        check("v0: out_A_0", out_A_0, 0);
        check("v0: out_A_3", out_A_3, 0);
        check("v0: out_AAAAAA0", out_AAAAAA0, 0);
        check("v0: out_AAAAAA3", out_AAAAAA3, 0);
        check("v0: out_A_E", out_A_E, 0);
        check("v0: out_AB1", out_AB1, 0);
        check("v0: out_AD1", out_AD1, 0);
        check("v0: out_AG3", out_AG3, 0);
        // vector 1: B=15 C=15 E=15 F=15 H=15 I=15 K=15 L=15 N=15 O=15 Q=15 R=15 T=15 U=15 W=15 X=15 Z=15 A1=15 A3=15 A4=15 A6=15 A7=15 A9=15 A10=15 A_1=15 A_2=15 A_4=15 A_5=15 AAAAAA1=15 AAAAAA2=15 AAAAAA4=15 AAAAAA5=15 AA_E=15 A_EE=15 ABB2=15 AC1=15 AE2=15 AF3=15 AG2=15 AG1=15
        in_B = 4'd15; in_C = 4'd15; in_E = 4'd15; in_F = 4'd15; in_H = 4'd15; in_I = 4'd15; in_K = 4'd15; in_L = 4'd15; in_N = 4'd15; in_O = 4'd15; in_Q = 4'd15; in_R = 4'd15; in_T = 4'd15; in_U = 4'd15; in_W = 4'd15; in_X = 4'd15; in_Z = 4'd15; in_A1 = 4'd15; in_A3 = 4'd15; in_A4 = 4'd15; in_A6 = 4'd15; in_A7 = 4'd15; in_A9 = 4'd15; in_A10 = 4'd15; in_A_1 = 4'd15; in_A_2 = 4'd15; in_A_4 = 4'd15; in_A_5 = 4'd15; in_AAAAAA1 = 4'd15; in_AAAAAA2 = 4'd15; in_AAAAAA4 = 4'd15; in_AAAAAA5 = 4'd15; in_AA_E = 4'd15; in_A_EE = 4'd15; in_ABB2 = 4'd15; in_AC1 = 4'd15; in_AE2 = 4'd15; in_AF3 = 4'd15; in_AG2 = 4'd15; in_AG1 = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v1: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v1: done after 2 cycles", done, 1);
        check("v1: out_A", out_A, 14);
        check("v1: out_D", out_D, 0);
        check("v1: out_G", out_G, 14);
        check("v1: out_J", out_J, 0);
        check("v1: out_M", out_M, 14);
        check("v1: out_P", out_P, 0);
        check("v1: out_S", out_S, 14);
        check("v1: out_V", out_V, 0);
        check("v1: out_Y", out_Y, 14);
        check("v1: out_A2", out_A2, 0);
        check("v1: out_A5", out_A5, 14);
        check("v1: out_A8", out_A8, 0);
        check("v1: out_A_0", out_A_0, 14);
        check("v1: out_A_3", out_A_3, 0);
        check("v1: out_AAAAAA0", out_AAAAAA0, 14);
        check("v1: out_AAAAAA3", out_AAAAAA3, 0);
        check("v1: out_A_E", out_A_E, 14);
        check("v1: out_AB1", out_AB1, 0);
        check("v1: out_AD1", out_AD1, 14);
        check("v1: out_AG3", out_AG3, 0);
        // vector 2: B=1 C=2 E=3 F=4 H=5 I=6 K=7 L=8 N=9 O=10 Q=11 R=12 T=13 U=14 W=15 X=0 Z=1 A1=2 A3=3 A4=4 A6=5 A7=6 A9=7 A10=8 A_1=9 A_2=10 A_4=11 A_5=12 AAAAAA1=13 AAAAAA2=14 AAAAAA4=15 AAAAAA5=0 AA_E=1 A_EE=2 ABB2=3 AC1=4 AE2=5 AF3=6 AG2=7 AG1=8
        in_B = 4'd1; in_C = 4'd2; in_E = 4'd3; in_F = 4'd4; in_H = 4'd5; in_I = 4'd6; in_K = 4'd7; in_L = 4'd8; in_N = 4'd9; in_O = 4'd10; in_Q = 4'd11; in_R = 4'd12; in_T = 4'd13; in_U = 4'd14; in_W = 4'd15; in_X = 4'd0; in_Z = 4'd1; in_A1 = 4'd2; in_A3 = 4'd3; in_A4 = 4'd4; in_A6 = 4'd5; in_A7 = 4'd6; in_A9 = 4'd7; in_A10 = 4'd8; in_A_1 = 4'd9; in_A_2 = 4'd10; in_A_4 = 4'd11; in_A_5 = 4'd12; in_AAAAAA1 = 4'd13; in_AAAAAA2 = 4'd14; in_AAAAAA4 = 4'd15; in_AAAAAA5 = 4'd0; in_AA_E = 4'd1; in_A_EE = 4'd2; in_ABB2 = 4'd3; in_AC1 = 4'd4; in_AE2 = 4'd5; in_AF3 = 4'd6; in_AG2 = 4'd7; in_AG1 = 4'd8;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v2: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v2: done after 2 cycles", done, 1);
        check("v2: out_A", out_A, 3);
        check("v2: out_D", out_D, 0);
        check("v2: out_G", out_G, 11);
        check("v2: out_J", out_J, 0);
        check("v2: out_M", out_M, 3);
        check("v2: out_P", out_P, 0);
        check("v2: out_S", out_S, 11);
        check("v2: out_V", out_V, 15);
        check("v2: out_Y", out_Y, 3);
        check("v2: out_A2", out_A2, 0);
        check("v2: out_A5", out_A5, 11);
        check("v2: out_A8", out_A8, 0);
        check("v2: out_A_0", out_A_0, 3);
        check("v2: out_A_3", out_A_3, 0);
        check("v2: out_AAAAAA0", out_AAAAAA0, 11);
        check("v2: out_AAAAAA3", out_AAAAAA3, 15);
        check("v2: out_A_E", out_A_E, 3);
        check("v2: out_AB1", out_AB1, 0);
        check("v2: out_AD1", out_AD1, 11);
        check("v2: out_AG3", out_AG3, 0);
        // vector 3: B=7 C=0 E=6 F=7 H=11 I=13 K=12 L=0 N=5 O=8 Q=10 R=2 T=13 U=0 W=15 X=5 Z=1 A1=9 A3=9 A4=14 A6=12 A7=15 A9=13 A10=7 A_1=2 A_2=13 A_4=8 A_5=11 AAAAAA1=3 AAAAAA2=14 AAAAAA4=3 AAAAAA5=10 AA_E=0 A_EE=7 ABB2=0 AC1=1 AE2=11 AF3=3 AG2=8 AG1=5
        in_B = 4'd7; in_C = 4'd0; in_E = 4'd6; in_F = 4'd7; in_H = 4'd11; in_I = 4'd13; in_K = 4'd12; in_L = 4'd0; in_N = 4'd5; in_O = 4'd8; in_Q = 4'd10; in_R = 4'd2; in_T = 4'd13; in_U = 4'd0; in_W = 4'd15; in_X = 4'd5; in_Z = 4'd1; in_A1 = 4'd9; in_A3 = 4'd9; in_A4 = 4'd14; in_A6 = 4'd12; in_A7 = 4'd15; in_A9 = 4'd13; in_A10 = 4'd7; in_A_1 = 4'd2; in_A_2 = 4'd13; in_A_4 = 4'd8; in_A_5 = 4'd11; in_AAAAAA1 = 4'd3; in_AAAAAA2 = 4'd14; in_AAAAAA4 = 4'd3; in_AAAAAA5 = 4'd10; in_AA_E = 4'd0; in_A_EE = 4'd7; in_ABB2 = 4'd0; in_AC1 = 4'd1; in_AE2 = 4'd11; in_AF3 = 4'd3; in_AG2 = 4'd8; in_AG1 = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v3: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v3: done after 2 cycles", done, 1);
        check("v3: out_A", out_A, 7);
        check("v3: out_D", out_D, 0);
        check("v3: out_G", out_G, 8);
        check("v3: out_J", out_J, 12);
        check("v3: out_M", out_M, 13);
        check("v3: out_P", out_P, 8);
        check("v3: out_S", out_S, 13);
        check("v3: out_V", out_V, 10);
        check("v3: out_Y", out_Y, 10);
        check("v3: out_A2", out_A2, 0);
        check("v3: out_A5", out_A5, 11);
        check("v3: out_A8", out_A8, 6);
        check("v3: out_A_0", out_A_0, 15);
        check("v3: out_A_3", out_A_3, 0);
        check("v3: out_AAAAAA0", out_AAAAAA0, 1);
        check("v3: out_AAAAAA3", out_AAAAAA3, 0);
        check("v3: out_A_E", out_A_E, 7);
        check("v3: out_AB1", out_AB1, 0);
        check("v3: out_AD1", out_AD1, 14);
        check("v3: out_AG3", out_AG3, 3);
        // vector 4: B=1 C=12 E=15 F=7 H=10 I=10 K=0 L=4 N=2 O=13 Q=6 R=2 T=3 U=9 W=4 X=10 Z=0 A1=8 A3=12 A4=0 A6=1 A7=2 A9=13 A10=8 A_1=13 A_2=12 A_4=2 A_5=7 AAAAAA1=12 AAAAAA2=11 AAAAAA4=4 AAAAAA5=12 AA_E=2 A_EE=8 ABB2=11 AC1=2 AE2=9 AF3=8 AG2=2 AG1=9
        in_B = 4'd1; in_C = 4'd12; in_E = 4'd15; in_F = 4'd7; in_H = 4'd10; in_I = 4'd10; in_K = 4'd0; in_L = 4'd4; in_N = 4'd2; in_O = 4'd13; in_Q = 4'd6; in_R = 4'd2; in_T = 4'd3; in_U = 4'd9; in_W = 4'd4; in_X = 4'd10; in_Z = 4'd0; in_A1 = 4'd8; in_A3 = 4'd12; in_A4 = 4'd0; in_A6 = 4'd1; in_A7 = 4'd2; in_A9 = 4'd13; in_A10 = 4'd8; in_A_1 = 4'd13; in_A_2 = 4'd12; in_A_4 = 4'd2; in_A_5 = 4'd7; in_AAAAAA1 = 4'd12; in_AAAAAA2 = 4'd11; in_AAAAAA4 = 4'd4; in_AAAAAA5 = 4'd12; in_AA_E = 4'd2; in_A_EE = 4'd8; in_ABB2 = 4'd11; in_AC1 = 4'd2; in_AE2 = 4'd9; in_AF3 = 4'd8; in_AG2 = 4'd2; in_AG1 = 4'd9;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v4: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v4: done after 2 cycles", done, 1);
        check("v4: out_A", out_A, 13);
        check("v4: out_D", out_D, 8);
        check("v4: out_G", out_G, 4);
        check("v4: out_J", out_J, 0);
        check("v4: out_M", out_M, 15);
        check("v4: out_P", out_P, 4);
        check("v4: out_S", out_S, 12);
        check("v4: out_V", out_V, 0);
        check("v4: out_Y", out_Y, 8);
        check("v4: out_A2", out_A2, 12);
        check("v4: out_A5", out_A5, 3);
        check("v4: out_A8", out_A8, 5);
        check("v4: out_A_0", out_A_0, 9);
        check("v4: out_A_3", out_A_3, 0);
        check("v4: out_AAAAAA0", out_AAAAAA0, 7);
        check("v4: out_AAAAAA3", out_AAAAAA3, 0);
        check("v4: out_A_E", out_A_E, 10);
        check("v4: out_AB1", out_AB1, 9);
        check("v4: out_AD1", out_AD1, 1);
        check("v4: out_AG3", out_AG3, 0);
        // vector 5: B=13 C=6 E=6 F=10 H=1 I=9 K=4 L=14 N=13 O=14 Q=0 R=4 T=0 U=12 W=5 X=2 Z=1 A1=1 A3=7 A4=6 A6=2 A7=14 A9=2 A10=14 A_1=1 A_2=7 A_4=0 A_5=3 AAAAAA1=15 AAAAAA2=8 AAAAAA4=12 AAAAAA5=4 AA_E=10 A_EE=8 ABB2=6 AC1=4 AE2=15 AF3=7 AG2=4 AG1=10
        in_B = 4'd13; in_C = 4'd6; in_E = 4'd6; in_F = 4'd10; in_H = 4'd1; in_I = 4'd9; in_K = 4'd4; in_L = 4'd14; in_N = 4'd13; in_O = 4'd14; in_Q = 4'd0; in_R = 4'd4; in_T = 4'd0; in_U = 4'd12; in_W = 4'd5; in_X = 4'd2; in_Z = 4'd1; in_A1 = 4'd1; in_A3 = 4'd7; in_A4 = 4'd6; in_A6 = 4'd2; in_A7 = 4'd14; in_A9 = 4'd2; in_A10 = 4'd14; in_A_1 = 4'd1; in_A_2 = 4'd7; in_A_4 = 4'd0; in_A_5 = 4'd3; in_AAAAAA1 = 4'd15; in_AAAAAA2 = 4'd8; in_AAAAAA4 = 4'd12; in_AAAAAA5 = 4'd4; in_AA_E = 4'd10; in_A_EE = 4'd8; in_ABB2 = 4'd6; in_AC1 = 4'd4; in_AE2 = 4'd15; in_AF3 = 4'd7; in_AG2 = 4'd4; in_AG1 = 4'd10;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v5: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v5: done after 2 cycles", done, 1);
        check("v5: out_A", out_A, 3);
        check("v5: out_D", out_D, 0);
        check("v5: out_G", out_G, 10);
        check("v5: out_J", out_J, 0);
        check("v5: out_M", out_M, 11);
        check("v5: out_P", out_P, 0);
        check("v5: out_S", out_S, 12);
        check("v5: out_V", out_V, 3);
        check("v5: out_Y", out_Y, 2);
        check("v5: out_A2", out_A2, 1);
        check("v5: out_A5", out_A5, 0);
        check("v5: out_A8", out_A8, 0);
        check("v5: out_A_0", out_A_0, 8);
        check("v5: out_A_3", out_A_3, 0);
        check("v5: out_AAAAAA0", out_AAAAAA0, 7);
        check("v5: out_AAAAAA3", out_AAAAAA3, 8);
        check("v5: out_A_E", out_A_E, 2);
        check("v5: out_AB1", out_AB1, 2);
        check("v5: out_AD1", out_AD1, 6);
        check("v5: out_AG3", out_AG3, 0);
        // vector 6: B=2 C=3 E=9 F=3 H=11 I=5 K=4 L=11 N=7 O=7 Q=6 R=10 T=8 U=11 W=8 X=5 Z=4 A1=0 A3=12 A4=1 A6=1 A7=6 A9=1 A10=0 A_1=8 A_2=6 A_4=4 A_5=2 AAAAAA1=13 AAAAAA2=6 AAAAAA4=0 AAAAAA5=5 AA_E=9 A_EE=13 ABB2=5 AC1=3 AE2=9 AF3=2 AG2=14 AG1=14
        in_B = 4'd2; in_C = 4'd3; in_E = 4'd9; in_F = 4'd3; in_H = 4'd11; in_I = 4'd5; in_K = 4'd4; in_L = 4'd11; in_N = 4'd7; in_O = 4'd7; in_Q = 4'd6; in_R = 4'd10; in_T = 4'd8; in_U = 4'd11; in_W = 4'd8; in_X = 4'd5; in_Z = 4'd4; in_A1 = 4'd0; in_A3 = 4'd12; in_A4 = 4'd1; in_A6 = 4'd1; in_A7 = 4'd6; in_A9 = 4'd1; in_A10 = 4'd0; in_A_1 = 4'd8; in_A_2 = 4'd6; in_A_4 = 4'd4; in_A_5 = 4'd2; in_AAAAAA1 = 4'd13; in_AAAAAA2 = 4'd6; in_AAAAAA4 = 4'd0; in_AAAAAA5 = 4'd5; in_AA_E = 4'd9; in_A_EE = 4'd13; in_ABB2 = 4'd5; in_AC1 = 4'd3; in_AE2 = 4'd9; in_AF3 = 4'd2; in_AG2 = 4'd14; in_AG1 = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v6: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v6: done after 2 cycles", done, 1);
        check("v6: out_A", out_A, 5);
        check("v6: out_D", out_D, 6);
        check("v6: out_G", out_G, 0);
        check("v6: out_J", out_J, 0);
        check("v6: out_M", out_M, 14);
        check("v6: out_P", out_P, 0);
        check("v6: out_S", out_S, 3);
        check("v6: out_V", out_V, 3);
        check("v6: out_Y", out_Y, 4);
        check("v6: out_A2", out_A2, 11);
        check("v6: out_A5", out_A5, 7);
        check("v6: out_A8", out_A8, 1);
        check("v6: out_A_0", out_A_0, 14);
        check("v6: out_A_3", out_A_3, 2);
        check("v6: out_AAAAAA0", out_AAAAAA0, 3);
        check("v6: out_AAAAAA3", out_AAAAAA3, 0);
        check("v6: out_A_E", out_A_E, 6);
        check("v6: out_AB1", out_AB1, 2);
        check("v6: out_AD1", out_AD1, 11);
        check("v6: out_AG3", out_AG3, 0);
        // vector 7: B=3 C=13 E=15 F=0 H=12 I=0 K=12 L=11 N=5 O=4 Q=11 R=3 T=12 U=3 W=7 X=14 Z=0 A1=1 A3=2 A4=11 A6=0 A7=2 A9=13 A10=4 A_1=3 A_2=13 A_4=15 A_5=14 AAAAAA1=15 AAAAAA2=14 AAAAAA4=11 AAAAAA5=10 AA_E=1 A_EE=14 ABB2=4 AC1=14 AE2=9 AF3=13 AG2=14 AG1=6
        in_B = 4'd3; in_C = 4'd13; in_E = 4'd15; in_F = 4'd0; in_H = 4'd12; in_I = 4'd0; in_K = 4'd12; in_L = 4'd11; in_N = 4'd5; in_O = 4'd4; in_Q = 4'd11; in_R = 4'd3; in_T = 4'd12; in_U = 4'd3; in_W = 4'd7; in_X = 4'd14; in_Z = 4'd0; in_A1 = 4'd1; in_A3 = 4'd2; in_A4 = 4'd11; in_A6 = 4'd0; in_A7 = 4'd2; in_A9 = 4'd13; in_A10 = 4'd4; in_A_1 = 4'd3; in_A_2 = 4'd13; in_A_4 = 4'd15; in_A_5 = 4'd14; in_AAAAAA1 = 4'd15; in_AAAAAA2 = 4'd14; in_AAAAAA4 = 4'd11; in_AAAAAA5 = 4'd10; in_AA_E = 4'd1; in_A_EE = 4'd14; in_ABB2 = 4'd4; in_AC1 = 4'd14; in_AE2 = 4'd9; in_AF3 = 4'd13; in_AG2 = 4'd14; in_AG1 = 4'd6;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v7: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v7: done after 2 cycles", done, 1);
        check("v7: out_A", out_A, 0);
        check("v7: out_D", out_D, 15);
        check("v7: out_G", out_G, 12);
        check("v7: out_J", out_J, 1);
        check("v7: out_M", out_M, 9);
        check("v7: out_P", out_P, 8);
        check("v7: out_S", out_S, 15);
        check("v7: out_V", out_V, 0);
        check("v7: out_Y", out_Y, 1);
        check("v7: out_A2", out_A2, 0);
        check("v7: out_A5", out_A5, 2);
        check("v7: out_A8", out_A8, 9);
        check("v7: out_A_0", out_A_0, 0);
        check("v7: out_A_3", out_A_3, 1);
        check("v7: out_AAAAAA0", out_AAAAAA0, 13);
        check("v7: out_AAAAAA3", out_AAAAAA3, 1);
        check("v7: out_A_E", out_A_E, 15);
        check("v7: out_AB1", out_AB1, 0);
        check("v7: out_AD1", out_AD1, 6);
        check("v7: out_AG3", out_AG3, 8);
        // vector 8: B=7 C=14 E=14 F=14 H=7 I=7 K=14 L=9 N=15 O=15 Q=12 R=7 T=6 U=11 W=13 X=13 Z=1 A1=12 A3=1 A4=10 A6=14 A7=11 A9=11 A10=8 A_1=1 A_2=0 A_4=1 A_5=14 AAAAAA1=5 AAAAAA2=12 AAAAAA4=1 AAAAAA5=5 AA_E=4 A_EE=13 ABB2=12 AC1=2 AE2=10 AF3=13 AG2=2 AG1=11
        in_B = 4'd7; in_C = 4'd14; in_E = 4'd14; in_F = 4'd14; in_H = 4'd7; in_I = 4'd7; in_K = 4'd14; in_L = 4'd9; in_N = 4'd15; in_O = 4'd15; in_Q = 4'd12; in_R = 4'd7; in_T = 4'd6; in_U = 4'd11; in_W = 4'd13; in_X = 4'd13; in_Z = 4'd1; in_A1 = 4'd12; in_A3 = 4'd1; in_A4 = 4'd10; in_A6 = 4'd14; in_A7 = 4'd11; in_A9 = 4'd11; in_A10 = 4'd8; in_A_1 = 4'd1; in_A_2 = 4'd0; in_A_4 = 4'd1; in_A_5 = 4'd14; in_AAAAAA1 = 4'd5; in_AAAAAA2 = 4'd12; in_AAAAAA4 = 4'd1; in_AAAAAA5 = 4'd5; in_AA_E = 4'd4; in_A_EE = 4'd13; in_ABB2 = 4'd12; in_AC1 = 4'd2; in_AE2 = 4'd10; in_AF3 = 4'd13; in_AG2 = 4'd2; in_AG1 = 4'd11;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v8: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v8: done after 2 cycles", done, 1);
        check("v8: out_A", out_A, 5);
        check("v8: out_D", out_D, 0);
        check("v8: out_G", out_G, 14);
        check("v8: out_J", out_J, 5);
        check("v8: out_M", out_M, 14);
        check("v8: out_P", out_P, 5);
        check("v8: out_S", out_S, 1);
        check("v8: out_V", out_V, 0);
        check("v8: out_Y", out_Y, 13);
        check("v8: out_A2", out_A2, 0);
        check("v8: out_A5", out_A5, 9);
        check("v8: out_A8", out_A8, 3);
        check("v8: out_A_0", out_A_0, 1);
        check("v8: out_A_3", out_A_3, 0);
        check("v8: out_AAAAAA0", out_AAAAAA0, 1);
        check("v8: out_AAAAAA3", out_AAAAAA3, 0);
        check("v8: out_A_E", out_A_E, 1);
        check("v8: out_AB1", out_AB1, 10);
        check("v8: out_AD1", out_AD1, 7);
        check("v8: out_AG3", out_AG3, 0);
        // vector 9: B=3 C=15 E=3 F=4 H=4 I=12 K=13 L=3 N=14 O=12 Q=5 R=9 T=3 U=5 W=3 X=11 Z=12 A1=14 A3=11 A4=15 A6=7 A7=14 A9=15 A10=8 A_1=12 A_2=13 A_4=5 A_5=9 AAAAAA1=7 AAAAAA2=9 AAAAAA4=2 AAAAAA5=9 AA_E=12 A_EE=4 ABB2=10 AC1=14 AE2=13 AF3=8 AG2=1 AG1=5
        in_B = 4'd3; in_C = 4'd15; in_E = 4'd3; in_F = 4'd4; in_H = 4'd4; in_I = 4'd12; in_K = 4'd13; in_L = 4'd3; in_N = 4'd14; in_O = 4'd12; in_Q = 4'd5; in_R = 4'd9; in_T = 4'd3; in_U = 4'd5; in_W = 4'd3; in_X = 4'd11; in_Z = 4'd12; in_A1 = 4'd14; in_A3 = 4'd11; in_A4 = 4'd15; in_A6 = 4'd7; in_A7 = 4'd14; in_A9 = 4'd15; in_A10 = 4'd8; in_A_1 = 4'd12; in_A_2 = 4'd13; in_A_4 = 4'd5; in_A_5 = 4'd9; in_AAAAAA1 = 4'd7; in_AAAAAA2 = 4'd9; in_AAAAAA4 = 4'd2; in_AAAAAA5 = 4'd9; in_AA_E = 4'd12; in_A_EE = 4'd4; in_ABB2 = 4'd10; in_AC1 = 4'd14; in_AE2 = 4'd13; in_AF3 = 4'd8; in_AG2 = 4'd1; in_AG1 = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v9: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v9: done after 2 cycles", done, 1);
        check("v9: out_A", out_A, 2);
        check("v9: out_D", out_D, 0);
        check("v9: out_G", out_G, 0);
        check("v9: out_J", out_J, 10);
        check("v9: out_M", out_M, 10);
        check("v9: out_P", out_P, 0);
        check("v9: out_S", out_S, 8);
        check("v9: out_V", out_V, 0);
        check("v9: out_Y", out_Y, 10);
        check("v9: out_A2", out_A2, 0);
        check("v9: out_A5", out_A5, 5);
        check("v9: out_A8", out_A8, 7);
        check("v9: out_A_0", out_A_0, 9);
        check("v9: out_A_3", out_A_3, 0);
        check("v9: out_AAAAAA0", out_AAAAAA0, 0);
        check("v9: out_AAAAAA3", out_AAAAAA3, 0);
        check("v9: out_A_E", out_A_E, 0);
        check("v9: out_AB1", out_AB1, 0);
        check("v9: out_AD1", out_AD1, 5);
        check("v9: out_AG3", out_AG3, 0);
        // vector 10: B=12 C=6 E=12 F=11 H=12 I=11 K=6 L=11 N=11 O=10 Q=15 R=14 T=3 U=3 W=15 X=10 Z=6 A1=14 A3=7 A4=4 A6=1 A7=0 A9=2 A10=4 A_1=8 A_2=4 A_4=9 A_5=5 AAAAAA1=6 AAAAAA2=1 AAAAAA4=10 AAAAAA5=1 AA_E=10 A_EE=14 ABB2=15 AC1=6 AE2=11 AF3=13 AG2=2 AG1=2
        in_B = 4'd12; in_C = 4'd6; in_E = 4'd12; in_F = 4'd11; in_H = 4'd12; in_I = 4'd11; in_K = 4'd6; in_L = 4'd11; in_N = 4'd11; in_O = 4'd10; in_Q = 4'd15; in_R = 4'd14; in_T = 4'd3; in_U = 4'd3; in_W = 4'd15; in_X = 4'd10; in_Z = 4'd6; in_A1 = 4'd14; in_A3 = 4'd7; in_A4 = 4'd4; in_A6 = 4'd1; in_A7 = 4'd0; in_A9 = 4'd2; in_A10 = 4'd4; in_A_1 = 4'd8; in_A_2 = 4'd4; in_A_4 = 4'd9; in_A_5 = 4'd5; in_AAAAAA1 = 4'd6; in_AAAAAA2 = 4'd1; in_AAAAAA4 = 4'd10; in_AAAAAA5 = 4'd1; in_AA_E = 4'd10; in_A_EE = 4'd14; in_ABB2 = 4'd15; in_AC1 = 4'd6; in_AE2 = 4'd11; in_AF3 = 4'd13; in_AG2 = 4'd2; in_AG1 = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v10: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v10: done after 2 cycles", done, 1);
        check("v10: out_A", out_A, 2);
        check("v10: out_D", out_D, 1);
        check("v10: out_G", out_G, 7);
        check("v10: out_J", out_J, 0);
        check("v10: out_M", out_M, 5);
        check("v10: out_P", out_P, 1);
        check("v10: out_S", out_S, 6);
        check("v10: out_V", out_V, 5);
        check("v10: out_Y", out_Y, 4);
        check("v10: out_A2", out_A2, 3);
        check("v10: out_A5", out_A5, 1);
        check("v10: out_A8", out_A8, 0);
        check("v10: out_A_0", out_A_0, 12);
        check("v10: out_A_3", out_A_3, 4);
        check("v10: out_AAAAAA0", out_AAAAAA0, 7);
        check("v10: out_AAAAAA3", out_AAAAAA3, 9);
        check("v10: out_A_E", out_A_E, 8);
        check("v10: out_AB1", out_AB1, 9);
        check("v10: out_AD1", out_AD1, 8);
        check("v10: out_AG3", out_AG3, 0);
        // vector 11: B=13 C=1 E=12 F=14 H=2 I=0 K=7 L=3 N=11 O=5 Q=8 R=10 T=3 U=5 W=1 X=12 Z=13 A1=5 A3=13 A4=14 A6=9 A7=8 A9=5 A10=6 A_1=11 A_2=8 A_4=6 A_5=8 AAAAAA1=0 AAAAAA2=1 AAAAAA4=13 AAAAAA5=14 AA_E=1 A_EE=0 ABB2=2 AC1=7 AE2=2 AF3=15 AG2=2 AG1=14
        in_B = 4'd13; in_C = 4'd1; in_E = 4'd12; in_F = 4'd14; in_H = 4'd2; in_I = 4'd0; in_K = 4'd7; in_L = 4'd3; in_N = 4'd11; in_O = 4'd5; in_Q = 4'd8; in_R = 4'd10; in_T = 4'd3; in_U = 4'd5; in_W = 4'd1; in_X = 4'd12; in_Z = 4'd13; in_A1 = 4'd5; in_A3 = 4'd13; in_A4 = 4'd14; in_A6 = 4'd9; in_A7 = 4'd8; in_A9 = 4'd5; in_A10 = 4'd6; in_A_1 = 4'd11; in_A_2 = 4'd8; in_A_4 = 4'd6; in_A_5 = 4'd8; in_AAAAAA1 = 4'd0; in_AAAAAA2 = 4'd1; in_AAAAAA4 = 4'd13; in_AAAAAA5 = 4'd14; in_AA_E = 4'd1; in_A_EE = 4'd0; in_ABB2 = 4'd2; in_AC1 = 4'd7; in_AE2 = 4'd2; in_AF3 = 4'd15; in_AG2 = 4'd2; in_AG1 = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v11: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v11: done after 2 cycles", done, 1);
        check("v11: out_A", out_A, 14);
        check("v11: out_D", out_D, 0);
        check("v11: out_G", out_G, 2);
        check("v11: out_J", out_J, 4);
        check("v11: out_M", out_M, 0);
        check("v11: out_P", out_P, 0);
        check("v11: out_S", out_S, 8);
        check("v11: out_V", out_V, 0);
        check("v11: out_Y", out_Y, 2);
        check("v11: out_A2", out_A2, 0);
        check("v11: out_A5", out_A5, 1);
        check("v11: out_A8", out_A8, 0);
        check("v11: out_A_0", out_A_0, 3);
        check("v11: out_A_3", out_A_3, 0);
        check("v11: out_AAAAAA0", out_AAAAAA0, 1);
        check("v11: out_AAAAAA3", out_AAAAAA3, 0);
        check("v11: out_A_E", out_A_E, 1);
        check("v11: out_AB1", out_AB1, 0);
        check("v11: out_AD1", out_AD1, 1);
        check("v11: out_AG3", out_AG3, 0);
        // vector 12: B=8 C=9 E=2 F=2 H=11 I=12 K=13 L=15 N=9 O=1 Q=12 R=1 T=4 U=13 W=12 X=11 Z=14 A1=0 A3=4 A4=3 A6=1 A7=4 A9=12 A10=6 A_1=15 A_2=5 A_4=2 A_5=1 AAAAAA1=5 AAAAAA2=15 AAAAAA4=10 AAAAAA5=2 AA_E=1 A_EE=12 ABB2=1 AC1=14 AE2=1 AF3=8 AG2=10 AG1=0
        in_B = 4'd8; in_C = 4'd9; in_E = 4'd2; in_F = 4'd2; in_H = 4'd11; in_I = 4'd12; in_K = 4'd13; in_L = 4'd15; in_N = 4'd9; in_O = 4'd1; in_Q = 4'd12; in_R = 4'd1; in_T = 4'd4; in_U = 4'd13; in_W = 4'd12; in_X = 4'd11; in_Z = 4'd14; in_A1 = 4'd0; in_A3 = 4'd4; in_A4 = 4'd3; in_A6 = 4'd1; in_A7 = 4'd4; in_A9 = 4'd12; in_A10 = 4'd6; in_A_1 = 4'd15; in_A_2 = 4'd5; in_A_4 = 4'd2; in_A_5 = 4'd1; in_AAAAAA1 = 4'd5; in_AAAAAA2 = 4'd15; in_AAAAAA4 = 4'd10; in_AAAAAA5 = 4'd2; in_AA_E = 4'd1; in_A_EE = 4'd12; in_ABB2 = 4'd1; in_AC1 = 4'd14; in_AE2 = 4'd1; in_AF3 = 4'd8; in_AG2 = 4'd10; in_AG1 = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v12: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v12: done after 2 cycles", done, 1);
        check("v12: out_A", out_A, 1);
        check("v12: out_D", out_D, 0);
        check("v12: out_G", out_G, 7);
        check("v12: out_J", out_J, 0);
        check("v12: out_M", out_M, 10);
        check("v12: out_P", out_P, 11);
        check("v12: out_S", out_S, 1);
        check("v12: out_V", out_V, 1);
        check("v12: out_Y", out_Y, 14);
        check("v12: out_A2", out_A2, 1);
        check("v12: out_A5", out_A5, 5);
        check("v12: out_A8", out_A8, 6);
        check("v12: out_A_0", out_A_0, 4);
        check("v12: out_A_3", out_A_3, 1);
        check("v12: out_AAAAAA0", out_AAAAAA0, 4);
        check("v12: out_AAAAAA3", out_AAAAAA3, 8);
        check("v12: out_A_E", out_A_E, 13);
        check("v12: out_AB1", out_AB1, 0);
        check("v12: out_AD1", out_AD1, 9);
        check("v12: out_AG3", out_AG3, 10);
        // vector 13: B=14 C=8 E=11 F=0 H=7 I=12 K=12 L=4 N=2 O=4 Q=13 R=6 T=14 U=14 W=15 X=7 Z=11 A1=3 A3=11 A4=9 A6=8 A7=1 A9=6 A10=9 A_1=4 A_2=4 A_4=6 A_5=10 AAAAAA1=3 AAAAAA2=3 AAAAAA4=4 AAAAAA5=15 AA_E=5 A_EE=5 ABB2=12 AC1=14 AE2=0 AF3=4 AG2=1 AG1=13
        in_B = 4'd14; in_C = 4'd8; in_E = 4'd11; in_F = 4'd0; in_H = 4'd7; in_I = 4'd12; in_K = 4'd12; in_L = 4'd4; in_N = 4'd2; in_O = 4'd4; in_Q = 4'd13; in_R = 4'd6; in_T = 4'd14; in_U = 4'd14; in_W = 4'd15; in_X = 4'd7; in_Z = 4'd11; in_A1 = 4'd3; in_A3 = 4'd11; in_A4 = 4'd9; in_A6 = 4'd8; in_A7 = 4'd1; in_A9 = 4'd6; in_A10 = 4'd9; in_A_1 = 4'd4; in_A_2 = 4'd4; in_A_4 = 4'd6; in_A_5 = 4'd10; in_AAAAAA1 = 4'd3; in_AAAAAA2 = 4'd3; in_AAAAAA4 = 4'd4; in_AAAAAA5 = 4'd15; in_AA_E = 4'd5; in_A_EE = 4'd5; in_ABB2 = 4'd12; in_AC1 = 4'd14; in_AE2 = 4'd0; in_AF3 = 4'd4; in_AG2 = 4'd1; in_AG1 = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v13: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v13: done after 2 cycles", done, 1);
        check("v13: out_A", out_A, 6);
        check("v13: out_D", out_D, 11);
        check("v13: out_G", out_G, 3);
        check("v13: out_J", out_J, 8);
        check("v13: out_M", out_M, 6);
        check("v13: out_P", out_P, 7);
        check("v13: out_S", out_S, 12);
        check("v13: out_V", out_V, 8);
        check("v13: out_Y", out_Y, 14);
        check("v13: out_A2", out_A2, 2);
        check("v13: out_A5", out_A5, 9);
        check("v13: out_A8", out_A8, 0);
        check("v13: out_A_0", out_A_0, 8);
        check("v13: out_A_3", out_A_3, 0);
        check("v13: out_AAAAAA0", out_AAAAAA0, 6);
        check("v13: out_AAAAAA3", out_AAAAAA3, 0);
        check("v13: out_A_E", out_A_E, 10);
        check("v13: out_AB1", out_AB1, 0);
        check("v13: out_AD1", out_AD1, 4);
        check("v13: out_AG3", out_AG3, 0);
        // vector 14: B=5 C=0 E=13 F=4 H=13 I=7 K=2 L=8 N=1 O=2 Q=14 R=5 T=7 U=12 W=1 X=4 Z=9 A1=11 A3=8 A4=1 A6=10 A7=1 A9=3 A10=2 A_1=13 A_2=14 A_4=2 A_5=12 AAAAAA1=2 AAAAAA2=11 AAAAAA4=0 AAAAAA5=5 AA_E=15 A_EE=9 ABB2=4 AC1=14 AE2=3 AF3=1 AG2=1 AG1=11
        in_B = 4'd5; in_C = 4'd0; in_E = 4'd13; in_F = 4'd4; in_H = 4'd13; in_I = 4'd7; in_K = 4'd2; in_L = 4'd8; in_N = 4'd1; in_O = 4'd2; in_Q = 4'd14; in_R = 4'd5; in_T = 4'd7; in_U = 4'd12; in_W = 4'd1; in_X = 4'd4; in_Z = 4'd9; in_A1 = 4'd11; in_A3 = 4'd8; in_A4 = 4'd1; in_A6 = 4'd10; in_A7 = 4'd1; in_A9 = 4'd3; in_A10 = 4'd2; in_A_1 = 4'd13; in_A_2 = 4'd14; in_A_4 = 4'd2; in_A_5 = 4'd12; in_AAAAAA1 = 4'd2; in_AAAAAA2 = 4'd11; in_AAAAAA4 = 4'd0; in_AAAAAA5 = 4'd5; in_AA_E = 4'd15; in_A_EE = 4'd9; in_ABB2 = 4'd4; in_AC1 = 4'd14; in_AE2 = 4'd3; in_AF3 = 4'd1; in_AG2 = 4'd1; in_AG1 = 4'd11;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v14: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v14: done after 2 cycles", done, 1);
        check("v14: out_A", out_A, 5);
        check("v14: out_D", out_D, 9);
        check("v14: out_G", out_G, 4);
        check("v14: out_J", out_J, 0);
        check("v14: out_M", out_M, 3);
        check("v14: out_P", out_P, 9);
        check("v14: out_S", out_S, 3);
        check("v14: out_V", out_V, 0);
        check("v14: out_Y", out_Y, 4);
        check("v14: out_A2", out_A2, 7);
        check("v14: out_A5", out_A5, 11);
        check("v14: out_A8", out_A8, 1);
        check("v14: out_A_0", out_A_0, 11);
        check("v14: out_A_3", out_A_3, 0);
        check("v14: out_AAAAAA0", out_AAAAAA0, 13);
        check("v14: out_AAAAAA3", out_AAAAAA3, 0);
        check("v14: out_A_E", out_A_E, 8);
        check("v14: out_AB1", out_AB1, 0);
        check("v14: out_AD1", out_AD1, 4);
        check("v14: out_AG3", out_AG3, 0);
        // vector 15: B=15 C=5 E=2 F=2 H=13 I=3 K=8 L=4 N=4 O=3 Q=13 R=10 T=4 U=10 W=6 X=10 Z=5 A1=11 A3=13 A4=9 A6=15 A7=2 A9=1 A10=8 A_1=3 A_2=1 A_4=15 A_5=5 AAAAAA1=9 AAAAAA2=15 AAAAAA4=11 AAAAAA5=10 AA_E=4 A_EE=0 ABB2=7 AC1=9 AE2=10 AF3=6 AG2=6 AG1=3
        in_B = 4'd15; in_C = 4'd5; in_E = 4'd2; in_F = 4'd2; in_H = 4'd13; in_I = 4'd3; in_K = 4'd8; in_L = 4'd4; in_N = 4'd4; in_O = 4'd3; in_Q = 4'd13; in_R = 4'd10; in_T = 4'd4; in_U = 4'd10; in_W = 4'd6; in_X = 4'd10; in_Z = 4'd5; in_A1 = 4'd11; in_A3 = 4'd13; in_A4 = 4'd9; in_A6 = 4'd15; in_A7 = 4'd2; in_A9 = 4'd1; in_A10 = 4'd8; in_A_1 = 4'd3; in_A_2 = 4'd1; in_A_4 = 4'd15; in_A_5 = 4'd5; in_AAAAAA1 = 4'd9; in_AAAAAA2 = 4'd15; in_AAAAAA4 = 4'd11; in_AAAAAA5 = 4'd10; in_AA_E = 4'd4; in_A_EE = 4'd0; in_ABB2 = 4'd7; in_AC1 = 4'd9; in_AE2 = 4'd10; in_AF3 = 4'd6; in_AG2 = 4'd6; in_AG1 = 4'd3;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v15: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v15: done after 2 cycles", done, 1);
        check("v15: out_A", out_A, 4);
        check("v15: out_D", out_D, 0);
        check("v15: out_G", out_G, 0);
        check("v15: out_J", out_J, 4);
        check("v15: out_M", out_M, 7);
        check("v15: out_P", out_P, 3);
        check("v15: out_S", out_S, 14);
        check("v15: out_V", out_V, 0);
        check("v15: out_Y", out_Y, 0);
        check("v15: out_A2", out_A2, 4);
        check("v15: out_A5", out_A5, 1);
        check("v15: out_A8", out_A8, 0);
        check("v15: out_A_0", out_A_0, 4);
        check("v15: out_A_3", out_A_3, 10);
        check("v15: out_AAAAAA0", out_AAAAAA0, 8);
        check("v15: out_AAAAAA3", out_AAAAAA3, 1);
        check("v15: out_A_E", out_A_E, 4);
        check("v15: out_AB1", out_AB1, 0);
        check("v15: out_AD1", out_AD1, 0);
        check("v15: out_AG3", out_AG3, 3);
        // vector 16: B=3 C=10 E=2 F=12 H=4 I=5 K=11 L=11 N=2 O=12 Q=14 R=4 T=12 U=1 W=2 X=0 Z=2 A1=9 A3=14 A4=6 A6=10 A7=14 A9=11 A10=7 A_1=10 A_2=10 A_4=1 A_5=15 AAAAAA1=3 AAAAAA2=7 AAAAAA4=14 AAAAAA5=12 AA_E=0 A_EE=6 ABB2=14 AC1=9 AE2=7 AF3=3 AG2=13 AG1=1
        in_B = 4'd3; in_C = 4'd10; in_E = 4'd2; in_F = 4'd12; in_H = 4'd4; in_I = 4'd5; in_K = 4'd11; in_L = 4'd11; in_N = 4'd2; in_O = 4'd12; in_Q = 4'd14; in_R = 4'd4; in_T = 4'd12; in_U = 4'd1; in_W = 4'd2; in_X = 4'd0; in_Z = 4'd2; in_A1 = 4'd9; in_A3 = 4'd14; in_A4 = 4'd6; in_A6 = 4'd10; in_A7 = 4'd14; in_A9 = 4'd11; in_A10 = 4'd7; in_A_1 = 4'd10; in_A_2 = 4'd10; in_A_4 = 4'd1; in_A_5 = 4'd15; in_AAAAAA1 = 4'd3; in_AAAAAA2 = 4'd7; in_AAAAAA4 = 4'd14; in_AAAAAA5 = 4'd12; in_AA_E = 4'd0; in_A_EE = 4'd6; in_ABB2 = 4'd14; in_AC1 = 4'd9; in_AE2 = 4'd7; in_AF3 = 4'd3; in_AG2 = 4'd13; in_AG1 = 4'd1;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v16: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v16: done after 2 cycles", done, 1);
        check("v16: out_A", out_A, 13);
        check("v16: out_D", out_D, 0);
        check("v16: out_G", out_G, 9);
        check("v16: out_J", out_J, 0);
        check("v16: out_M", out_M, 14);
        check("v16: out_P", out_P, 10);
        check("v16: out_S", out_S, 13);
        check("v16: out_V", out_V, 2);
        check("v16: out_Y", out_Y, 11);
        check("v16: out_A2", out_A2, 8);
        check("v16: out_A5", out_A5, 8);
        check("v16: out_A8", out_A8, 4);
        check("v16: out_A_0", out_A_0, 4);
        check("v16: out_A_3", out_A_3, 0);
        check("v16: out_AAAAAA0", out_AAAAAA0, 10);
        check("v16: out_AAAAAA3", out_AAAAAA3, 2);
        check("v16: out_A_E", out_A_E, 6);
        check("v16: out_AB1", out_AB1, 5);
        check("v16: out_AD1", out_AD1, 10);
        check("v16: out_AG3", out_AG3, 12);
        // vector 17: B=13 C=8 E=4 F=1 H=10 I=13 K=4 L=3 N=4 O=2 Q=11 R=2 T=11 U=7 W=14 X=3 Z=8 A1=3 A3=10 A4=1 A6=6 A7=14 A9=9 A10=14 A_1=13 A_2=14 A_4=9 A_5=7 AAAAAA1=10 AAAAAA2=11 AAAAAA4=0 AAAAAA5=5 AA_E=7 A_EE=1 ABB2=6 AC1=1 AE2=9 AF3=10 AG2=15 AG1=13
        in_B = 4'd13; in_C = 4'd8; in_E = 4'd4; in_F = 4'd1; in_H = 4'd10; in_I = 4'd13; in_K = 4'd4; in_L = 4'd3; in_N = 4'd4; in_O = 4'd2; in_Q = 4'd11; in_R = 4'd2; in_T = 4'd11; in_U = 4'd7; in_W = 4'd14; in_X = 4'd3; in_Z = 4'd8; in_A1 = 4'd3; in_A3 = 4'd10; in_A4 = 4'd1; in_A6 = 4'd6; in_A7 = 4'd14; in_A9 = 4'd9; in_A10 = 4'd14; in_A_1 = 4'd13; in_A_2 = 4'd14; in_A_4 = 4'd9; in_A_5 = 4'd7; in_AAAAAA1 = 4'd10; in_AAAAAA2 = 4'd11; in_AAAAAA4 = 4'd0; in_AAAAAA5 = 4'd5; in_AA_E = 4'd7; in_A_EE = 4'd1; in_ABB2 = 4'd6; in_AC1 = 4'd1; in_AE2 = 4'd9; in_AF3 = 4'd10; in_AG2 = 4'd15; in_AG1 = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v17: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v17: done after 2 cycles", done, 1);
        check("v17: out_A", out_A, 5);
        check("v17: out_D", out_D, 3);
        check("v17: out_G", out_G, 7);
        check("v17: out_J", out_J, 1);
        check("v17: out_M", out_M, 6);
        check("v17: out_P", out_P, 9);
        check("v17: out_S", out_S, 2);
        check("v17: out_V", out_V, 11);
        check("v17: out_Y", out_Y, 11);
        check("v17: out_A2", out_A2, 9);
        check("v17: out_A5", out_A5, 4);
        check("v17: out_A8", out_A8, 0);
        check("v17: out_A_0", out_A_0, 11);
        check("v17: out_A_3", out_A_3, 2);
        check("v17: out_AAAAAA0", out_AAAAAA0, 5);
        check("v17: out_AAAAAA3", out_AAAAAA3, 0);
        check("v17: out_A_E", out_A_E, 8);
        check("v17: out_AB1", out_AB1, 5);
        check("v17: out_AD1", out_AD1, 3);
        check("v17: out_AG3", out_AG3, 2);
        // vector 18: B=15 C=1 E=10 F=14 H=7 I=8 K=15 L=15 N=1 O=13 Q=1 R=8 T=10 U=1 W=8 X=4 Z=10 A1=2 A3=0 A4=7 A6=1 A7=5 A9=7 A10=8 A_1=11 A_2=2 A_4=8 A_5=15 AAAAAA1=10 AAAAAA2=1 AAAAAA4=1 AAAAAA5=15 AA_E=6 A_EE=12 ABB2=3 AC1=1 AE2=0 AF3=11 AG2=3 AG1=12
        in_B = 4'd15; in_C = 4'd1; in_E = 4'd10; in_F = 4'd14; in_H = 4'd7; in_I = 4'd8; in_K = 4'd15; in_L = 4'd15; in_N = 4'd1; in_O = 4'd13; in_Q = 4'd1; in_R = 4'd8; in_T = 4'd10; in_U = 4'd1; in_W = 4'd8; in_X = 4'd4; in_Z = 4'd10; in_A1 = 4'd2; in_A3 = 4'd0; in_A4 = 4'd7; in_A6 = 4'd1; in_A7 = 4'd5; in_A9 = 4'd7; in_A10 = 4'd8; in_A_1 = 4'd11; in_A_2 = 4'd2; in_A_4 = 4'd8; in_A_5 = 4'd15; in_AAAAAA1 = 4'd10; in_AAAAAA2 = 4'd1; in_AAAAAA4 = 4'd1; in_AAAAAA5 = 4'd15; in_AA_E = 4'd6; in_A_EE = 4'd12; in_ABB2 = 4'd3; in_AC1 = 4'd1; in_AE2 = 4'd0; in_AF3 = 4'd11; in_AG2 = 4'd3; in_AG1 = 4'd12;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v18: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v18: done after 2 cycles", done, 1);
        check("v18: out_A", out_A, 0);
        check("v18: out_D", out_D, 0);
        check("v18: out_G", out_G, 15);
        check("v18: out_J", out_J, 0);
        check("v18: out_M", out_M, 14);
        check("v18: out_P", out_P, 0);
        check("v18: out_S", out_S, 11);
        check("v18: out_V", out_V, 4);
        check("v18: out_Y", out_Y, 12);
        check("v18: out_A2", out_A2, 0);
        check("v18: out_A5", out_A5, 6);
        check("v18: out_A8", out_A8, 0);
        check("v18: out_A_0", out_A_0, 13);
        check("v18: out_A_3", out_A_3, 0);
        check("v18: out_AAAAAA0", out_AAAAAA0, 11);
        check("v18: out_AAAAAA3", out_AAAAAA3, 0);
        check("v18: out_A_E", out_A_E, 2);
        check("v18: out_AB1", out_AB1, 2);
        check("v18: out_AD1", out_AD1, 11);
        check("v18: out_AG3", out_AG3, 0);
        // vector 19: B=15 C=6 E=14 F=15 H=8 I=1 K=1 L=6 N=0 O=0 Q=14 R=9 T=0 U=9 W=3 X=3 Z=8 A1=12 A3=0 A4=12 A6=9 A7=14 A9=10 A10=0 A_1=7 A_2=12 A_4=0 A_5=11 AAAAAA1=9 AAAAAA2=8 AAAAAA4=6 AAAAAA5=13 AA_E=3 A_EE=11 ABB2=7 AC1=0 AE2=8 AF3=10 AG2=7 AG1=12
        in_B = 4'd15; in_C = 4'd6; in_E = 4'd14; in_F = 4'd15; in_H = 4'd8; in_I = 4'd1; in_K = 4'd1; in_L = 4'd6; in_N = 4'd0; in_O = 4'd0; in_Q = 4'd14; in_R = 4'd9; in_T = 4'd0; in_U = 4'd9; in_W = 4'd3; in_X = 4'd3; in_Z = 4'd8; in_A1 = 4'd12; in_A3 = 4'd0; in_A4 = 4'd12; in_A6 = 4'd9; in_A7 = 4'd14; in_A9 = 4'd10; in_A10 = 4'd0; in_A_1 = 4'd7; in_A_2 = 4'd12; in_A_4 = 4'd0; in_A_5 = 4'd11; in_AAAAAA1 = 4'd9; in_AAAAAA2 = 4'd8; in_AAAAAA4 = 4'd6; in_AAAAAA5 = 4'd13; in_AA_E = 4'd3; in_A_EE = 4'd11; in_ABB2 = 4'd7; in_AC1 = 4'd0; in_AE2 = 4'd8; in_AF3 = 4'd10; in_AG2 = 4'd7; in_AG1 = 4'd12;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v19: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v19: done after 2 cycles", done, 1);
        check("v19: out_A", out_A, 5);
        check("v19: out_D", out_D, 0);
        check("v19: out_G", out_G, 9);
        check("v19: out_J", out_J, 0);
        check("v19: out_M", out_M, 0);
        check("v19: out_P", out_P, 5);
        check("v19: out_S", out_S, 9);
        check("v19: out_V", out_V, 0);
        check("v19: out_Y", out_Y, 4);
        check("v19: out_A2", out_A2, 0);
        check("v19: out_A5", out_A5, 7);
        check("v19: out_A8", out_A8, 10);
        check("v19: out_A_0", out_A_0, 3);
        check("v19: out_A_3", out_A_3, 0);
        check("v19: out_AAAAAA0", out_AAAAAA0, 1);
        check("v19: out_AAAAAA3", out_AAAAAA3, 0);
        check("v19: out_A_E", out_A_E, 14);
        check("v19: out_AB1", out_AB1, 7);
        check("v19: out_AD1", out_AD1, 2);
        check("v19: out_AG3", out_AG3, 0);

        // ---- hls_top: B=3 C=2 E=1 F=1 H=1 I=1 K=1 L=1 N=1 O=1 Q=1 R=1 T=1 U=1 W=1 X=1 Z=1 A1=1 A3=1 A4=1 A6=1 A7=1 A9=1 A10=1 A_1=1 A_2=1 A_4=1 A_5=1 AAAAAA1=1 AAAAAA2=1 AAAAAA4=1 AAAAAA5=1 AA_E=1 A_EE=1 ABB2=1 AC1=1 AE2=1 AF3=1 AG2=1 AG1=1
        sw[3:0] = 4'd3;
        sw[7:4] = 4'd2;
        sw[11:8] = 4'd1;
        repeat (4) @(posedge clk); #1 t_rst = 1'b0;
        repeat (4) @(posedge clk); #1;
        check("top: state after reset", t_state, 0);
        repeat (30) @(posedge clk); #1;
        check("top: state holds without a press", t_state, 0);
        press;
        check("top: state after press 1", t_state, 1);
        sw[15:12] = 4'd0; #1;
        check("top: S1 fu_add0_y (A_0)", obs_val, 5);
        sw[15:12] = 4'd10; #1;
        check("top: S1 fu_sub0_y (D_0)", obs_val, 0);
        sw[15:12] = 4'd1; #1;
        check("top: S1 fu_add1_y (G_0)", obs_val, 2);
        sw[15:12] = 4'd11; #1;
        check("top: S1 fu_sub1_y (J_0)", obs_val, 0);
        sw[15:12] = 4'd2; #1;
        check("top: S1 fu_add2_y (M_0)", obs_val, 2);
        sw[15:12] = 4'd12; #1;
        check("top: S1 fu_sub2_y (P_0)", obs_val, 0);
        sw[15:12] = 4'd3; #1;
        check("top: S1 fu_add3_y (S_0)", obs_val, 2);
        sw[15:12] = 4'd13; #1;
        check("top: S1 fu_sub3_y (V_0)", obs_val, 0);
        sw[15:12] = 4'd4; #1;
        check("top: S1 fu_add4_y (Y_0)", obs_val, 2);
        sw[15:12] = 4'd14; #1;
        check("top: S1 fu_sub4_y (A2_0)", obs_val, 0);
        sw[15:12] = 4'd5; #1;
        check("top: S1 fu_add5_y (A5_0)", obs_val, 2);
        sw[15:12] = 4'd15; #1;
        check("top: S1 fu_sub5_y (A8_0)", obs_val, 0);
        sw[15:12] = 4'd6; #1;
        check("top: S1 fu_add6_y (A_0_0)", obs_val, 2);
        sw[15:12] = 4'd7; #1;
        check("top: S1 fu_add7_y (AAAAAA0_0)", obs_val, 2);
        sw[15:12] = 4'd8; #1;
        check("top: S1 fu_add8_y (A_E_0)", obs_val, 2);
        sw[15:12] = 4'd9; #1;
        check("top: S1 fu_add9_y (AD1_0)", obs_val, 2);
        press;
        check("top: state after press 2", t_state, 2);
        check("top: done", t_done, 1);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d FAILURES", errors);
        $finish;
    end
endmodule
