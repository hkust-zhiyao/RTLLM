module width_8to16(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

// Internal signal to store the first half of the data
reg [7:0] data_lock;
// Flag to indicate that the first half is stored
reg flag;

// Data handling and output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the output and internal registers
        data_out <= 16'd0;
        valid_out <= 1'b0;
        data_lock <= 8'd0;
        flag <= 1'b0;
    end else if (valid_in) begin
        if (flag) begin
            // If we have a stored first half, concatenate with the new input
            data_out <= {data_lock, data_in};
            valid_out <= 1'b1; // Output is now valid
            flag <= 1'b0; // Clear the flag as we've used the stored half
        end else begin
            // Store the first half of the data
            data_lock <= data_in;
            flag <= 1'b1;
            valid_out <= 1'b0; // Output is not valid until we get the second half
        end
    end else if (!valid_in && flag) begin
        // If no valid input and we have a stored first half, do not change the state
        valid_out <= 1'b0;
    end
end

endmodule