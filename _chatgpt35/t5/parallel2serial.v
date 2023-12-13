module parallel2serial (
  input clk,
  input rst_n,
  input [3:0] d,
  output valid_out,
  output dout
);

  reg [2:0] cnt;
  reg [3:0] data;
  wire valid;

  // Counter Register
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      cnt <= 3'b0;
    else if (cnt == 3)
      cnt <= 3'b0;
    else
      cnt <= cnt + 1;
  end

  // Data Register and Valid Signal Generation
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      data <= 4'b0;
      valid <= 1'b0;
    end
    else if (cnt == 3) begin
      data <= d;
      valid <= 1'b1;
    end
    else begin
      data <= {data[2:0], d[3]};
      valid <= 1'b0;
    end
  end

  // Output Assignment
  assign valid_out = valid;
  assign dout = data[3];

endmodule