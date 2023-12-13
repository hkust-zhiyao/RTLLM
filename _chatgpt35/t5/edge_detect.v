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
      rise <= 0;
      down <= 0;
      a_prev <= 0;
    end
    else begin
      if (a && ~a_prev)
        rise <= 1;
      else
        rise <= 0;

      if (~a && a_prev)
        down <= 1;
      else
        down <= 0;

      a_prev <= a;
    end
  end

endmodule