module RAM #(
  parameter WIDTH = 4,
  parameter DEPTH = 8
)(
  input wire clk,
  input wire rst_n,
  input wire write_en,
  input wire [WIDTH-1:0] write_addr,
  input wire [DEPTH-1:0] write_data,
  input wire read_en,
  input wire [WIDTH-1:0] read_addr,
  output reg [DEPTH-1:0] read_data
);

  reg [DEPTH-1:0] RAM [2**WIDTH-1:0];
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      for (int i = 0; i < 2**WIDTH; i = i + 1) begin
        RAM[i] <= 0;
      end
    end
    else begin
      if (write_en) begin
        RAM[write_addr] <= write_data;
      end
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      read_data <= 0;
    end
    else begin
      if (read_en) begin
        read_data <= RAM[read_addr];
      end
      else begin
        read_data <= 0;
      end
    end
  end

endmodule