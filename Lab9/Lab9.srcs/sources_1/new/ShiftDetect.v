`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 02:43:21 PM
// Design Name: 
// Module Name: ShiftDetect
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


module ShiftDetect(
input clk, reset, serial_in,
output unlock
);

reg [2:0] shift;

assign unlock = (shift == 3'b101);

always @(posedge clk) begin
    if (reset)
        shift <= 3'b000;
        else 
        begin
        shift <= {shift[1:0], serial_in};    
    end
end

    
    
endmodule
