`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2026 12:50:15 PM
// Design Name: 
// Module Name: TOP
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


module TOP(
    input  wire       clk,  // board clock
    input  wire       btnC, // reset button 
    input  wire       btnR, // load button 
    input  wire       sw,   // serial_in  
    output wire [4:0] led   // 0 output; 2:1 state; 4:3 next
);


    // Top-level function mapping port names to board device names
    // Rememer to update your constraints!
    FsmFinal u_fsm (
        .clk           (clk),
        .reset         (btnC),
        .load          (btnR),
        .serial_in     (sw),
        .unlock        (led[0]),
        .state_out     (led[2:1]),
        .next_state_out(led[4:3])
    );

endmodule
