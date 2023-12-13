module serial2parallel (
  input clk,
  input rst_n,
  input din_serial,
  input din_valid,
  output reg [7:0] dout_parallel,
  output reg dout_valid
);
  reg [3:0] cnt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 0;
      dout_parallel <= 0;
      dout_valid <= 0;
    end
    else begin
      if (din_valid) begin
        if (cnt < 7) begin
          cnt <= cnt + 1;
          dout_parallel <= {dout_parallel[6:0], din_serial};
          dout_valid <= 0;
        end
        else begin
          cnt <= 0;
          dout_parallel <= {dout_parallel[6:0], din_serial};
          dout_valid <= 1;
        end
      end
    end
  end
endmodule