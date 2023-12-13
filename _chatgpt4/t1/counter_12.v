module counter_12 (
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

    // Define the maximum count value as a parameter for easy changes
    parameter MAX_COUNT = 4'd11;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active low reset signal
            out <= 4'b0000;
        end else if (valid_count) begin
            // Only increment the counter if valid_count is high
            if (out == MAX_COUNT) begin
                // Reset to 0 if the counter reaches the maximum count value
                out <= 4'b0000;
            end else begin
                // Increment the counter
                out <= out + 1;
            end
        end
        // If valid_count is 0, do nothing (counter is paused)
    end

endmodule