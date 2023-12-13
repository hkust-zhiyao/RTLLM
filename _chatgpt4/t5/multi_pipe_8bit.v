module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Define internal registers
reg [7:0] reg_mul_a, reg_mul_b;
reg [15:0] reg_mul_out;
reg [7:0] partial_products[7:0];
reg [15:0] sum[6:0]; // 7 stages of addition
reg [7:0] mul_en_pipeline;

// Input register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_mul_a <= 0;
        reg_mul_b <= 0;
        mul_en_pipeline <= 0;
    end else if (mul_en_in) begin
        reg_mul_a <= mul_a;
        reg_mul_b <= mul_b;
        mul_en_pipeline <= {mul_en_pipeline[6:0], mul_en_in}; // Shift enable signal through the pipeline
    end
end

// Generate partial products
integer i;
always @(posedge clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        partial_products[i] <= reg_mul_a & {8{reg_mul_b[i]}};
    end
end

// Addition pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum[0] <= 0;
        sum[1] <= 0;
        sum[2] <= 0;
        sum[3] <= 0;
        sum[4] <= 0;
        sum[5] <= 0;
        sum[6] <= 0;
        reg_mul_out <= 0;
    end else begin
        // Perform the additions in a pipelined manner
        sum[0] <= partial_products[0] + (partial_products[1] << 1);
        sum[1] <= partial_products[2] + (partial_products[3] << 2);
        sum[2] <= partial_products[4] + (partial_products[5] << 4);
        sum[3] <= partial_products[6] + (partial_products[7] << 6);
        sum[4] <= sum[0] + (sum[1] << 2);
        sum[5] <= sum[2] + (sum[3] << 4);
        sum[6] <= sum[4] + (sum[5] << 4);
        reg_mul_out <= sum[6];
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
        mul_en_out <= 0;
    end else begin
        mul_out <= reg_mul_out;
        mul_en_out <= mul_en_pipeline[7];
    end
end

endmodule