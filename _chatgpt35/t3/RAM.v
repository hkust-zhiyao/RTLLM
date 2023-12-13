module RAM #(parameter WIDTH = 4, parameter DEPTH = 8) (
  input clk,
  input rst_n,
  input write_en,
  input [WIDTH-1:0] write_addr,
  input [DEPTH-1:0] write_data,
  input read_en,
  input [WIDTH-1:0] read_addr,
  output reg [DEPTH-1:0] read_data
);

  reg [DEPTH-1:0][WIDTH-1:0] RAM;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for (int i = 0; i < (2**WIDTH); i = i + 1)
        RAM[i] <= 'b0;
    end
    else begin
      if (write_en)
        RAM[write_addr] <= write_data;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      read_data <= 'b0;
    else begin
      if (read_en)
        read_data <= RAM[read_addr];
      else
        read_data <= 'b0;
    end
  end

endmodule