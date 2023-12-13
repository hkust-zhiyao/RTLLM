module RAM (
  input wire clk,
  input wire rst_n,
  input wire write_en,
  input wire [2:0] write_addr,
  input wire [3:0] write_data,
  input wire read_en,
  input wire [2:0] read_addr,
  output wire [3:0] read_data
);

  parameter DEPTH = 8;
  parameter WIDTH = 4;

  reg [DEPTH-1:0][WIDTH-1:0] RAM;

  // Write operation
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for (int i = 0; i < DEPTH; i = i + 1)
        RAM[i] <= 4'b0000;
    end else begin
      if (write_en)
        RAM[write_addr] <= write_data;
    end
  end

  // Read operation
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      read_data <= 4'b0000;
    end else begin
      if (read_en)
        read_data <= RAM[read_addr];
      else
        read_data <= 4'b0000;
    end
  end

endmodule