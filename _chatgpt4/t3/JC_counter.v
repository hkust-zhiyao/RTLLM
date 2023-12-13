module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    // Johnson counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low reset is asserted, initialize the counter
            Q <= 64'b0;
        end else begin
            // Shift the counter and append bits at the ends according to the pattern
            Q <= {Q[62:0], ~Q[63]};
        end
    end

endmodule