module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // 4-bit counter to count the number of bits received
    reg [2:0] cnt;

    // On every positive edge of the clock, perform the series to parallel conversion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // If reset is active, clear the counter and output registers
            cnt <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            // If the input data is valid, shift in the serial data
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            
            // Increment the counter
            cnt <= cnt + 1;
            
            // If 8 bits have been received, indicate that output is valid
            if (cnt == 3'd7) begin
                dout_valid <= 1'b1;
                cnt <= 3'd0; // reset the counter after 8 bits
            end else begin
                dout_valid <= 1'b0;
            end
        end else begin
            // If din_valid is not high, do not shift in new data
            // and clear the valid flag
            dout_valid <= 1'b0;
        end
    end

endmodule