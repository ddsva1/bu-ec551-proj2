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
    wire [W-1:0] out_A;
    wire [1:0] state;
    wire done;
    hls_core dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .in_B(in_B),
        .in_C(in_C),
        .out_A(out_A),
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
        // vector 0: B=0 C=0
        in_B = 4'd0; in_C = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v0: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v0: done after 2 cycles", done, 1);
        check("v0: out_A", out_A, 0);
        // vector 1: B=15 C=15
        in_B = 4'd15; in_C = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v1: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v1: done after 2 cycles", done, 1);
        check("v1: out_A", out_A, 0);
        // vector 2: B=1 C=2
        in_B = 4'd1; in_C = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v2: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v2: done after 2 cycles", done, 1);
        check("v2: out_A", out_A, 0);
        // vector 3: B=7 C=0
        in_B = 4'd7; in_C = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v3: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v3: done after 2 cycles", done, 1);
        check("v3: out_A", out_A, 7);
        // vector 4: B=6 C=7
        in_B = 4'd6; in_C = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v4: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v4: done after 2 cycles", done, 1);
        check("v4: out_A", out_A, 0);
        // vector 5: B=11 C=13
        in_B = 4'd11; in_C = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v5: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v5: done after 2 cycles", done, 1);
        check("v5: out_A", out_A, 0);
        // vector 6: B=12 C=0
        in_B = 4'd12; in_C = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v6: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v6: done after 2 cycles", done, 1);
        check("v6: out_A", out_A, 12);
        // vector 7: B=5 C=8
        in_B = 4'd5; in_C = 4'd8;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v7: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v7: done after 2 cycles", done, 1);
        check("v7: out_A", out_A, 0);
        // vector 8: B=10 C=2
        in_B = 4'd10; in_C = 4'd2;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v8: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v8: done after 2 cycles", done, 1);
        check("v8: out_A", out_A, 8);
        // vector 9: B=13 C=0
        in_B = 4'd13; in_C = 4'd0;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v9: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v9: done after 2 cycles", done, 1);
        check("v9: out_A", out_A, 13);
        // vector 10: B=15 C=5
        in_B = 4'd15; in_C = 4'd5;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v10: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v10: done after 2 cycles", done, 1);
        check("v10: out_A", out_A, 10);
        // vector 11: B=1 C=9
        in_B = 4'd1; in_C = 4'd9;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v11: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v11: done after 2 cycles", done, 1);
        check("v11: out_A", out_A, 0);
        // vector 12: B=9 C=14
        in_B = 4'd9; in_C = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v12: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v12: done after 2 cycles", done, 1);
        check("v12: out_A", out_A, 0);
        // vector 13: B=12 C=15
        in_B = 4'd12; in_C = 4'd15;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v13: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v13: done after 2 cycles", done, 1);
        check("v13: out_A", out_A, 0);
        // vector 14: B=13 C=7
        in_B = 4'd13; in_C = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v14: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v14: done after 2 cycles", done, 1);
        check("v14: out_A", out_A, 6);
        // vector 15: B=2 C=13
        in_B = 4'd2; in_C = 4'd13;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v15: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v15: done after 2 cycles", done, 1);
        check("v15: out_A", out_A, 0);
        // vector 16: B=8 C=11
        in_B = 4'd8; in_C = 4'd11;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v16: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v16: done after 2 cycles", done, 1);
        check("v16: out_A", out_A, 0);
        // vector 17: B=3 C=14
        in_B = 4'd3; in_C = 4'd14;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v17: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v17: done after 2 cycles", done, 1);
        check("v17: out_A", out_A, 0);
        // vector 18: B=3 C=10
        in_B = 4'd3; in_C = 4'd10;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v18: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v18: done after 2 cycles", done, 1);
        check("v18: out_A", out_A, 0);
        // vector 19: B=0 C=7
        in_B = 4'd0; in_C = 4'd7;
        rst = 1'b1; @(posedge clk); #1 rst = 1'b0;
        start = 1'b1; @(posedge clk); #1 start = 1'b0;   // IDLE -> S1, inputs loaded
        check("v19: done must be 0 in last step", done, 0);
        @(posedge clk); #1;
        check("v19: done after 2 cycles", done, 1);
        check("v19: out_A", out_A, 0);

        // ---- hls_top: B=3 C=2
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
        check("top: S1 fu_sub0_y (A_0)", obs_val, 1);
        press;
        check("top: state after press 2", t_state, 2);
        check("top: done", t_done, 1);
        sw[15:12] = 4'd1; #1;
        check("top: observe out_A", obs_val, 1);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d FAILURES", errors);
        $finish;
    end
endmodule
