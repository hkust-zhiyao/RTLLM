module pe(
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Intermediate full width of the product to avoid overflow during accumulation
    reg [63:0] product;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator register 'c' to 0
            c <= 32'b0;
        end else begin
            // Perform multiplication
            product <= a * b;
            // Accumulate the result
            c <= c + product[31:0]; // Assuming you want to accumulate the lower 32 bits of the product
        end
    end

endmodule