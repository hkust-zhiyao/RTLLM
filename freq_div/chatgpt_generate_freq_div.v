module chatgpt_generate_freq_div (
  input CLK_in,
  input RST,
  output reg CLK_50,
  output reg CLK_10,
  output reg CLK_1
);

reg [25:0] counter_50mhz = 0;
reg [27:0] counter_10mhz = 0;
reg [29:0] counter_1mhz = 0;

always @(posedge CLK_in) begin
  if (RST) begin
    counter_50mhz <= 0;
    counter_10mhz <= 0;
    counter_1mhz <= 0;
    CLK_50 <= 1'b0;
    CLK_10 <= 1'b0;
    CLK_1 <= 1'b0;
  end else begin
    counter_50mhz <= counter_50mhz + 1;
    counter_10mhz <= counter_10mhz + 1;
    counter_1mhz <= counter_1mhz + 1;
    
    if (counter_50mhz == 999_999) begin
      counter_50mhz <= 0;
      CLK_50 <= ~CLK_50;
    end
    
    if (counter_10mhz == 49_999_999) begin
      counter_10mhz <= 0;
      CLK_10 <= ~CLK_10;
    end
    
    if (counter_1mhz == 99_999_999) begin
      counter_1mhz <= 0;
      CLK_1 <= ~CLK_1;
    end
  end
end

endmodule
