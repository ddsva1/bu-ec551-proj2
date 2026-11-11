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
    output reg we_r0,
    output reg we_r1
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
        we_r0 = 1'b0;
        we_r1 = 1'b0;
        case (state)
            ST_IDLE: if (start) begin   // load the primary inputs
                we_r0 = 1'b1;
                sel_r0 = 1'd0;
                we_r1 = 1'b1;
            end
            ST_S1: begin
                // op0: A_0 = B_0 - C_0  on sub0
                we_r0 = 1'b1;
                sel_r0 = 1'd1;
            end
            ST_DONE: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end
endmodule

// Datapath generated from the schedule:
//   0 adder(s), 1 subtractor(s), 0 multiplier(s), 2 registers, 3 FSM states
// Registers sit at the cycle boundaries; muxes route registers/constants
// to the shared functional units and FU outputs back to the registers.
module hls_core (
    input clk,
    input rst,
    input en,
    input start,
    input  [3:0] in_B,
    input  [3:0] in_C,
    output [3:0] out_A,
    output [3:0] fu_sub0_y,
    output [1:0] state,
    output done
);
    localparam W = 4;

    // control signals
    wire sel_r0;
    wire we_r0;
    wire we_r1;

    hls_controller ctrl (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .state(state),
        .done(done),
        .sel_r0(sel_r0),
        .we_r0(we_r0),
        .we_r1(we_r1)
    );

    // registers
    reg [W-1:0] r0, r1;

    // functional units and their input muxes
    reg [W-1:0] sub0_a, sub0_b;
    always @(*) sub0_a = r0;
    always @(*) sub0_b = r1;
    subtractor #(.W(W)) u_sub0 (.a(sub0_a), .b(sub0_b), .y(fu_sub0_y));

    // register input muxes
    reg [W-1:0] r0_d;
    always @(*)
        case (sel_r0)
            1'd0: r0_d = in_B;
            1'd1: r0_d = fu_sub0_y;
            default: r0_d = {W{1'b0}};
        endcase
    reg [W-1:0] r1_d;
    always @(*) r1_d = in_C;

    always @(posedge clk) begin
        if (rst) begin
            r0 <= {W{1'b0}};
            r1 <= {W{1'b0}};
        end else if (en) begin
            if (we_r0) r0 <= r0_d;
            if (we_r1) r1 <= r1_d;
        end
    end

    // outputs (valid in state DONE)
    assign out_A = r0;   // A_0
endmodule
