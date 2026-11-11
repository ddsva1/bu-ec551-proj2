// Self-checking testbench, generated together with hls_core.v / hls_top.v.
//   part 1: hls_core with en=1, one run per input vector, every output checked
//   part 2: hls_top stepped with the button; state advance and the
//           observability mux are checked
module testbench;
    localparam W = 4;
    localparam LATENCY = 5;
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
    wire [W-1:0] out_B;
    wire [W-1:0] out_C;
    wire [W-1:0] out_A;
    wire [W-1:0] out_D;
    wire [2:0] state;
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
        .out_B(out_B),
        .out_C(out_C),
        .out_A(out_A),
        .out_D(out_D),
        .fu_add0_y(),
        .fu_sub0_y(),
        .fu_mul0_y(),
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
        // vector 0: B=0 C=0 E=0 F=0
        in_B = 4'd0; in_C = 4'd0; in_E = 4'd0; in_F = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v0: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v0: done after 6 cycles", done, 1);
        check("v0: out_B", out_B, 0);
        check("v0: out_C", out_C, 0);
        check("v0: out_A", out_A, 0);
        check("v0: out_D", out_D, 0);
        // vector 1: B=15 C=15 E=15 F=15
        in_B = 4'd15; in_C = 4'd15; in_E = 4'd15; in_F = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v1: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v1: done after 6 cycles", done, 1);
        check("v1: out_B", out_B, 15);
        check("v1: out_C", out_C, 0);
        check("v1: out_A", out_A, 0);
        check("v1: out_D", out_D, 14);
        // vector 2: B=1 C=2 E=3 F=4
        in_B = 4'd1; in_C = 4'd2; in_E = 4'd3; in_F = 4'd4;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v2: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v2: done after 6 cycles", done, 1);
        check("v2: out_B", out_B, 1);
        check("v2: out_C", out_C, 0);
        check("v2: out_A", out_A, 0);
        check("v2: out_D", out_D, 7);
        // vector 3: B=7 C=0 E=6 F=7
        in_B = 4'd7; in_C = 4'd0; in_E = 4'd6; in_F = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v3: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v3: done after 6 cycles", done, 1);
        check("v3: out_B", out_B, 14);
        check("v3: out_C", out_C, 2);
        check("v3: out_A", out_A, 0);
        check("v3: out_D", out_D, 13);
        // vector 4: B=11 C=13 E=12 F=0
        in_B = 4'd11; in_C = 4'd13; in_E = 4'd12; in_F = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v4: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v4: done after 6 cycles", done, 1);
        check("v4: out_B", out_B, 11);
        check("v4: out_C", out_C, 0);
        check("v4: out_A", out_A, 0);
        check("v4: out_D", out_D, 12);
        // vector 5: B=5 C=8 E=10 F=2
        in_B = 4'd5; in_C = 4'd8; in_E = 4'd10; in_F = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v5: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v5: done after 6 cycles", done, 1);
        check("v5: out_B", out_B, 5);
        check("v5: out_C", out_C, 0);
        check("v5: out_A", out_A, 0);
        check("v5: out_D", out_D, 12);
        // vector 6: B=13 C=0 E=15 F=5
        in_B = 4'd13; in_C = 4'd0; in_E = 4'd15; in_F = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v6: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v6: done after 6 cycles", done, 1);
        check("v6: out_B", out_B, 10);
        check("v6: out_C", out_C, 2);
        check("v6: out_A", out_A, 0);
        check("v6: out_D", out_D, 4);
        // vector 7: B=1 C=9 E=9 F=14
        in_B = 4'd1; in_C = 4'd9; in_E = 4'd9; in_F = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v7: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v7: done after 6 cycles", done, 1);
        check("v7: out_B", out_B, 1);
        check("v7: out_C", out_C, 0);
        check("v7: out_A", out_A, 0);
        check("v7: out_D", out_D, 7);
        // vector 8: B=12 C=15 E=13 F=7
        in_B = 4'd12; in_C = 4'd15; in_E = 4'd13; in_F = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v8: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v8: done after 6 cycles", done, 1);
        check("v8: out_B", out_B, 12);
        check("v8: out_C", out_C, 0);
        check("v8: out_A", out_A, 0);
        check("v8: out_D", out_D, 4);
        // vector 9: B=2 C=13 E=8 F=11
        in_B = 4'd2; in_C = 4'd13; in_E = 4'd8; in_F = 4'd11;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v9: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v9: done after 6 cycles", done, 1);
        check("v9: out_B", out_B, 2);
        check("v9: out_C", out_C, 0);
        check("v9: out_A", out_A, 0);
        check("v9: out_D", out_D, 3);
        // vector 10: B=3 C=14 E=3 F=10
        in_B = 4'd3; in_C = 4'd14; in_E = 4'd3; in_F = 4'd10;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v10: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v10: done after 6 cycles", done, 1);
        check("v10: out_B", out_B, 3);
        check("v10: out_C", out_C, 0);
        check("v10: out_A", out_A, 0);
        check("v10: out_D", out_D, 13);
        // vector 11: B=0 C=7 E=0 F=1
        in_B = 4'd0; in_C = 4'd7; in_E = 4'd0; in_F = 4'd1;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v11: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v11: done after 6 cycles", done, 1);
        check("v11: out_B", out_B, 0);
        check("v11: out_C", out_C, 0);
        check("v11: out_A", out_A, 0);
        check("v11: out_D", out_D, 1);
        // vector 12: B=11 C=3 E=8 F=5
        in_B = 4'd11; in_C = 4'd3; in_E = 4'd8; in_F = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v12: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v12: done after 6 cycles", done, 1);
        check("v12: out_B", out_B, 3);
        check("v12: out_C", out_C, 8);
        check("v12: out_A", out_A, 10);
        check("v12: out_D", out_D, 13);
        // vector 13: B=1 C=12 E=15 F=7
        in_B = 4'd1; in_C = 4'd12; in_E = 4'd15; in_F = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v13: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v13: done after 6 cycles", done, 1);
        check("v13: out_B", out_B, 1);
        check("v13: out_C", out_C, 0);
        check("v13: out_A", out_A, 0);
        check("v13: out_D", out_D, 6);
        // vector 14: B=10 C=10 E=0 F=4
        in_B = 4'd10; in_C = 4'd10; in_E = 4'd0; in_F = 4'd4;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v14: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v14: done after 6 cycles", done, 1);
        check("v14: out_B", out_B, 10);
        check("v14: out_C", out_C, 0);
        check("v14: out_A", out_A, 0);
        check("v14: out_D", out_D, 4);
        // vector 15: B=2 C=13 E=6 F=2
        in_B = 4'd2; in_C = 4'd13; in_E = 4'd6; in_F = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v15: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v15: done after 6 cycles", done, 1);
        check("v15: out_B", out_B, 2);
        check("v15: out_C", out_C, 0);
        check("v15: out_A", out_A, 0);
        check("v15: out_D", out_D, 8);
        // vector 16: B=3 C=9 E=4 F=10
        in_B = 4'd3; in_C = 4'd9; in_E = 4'd4; in_F = 4'd10;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v16: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v16: done after 6 cycles", done, 1);
        check("v16: out_B", out_B, 3);
        check("v16: out_C", out_C, 0);
        check("v16: out_A", out_A, 0);
        check("v16: out_D", out_D, 14);
        // vector 17: B=0 C=8 E=12 F=0
        in_B = 4'd0; in_C = 4'd8; in_E = 4'd12; in_F = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v17: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v17: done after 6 cycles", done, 1);
        check("v17: out_B", out_B, 0);
        check("v17: out_C", out_C, 0);
        check("v17: out_A", out_A, 0);
        check("v17: out_D", out_D, 12);
        // vector 18: B=1 C=2 E=13 F=8
        in_B = 4'd1; in_C = 4'd2; in_E = 4'd13; in_F = 4'd8;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v18: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v18: done after 6 cycles", done, 1);
        check("v18: out_B", out_B, 1);
        check("v18: out_C", out_C, 0);
        check("v18: out_A", out_A, 0);
        check("v18: out_D", out_D, 5);
        // vector 19: B=13 C=12 E=2 F=7
        in_B = 4'd13; in_C = 4'd12; in_E = 4'd2; in_F = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (4) @(posedge clk); #1;
        check("v19: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v19: done after 6 cycles", done, 1);
        check("v19: out_B", out_B, 14);
        check("v19: out_C", out_C, 14);
        check("v19: out_A", out_A, 0);
        check("v19: out_D", out_D, 9);

        // ---- hls_top: B=3 C=2 E=1 F=1
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
        sw[15:12] = 4'd1; #1;
        check("top: S1 fu_sub0_y (A_0)", obs_val, 1);
        sw[15:12] = 4'd0; #1;
        check("top: S1 fu_add0_y (D_0)", obs_val, 2);
        press;
        check("top: state after press 2", t_state, 2);
        sw[15:12] = 4'd0; #1;
        check("top: S2 fu_add0_y (B_1)", obs_val, 4);
        press;
        check("top: state after press 3", t_state, 3);
        sw[15:12] = 4'd2; #1;
        check("top: S3 fu_mul0_y (C_1)", obs_val, 4);
        press;
        check("top: state after press 4", t_state, 4);
        sw[15:12] = 4'd1; #1;
        check("top: S4 fu_sub0_y (A_1)", obs_val, 0);
        press;
        check("top: state after press 5", t_state, 5);
        sw[15:12] = 4'd0; #1;
        check("top: S5 fu_add0_y (A_2)", obs_val, 0);
        press;
        check("top: state after press 6", t_state, 6);
        check("top: done", t_done, 1);
        sw[15:12] = 4'd3; #1;
        check("top: observe out_B", obs_val, 4);
        sw[15:12] = 4'd4; #1;
        check("top: observe out_C", obs_val, 4);
        sw[15:12] = 4'd5; #1;
        check("top: observe out_A", obs_val, 0);
        sw[15:12] = 4'd6; #1;
        check("top: observe out_D", obs_val, 2);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d FAILURES", errors);
        $finish;
    end
endmodule
