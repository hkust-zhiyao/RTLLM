module multi_pipe_4bit #(
    parameter size = 4
) (
    input wire clk,
    input wire rst_n,
    input wire [size-1:0] mul_a,
    input wire [size-1:0] mul_b,
    output wire [2*size-1:0] mul_out
);

    // Intermediate registers for pipeline stages
    reg [2*size-1:0] partial_products[size-1:0];
    reg [2*size-1:0] sum_stage1;
    reg [2*size-1:0] sum_stage2;
    reg [2*size-1:0] final_product;

    // Output assignment
    assign mul_out = final_product;

    // Generate block to create partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_products[i] <= 0;
                end else begin
                    // If the corresponding bit in the multiplier is 1,
                    // left-shift the multiplicand by i positions.
                    // Otherwise, the partial product is 0.
                    partial_products[i] <= mul_b[i] ? (mul_a << i) : 0;
                end
            end
        end
    endgenerate

    // Pipeline stage 1: Add partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
        end else begin
            sum_stage1 <= partial_products[0] + partial_products[1] +
                          partial_products[2] + partial_products[3];
        end
    end

    // Pipeline stage 2: Store the result of addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 0;
        end else begin
            sum_stage2 <= sum_stage1;
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_product <= 0;
        end else begin
            final_product <= sum_stage2;
        end
    end

endmodule