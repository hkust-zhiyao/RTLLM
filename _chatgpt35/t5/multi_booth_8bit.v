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
    if (reset)
      ctr <= 4'b0000;
    else if (ctr < 4'b1111) begin
      multiplicand <= multiplicand << 1;
      if (multiplier[ctr] == 1'b1)
        p <= p + multiplicand;
      ctr <= ctr + 1;
    end
    else begin
      rdy <= 1'b1;
    end
  end
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      multiplicand <= 8'b0;
      multiplier <= 8'b0;
      p <= 16'b0;
      rdy <= 1'b0;
    end
    else begin
      multiplier <= b;
    end
  end

endmodule