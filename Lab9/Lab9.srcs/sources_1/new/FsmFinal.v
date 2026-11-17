`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2026 01:16:38 PM
// Design Name: 
// Module Name: FsmFinal
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module FsmFinal (
    input  wire       clk,
    input  wire       reset,       // synchronous, active-high
    input  wire       load,        // asynchronous button, active-high
    input  wire       serial_in,   // switch bit to commit
    output reg        unlock,      // one-cycle pulse when 101 is detected
    output wire [1:0] state_out,
    output wire [1:0] next_state_out
);

/////////////////////////////////////////////////////////////////////////////

    // Housekeeping
    localparam [1:0] S0 = 2'd0; // no matching prefix
    localparam [1:0] S1 = 2'd1; // matched 1
    localparam [1:0] S2 = 2'd2; // matched 10
    localparam [1:0] S3 = 2'd3; // matched 101

    reg [1:0] state;
    reg [1:0] next_state;

/////////////////////////////////////////////////////////////////////////////

    // Synchronize the button to clk and make a one-cycle pulse
    // on each low-to-high transition.
    reg load_meta; // Meta-signal
    reg load_sync; // Synchronized signal (to posedge clk)
    reg load_prev; // Previous signal (to create single pulse)

    always @(posedge clk) begin
        if (reset) begin
            load_meta <= 1'b0;
            load_sync <= 1'b0;
            load_prev <= 1'b0;
        end else begin
            load_meta <= load;
            load_sync <= load_meta;
            load_prev <= load_sync;
        end
    end

    wire load_pulse = load_sync & ~load_prev;

/////////////////////////////////////////////////////////////////////////////

    // Preview the next state for the current switch position.
    // The input is committed only when load_pulse is asserted.
    always @* begin
        case (state)
            S0:      next_state = serial_in ? S1 : S0;
            S1:      next_state = serial_in ? S1 : S2;
            S2:      next_state = serial_in ? S3 : S0;
            S3:      next_state = serial_in ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Commit one input bit on each button press.
    always @(posedge clk) begin
        if (reset) begin
            state  <= S0;
            unlock <= 1'b0;
        end else begin
 //           unlock <= 1'b0; // uncomment to make unlock a one-cycle pulse

            if (load_pulse) begin
                state  <= next_state;
                unlock <= (next_state == S3);
            end
        end
    end
    
/////////////////////////////////////////////////////////////////////////////

    // Expose current and next state as outputs to help you debug
    assign state_out      = state;
    assign next_state_out = next_state;

/////////////////////////////////////////////////////////////////////////////

endmodule
