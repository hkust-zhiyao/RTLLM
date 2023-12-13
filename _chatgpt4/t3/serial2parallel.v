module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// Internal counter to track the number of received bits
reg [2:0] cnt; // 3 bits to count up to 8

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: clear the counter and output registers
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If input is valid, shift in the new bit and increment the counter
        dout_parallel <= {din_serial, dout_parallel[7:1]};
        cnt <= cnt + 1'b1;
        
        // Check if 8 bits have been shifted in
        if (cnt == 3'b111) begin
            // Indicate that the output is valid on the 8th bit
            dout_valid <= 1'b1;
            cnt <= 3'b000; // Reset the counter for the next cycle
        end else begin
            // Output is not yet valid
            dout_valid <= 1'b0;
        end
    end else begin
        // If input is not valid, just clear the valid output signal
        dout_valid <= 1'b0;
    end
end

endmodule