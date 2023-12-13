module pulse_detect (
  input clk,
  input rst_n,
  input data_in,
  output reg data_out
);

  reg [1:0] state;

  parameter IDLE = 2'b00;
  parameter DETECT = 2'b01;
  parameter PULSE_END = 2'b10;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= IDLE;
      data_out <= 1'b0;
    end
    else begin
      case (state)
        IDLE:
          if (data_in == 1'b1)
            state <= DETECT;
          else
            state <= IDLE;
        
        DETECT:
          if (data_in == 1'b0)
            state <= PULSE_END;
          else
            state <= DETECT;
        
        PULSE_END:
          if (data_in == 1'b0)
            state <= IDLE;
          else
            state <= DETECT;
      endcase

      if (state == PULSE_END)
        data_out <= 1'b1;
      else
        data_out <= 1'b0;
    end
  end

endmodule