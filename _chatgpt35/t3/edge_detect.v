module edge_detect (
  input clk,
  input rst_n,
  input a,
  output reg rise,
  output reg down
);
  
  reg a_prev;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      a_prev <= 1'b0;
    else
      a_prev <= a;
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      rise <= (a == 1'b1) && (a_prev == 1'b0);
      down <= (a == 1'b0) && (a_prev == 1'b1);
    end
  end
  
endmodule