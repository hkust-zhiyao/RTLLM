module multi_booth_8bit (
  input clk,
  input reset,
  input [7:0] a,
  input [7:0] b,
  output reg [15:0] p,
  output reg rdy
);

  reg [3:0] ctr;
  reg [7:0] multiplicand;
  reg [7:0] multiplier;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ctr <= 4'b0000;
      multiplicand <= 8'b0;
      multiplier <= 8'b0;
      p <= 16'b0;
      rdy <= 0;
    end
    else begin
      if (ctr < 4'b10000) begin
        multiplicand <= multiplicand << 1;
        if (multiplier[ctr] == 1)
          p <= p + multiplicand;
        ctr <= ctr + 1;
      end
      else begin
        rdy <= 1;
      end
    end
  end

  always @(posedge clk) begin
    if (reset)
      p <= 16'b0;
  end

endmodule