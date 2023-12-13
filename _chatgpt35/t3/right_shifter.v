module right_shifter (
  input clk,
  input d,
  output reg [7:0] q
);

  always @(posedge clk) begin
    q <= {q[6:0], d};
  end

  initial begin
    q <= 8'b0;
  end

endmodule