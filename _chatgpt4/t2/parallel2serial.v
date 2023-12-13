module parallel2serial (
    input         clk,
    input         rst_n,
    input  [3:0]  d,
    output reg    valid_out,
    output reg    dout
);

    // Internal 4-bit register to hold the input data
    reg [3:0] data;

    // 2-bit counter to keep track of the bit position
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Asynchronous reset
            cnt <= 2'd0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data <= 4'd0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data and reset counter
                data <= d;
                cnt <= 2'd0;
                valid_out <= 1'b1; // Valid output on loading new data
            end else begin
                // Shift data and increment counter
                data <= {data[2:0], 1'b0};
                cnt <= cnt + 2'd1;
                valid_out <= 1'b0;
            end
            // Output the MSB of the data register
            dout <= data[3];
        end
    end

endmodule