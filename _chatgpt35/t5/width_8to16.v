module width_8to16 (
  input wire clk,
  input wire rst_n,
  input wire valid_in,
  input wire [7:0] data_in,
  output wire valid_out,
  output wire [15:0] data_out
);

  reg [7:0] data_lock;
  reg [7:0] data_in_reg;
  reg [1:0] counter;
  reg flag;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_lock <= 8'b0;
      data_in_reg <= 8'b0;
      counter <= 2'b0;
      flag <= 0;
    end else begin
      if (valid_in) begin
        data_in_reg <= data_in;
        flag <= 1;
      end else begin
        flag <= 0;
      end

      case (counter)
        2'b00:
          data_lock <= data_in_reg;
        2'b01:
          data_out <= {data_lock, data_in_reg};
          valid_out <= flag;
        default:
          valid_out <= 0;
      end

      if (counter == 2'b01)
        counter <= 2'b00;
      else if (valid_in)
        counter <= counter + 1;
    end
  end

endmodule