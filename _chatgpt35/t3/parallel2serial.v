module parallel2serial (
  input wire clk,
  input wire rst_n,
  input wire [3:0] d,
  output wire valid_out,
  output wire dout
);

  reg [2:0] cnt;
  reg [3:0] data;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      cnt <= 3'b0;
      data <= 4'd0;
    end
    else begin
      if (cnt == 3) begin
        // Last bit of parallel input
        cnt <= 3'b0;
        data <= d;
        valid_out <= 1'b1;
      end
      else begin
        // Shift data and increment counter
        cnt <= cnt + 1;
        data <= {data[2:0], d[3]};
        valid_out <= 1'b0;
      end
    end
  end
  
  assign dout = data[3];

endmodule