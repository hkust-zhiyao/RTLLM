module multi_pipe_8bit(
  input wire clk,
  input wire rst_n,
  input wire mul_en_in,
  input wire [7:0] mul_a,
  input wire [7:0] mul_b,
  output wire mul_en_out,
  output wire [15:0] mul_out
);

  reg mul_en_out_reg;
  reg [7:0] mul_a_reg;
  reg [7:0] mul_b_reg;
  wire [7:0] temp [0:7];
  reg [15:0] sum [0:7];
  reg [15:0] mul_out_reg;

  // Input control
  always @(posedge clk) begin
    if (rst_n == 0) begin
      mul_en_out_reg <= 0;
    end else begin
      mul_en_out_reg <= mul_en_in;
    end
  end

  // Input registers
  always @(posedge clk) begin
    if (rst_n == 0) begin
      mul_a_reg <= 0;
      mul_b_reg <= 0;
    end else if (mul_en_in) begin
      mul_a_reg <= mul_a;
      mul_b_reg <= mul_b;
    end
  end

  // Partial product generation
  assign temp[0] = mul_a_reg & mul_b_reg[0];
  assign temp[1] = mul_a_reg & mul_b_reg[1];
  assign temp[2] = mul_a_reg & mul_b_reg[2];
  assign temp[3] = mul_a_reg & mul_b_reg[3];
  assign temp[4] = mul_a_reg & mul_b_reg[4];
  assign temp[5] = mul_a_reg & mul_b_reg[5];
  assign temp[6] = mul_a_reg & mul_b_reg[6];
  assign temp[7] = mul_a_reg & mul_b_reg[7];

  // Partial sum calculation
  always @(posedge clk) begin
    if (rst_n == 0) begin
      sum <= 0;
    end else if (mul_en_in) begin
      sum[0] <= temp[0];
      sum[1] <= temp[1] + temp[0];
      sum[2] <= temp[2] + temp[1];
      sum[3] <= temp[3] + temp[2];
      sum[4] <= temp[4] + temp[3];
      sum[5] <= temp[5] + temp[4];
      sum[6] <= temp[6] + temp[5];
      sum[7] <= temp[7] + temp[6];
    end
  end

  // Final product calculation
  always @(posedge clk) begin
    if (rst_n == 0) begin
      mul_out_reg <= 0;
    end else if (mul_en_in) begin
      mul_out_reg <= sum[7];
    end
  end

  // Output assignment
  assign mul_en_out = mul_en_out_reg;
  assign mul_out = mul_en_out_reg ? mul_out_reg : 16'b0;

endmodule