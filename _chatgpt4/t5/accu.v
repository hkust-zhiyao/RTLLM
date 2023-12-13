module accu(
    input clk,             // Clock input
    input rst_n,           // Active-low reset
    input [7:0] data_in,   // 8-bit input data
    input valid_in,        // Input data valid signal
    output reg valid_out,  // Output valid signal
    output reg [9:0] data_out  // 10-bit accumulated output data
);

    // Internal signals
    reg [9:0] accu_sum;           // Accumulator for the sum
    reg [1:0] count;              // Counter for the input data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            accu_sum <= 10'd0;
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                // When valid_in is high, accumulate the sum
                if (count == 3'd3) begin
                    // If 4 data points have been received, output the sum
                    accu_sum <= accu_sum + data_in;
                    data_out <= accu_sum + data_in; // Include the current data_in in the sum
                    valid_out <= 1'b1; // Output is valid
                    count <= 2'd0; // Reset the counter for next cycle
                    accu_sum <= 10'd0; // Reset the accumulator
                end else begin
                    // If fewer than 4 data points have been received, keep accumulating
                    accu_sum <= accu_sum + data_in;
                    count <= count + 2'd1;
                    valid_out <= 1'b0; // Output is not valid yet
                end
            end else begin
                // If valid_in is low, do nothing
                valid_out <= 1'b0; // Maintain output as invalid
            end
        end
    end
endmodule