module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

// Internal variables
reg [9:0] sum; // 10-bit sum to hold the accumulated value
reg [1:0] count; // Counter to count the number of valid inputs

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers when reset is active
        sum <= 10'd0;
        count <= 2'd0;
        data_out <= 10'd0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        // If valid_in is high, accumulate the data_in
        if (count == 3) begin
            // If already received 3 inputs, then this is the 4th one
            sum <= sum + data_in; // Add the current data to the sum
            data_out <= sum + data_in; // Update the data_out with the full sum
            valid_out <= 1'b1; // Set the valid_out high for one cycle
            count <= 2'd0; // Reset the count for the next set of inputs
            sum <= 10'd0; // Reset the sum for the next set of inputs
        end else begin
            // If count is less than 3, accumulate the sum
            sum <= sum + data_in; // Add the current data to the sum
            count <= count + 1'b1; // Increment the count
            valid_out <= 1'b0; // Make sure valid_out is low
        end
    end else begin
        // If valid_in is not high, do not accumulate and keep valid_out low
        valid_out <= 1'b0;
    end
end

endmodule