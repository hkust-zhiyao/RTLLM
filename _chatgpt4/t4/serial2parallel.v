module serial2parallel(
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Internal counter to keep track of the number of bits received
    reg [2:0] cnt;

    // Reset and data shifting is handled on the rising edge of the clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // When reset is asserted, clear the counter and output registers
            cnt <= 3'b000;
            dout_parallel <= 8'b00000000;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            // Shift in the serial data into dout_parallel starting with the MSB
            dout_parallel <= {din_serial, dout_parallel[7:1]};
            // Increment the counter
            cnt <= cnt + 3'b001;
            // If 8 bits have been received, indicate that dout_parallel is valid
            if (cnt == 3'b111) begin
                dout_valid <= 1'b1;
                cnt <= 3'b000; // Reset the counter for the next batch of 8 bits
            end else begin
                dout_valid <= 1'b0;
            end
        end else begin
            // When din_valid is not high, do not shift in new data
            dout_valid <= 1'b0;
        end
    end

endmodule