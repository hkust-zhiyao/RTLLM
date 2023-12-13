module multi_pipe_4bit(
  input wire clk,
  input wire rst_n,
  input wire [3:0] mul_a,
  input wire [3:0] mul_b,
  output wire [7:0] mul_out
);

  parameter size = 4;

  reg [7:0] partial_products [0:size-1];
  reg [7:0] sum_reg;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      sum_reg <= 8'd0;
      for (int i = 0; i < size; i = i + 1) begin
        partial_products[i] <= 8'd0;
      end
    end
    else begin
      // Add operation
      sum_reg <= sum_reg + partial_products[0];
      for (int i = 0; i < size - 1; i = i + 1) begin
        partial_products[i] <= partial_products[i + 1];
      end
      if (mul_b[0]) begin
        partial_products[size - 1] <= {mul_a, 4'd0} << 0;
      end
      else begin
        partial_products[size - 1] <= 8'd0;
      end
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      mul_out <= 8'd0;
    end
    else begin
      // Final product calculation
      mul_out <= sum_reg;
    end
  end

endmodule