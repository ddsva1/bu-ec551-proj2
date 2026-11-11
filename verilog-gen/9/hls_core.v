// Controller / sequencer: one state per control step.
// The state only advances when en=1 (one button press on the board).
module hls_controller (
    input clk,
    input rst,
    input en,
    input start,
    output reg [2:0] state,
    output reg done,
    output reg sel_add0_a,
    output reg sel_sub0_b,
    output reg sel_r0,
    output reg [1:0] sel_r1,
    output reg sel_r2,
    output reg we_r0,
    output reg we_r1,
    output reg we_r2,
    output reg we_r3,
    output reg we_r4,
    output reg we_r5
);
    localparam ST_IDLE = 3'd0;
    localparam ST_S1 = 3'd1;
    localparam ST_S2 = 3'd2;
    localparam ST_S3 = 3'd3;
    localparam ST_DONE = 3'd4;

    always @(posedge clk) begin
        if (rst)
            state <= ST_IDLE;
        else if (en)
            case (state)
                ST_IDLE: if (start) state <= ST_S1;
                ST_S1: state <= ST_S2;
                ST_S2: state <= ST_S3;
                ST_S3: state <= ST_DONE;
                ST_DONE: if (start) state <= ST_IDLE;
                default: state <= ST_IDLE;
            endcase
    end

    always @(*) begin
        done = 1'b0;
        sel_add0_a = 1'd0;
        sel_sub0_b = 1'd0;
        sel_r0 = 1'd0;
        sel_r1 = 2'd0;
        sel_r2 = 1'd0;
        we_r0 = 1'b0;
        we_r1 = 1'b0;
        we_r2 = 1'b0;
        we_r3 = 1'b0;
        we_r4 = 1'b0;
        we_r5 = 1'b0;
        case (state)
            ST_IDLE: if (start) begin   // load the primary inputs
                we_r0 = 1'b1;
                sel_r0 = 1'd0;
                we_r1 = 1'b1;
                sel_r1 = 2'd0;
                we_r2 = 1'b1;
                sel_r2 = 1'd0;
            end
            ST_S1: begin
                // op3: A_3 = B_0 - C_0  on sub0
                sel_sub0_b = 1'd0;
                we_r3 = 1'b1;
            end
            ST_S2: begin
                // op0: A_0 = B_0 + C_0  on add0
                // op4: B_1 = A_3 * B_0  on mul0
                sel_add0_a = 1'd0;
                we_r1 = 1'b1;
                sel_r1 = 2'd1;
                we_r4 = 1'b1;
            end
            ST_S3: begin
                // op1: A_1 = D_0 + A_0  on add0
                // op2: A_2 = B_0 - D_0  on sub0
                // op5: D_1 = A_3 + B_1  on add1
                // op6: C_1 = B_1 - B_1  on sub1
                sel_add0_a = 1'd1;
                sel_sub0_b = 1'd1;
                we_r0 = 1'b1;
                sel_r0 = 1'd1;
                we_r1 = 1'b1;
                sel_r1 = 2'd2;
                we_r2 = 1'b1;
                sel_r2 = 1'd1;
                we_r5 = 1'b1;
            end
            ST_DONE: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end
endmodule

// Datapath generated from the schedule:
//   2 adder(s), 2 subtractor(s), 1 multiplier(s), 6 registers, 5 FSM states
// Registers sit at the cycle boundaries; muxes route registers/constants
// to the shared functional units and FU outputs back to the registers.
module hls_core (
    input clk,
    input rst,
    input en,
    input start,
    input  [3:0] in_B,
    input  [3:0] in_C,
    input  [3:0] in_D,
    output [3:0] out_A,
    output [3:0] out_B,
    output [3:0] out_D,
    output [3:0] out_C,
    output [3:0] fu_add0_y,
    output [3:0] fu_add1_y,
    output [3:0] fu_sub0_y,
    output [3:0] fu_sub1_y,
    output [3:0] fu_mul0_y,
    output [2:0] state,
    output done
);
    localparam W = 4;

    // control signals
    wire sel_add0_a;
    wire sel_sub0_b;
    wire sel_r0;
    wire [1:0] sel_r1;
    wire sel_r2;
    wire we_r0;
    wire we_r1;
    wire we_r2;
    wire we_r3;
    wire we_r4;
    wire we_r5;

    hls_controller ctrl (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .state(state),
        .done(done),
        .sel_add0_a(sel_add0_a),
        .sel_sub0_b(sel_sub0_b),
        .sel_r0(sel_r0),
        .sel_r1(sel_r1),
        .sel_r2(sel_r2),
        .we_r0(we_r0),
        .we_r1(we_r1),
        .we_r2(we_r2),
        .we_r3(we_r3),
        .we_r4(we_r4),
        .we_r5(we_r5)
    );

    // registers
    reg [W-1:0] r0, r1, r2, r3, r4, r5;

    // functional units and their input muxes
    reg [W-1:0] add0_a, add0_b;
    always @(*)
        case (sel_add0_a)
            1'd0: add0_a = r0;
            1'd1: add0_a = r2;
            default: add0_a = {W{1'b0}};
        endcase
    always @(*) add0_b = r1;
    adder #(.W(W)) u_add0 (.a(add0_a), .b(add0_b), .y(fu_add0_y));

    reg [W-1:0] add1_a, add1_b;
    always @(*) add1_a = r3;
    always @(*) add1_b = r4;
    adder #(.W(W)) u_add1 (.a(add1_a), .b(add1_b), .y(fu_add1_y));

    reg [W-1:0] sub0_a, sub0_b;
    always @(*) sub0_a = r0;
    always @(*)
        case (sel_sub0_b)
            1'd0: sub0_b = r1;
            1'd1: sub0_b = r2;
            default: sub0_b = {W{1'b0}};
        endcase
    subtractor #(.W(W)) u_sub0 (.a(sub0_a), .b(sub0_b), .y(fu_sub0_y));

    reg [W-1:0] sub1_a, sub1_b;
    always @(*) sub1_a = r4;
    always @(*) sub1_b = r4;
    subtractor #(.W(W)) u_sub1 (.a(sub1_a), .b(sub1_b), .y(fu_sub1_y));

    reg [W-1:0] mul0_a, mul0_b;
    always @(*) mul0_a = r3;
    always @(*) mul0_b = r0;
    multiplier #(.W(W)) u_mul0 (.a(mul0_a), .b(mul0_b), .y(fu_mul0_y));

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
            2'd0: r1_d = in_C;
            2'd1: r1_d = fu_add0_y;
            2'd2: r1_d = fu_sub0_y;
            default: r1_d = {W{1'b0}};
        endcase
    reg [W-1:0] r2_d;
    always @(*)
        case (sel_r2)
            1'd0: r2_d = in_D;
            1'd1: r2_d = fu_add1_y;
            default: r2_d = {W{1'b0}};
        endcase
    reg [W-1:0] r3_d;
    always @(*) r3_d = fu_sub0_y;
    reg [W-1:0] r4_d;
    always @(*) r4_d = fu_mul0_y;
    reg [W-1:0] r5_d;
    always @(*) r5_d = fu_sub1_y;

    always @(posedge clk) begin
        if (rst) begin
            r0 <= {W{1'b0}};
            r1 <= {W{1'b0}};
            r2 <= {W{1'b0}};
            r3 <= {W{1'b0}};
            r4 <= {W{1'b0}};
            r5 <= {W{1'b0}};
        end else if (en) begin
            if (we_r0) r0 <= r0_d;
            if (we_r1) r1 <= r1_d;
            if (we_r2) r2 <= r2_d;
            if (we_r3) r3 <= r3_d;
            if (we_r4) r4 <= r4_d;
            if (we_r5) r5 <= r5_d;
        end
    end

    // outputs (valid in state DONE)
    assign out_A = r3;   // A_3
    assign out_B = r4;   // B_1
    assign out_D = r2;   // D_1
    assign out_C = r5;   // C_1
endmodule
