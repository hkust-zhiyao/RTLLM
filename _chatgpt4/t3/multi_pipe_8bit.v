module multi_pipe_8bit(
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Intermediate registers for pipelined stages
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [15:0] partial_products [7:0];
    reg [15:0] sum [6:0]; // 7 intermediate sums
    reg mul_en_out_reg; // Register for mul_en_in signal

    // Input control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= mul_en_in;
        end
    end

    // Generate partial products
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                partial_products[i] <= 0;
            end
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                partial_products[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 0;
            end
        end
    end

    // Calculate the intermediate sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 7; i = i + 1) begin
                sum[i] <= 0;
            end
        end else begin
            sum[0] <= partial_products[0] + partial_products[1];
            sum[1] <= partial_products[2] + partial_products[3];
            sum[2] <= partial_products[4] + partial_products[5];
            sum[3] <= partial_products[6] + partial_products[7];
            sum[4] <= sum[0] + sum[1];
            sum[5] <= sum[2] + sum[3];
            sum[6] <= sum[4] + sum[5];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
            mul_en_out <= 0;
        end else begin
            mul_out <= sum[6];
            mul_en_out <= mul_en_out_reg;
        end
    end

endmodule