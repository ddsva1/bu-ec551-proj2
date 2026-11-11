// Self-checking testbench, generated together with hls_core.v / hls_top.v.
//   part 1: hls_core with en=1, one run per input vector, every output checked
//   part 2: hls_top stepped with the button; state advance and the
//           observability mux are checked
module testbench;
    localparam W = 4;
    localparam LATENCY = 20;
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
    wire [W-1:0] out_A;
    wire [4:0] state;
    wire done;
    hls_core dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .in_A(in_A),
        .out_A(out_A),
        .fu_add0_y(),
        .fu_sub0_y(),
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
        // vector 0: A=0
        in_A = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v0: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v0: done after 21 cycles", done, 1);
        check("v0: out_A", out_A, 0);
        // vector 1: A=15
        in_A = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v1: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v1: done after 21 cycles", done, 1);
        check("v1: out_A", out_A, 0);
        // vector 2: A=1
        in_A = 4'd1;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v2: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v2: done after 21 cycles", done, 1);
        check("v2: out_A", out_A, 0);
        // vector 3: A=7
        in_A = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v3: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v3: done after 21 cycles", done, 1);
        check("v3: out_A", out_A, 0);
        // vector 4: A=0
        in_A = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v4: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v4: done after 21 cycles", done, 1);
        check("v4: out_A", out_A, 0);
        // vector 5: A=6
        in_A = 4'd6;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v5: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v5: done after 21 cycles", done, 1);
        check("v5: out_A", out_A, 0);
        // vector 6: A=7
        in_A = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v6: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v6: done after 21 cycles", done, 1);
        check("v6: out_A", out_A, 0);
        // vector 7: A=11
        in_A = 4'd11;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v7: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v7: done after 21 cycles", done, 1);
        check("v7: out_A", out_A, 0);
        // vector 8: A=13
        in_A = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v8: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v8: done after 21 cycles", done, 1);
        check("v8: out_A", out_A, 0);
        // vector 9: A=12
        in_A = 4'd12;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v9: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v9: done after 21 cycles", done, 1);
        check("v9: out_A", out_A, 0);
        // vector 10: A=0
        in_A = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v10: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v10: done after 21 cycles", done, 1);
        check("v10: out_A", out_A, 0);
        // vector 11: A=5
        in_A = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v11: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v11: done after 21 cycles", done, 1);
        check("v11: out_A", out_A, 0);
        // vector 12: A=8
        in_A = 4'd8;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v12: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v12: done after 21 cycles", done, 1);
        check("v12: out_A", out_A, 0);
        // vector 13: A=10
        in_A = 4'd10;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v13: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v13: done after 21 cycles", done, 1);
        check("v13: out_A", out_A, 0);
        // vector 14: A=2
        in_A = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v14: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v14: done after 21 cycles", done, 1);
        check("v14: out_A", out_A, 0);
        // vector 15: A=13
        in_A = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v15: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v15: done after 21 cycles", done, 1);
        check("v15: out_A", out_A, 0);
        // vector 16: A=0
        in_A = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v16: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v16: done after 21 cycles", done, 1);
        check("v16: out_A", out_A, 0);
        // vector 17: A=15
        in_A = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v17: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v17: done after 21 cycles", done, 1);
        check("v17: out_A", out_A, 0);
        // vector 18: A=5
        in_A = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v18: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v18: done after 21 cycles", done, 1);
        check("v18: out_A", out_A, 0);
        // vector 19: A=1
        in_A = 4'd1;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        repeat (19) @(posedge clk); #1;
        check("v19: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v19: done after 21 cycles", done, 1);
        check("v19: out_A", out_A, 0);

        // ---- hls_top: A=3
        sw[3:0] = 4'd3;
        repeat (4) @(posedge clk); #1 t_rst = 1'b0;
        repeat (4) @(posedge clk); #1;
        check("top: state after reset", t_state, 0);
        repeat (30) @(posedge clk); #1;
        check("top: state holds without a press", t_state, 0);
        press;
        check("top: state after press 1", t_state, 1);
        sw[15:12] = 4'd0; #1;
        check("top: S1 fu_add0_y (A_1)", obs_val, 6);
        press;
        check("top: state after press 2", t_state, 2);
        sw[15:12] = 4'd1; #1;
        check("top: S2 fu_sub0_y (A_2)", obs_val, 0);
        press;
        check("top: state after press 3", t_state, 3);
        sw[15:12] = 4'd0; #1;
        check("top: S3 fu_add0_y (A_3)", obs_val, 0);
        press;
        check("top: state after press 4", t_state, 4);
        sw[15:12] = 4'd1; #1;
        check("top: S4 fu_sub0_y (A_4)", obs_val, 0);
        press;
        check("top: state after press 5", t_state, 5);
        sw[15:12] = 4'd0; #1;
        check("top: S5 fu_add0_y (A_5)", obs_val, 0);
        press;
        check("top: state after press 6", t_state, 6);
        sw[15:12] = 4'd1; #1;
        check("top: S6 fu_sub0_y (A_6)", obs_val, 0);
        press;
        check("top: state after press 7", t_state, 7);
        sw[15:12] = 4'd0; #1;
        check("top: S7 fu_add0_y (A_7)", obs_val, 0);
        press;
        check("top: state after press 8", t_state, 8);
        sw[15:12] = 4'd1; #1;
        check("top: S8 fu_sub0_y (A_8)", obs_val, 0);
        press;
        check("top: state after press 9", t_state, 9);
        sw[15:12] = 4'd0; #1;
        check("top: S9 fu_add0_y (A_9)", obs_val, 0);
        press;
        check("top: state after press 10", t_state, 10);
        sw[15:12] = 4'd1; #1;
        check("top: S10 fu_sub0_y (A_10)", obs_val, 0);
        press;
        check("top: state after press 11", t_state, 11);
        sw[15:12] = 4'd0; #1;
        check("top: S11 fu_add0_y (A_11)", obs_val, 0);
        press;
        check("top: state after press 12", t_state, 12);
        sw[15:12] = 4'd1; #1;
        check("top: S12 fu_sub0_y (A_12)", obs_val, 0);
        press;
        check("top: state after press 13", t_state, 13);
        sw[15:12] = 4'd0; #1;
        check("top: S13 fu_add0_y (A_13)", obs_val, 0);
        press;
        check("top: state after press 14", t_state, 14);
        sw[15:12] = 4'd1; #1;
        check("top: S14 fu_sub0_y (A_14)", obs_val, 0);
        press;
        check("top: state after press 15", t_state, 15);
        sw[15:12] = 4'd0; #1;
        check("top: S15 fu_add0_y (A_15)", obs_val, 0);
        press;
        check("top: state after press 16", t_state, 16);
        sw[15:12] = 4'd1; #1;
        check("top: S16 fu_sub0_y (A_16)", obs_val, 0);
        press;
        check("top: state after press 17", t_state, 17);
        sw[15:12] = 4'd0; #1;
        check("top: S17 fu_add0_y (A_17)", obs_val, 0);
        press;
        check("top: state after press 18", t_state, 18);
        sw[15:12] = 4'd1; #1;
        check("top: S18 fu_sub0_y (A_18)", obs_val, 0);
        press;
        check("top: state after press 19", t_state, 19);
        sw[15:12] = 4'd0; #1;
        check("top: S19 fu_add0_y (A_19)", obs_val, 0);
        press;
        check("top: state after press 20", t_state, 20);
        sw[15:12] = 4'd1; #1;
        check("top: S20 fu_sub0_y (A_20)", obs_val, 0);
        press;
        check("top: state after press 21", t_state, 21);
        check("top: done", t_done, 1);
        sw[15:12] = 4'd2; #1;
        check("top: observe out_A", obs_val, 0);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d FAILURES", errors);
        $finish;
    end
endmodule
