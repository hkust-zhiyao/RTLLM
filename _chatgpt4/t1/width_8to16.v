module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal register to store the first half of the data
reg [7:0] data_lock;
reg data_lock_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the output and internal registers
        data_out <= 16'd0;
        valid_out <= 1'b0;
        data_lock <= 8'd0;
        data_lock_valid <= 1'b0;
    end else begin
        if (valid_in) begin
            if (data_lock_valid) begin
                // If we have valid data locked, concatenate with new data
                data_out <= {data_lock, data_in};
                data_lock <= 8'd0; // Clear the lock register
                valid_out <= 1'b1; // Set output valid
                data_lock_valid <= 1'b0; // Clear the lock valid flag
            end else begin
                // Store the first half of the data
                data_lock <= data_in;
                data_lock_valid <= 1'b1; // Set the lock valid flag
                valid_out <= 1'b0; // Clear the output valid as we wait for next data
            end
        end else if (data_lock_valid) begin
            // If no new valid data, but we have data locked
            // we don't update the output
            valid_out <= 1'b0;
        end
        // If no valid input and no data locked, maintain the current state
    end
end

endmodule