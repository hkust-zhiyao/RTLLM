module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [(2*size)-1:0] mul_out
);

    // Intermediate product registers for pipeline stages
    reg [size-1:0] stage1_mul_a[size-1:0];
    reg [(2*size)-1:0] stage1_product[size-1:0];
    reg [(2*size)-1:0] stage2_sum;

    // Calculate partial products and store them in pipeline registers
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < size; i = i + 1) begin
                stage1_mul_a[i] <= 0;
                stage1_product[i] <= 0;
            end
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage: calculate and store partial products
            for (i = 0; i < size; i = i + 1) begin
                stage1_mul_a[i] <= mul_a;
                if (mul_b[i]) begin
                    stage1_product[i] <= mul_a << i;
                end else begin
                    stage1_product[i] <= 0;
                end
            end

            // Second pipeline stage: sum the partial products
            stage2_sum <= stage1_product[0];
            for (i = 1; i < size; i = i + 1) begin
                stage2_sum <= stage2_sum + stage1_product[i];
            end

            // Update the output register with the final product
            mul_out <= stage2_sum;
        end
    end

endmodule