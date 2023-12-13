module multi_pipe_8bit (
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
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      mul_en_out_reg <= 1'b0;
      mul_a_reg <= 8'd0;
      mul_b_reg <= 8'd0;
      mul_out_reg <= 16'd0;
      for (int i = 0; i < 8; i = i + 1) begin
        sum[i] <= 16'd0;
      end
    end
    else begin
      // Input control
      mul_en_out_reg <= mul_en_in;
      
      // Input registers
      if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
      end
      
      // Partial product generation
      for (int i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i]) begin
          temp[i] <= mul_a_reg << i;
        end
        else begin
          temp[i] <= 8'd0;
        end
      end
      
      // Partial sum calculation
      for (int i = 0; i < 8; i = i + 1) begin
        if (i == 0) begin
          sum[i] <= temp[i];
        end
        else begin
          sum[i] <= sum[i-1] + temp[i];
        end
      end
      
      // Final product calculation
      mul_out_reg <= sum[7];
    end
  end
  
  assign mul_en_out = mul_en_out_reg[7];
  assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'd0;

endmodule