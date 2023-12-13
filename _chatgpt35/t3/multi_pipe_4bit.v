module multi_pipe_4bit(
  input wire clk,
  input wire rst_n,
  input wire [3:0] mul_a,
  input wire [3:0] mul_b,
  output wire [7:0] mul_out
);

  parameter size = 4;

  reg [7:0] regs [0:size-1];
  wire [7:0] partial_products [0:size-1];

  // Extension of input signals
  wire [7:0] extended_mul_a;
  wire [7:0] extended_mul_b;
  assign extended_mul_a = {4'b0, mul_a};
  assign extended_mul_b = {4'b0, mul_b};

  // Partial product generation
  genvar i;
  generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_PRODUCTS_GEN
      assign partial_products[i] = extended_mul_a << i;
    end
  endgenerate

  // Register and add operations
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      for (i = 0; i < size; i = i + 1) begin
        regs[i] <= 8'b0;
      end
    end else begin
      // Add operation
      for (i = 0; i < size; i = i + 1) begin
        if (partial_products[i] != 8'b0) begin
          regs[i] <= regs[i] + partial_products[i];
        end
      end
    end
  end

  // Final product calculation
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      mul_out <= 8'b0;
    end else begin
      // Product calculation
      mul_out <= regs[size-1];
    end
  end

endmodule