module radix2_div #(parameter DATAWIDTH = 8) (
  input clk,
  input rstn,
  input en,
  input [DATAWIDTH-1:0] dividend,
  input [DATAWIDTH-1:0] divisor,
  output ready,
  output [DATAWIDTH-1:0] quotient,
  output [DATAWIDTH-1:0] remainder,
  output vld_out
);

  reg [2:0] current_state, next_state;
  reg [DATAWIDTH:0] dividend_e, divisor_e;
  reg [DATAWIDTH-1:0] quotient_e, remainder_e;
  reg [DATAWIDTH-1:0] shifted_dividend;

  reg [DATAWIDTH:0] count;

  parameter IDLE = 3'b000;
  parameter SUB = 3'b001;
  parameter SHIFT = 3'b010;
  parameter DONE = 3'b011;

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      current_state <= IDLE;
      next_state <= IDLE;
      dividend_e <= 0;
      divisor_e <= 0;
      quotient_e <= 0;
      remainder_e <= 0;
      shifted_dividend <= 0;
      count <= 0;
    end
    else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    next_state = current_state;

    case (current_state)
      IDLE:
        if (en)
          next_state = SUB;
      
      SUB:
        if (count == DATAWIDTH) begin
          next_state = SHIFT;
          count <= 0;
        end

      SHIFT:
        if (count == DATAWIDTH) begin
          next_state = DONE;
          count <= 0;
        end

      DONE:
        if (~en)
          next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (en) begin
      case (current_state)
        IDLE:
          dividend_e <= {1'b0, dividend};
          divisor_e <= {1'b0, divisor};
          quotient_e <= 0;
          remainder_e <= 0;

        SUB:
          if (dividend_e >= divisor_e) begin
            dividend_e <= dividend_e - divisor_e;
            quotient_e <= quotient_e + (1 << count);
          end

        SHIFT:
          shifted_dividend <= dividend_e << 1;
          count <= count + 1;

        DONE:
          quotient_e <= quotient_e[DATAWIDTH-1:0];
          remainder_e <= dividend_e[DATAWIDTH-1:0];
      endcase
    end
  end

  assign ready = (current_state == IDLE);
  assign quotient = quotient_e[DATAWIDTH-1:0];
  assign remainder = remainder_e[DATAWIDTH-1:0];
  assign vld_out = (current_state == DONE);

endmodule