// Self-checking testbench, generated together with hls_core.v / hls_top.v.
//   part 1: hls_core with en=1, one run per input vector, every output checked
//   part 2: hls_top stepped with the button; state advance and the
//           observability mux are checked
module testbench;
    localparam W = 4;
    localparam LATENCY = 3;
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
    reg  [W-1:0] in_A = 0;
    reg  [W-1:0] in_B = 0;
    wire [W-1:0] out_X;
    wire [W-1:0] out_Y;
    wire [W-1:0] out_Z;
    wire [W-1:0] out_Q;
    wire [2:0] state;
    wire done;
    hls_core dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .in_A(in_A),
        .in_B(in_B),
        .out_X(out_X),
        .out_Y(out_Y),
        .out_Z(out_Z),
        .out_Q(out_Q),
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
        // vector 0: A=0 B=0
        in_A = 4'd0; in_B = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v0: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v0: done after 4 cycles", done, 1);
        check("v0: out_X", out_X, 0);
        check("v0: out_Y", out_Y, 0);
        check("v0: out_Z", out_Z, 0);
        check("v0: out_Q", out_Q, 0);
        // vector 1: A=15 B=15
        in_A = 4'd15; in_B = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v1: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v1: done after 4 cycles", done, 1);
        check("v1: out_X", out_X, 14);
        check("v1: out_Y", out_Y, 13);
        check("v1: out_Z", out_Z, 0);
        check("v1: out_Q", out_Q, 0);
        // vector 2: A=1 B=2
        in_A = 4'd1; in_B = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v2: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v2: done after 4 cycles", done, 1);
        check("v2: out_X", out_X, 3);
        check("v2: out_Y", out_Y, 4);
        check("v2: out_Z", out_Z, 1);
        check("v2: out_Q", out_Q, 2);
        // vector 3: A=7 B=0
        in_A = 4'd7; in_B = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v3: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v3: done after 4 cycles", done, 1);
        check("v3: out_X", out_X, 7);
        check("v3: out_Y", out_Y, 14);
        check("v3: out_Z", out_Z, 7);
        check("v3: out_Q", out_Q, 0);
        // vector 4: A=6 B=7
        in_A = 4'd6; in_B = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v4: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v4: done after 4 cycles", done, 1);
        check("v4: out_X", out_X, 13);
        check("v4: out_Y", out_Y, 3);
        check("v4: out_Z", out_Z, 6);
        check("v4: out_Q", out_Q, 10);
        // vector 5: A=11 B=13
        in_A = 4'd11; in_B = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v5: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v5: done after 4 cycles", done, 1);
        check("v5: out_X", out_X, 8);
        check("v5: out_Y", out_Y, 3);
        check("v5: out_Z", out_Z, 0);
        check("v5: out_Q", out_Q, 0);
        // vector 6: A=12 B=0
        in_A = 4'd12; in_B = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v6: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v6: done after 4 cycles", done, 1);
        check("v6: out_X", out_X, 12);
        check("v6: out_Y", out_Y, 8);
        check("v6: out_Z", out_Z, 12);
        check("v6: out_Q", out_Q, 0);
        // vector 7: A=5 B=8
        in_A = 4'd5; in_B = 4'd8;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v7: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v7: done after 4 cycles", done, 1);
        check("v7: out_X", out_X, 13);
        check("v7: out_Y", out_Y, 2);
        check("v7: out_Z", out_Z, 5);
        check("v7: out_Q", out_Q, 8);
        // vector 8: A=10 B=2
        in_A = 4'd10; in_B = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v8: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v8: done after 4 cycles", done, 1);
        check("v8: out_X", out_X, 12);
        check("v8: out_Y", out_Y, 6);
        check("v8: out_Z", out_Z, 10);
        check("v8: out_Q", out_Q, 4);
        // vector 9: A=13 B=0
        in_A = 4'd13; in_B = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v9: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v9: done after 4 cycles", done, 1);
        check("v9: out_X", out_X, 13);
        check("v9: out_Y", out_Y, 10);
        check("v9: out_Z", out_Z, 13);
        check("v9: out_Q", out_Q, 0);
        // vector 10: A=15 B=5
        in_A = 4'd15; in_B = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v10: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v10: done after 4 cycles", done, 1);
        check("v10: out_X", out_X, 4);
        check("v10: out_Y", out_Y, 3);
        check("v10: out_Z", out_Z, 0);
        check("v10: out_Q", out_Q, 0);
        // vector 11: A=1 B=9
        in_A = 4'd1; in_B = 4'd9;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v11: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v11: done after 4 cycles", done, 1);
        check("v11: out_X", out_X, 10);
        check("v11: out_Y", out_Y, 11);
        check("v11: out_Z", out_Z, 1);
        check("v11: out_Q", out_Q, 9);
        // vector 12: A=9 B=14
        in_A = 4'd9; in_B = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v12: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v12: done after 4 cycles", done, 1);
        check("v12: out_X", out_X, 7);
        check("v12: out_Y", out_Y, 0);
        check("v12: out_Z", out_Z, 0);
        check("v12: out_Q", out_Q, 0);
        // vector 13: A=12 B=15
        in_A = 4'd12; in_B = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v13: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v13: done after 4 cycles", done, 1);
        check("v13: out_X", out_X, 11);
        check("v13: out_Y", out_Y, 7);
        check("v13: out_Z", out_Z, 0);
        check("v13: out_Q", out_Q, 0);
        // vector 14: A=13 B=7
        in_A = 4'd13; in_B = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v14: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v14: done after 4 cycles", done, 1);
        check("v14: out_X", out_X, 4);
        check("v14: out_Y", out_Y, 1);
        check("v14: out_Z", out_Z, 0);
        check("v14: out_Q", out_Q, 0);
        // vector 15: A=2 B=13
        in_A = 4'd2; in_B = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v15: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v15: done after 4 cycles", done, 1);
        check("v15: out_X", out_X, 15);
        check("v15: out_Y", out_Y, 1);
        check("v15: out_Z", out_Z, 2);
        check("v15: out_Q", out_Q, 10);
        // vector 16: A=8 B=11
        in_A = 4'd8; in_B = 4'd11;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v16: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v16: done after 4 cycles", done, 1);
        check("v16: out_X", out_X, 3);
        check("v16: out_Y", out_Y, 11);
        check("v16: out_Z", out_Z, 0);
        check("v16: out_Q", out_Q, 0);
        // vector 17: A=3 B=14
        in_A = 4'd3; in_B = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v17: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v17: done after 4 cycles", done, 1);
        check("v17: out_X", out_X, 1);
        check("v17: out_Y", out_Y, 4);
        check("v17: out_Z", out_Z, 0);
        check("v17: out_Q", out_Q, 0);
        // vector 18: A=3 B=10
        in_A = 4'd3; in_B = 4'd10;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v18: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v18: done after 4 cycles", done, 1);
        check("v18: out_X", out_X, 13);
        check("v18: out_Y", out_Y, 0);
        check("v18: out_Z", out_Z, 3);
        check("v18: out_Q", out_Q, 14);
        // vector 19: A=0 B=7
        in_A = 4'd0; in_B = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (2) @(posedge clk); #1;
        check("v19: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v19: done after 4 cycles", done, 1);
        check("v19: out_X", out_X, 7);
        check("v19: out_Y", out_Y, 7);
        check("v19: out_Z", out_Z, 0);
        check("v19: out_Q", out_Q, 0);

        // ---- hls_top: A=3 B=2
        sw[3:0] = 4'd3;
        sw[7:4] = 4'd2;
        repeat (4) @(posedge clk); #1 t_rst = 1'b0;
        repeat (4) @(posedge clk); #1;
        check("top: state after reset", t_state, 0);
        repeat (30) @(posedge clk); #1;
        check("top: state holds without a press", t_state, 0);
        press;
        check("top: state after press 1", t_state, 1);
        sw[15:12] = 4'd0; #1;
        check("top: S1 fu_add0_y (X_0)", obs_val, 5);
        press;
        check("top: state after press 2", t_state, 2);
        sw[15:12] = 4'd0; #1;
        check("top: S2 fu_add0_y (Y_0)", obs_val, 8);
        sw[15:12] = 4'd1; #1;
        check("top: S2 fu_sub0_y (Z_0)", obs_val, 3);
        press;
        check("top: state after press 3", t_state, 3);
        sw[15:12] = 4'd2; #1;
        check("top: S3 fu_mul0_y (Q_0)", obs_val, 6);
        press;
        check("top: state after press 4", t_state, 4);
        check("top: done", t_done, 1);
        sw[15:12] = 4'd3; #1;
        check("top: observe out_X", obs_val, 5);
        sw[15:12] = 4'd4; #1;
        check("top: observe out_Y", obs_val, 8);
        sw[15:12] = 4'd5; #1;
        check("top: observe out_Z", obs_val, 3);
        sw[15:12] = 4'd6; #1;
        check("top: observe out_Q", obs_val, 6);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d FAILURES", errors);
        $finish;
    end
endmodule
