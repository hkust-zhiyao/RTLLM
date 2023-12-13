module multi_pipe_4bit (
  input clk,
  input rst_n,
  input [3:0] mul_a,
  input [3:0] mul_b,
  output [7:0] mul_out
);

  parameter size = 4;
  reg [7:0] partial_products [0:size-1];
  reg [7:0] registers [0:size-1];

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      for (int i = 0; i < size; i = i + 1) begin
        partial_products[i] <= 8'b0;
        registers[i] <= 8'b0;
      end
    end
    else begin
      // Multiplication operation
      for (int i = 0; i < size; i = i + 1) begin
        if (mul_b[i] == 1'b1)
          partial_products[i] <= {mul_a, {8{i}}};
        else
          partial_products[i] <= 8'b0;
      end

      // Addition of partial products
      for (int i = 0; i < size; i = i + 1) begin
        if (~rst_n)
          registers[i] <= 8'b0;
        else
          registers[i] <= partial_products[i] + registers[i];
      end

      // Final product calculation
      if (~rst_n)
        mul_out <= 8'b0;
      else
        mul_out <= registers[size-1];
    end
  end

endmodule