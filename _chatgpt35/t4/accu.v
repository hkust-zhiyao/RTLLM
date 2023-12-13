module accu (
  input clk,
  input rst_n,
  input [7:0] data_in,
  input valid_in,
  output valid_out,
  output reg [9:0] data_out
);

reg [7:0] buffer [0:3];
reg [1:0] count;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    count <= 2'b00;
    data_out <= 10'b0;
  end
  else begin
    if (valid_in) begin
      buffer[count] <= data_in;
      count <= count + 1;
      
      if (count == 2'b11) begin
        data_out <= buffer[0] + buffer[1] + buffer[2] + buffer[3];
        valid_out <= 1'b1;
      end
      else begin
        valid_out <= 1'b0;
      end
    end
  end
end

endmodule