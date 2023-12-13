module multi_pipe_4bit #(
    parameter size = 4
)(
    input wire clk,
    input wire rst_n,
    input wire [size-1:0] mul_a,
    input wire [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Internal signals for partial products and the pipeline registers
    wire [size-1:0] partial_products[size-1:0];
    reg [2*size-1:0] pipeline_reg1[size-1:0];
    reg [2*size-1:0] pipeline_reg2;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a << i) : 0;
        end
    endgenerate

    // Pipeline stage 1 - partial product accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the pipeline registers
            for (i = 0; i < size; i = i + 1) begin
                pipeline_reg1[i] <= 0;
            end
        end else begin
            // Load the partial products into pipeline stage 1
            for (i = 0; i < size; i = i + 1) begin
                pipeline_reg1[i] <= {{(size){partial_products[i][size-1]}}, partial_products[i]};
            end
        end
    end

    // Pipeline stage 2 - final sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pipeline_reg2 <= 0;
            mul_out <= 0;
        end else begin
            // Add the partial products from pipeline stage 1
            pipeline_reg2 <= pipeline_reg1[0] +
                             pipeline_reg1[1] +
                             pipeline_reg1[2] +
                             pipeline_reg1[3];
            // Update the product output
            mul_out <= pipeline_reg2;
        end
    end

endmodule