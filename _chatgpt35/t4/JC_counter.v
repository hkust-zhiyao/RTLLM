module JC_counter (
  input clk,
  input rst_n,
  output reg [63:0] Q
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      Q <= 64'b0;
    else begin
      if (Q[0] == 1)
        Q <= {Q[62:0], 1'b0};
      else
        Q <= {Q[62:0], 1'b1};
    end
  end

endmodule