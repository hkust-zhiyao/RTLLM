module chatgpt4_generate_multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    reg [7:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] prod_reg;
    reg [3:0] stage;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            a_reg <= 8'h0;
            b_reg <= 8'h0;
            prod_reg <= 16'h0;
            stage <= 4'h0;
            mul_en_out <= 1'b0;
        end
        else begin
            case (stage)
                4'h0: begin
                    a_reg <= mul_a;
                    b_reg <= mul_b;
                    prod_reg <= 16'h0;
                    stage <= 4'h1;
                    mul_en_out <= mul_en_in;
                end
                4'h1: begin
                    prod_reg <= {8'h0, a_reg} * {8'h0, b_reg};
                    stage <= 4'h2;
                end
                4'h2: begin
                    prod_reg <= prod_reg + {8'h0, a_reg} * {8'h0, b_reg};
                    stage <= 4'h3;
                end
                4'h3: begin
                    mul_out <= prod_reg;
                    stage <= 4'h0;
                    mul_en_out <= 1'b0;
                end
            endcase
        end
    end

endmodule