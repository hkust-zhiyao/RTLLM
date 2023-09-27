module chatgpt_generate_edge_detect(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);

  reg [1:0] a_prev;
  reg [1:0] a_current;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the circuit
      a_prev <= 2'b0;
      a_current <= 2'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      // Store the previous and current values of signal a
      a_prev <= a_current;
      a_current <= a;
      
      // Detect rising edge
      if (a_current && !a_prev) begin
        rise <= 1'b1;
      end else begin
        rise <= 1'b0;
      end
      
      // Detect falling edge
      if (!a_current && a_prev) begin
        down <= 1'b1;
      end else begin
        down <= 1'b0;
      end
    end
  end

endmodule
