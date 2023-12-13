module pulse_detect (
  input wire clk,
  input wire rst_n,
  input wire data_in,
  output wire data_out
);

  reg [1:0] state;
  reg data_out_reg;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      // Reset condition
      state <= 2'b00;
      data_out_reg <= 1'b0;
    end
    else begin
      case (state)
        2'b00: begin
          if (data_in) begin
            state <= 2'b01;
          end
        end
        2'b01: begin
          if (~data_in) begin
            state <= 2'b10;
          end
        end
        2'b10: begin
          if (data_in) begin
            state <= 2'b11;
            data_out_reg <= 1'b1;
          end
          else begin
            state <= 2'b00;
            data_out_reg <= 1'b0;
          end
        end
        2'b11: begin
          if (~data_in) begin
            state <= 2'b00;
            data_out_reg <= 1'b0;
          end
        end
      endcase
    end
  end
  
  assign data_out = data_out_reg;

endmodule