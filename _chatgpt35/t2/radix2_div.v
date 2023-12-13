module radix2_div #(
  parameter DATAWIDTH = 8
) (
  input clk,
  input rstn,
  input en,
  input [DATAWIDTH-1:0] dividend,
  input [DATAWIDTH-1:0] divisor,
  output reg ready,
  output reg [DATAWIDTH-1:0] quotient,
  output reg [DATAWIDTH-1:0] remainder,
  output reg vld_out
);

  localparam IDLE = 2'b00;
  localparam SUB = 2'b01;
  localparam SHIFT = 2'b10;
  localparam DONE = 2'b11;

  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [2*DATAWIDTH-1:0] dividend_e;
  reg [2*DATAWIDTH-1:0] divisor_e;
  reg [2*DATAWIDTH-1:0] quotient_e;
  reg [2*DATAWIDTH-1:0] remainder_e;
  reg [3:0] count;

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      current_state <= IDLE;
      next_state <= IDLE;
      dividend_e <= 0;
      divisor_e <= 0;
      quotient_e <= 0;
      remainder_e <= 0;
      count <= 0;
      ready <= 0;
      vld_out <= 0;
    end else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    case (current_state)
      IDLE: begin
        if (en) begin
          next_state = SUB;
          dividend_e = {dividend, {DATAWIDTH{1'b0}}};
          divisor_e = {divisor, {DATAWIDTH{1'b0}}};
          quotient_e = 0;
          remainder_e = dividend_e;
          count = 0;
          ready = 0;
          vld_out = 0;
        end else begin
          next_state = IDLE;
          ready = 1;
        end
      end
      SUB: begin
        next_state = SHIFT;
        if (remainder_e >= divisor_e) begin
          remainder_e = remainder_e - divisor_e;
          quotient_e = quotient_e + {1'b1, {DATAWIDTH{1'b0}}};
        end else begin
          quotient_e = quotient_e + {1'b0, {DATAWIDTH{1'b0}}};
        end
      end
      SHIFT: begin
        if (count < DATAWIDTH) begin
          next_state = SUB;
          remainder_e = {remainder_e[2*DATAWIDTH-2:DATAWIDTH], remainder_e[DATAWIDTH-1:0]};
          count = count + 1;
        end else begin
          next_state = DONE;
        end
      end
      DONE: begin
        next_state = IDLE;
        ready = 1;
        vld_out = 1;
        quotient = quotient_e[2*DATAWIDTH-1:DATAWIDTH];
        remainder = remainder_e[DATAWIDTH-1:0];
      end
    endcase
  end

endmodule