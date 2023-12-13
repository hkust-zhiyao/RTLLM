module JC_counter(
    input clk,        // Clock signal
    input rst_n,      // Active-low reset
    output reg [63:0] Q  // 64-bit counter value
);

    // Counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset condition
            Q <= 64'b0;
        end else begin
            if (Q[0] == 1'b0) begin
                // Increment (shift left and append '1' at LSB)
                Q <= {Q[62:0], 1'b1};
            end else begin
                // Decrement (shift left and append '0' at LSB)
                Q <= {Q[62:0], 1'b0};
            end
        end
    end

endmodule