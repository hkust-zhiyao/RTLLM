module edge_detect (
  input clk,
  input rst_n,
  input a,
  output reg rise,
  output reg down
);

  reg a_prev;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rise <= 1'b0;
      down <= 1'b0;
      a_prev <= 1'b0;
    end else begin
      if (a_prev == 1'b0 && a == 1'b1) begin
        rise <= 1'b1;
      end else if (a_prev == 1'b1 && a == 1'b0) begin
        down <= 1'b1;
      end else begin
        rise <= 1'b0;
        down <= 1'b0;
      end
      a_prev <= a;
    end
  end

endmodule