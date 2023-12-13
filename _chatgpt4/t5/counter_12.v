`timescale 1ns / 1ps

module counter_12 (
    input wire rst_n,       // Active low reset
    input wire clk,         // Clock signal
    input wire valid_count, // Enable counting
    output reg [3:0] out    // 4-bit count output
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            out <= 4'b0000;
        end else if (valid_count) begin
            if (out == 4'd11) begin
                // Wrap counter back to 0 after reaching 11
                out <= 4'b0000;
            end else begin
                // Increment counter
                out <= out + 4'd1;
            end
        end
        // If valid_count is 0, do nothing (counter is paused)
    end

endmodule