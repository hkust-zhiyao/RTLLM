module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

    // Johnson counter sequence update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            Q <= 64'b0; // Set all bits to 0
        end else begin
            // Normal operation
            if (Q[0] == 1'b0) begin
                // If the LSB is 0, shift left and insert 1 at MSB
                Q <= {Q[62:0], 1'b1};
            end else begin
                // If the LSB is 1, shift left and insert 0 at MSB
                Q <= {Q[62:0], 1'b0};
            end
        end
    end

endmodule