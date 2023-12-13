module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal signal to hold the first 8-bit data and the flag to indicate its presence
reg [7:0] data_lock;
reg data_lock_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset state: clear registers and output
        data_out <= 16'b0;
        valid_out <= 1'b0;
        data_lock <= 8'b0;
        data_lock_valid <= 1'b0;
    end else begin
        if (valid_in) begin
            if (data_lock_valid) begin
                // If we already have a valid data_lock, concatenate and output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                data_lock_valid <= 1'b0; // Reset the data_lock_valid flag
            end else begin
                // Store the first part of the data and wait for the next valid input
                data_lock <= data_in;
                data_lock_valid <= 1'b1;
                valid_out <= 1'b0; // Do not assert valid_out yet
            end
        end else if (!data_lock_valid) begin
            // If valid_in is low and we don't have a valid data_lock, keep outputs deasserted
            valid_out <= 1'b0;
        end
        // No else condition here, if valid_in is low but data_lock_valid is true, we wait.
    end
end

endmodule