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
    if (~rst_n)
      mul_en_out <= 1'b0;
    else
      mul_en_out <= mul_en_in;
  end
  
  always @(posedge clk) begin
    if (~rst_n)
      mul_a_reg <= 8'b0;
    else if (mul_en_in)
      mul_a_reg <= mul_a;
  end
  
  always @(posedge clk) begin
    if (~rst_n)
      mul_b_reg <= 8'b0;
    else if (mul_en_in)
      mul_b_reg <= mul_b;
  end
  
  assign temp = {mul_a_reg, 8'b0} & {mul_b_reg, 8'b0};
  
  always @(posedge clk) begin
    if (~rst_n) begin
      for (int i = 0; i < 8; i = i + 1)
        sum[i] <= 16'b0;
    end
    else if (mul_en_in) begin
      for (int i = 0; i < 8; i = i + 1)
        sum[i] <= sum[i] + temp[2*i+:16];
    end
  end
  
  always @(posedge clk) begin
    if (~rst_n)
      mul_out_reg <= 16'b0;
    else if (mul_en_in)
      mul_out_reg <= sum[7];
  end
  
  always @(mul_en_out, mul_out_reg) begin
    if (mul_en_out)
      mul_out <= mul_out_reg;
    else
      mul_out <= 16'b0;
  end
endmodule