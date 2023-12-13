module multi_pipe_8bit (
  input clk,
  input rst_n,
  input mul_en_in,
  input [7:0] mul_a,
  input [7:0] mul_b,
  output mul_en_out,
  output [15:0] mul_out
);

  reg mul_en_out_reg;
  reg [7:0] mul_a_reg;
  reg [7:0] mul_b_reg;

  wire [15:0] temp [0:7];
  reg [15:0] sum [0:7];
  reg [15:0] mul_out_reg;

  // Input Control
  always @(posedge clk) begin
    if (~rst_n)
      mul_en_out_reg <= 1'b0;
    else
      mul_en_out_reg <= mul_en_in;
  end

  // Input Registers
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

  // Partial Product Generation
  assign temp[0] = {mul_a_reg[0], 7'b0};
  assign temp[1] = {mul_a_reg[1], 7'b0};
  assign temp[2] = {mul_a_reg[2], 7'b0};
  assign temp[3] = {mul_a_reg[3], 7'b0};
  assign temp[4] = {mul_a_reg[4], 7'b0};
  assign temp[5] = {mul_a_reg[5], 7'b0};
  assign temp[6] = {mul_a_reg[6], 7'b0};
  assign temp[7] = {mul_a_reg[7], 7'b0};

  // Partial Sum Calculation
  always @(posedge clk) begin
    if (~rst_n) begin
      for (int i = 0; i < 8; i = i + 1)
        sum[i] <= 16'b0;
    end
    else if (mul_en_in) begin
      for (int i = 0; i < 8; i = i + 1)
        sum[i] <= sum[i] + temp[i];
    end
  end

  // Final Product Calculation
  always @(posedge clk) begin
    if (~rst_n)
      mul_out_reg <= 16'b0;
    else if (mul_en_in) begin
      mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
    end
  end

  // Output Assignment
  assign mul_en_out = mul_en_out_reg;
  assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;

endmodule