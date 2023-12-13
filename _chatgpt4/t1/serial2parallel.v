module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // 3-bit counter to count up to 8 bits
    reg [2:0] cnt;

    // Reset and count logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset
            cnt <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end
        else if (din_valid) begin
            if (cnt < 3'd7) begin
                // Shift in the serial data starting from the MSB
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                cnt <= cnt + 3'd1;
                dout_valid <= 1'b0;  // Not valid until 8 bits are received
            end
            else begin
                // Shift in the last bit and assert the valid signal
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                dout_valid <= 1'b1;
                cnt <= 3'd0;  // Reset the counter
            end
        end
    end

endmodule