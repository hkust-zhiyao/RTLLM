module pulse_detect(
  input wire clk,
  input wire rst_n,
  input wire data_in,
  output wire data_out
);

  reg [2:0] state;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 3'b000;
      data_out <= 1'b0;
    end else begin
      case (state)
        3'b000: begin
          if (data_in)
            state <= 3'b001;
          else
            state <= 3'b000;
        end
        3'b001: begin
          if (data_in)
            state <= 3'b010;
          else
            state <= 3'b000;
        end
        3'b010: begin
          if (data_in)
            state <= 3'b011;
          else
            state <= 3'b000;
        end
        3'b011: begin
          if (~data_in)
            state <= 3'b100;
          else
            state <= 3'b011;
        end
        3'b100: begin
          if (~data_in)
            state <= 3'b100;
          else
            state <= 3'b000;
        end
      endcase

      if (state == 3'b100)
        data_out <= 1'b1;
      else
        data_out <= 1'b0;
    end
  end

endmodule