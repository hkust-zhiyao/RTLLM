`timescale 1ns / 1ps

module counter_12(
    input rst_n,         // Active low reset
    input clk,           // Clock signal
    input valid_count,   // Enable counting
    output reg [3:0] out // 4-bit counter output
);

    // Counter operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            out <= 4'b0000;
        end else if (valid_count) begin
            // Counting enabled
            if (out == 4'd11) begin
                // Wrap the counter after reaching 11
                out <= 4'b0000;
            end else begin
                // Increment the counter
                out <= out + 1;
            end
        end
        // When valid_count is not active, counter holds the value (no 'else' needed)
    end

endmodule