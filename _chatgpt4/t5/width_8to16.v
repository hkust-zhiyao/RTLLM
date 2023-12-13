module width_8to16(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    // Intermediate storage for the first 8-bit data
    reg [7:0] data_lock;
    // Flag to indicate that the first data byte has been stored and is waiting for the second byte
    reg data_lock_valid;

    // Synchronous process for capturing and concatenating input data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            data_lock_valid <= 1'b0;
        end else begin
            if (valid_in) begin
                if (data_lock_valid) begin
                    // If we have valid data locked, concatenate it with new data
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1; // Output is valid now
                    data_lock_valid <= 1'b0; // Clear the lock flag as data is now used
                end else begin
                    // If no valid data is locked, lock the current input and wait for the next
                    data_lock <= data_in;
                    data_lock_valid <= 1'b1; // Set the lock flag
                    valid_out <= 1'b0; // Output is not valid until we get the second byte
                end
            end else if (!data_lock_valid) begin
                // If input is not valid and no data is locked, maintain the output as invalid
                valid_out <= 1'b0;
            end
            // No else clause for data_lock_valid and !valid_in, since we want to keep the locked data
        end
    end

endmodule