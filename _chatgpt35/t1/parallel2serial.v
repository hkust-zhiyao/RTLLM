module parallel2serial (
  input clk,
  input rst_n,
  input [3:0] d,
  output reg valid_out,
  output reg dout
);
  reg [2:0] cnt;
  reg [3:0] data;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      cnt <= 3'b0;
    else if (cnt == 3'b11)
      cnt <= 3'b0;
    else
      cnt <= cnt + 1;
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      data <= 4'b0;
    else if (cnt == 3'b0)
      data <= d;
    else
      data <= {data[2:0], 1'b0};
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      valid_out <= 1'b0;
    else if (cnt == 3'b0)
      valid_out <= 1'b1;
    else
      valid_out <= 1'b0;
  end
  
  always @(posedge clk) begin
    if (valid_out)
      dout <= data[3];
  end
endmodule