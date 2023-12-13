module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

// Internal signals
reg [9:0] sum;
reg [1:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset
        sum <= 10'd0;
        count <= 2'd0;
        data_out <= 10'd0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            // When valid_in is high, accumulate the data
            if (count < 3) begin
                // Accumulate data if count is less than 3
                sum <= sum + data_in;
                count <= count + 1'b1;
                valid_out <= 1'b0;
            end else begin
                // On the 4th data, output the sum and reset
                sum <= sum + data_in;
                data_out <= sum + data_in;
                valid_out <= 1'b1;
                sum <= 10'd0; // Reset sum
                count <= 2'd0; // Reset count
            end
        end else if (valid_out) begin
            // Ensure valid_out is high for only 1 cycle
            valid_out <= 1'b0;
        end
    end
end

endmodule