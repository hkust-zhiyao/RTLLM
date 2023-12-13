module pe(
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Intermediate register to store the product of a and b
    reg [63:0] product;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to 0 when rst is high
            c <= 32'd0;
        end else begin
            // Perform the multiply-accumulate operation
            product <= a * b; // Multiply a by b
            c <= c + product[31:0]; // Accumulate the lower 32 bits of the product
        end
    end

endmodule