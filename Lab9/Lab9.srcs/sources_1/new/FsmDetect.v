`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 03:49:08 PM
// Design Name: 
// Module Name: FsmDetect
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


module FsmDetect(
input logic clk, reset, serial_in,
output logic unlock
);
localparam ST0 = 2'b00,
           ST1 = 2'b01,
           ST2 = 2'b10,
           ST3 = 2'b11;
           

reg [1:0] state, next_state;
reg [1:0] next_out;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= ST0;
    else begin
        state <= next_state;
        unlock <= next_out;
    end
end

always @(*) begin
    next_state = state;
    next_out = 1'b0;
    
    case(state)
        ST0: begin
            if (serial_in)
                next_state = ST1;
            else
                next_state = ST0;
        end
        
        ST1: begin
            if (serial_in)
                next_state = ST1;
            else
                next_state = ST2;
        end
        
        ST2: begin
            if (serial_in) begin
                next_state = ST3;
                next_out = 1;
            end
            else
                next_state = ST0;
        end
        
        ST3: begin
            if (!serial_in)
                next_state = ST2;
            else
                next_state = ST1;
            end
        
        default: begin
            next_state = ST0;
        end
     endcase
  end   
endmodule
