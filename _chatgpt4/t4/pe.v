module pe(
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

// Multiplication and accumulation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Synchronous reset: set the accumulator to zero
        c <= 32'd0;
    end else begin
        // Multiply and accumulate
        c <= c + (a * b);
    end
end

endmodule