module counter_12 (
    input wire rst_n,       // Active low reset
    input wire clk,         // Clock signal
    input wire valid_count, // Enable counting
    output reg [3:0] out    // 4-bit count value
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset the counter to 0 when reset is active
            out <= 4'b0000;
        end else if (valid_count) begin
            // Only count when valid_count is high
            if (out == 4'd11) begin
                // Wrap around the counter after reaching 4'd11
                out <= 4'b0000;
            end else begin
                // Increment the counter
                out <= out + 1;
            end
        end
        // When valid_count is low, do nothing (counter is paused)
    end

endmodule