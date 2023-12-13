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
      cnt <= 4'b0000;
      dout_parallel <= 8'b0;
      dout_valid <= 0;
    end else begin
      if (din_valid) begin
        if (cnt == 4'b0111) begin
          dout_parallel <= {din_serial, dout_parallel[7:1]};
          dout_valid <= 1;
          cnt <= 4'b1000;
        end else begin
          dout_valid <= 0;
          cnt <= cnt + 1;
        end
      end
    end
  end

endmodule