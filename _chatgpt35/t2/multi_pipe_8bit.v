module multi_pipe_8bit (
  input clk,
  input rst_n,
  input mul_en_in,
  input [7:0] mul_a,
  input [7:0] mul_b,
  output reg mul_en_out,
  output reg [15:0] mul_out
);

  reg [7:0] mul_a_reg;
  reg [7:0] mul_b_reg;

  wire [15:0] temp;
  reg [15:0] sum [0:7];
  reg [15:0] mul_out_reg;

  always @(posedge clk) begin
    if (~rst_n) begin
      mul_en_out <= 1'b0;
      mul_a_reg <= 8'b0;
      mul_b_reg <= 8'b0;
      mul_out_reg <= 16'b0;
      for (genvar i = 0; i < 8; i = i + 1) begin
        sum[i] <= 16'b0;
      end
    end else begin
      mul_en_out <= mul_en_in;
      if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
      end
      temp <= {mul_a_reg, 8'b0} & {8'b0, mul_b_reg};
      for (genvar i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i]) begin
          sum[i] <= temp[15:0];
        end else begin
          sum[i] <= 16'b0;
        end
      end
      mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      mul_out <= 16'b0;
    end else begin
      if (mul_en_out) begin
        mul_out <= mul_out_reg;
      end else begin
        mul_out <= 16'b0;
      end
    end
  end

endmodule