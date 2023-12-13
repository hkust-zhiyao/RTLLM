module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

    // Johnson counter update logic on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low reset to zero
            Q <= 64'b0;
        end else begin
            // Check the least significant bit to determine increment or decrement
            if (Q[0] == 1'b0) begin
                // Shift left and append 1 at LSB (note: MSB comes from the inverted LSB)
                Q <= {Q[62:0], ~Q[63]};
            end else begin
                // Shift left and append 0 at LSB (note: MSB comes from the inverted LSB)
                Q <= {Q[62:0], ~Q[63]};
            end
        end
    end

endmodule