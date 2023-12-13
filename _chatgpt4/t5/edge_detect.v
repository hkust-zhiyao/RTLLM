`timescale 1ns / 1ps

module edge_detect(
    input clk,       // Clock signal
    input rst_n,     // Active low reset signal
    input a,         // Input signal for edge detection
    output reg rise, // Output signal indicating a rising edge
    output reg down  // Output signal indicating a falling edge
);

    // Register to hold the previous state of 'a'
    reg a_prev;

    // Edge detection logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition, set everything to zero
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge
            rise <= (a == 1'b1) && (a_prev == 1'b0);
            // Detect falling edge
            down <= (a == 1'b0) && (a_prev == 1'b1);
            // Update previous state of 'a'
            a_prev <= a;
        end
    end

endmodule