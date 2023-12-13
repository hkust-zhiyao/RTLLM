module right_shifter (
  input wire clk,
  input wire d,
  output wire [7:0] q
);

  reg [7:0] q;

  always @(posedge clk) begin
    q <= {q[6:0], d};
  end

endmodule