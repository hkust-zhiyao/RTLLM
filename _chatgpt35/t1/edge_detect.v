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
    end
    else begin
      if (a == 1'b1 && a_prev == 1'b0)
        rise <= 1'b1;
      else if (a == 1'b0 && a_prev == 1'b1)
        down <= 1'b1;
      else begin
        rise <= 1'b0;
        down <= 1'b0;
      end
      
      a_prev <= a;
    end
  end
endmodule