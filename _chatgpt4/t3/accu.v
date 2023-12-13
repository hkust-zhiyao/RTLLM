module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Define state to store input data and count the number of inputs
    reg [9:0] sum;
    reg [1:0] count;

    // Always block to handle the accumulation and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state
            sum <= 10'd0;
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                // When a valid input is provided, add it to the sum
                sum <= sum + data_in;
                count <= count + 1'b1; // Increment the count of valid inputs

                // Reset the valid_out flag each cycle unless it's being set this cycle
                valid_out <= 1'b0;

                if (count == 2'd3) begin
                    // If four valid inputs have been accumulated, output the sum
                    data_out <= sum + data_in; // Include the current data_in in the sum
                    valid_out <= 1'b1; // Set valid_out high to indicate valid output
                    sum <= 10'd0; // Reset sum for the next round of accumulation
                    count <= 2'd0; // Reset count for the next round of accumulation
                end
            end
        end
    end

endmodule