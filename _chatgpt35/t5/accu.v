module accu (
  input clk,
  input rst_n,
  input [7:0] data_in,
  input valid_in,
  output reg valid_out,
  output reg [9:0] data_out
);
  
  reg [7:0] accumulator [0:3];
  reg [2:0] count;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      count <= 0;
      valid_out <= 0;
      data_out <= 0;
      accumulator <= 0;
    end
    else begin
      if (valid_in) begin
        accumulator[count] <= data_in;
        count <= count + 1;
        
        if (count == 3) begin
          data_out <= accumulator[0] + accumulator[1] + accumulator[2] + accumulator[3];
          valid_out <= 1;
        end
        else begin
          data_out <= 0;
          valid_out <= 0;
        end
      end
      else begin
        data_out <= 0;
        valid_out <= 0;
      end
    end
  end
  
endmodule