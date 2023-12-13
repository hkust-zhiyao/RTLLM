module multi_pipe_8bit (
    input          clk,
    input          rst_n,
    input          mul_en_in,
    input  [7:0]   mul_a,
    input  [7:0]   mul_b,
    output         mul_en_out,
    output [15:0]  mul_out
);

    reg [15:0] pipeline [2:0]; // 3-stage pipeline for partial products sum
    reg [7:0]  mul_a_reg, mul_b_reg; // Input registers
    reg        mul_en_in_reg, mul_en_out_reg; // Enable registers

    wire [15:0] partial_product [7:0]; // Array to hold partial products

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_product[i] = mul_a_reg & {8{mul_b_reg[i]}};
        end
    endgenerate

    // Pipeline stages logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_a_reg       <= 0;
            mul_b_reg       <= 0;
            mul_en_in_reg   <= 0;
            mul_en_out_reg  <= 0;
            pipeline[0]     <= 0;
            pipeline[1]     <= 0;
            pipeline[2]     <= 0;
        end else begin
            // Input registers update
            if (mul_en_in) begin
                mul_a_reg     <= mul_a;
                mul_b_reg     <= mul_b;
            end

            // Enable signal pipeline update
            mul_en_in_reg   <= mul_en_in; // Register input enable
            mul_en_out_reg  <= mul_en_in_reg; // Register output enable

            // First pipeline stage
            pipeline[0]     <= partial_product[0] + (partial_product[1] << 1);

            // Second pipeline stage
            pipeline[1]     <= pipeline[0] + (partial_product[2] << 2) + (partial_product[3] << 3);

            // Third pipeline stage, final sum
            pipeline[2]     <= pipeline[1] + (partial_product[4] << 4) + (partial_product[5] << 5) +
                               (partial_product[6] << 6) + (partial_product[7] << 7);
        end
    end

    // Output assignment
    assign mul_out = (mul_en_out_reg) ? pipeline[2] : 16'd0;
    assign mul_en_out = mul_en_out_reg;

endmodule