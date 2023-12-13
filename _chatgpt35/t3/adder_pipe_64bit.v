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
  reg [64:0] stage1_sum;
  reg [63:0] stage2_adda, stage2_addb;
  reg [64:0] stage2_sum;
  reg [63:0] stage3_adda, stage3_addb;
  reg [64:0] stage3_sum;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      stage1_adda <= 64'b0;
      stage1_addb <= 64'b0;
      stage1_sum <= 65'b0;
      stage2_adda <= 64'b0;
      stage2_addb <= 64'b0;
      stage2_sum <= 65'b0;
      stage3_adda <= 64'b0;
      stage3_addb <= 64'b0;
      stage3_sum <= 65'b0;
      result <= 65'b0;
      o_en <= 1'b0;
    end
    else begin
      if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_sum <= stage1_adda + stage1_addb;
      end
      else begin
        stage1_adda <= 64'b0;
        stage1_addb <= 64'b0;
        stage1_sum <= 65'b0;
      end
      
      stage2_adda <= stage1_adda;
      stage2_addb <= stage1_addb;
      stage2_sum <= stage1_sum;
      
      stage3_adda <= stage2_adda;
      stage3_addb <= stage2_addb;
      stage3_sum <= stage2_sum;
      
      result <= stage3_sum;
      o_en <= i_en;
    end
  end
endmodule