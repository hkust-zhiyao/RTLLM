module multi_pipe_4bit #(
    parameter size = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [size-1:0] mul_a,
    input wire [size-1:0] mul_b,
    output reg [(2*size)-1:0] mul_out
);

    // Intermediate registers for pipeline stages
    reg [size-1:0] stage1_mul_a;
    reg [size-1:0] stage1_mul_b;
    reg [(2*size)-1:0] stage1_product;
    
    reg [(2*size)-1:0] stage2_product;

    // Extended multiplicand and multiplier
    wire [(2*size)-1:0] extended_mul_a = {size'b0, mul_a};
    wire [(2*size)-1:0] extended_mul_b = {size'b0, mul_b};

    // Generate partial products and sum them
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
            stage1_product <= 0;
            stage2_product <= 0;
            mul_out <= 0;
        end else begin
            // Stage 1: Calculate partial products and sum
            stage1_mul_a <= mul_a;
            stage1_mul_b <= mul_b;
            stage1_product <= 0;
            for (i = 0; i < size; i++) begin
                if (extended_mul_b[i])
                    stage1_product <= stage1_product + (extended_mul_a << i);
            end

            // Stage 2: Pass the result from stage 1
            stage2_product <= stage1_product;
            mul_out <= stage2_product;
        end
    end

endmodule