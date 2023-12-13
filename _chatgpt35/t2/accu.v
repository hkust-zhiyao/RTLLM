module accu (
  input clk,
  input rst_n,
  input [7:0] data_in,
  input valid_in,
  output reg valid_out,
  output reg [9:0] data_out
);

  reg [9:0] accumulator;
  reg [3:0] count;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      accumulator <= 10'b0;
      count <= 4'b0;
      valid_out <= 1'b0;
    end
    else begin
      if (valid_in) begin
        accumulator <= accumulator + data_in;
        count <= count + 1'b1;
        
        if (count == 4'b11) begin
          data_out <= accumulator;
          valid_out <= 1'b1;
        end
        else begin
          valid_out <= 1'b0;
        end
      end
    end
  end

endmodule