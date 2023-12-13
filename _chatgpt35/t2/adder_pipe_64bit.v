module adder_pipe_64bit (
  input clk,
  input rst_n,
  input i_en,
  input [63:0] adda,
  input [63:0] addb,
  output [64:0] result,
  output o_en
);

  reg [63:0] stage1;
  reg [63:0] stage2;
  reg [63:0] stage3;
  reg o_en_reg;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      stage1 <= 64'b0;
    else
      stage1 <= adda;
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      stage2 <= 64'b0;
    else if (i_en)
      stage2 <= stage1 + addb;
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      stage3 <= 64'b0;
    else if (i_en)
      stage3 <= stage2;
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      o_en_reg <= 1'b0;
    else if (i_en)
      o_en_reg <= 1'b1;
  end
  
  assign result = {stage3, o_en_reg};
  assign o_en = o_en_reg;

endmodule