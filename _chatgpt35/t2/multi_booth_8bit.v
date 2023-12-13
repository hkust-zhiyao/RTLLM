module multi_booth_8bit (
  input clk,
  input reset,
  input [7:0] a,
  input [7:0] b,
  output reg [15:0] p,
  output reg rdy
);

  reg [7:0] multiplicand;
  reg [7:0] multiplier;
  reg [3:0] ctr;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      multiplicand <= 8'b0;
      multiplier <= 8'b0;
      ctr <= 4'b0;
      p <= 16'b0;
      rdy <= 1'b0;
    end else begin
      if (ctr < 4'd16) begin
        multiplicand <= multiplicand << 1;
        if (multiplier[ctr] == 1'b1) begin
          p <= p + multiplicand;
        end
        ctr <= ctr + 1;
      end else begin
        rdy <= 1'b1;
      end
    end
  end

endmodule