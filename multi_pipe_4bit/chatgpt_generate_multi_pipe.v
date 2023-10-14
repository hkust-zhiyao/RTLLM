module chatgpt_generate_multi_pipe(
  input clk,
  input rst_n,
  input [3:0] mul_a,
  input [3:0] mul_b,
  output reg [7:0] mul_out
);

reg [3:0] a_reg;
reg [3:0] b_reg;
reg [7:0] product;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 4'b0;
        b_reg <= 4'b0;
        product <= 8'b0;
    end
    else begin
        a_reg <= mul_a;
        b_reg <= mul_b;
        product <= {4'b0, a_reg} * {4'b0, b_reg};
    end
end

assign mul_out = product;

endmodule
