module multi_pipe_8bit(
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    reg [7:0] mul_a_reg, mul_b_reg;
    reg mul_en_in_reg;
    reg [15:0] partials[7:0]; // Array to store partial products
    reg [15:0] partial_sum;   // Register to store partial sum

    // Pipeline stage registers
    reg [15:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    // Input control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_in_reg <= 0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_in_reg <= mul_en_in;
        end
    end

    // Generate partial products
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                partials[i] <= 0;
        end else if (mul_en_in_reg) begin
            for (i = 0; i < 8; i = i + 1)
                partials[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 0;
        end
    end

    // Calculate partial sums and pipeline them through the stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum <= 0;
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            stage4 <= 0;
            stage5 <= 0;
            stage6 <= 0;
            stage7 <= 0;
        end else begin
            partial_sum <= partials[0] + partials[1];
            stage1 <= partial_sum + partials[2];
            stage2 <= stage1 + partials[3];
            stage3 <= stage2 + partials[4];
            stage4 <= stage3 + partials[5];
            stage5 <= stage4 + partials[6];
            stage6 <= stage5 + partials[7];
            stage7 <= stage6;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
            mul_en_out <= 0;
        end else begin
            mul_out <= stage7;
            mul_en_out <= mul_en_in_reg;
        end
    end

endmodule