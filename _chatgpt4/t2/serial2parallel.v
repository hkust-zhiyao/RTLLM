module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // 3-bit counter to count the number of bits received
    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the counter and output registers
            cnt <= 0;
            dout_parallel <= 0;
            dout_valid <= 0;
        end else if (din_valid) begin
            // Shift in the serial data into the MSB of dout_parallel
            dout_parallel <= (dout_parallel << 1) | din_serial;
            
            // Increment the counter
            cnt <= cnt + 1;

            // Check if 8 bits have been received
            if (cnt == 7) begin
                // Set the valid output high as all 8 bits are received
                dout_valid <= 1;
                // Reset the counter to start for the next byte
                cnt <= 0;
            end else begin
                // Keep the valid output low as all 8 bits are not yet received
                dout_valid <= 0;
            end
        end else begin
            // If din_valid is not high, do not shift in new data and keep dout_valid low
            dout_valid <= 0;
        end
    end

endmodule