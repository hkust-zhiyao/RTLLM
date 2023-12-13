module pe(
  input wire clk,
  input wire rst,
  input wire [31:0] a,
  input wire [31:0] b,
  output wire [31:0] c
);

  reg [31:0] c_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      c_reg <= 0;
    end else begin
      c_reg <= c_reg + (a * b);
    end
  end

  assign c = c_reg;

endmodule