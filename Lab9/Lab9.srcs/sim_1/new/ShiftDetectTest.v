`timescale 1ns/1ps

module ShiftDetectTest;

    reg clk = 0, reset = 1, serial_in = 0;
    wire unlock_shift, unlock_fsm;
    
    // Clock is faster than input -- very important
    always #5 clk = ~clk;

    // Instantiation of my Shift Register and FSM modules
   ShiftDetect u1 (.clk(clk), .reset(reset), .serial_in(serial_in), .unlock(unlock_shift));
   FsmDetect  u2 (.clk(clk), .reset(reset), .serial_in(serial_in), .unlock(unlock_fsm));

    integer i;
    reg [15:0] pattern = 16'b1010100000111010;
    initial begin
        #5;
        reset = 0;
        for (i = 15; i >= 0; i = i - 1) begin
            serial_in = pattern[i];
            #10;
            // Print to console, if desired
            $display("t=%0t in=%b shift_unlock=%b fsm_unlock=%b", $time, serial_in, unlock_shift, unlock_fsm);
        end
        #20;
        $finish;
    end

endmodule
