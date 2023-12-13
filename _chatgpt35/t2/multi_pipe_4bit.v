module multi_pipe_4bit (
  input clk,
  input rst_n,
  input [3:0] mul_a,
  input [3:0] mul_b,
  output reg [7:0] mul_out
);

  parameter size = 4;

  reg [7:0] partial_products [0:size-1];
  reg [7:0] registers [0:size-1];

  always @(mul_a, mul_b) begin
    for (genvar i = 0; i < size; i = i + 1) begin
      if (mul_b[i] == 1'b1) begin
        partial_products[i] = {mul_a, {size{i{1'b0}}}};
      end else begin
        partial_products[i] = 8'b0;
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for (genvar i = 0; i < size; i = i + 1) begin
        registers[i] <= 8'b0;
      end
    end else begin
      for (genvar i = 0; i < size; i = i + 1) begin
        registers[i] <= registers[i] + partial_products[i];
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      mul_out <= 8'b0;
    end else begin
      mul_out <= registers[size-1];
    end
  end

endmodule