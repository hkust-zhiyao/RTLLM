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
    if (~rst_n) begin
      cnt <= 3'b0;
      data <= 4'b0;
      valid_out <= 1'b0;
      dout <= 1'b0;
    end else begin
      if (cnt == 3'b11) begin
        cnt <= 3'b0;
        data <= d;
        valid_out <= 1'b1;
        dout <= data[3];
      end else begin
        cnt <= cnt + 1;
        valid_out <= 1'b0;
        data <= {data[2:0], 1'b0};
        dout <= data[3];
      end
    end
  end

endmodule