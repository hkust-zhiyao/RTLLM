module serial2parallel (
  input wire clk,
  input wire rst_n,
  input wire din_serial,
  input wire din_valid,
  output reg [7:0] dout_parallel,
  output reg dout_valid
);

  reg [3:0] cnt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 4'b0000;
      dout_parallel <= 8'b0;
      dout_valid <= 0;
    end else begin
      if (din_valid) begin
        if (cnt < 4'b1000) begin
          cnt <= cnt + 1;
          dout_parallel[cnt] <= din_serial;
        end else begin
          dout_valid <= 1;
        end
      end
    end
  end

endmodule