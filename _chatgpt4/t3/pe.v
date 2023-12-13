module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [63:0] c // Changed to 64 bits to avoid overflow
);

    // Perform multiplication and accumulation on the positive edge of the clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to 0 when rst is high
            c <= 64'b0; // Extended to 64 bits to hold the result without overflow
        end else begin
            // Multiply a and b, and accumulate the result
            c <= c + (a * b); // Here, a * b is a 64-bit operation
        end
    end

endmodule