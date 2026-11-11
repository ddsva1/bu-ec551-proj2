// Controller / sequencer: one state per control step.
// The state only advances when en=1 (one button press on the board).
module hls_controller (
    input clk,
    input rst,
    input en,
    input start,
    output reg [4:0] state,
    output reg done,
    output reg [1:0] sel_r0,
    output reg we_r0
);
    localparam ST_IDLE = 5'd0;
    localparam ST_S1 = 5'd1;
    localparam ST_S2 = 5'd2;
    localparam ST_S3 = 5'd3;
    localparam ST_S4 = 5'd4;
    localparam ST_S5 = 5'd5;
    localparam ST_S6 = 5'd6;
    localparam ST_S7 = 5'd7;
    localparam ST_S8 = 5'd8;
    localparam ST_S9 = 5'd9;
    localparam ST_S10 = 5'd10;
    localparam ST_S11 = 5'd11;
    localparam ST_S12 = 5'd12;
    localparam ST_S13 = 5'd13;
    localparam ST_S14 = 5'd14;
    localparam ST_S15 = 5'd15;
    localparam ST_S16 = 5'd16;
    localparam ST_S17 = 5'd17;
    localparam ST_S18 = 5'd18;
    localparam ST_S19 = 5'd19;
    localparam ST_S20 = 5'd20;
    localparam ST_DONE = 5'd21;

    always @(posedge clk) begin
        if (rst)
            state <= ST_IDLE;
        else if (en)
            case (state)
                ST_IDLE: if (start) state <= ST_S1;
                ST_S1: state <= ST_S2;
                ST_S2: state <= ST_S3;
                ST_S3: state <= ST_S4;
                ST_S4: state <= ST_S5;
                ST_S5: state <= ST_S6;
                ST_S6: state <= ST_S7;
                ST_S7: state <= ST_S8;
                ST_S8: state <= ST_S9;
                ST_S9: state <= ST_S10;
                ST_S10: state <= ST_S11;
                ST_S11: state <= ST_S12;
                ST_S12: state <= ST_S13;
                ST_S13: state <= ST_S14;
                ST_S14: state <= ST_S15;
                ST_S15: state <= ST_S16;
                ST_S16: state <= ST_S17;
                ST_S17: state <= ST_S18;
                ST_S18: state <= ST_S19;
                ST_S19: state <= ST_S20;
                ST_S20: state <= ST_DONE;
                ST_DONE: if (start) state <= ST_IDLE;
                default: state <= ST_IDLE;
            endcase
    end

    always @(*) begin
        done = 1'b0;
        sel_r0 = 2'd0;
        we_r0 = 1'b0;
        case (state)
            ST_IDLE: if (start) begin   // load the primary inputs
                we_r0 = 1'b1;
                sel_r0 = 2'd0;
            end
            ST_S1: begin
                // op0: A_1 = A_0 + A_0  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S2: begin
                // op1: A_2 = A_1 - A_1  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S3: begin
                // op2: A_3 = A_2 + A_2  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S4: begin
                // op3: A_4 = A_3 - A_3  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S5: begin
                // op4: A_5 = A_4 + A_4  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S6: begin
                // op5: A_6 = A_5 - A_5  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S7: begin
                // op6: A_7 = A_6 + A_6  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S8: begin
                // op7: A_8 = A_7 - A_7  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S9: begin
                // op8: A_9 = A_8 + A_8  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S10: begin
                // op9: A_10 = A_9 - A_9  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S11: begin
                // op10: A_11 = A_10 + A_10  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S12: begin
                // op11: A_12 = A_11 - A_11  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S13: begin
                // op12: A_13 = A_12 + A_12  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S14: begin
                // op13: A_14 = A_13 - A_13  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S15: begin
                // op14: A_15 = A_14 + A_14  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S16: begin
                // op15: A_16 = A_15 - A_15  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S17: begin
                // op16: A_17 = A_16 + A_16  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S18: begin
                // op17: A_18 = A_17 - A_17  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_S19: begin
                // op18: A_19 = A_18 + A_18  on add0
                we_r0 = 1'b1;
                sel_r0 = 2'd1;
            end
            ST_S20: begin
                // op19: A_20 = A_19 - A_19  on sub0
                we_r0 = 1'b1;
                sel_r0 = 2'd2;
            end
            ST_DONE: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end
endmodule

// Datapath generated from the schedule:
//   1 adder(s), 1 subtractor(s), 0 multiplier(s), 1 registers, 22 FSM states
// Registers sit at the cycle boundaries; muxes route registers/constants
// to the shared functional units and FU outputs back to the registers.
module hls_core (
    input clk,
    input rst,
    input en,
    input start,
    input  [3:0] in_A,
    output [3:0] out_A,
    output [3:0] fu_add0_y,
    output [3:0] fu_sub0_y,
    output [4:0] state,
    output done
);
    localparam W = 4;

    // control signals
    wire [1:0] sel_r0;
    wire we_r0;

    hls_controller ctrl (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .state(state),
        .done(done),
        .sel_r0(sel_r0),
        .we_r0(we_r0)
    );

    // registers
    reg [W-1:0] r0;

    // functional units and their input muxes
    reg [W-1:0] add0_a, add0_b;
    always @(*) add0_a = r0;
    always @(*) add0_b = r0;
    adder #(.W(W)) u_add0 (.a(add0_a), .b(add0_b), .y(fu_add0_y));

    reg [W-1:0] sub0_a, sub0_b;
    always @(*) sub0_a = r0;
    always @(*) sub0_b = r0;
    subtractor #(.W(W)) u_sub0 (.a(sub0_a), .b(sub0_b), .y(fu_sub0_y));

    // register input muxes
    reg [W-1:0] r0_d;
    always @(*)
        case (sel_r0)
            2'd0: r0_d = in_A;
            2'd1: r0_d = fu_add0_y;
            2'd2: r0_d = fu_sub0_y;
            default: r0_d = {W{1'b0}};
        endcase

    always @(posedge clk) begin
        if (rst) begin
            r0 <= {W{1'b0}};
        end else if (en) begin
            if (we_r0) r0 <= r0_d;
        end
    end

    // outputs (valid in state DONE)
    assign out_A = r0;   // A_20
endmodule
