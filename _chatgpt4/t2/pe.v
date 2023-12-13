module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

    // Temporary variable to hold the product of a and b
    wire [63:0] product;
    
    // Perform the multiplication of a and b
    assign product = a * b;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to 0 on reset signal
            c <= 32'd0;
        end else begin
            // Accumulate the product in the register c
            c <= c + product[31:0]; // Note: Truncating the product to 32 bits
        end
    end

endmodule