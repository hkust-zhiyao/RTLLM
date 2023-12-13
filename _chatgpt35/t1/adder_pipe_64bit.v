module adder_pipe_64bit (
  input clk,
  input rst_n,
  input i_en,
  input [63:0] adda,
  input [63:0] addb,
  output reg [64:0] result,
  output reg o_en
);

  reg [63:0] stage1_adda, stage1_addb;
  reg [63:0] stage2_adda, stage2_addb;
  reg [63:0] stage3_adda, stage3_addb;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      result <= 'b0;
    else if (i_en) begin
      stage1_adda <= adda;
      stage1_addb <= addb;
      stage2_adda <= stage1_adda + stage1_addb;
      stage2_addb <= stage1_adda & stage1_addb;
      stage3_adda <= stage2_adda + stage2_addb;
      stage3_addb <= stage2_adda & stage2_addb;
      result <= {stage3_adda, stage3_addb[63]};
      o_en <= 1'b1;
    end else begin
      o_en <= 1'b0;
    end
  end

endmodule