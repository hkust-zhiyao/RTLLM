module parallel2serial(
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // State representation
    reg [1:0] cnt; // 2-bit counter to keep track of the shifting
    reg [3:0] data; // Register to hold the current data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset: reset counter and output
            cnt <= 2'b00;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data <= 4'd0;
        end else begin
            if (cnt == 3) begin
                // Last bit was shifted out, load new data and reset counter
                data <= d;
                cnt <= 2'b00;
                valid_out <= 1'b1; // Indicate that valid data is available
                dout <= d[3]; // Output MSB
            end else begin
                // Shift data and increment counter
                data <= data << 1; // Shift left by 1 bit
                dout <= data[3]; // Output next bit
                cnt <= cnt + 1'b1;
                valid_out <= (cnt == 2'b00)? 1'b1 : 1'b0; // Set valid_out only when new data is loaded
            end
        end
    end

endmodule