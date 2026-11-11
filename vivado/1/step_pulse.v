// Turns a push button into a single one-clock pulse per press.
//   1. two flip-flops synchronize the button to the clock
//   2. the debounced level only changes after the button has been stable
//      for DEBOUNCE clock cycles (1_000_000 cycles = 10 ms at 100 MHz)
//   3. a rising-edge detector outputs one pulse when the level goes 0 -> 1
// Used as the clock enable of the synthesized design, so the design can be
// stepped one state per press while everything stays on the 100 MHz clock.
module step_pulse #(parameter DEBOUNCE = 1_000_000) (
    input  clk,
    input  btn,
    output pulse
);
    reg [1:0]  sync   = 2'b00;
    reg        level  = 1'b0;
    reg        prev   = 1'b0;
    reg [31:0] count  = 32'd0;

    always @(posedge clk) begin
        sync <= {sync[0], btn};
        if (sync[1] == level)
            count <= 32'd0;
        else if (count >= DEBOUNCE - 1) begin
            level <= sync[1];
            count <= 32'd0;
        end else
            count <= count + 32'd1;
        prev <= level;
    end

    assign pulse = level & ~prev;
endmodule
