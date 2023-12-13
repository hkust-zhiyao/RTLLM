module serial2parallel (
  input wire clk,
  input wire rst_n,
  input wire din_serial,
  input wire din_valid,
  output wire [7:0] dout_parallel,
  output wire dout_valid
);
  reg [3:0] cnt;
  reg [7:0] parallel_data;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 0;
      parallel_data <= 0;
    end
    else begin
      if (din_valid) begin
        if (cnt == 7) begin
          parallel_data <= {parallel_data[6:0], din_serial};
          dout_valid <= 1;
        end
        else begin
          parallel_data <= {parallel_data[6:0], din_serial};
          dout_valid <= 0;
          cnt <= cnt + 1;
        end
      end
    end
  end
  
  assign dout_parallel = parallel_data;
  
endmodule