module parallel2serial(
  input wire clk,
  input wire rst_n,
  input wire [3:0] d,
  output wire valid_out,
  output wire dout
);

  reg [2:0] cnt;
  reg [3:0] data;

  always @(posedge clk) begin
    if (rst_n == 0) begin
      cnt <= 0;
      data <= 0;
      valid_out <= 0;
      dout <= 0;
    end else begin
      if (cnt == 3) begin
        cnt <= 0;
        data <= d;
        valid_out <= 1;
      end else begin
        cnt <= cnt + 1;
        data <= {data[2:0], d[3]};
        valid_out <= 0;
      end
    end
  end

  assign dout = data[3];

endmodule