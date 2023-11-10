module chatgpt_generate_right_shifter (
  input      clk,
  input      d,
  output reg [7:0] q
);

always @(posedge clk) begin
  // Shift the contents of the q register to the right by one bit
  q <= {q[6:0], d};
end

initial begin
  // Initialize the q register to 0
  q <= 8'b0;
end

endmodule