module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] sum;
reg [1:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: clear the sum, count, and output signals
        sum <= 10'd0;
        count <= 2'd0;
        valid_out <= 1'b0;
        data_out <= 10'd0;
    end else begin
        if (valid_in) begin
            // If a valid input is received, accumulate the sum and increment the count
            if (count < 3) begin
                sum <= sum + data_in;        // Accumulate the input data
                count <= count + 1'b1;       // Increment the count
                valid_out <= 1'b0;           // Keep valid_out low as accumulation is not complete
            end else begin
                // If we have received four inputs, output the accumulated sum
                sum <= sum + data_in;        // Add the last data input to the sum
                data_out <= sum + data_in;   // Output the accumulated sum
                valid_out <= 1'b1;           // Indicate that valid_out is ready
                sum <= 10'd0;                // Reset the sum for the next accumulation
                count <= 2'd0;               // Reset the count for the next accumulation
            end
        end else begin
            // If valid_in is not high, do not accumulate and set valid_out to 0
            valid_out <= 1'b0;
        end
    end
end

endmodule