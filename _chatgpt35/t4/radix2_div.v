module radix2_div #(
  parameter DATAWIDTH = 8
)(
  input wire clk,
  input wire rstn,
  input wire en,
  input wire [DATAWIDTH-1:0] dividend,
  input wire [DATAWIDTH-1:0] divisor,
  output wire ready,
  output wire [DATAWIDTH-1:0] quotient,
  output wire [DATAWIDTH-1:0] remainder,
  output wire vld_out
);

  reg [2:0] current_state;
  reg [2:0] next_state;

  reg [DATAWIDTH:0] dividend_e;
  reg [DATAWIDTH-1:0] divisor_e;
  reg [DATAWIDTH-1:0] quotient_e;
  reg [DATAWIDTH-1:0] remainder_e;
  reg [3:0] count;

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      current_state <= 3'b000;
      next_state <= 3'b000;

      dividend_e <= 0;
      divisor_e <= 0;
      quotient_e <= 0;
      remainder_e <= 0;
      count <= 0;
    end else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    case (current_state)
      3'b000: begin // IDLE state
        ready = 1'b1;
        quotient = 0;
        remainder = 0;
        vld_out = 1'b0;

        if (en)
          next_state = 3'b001;
        else
          next_state = 3'b000;
      end
      3'b001: begin // SUB state
        ready = 1'b0;
        quotient = quotient_e;
        remainder = remainder_e;
        vld_out = 1'b0;

        dividend_e = {dividend, DATAWIDTH'b0};
        divisor_e = {divisor, DATAWIDTH'b0};

        if (dividend_e >= divisor_e)
          next_state = 3'b010;
        else
          next_state = 3'b011;
      end
      3'b010: begin // SHIFT state
        ready = 1'b0;
        quotient = quotient_e;
        remainder = remainder_e;
        vld_out = 1'b0;

        dividend_e = dividend_e - divisor_e;
        quotient_e = quotient_e << 1'b1;
        quotient_e[0] = 1'b1;

        count = count + 1;

        if (count == DATAWIDTH)
          next_state = 3'b100;
        else
          next_state = 3'b010;
      end
      3'b011: begin // DONE state
        ready = 1'b0;
        quotient = quotient_e;
        remainder = dividend;
        vld_out = 1'b1;

        next_state = 3'b000;
      end
      3'b100: begin // DONE state
        ready = 1'b0;
        quotient = quotient_e;
        remainder = dividend;
        vld_out = 1'b1;

        next_state = 3'b000;
      end
    endcase
  end

endmodule