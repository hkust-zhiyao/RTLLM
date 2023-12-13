module radix2_div #(parameter DATAWIDTH = 8)(
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

  // State enumeration
  localparam IDLE = 2'b00;
  localparam SUB = 2'b01;
  localparam SHIFT = 2'b10;
  localparam DONE = 2'b11;

  // State registers
  reg [1:0] current_state;
  reg [1:0] next_state;
  
  // Data registers
  reg [DATAWIDTH:0] dividend_e;
  reg [DATAWIDTH:0] divisor_e;
  reg [DATAWIDTH:0] quotient_e;
  reg [DATAWIDTH:0] remainder_e;
  reg [DATAWIDTH-1:0] count;

  always @(posedge clk or negedge rstn) begin
    if (~rstn)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  always @(current_state, en, dividend, divisor) begin
    case (current_state)
      IDLE: begin
        if (en)
          next_state = SUB;
        else
          next_state = IDLE;
      end

      SUB: begin
        next_state = SHIFT;
      end

      SHIFT: begin
        if (count == DATAWIDTH)
          next_state = DONE;
        else
          next_state = SUB;
      end
      
      DONE: begin
        next_state = IDLE;
      end
    endcase
  end

  always @(*) begin
    case (current_state)
      IDLE: begin
        ready = 1'b1;
        vld_out = 1'b0;
      end

      SUB: begin
        dividend_e = {dividend, 1'b0};
        divisor_e = {divisor, 1'b0};
        quotient_e = {quotient, 1'b0};
        remainder_e = {remainder, 1'b0};

        if (dividend_e >= divisor_e) begin
          quotient_e = quotient_e + 1'b1;
          remainder_e = dividend_e - divisor_e;
        end
      end

      SHIFT: begin
        count = count + 1'b1;
        dividend_e = remainder_e;
        quotient_e = {quotient_e[DATAWIDTH-2:0], 1'b0};
        remainder_e = {remainder_e[DATAWIDTH-2:0], 1'b0};
      end
      
      DONE: begin
        quotient = quotient_e[DATAWIDTH-1:0];
        remainder = remainder_e[DATAWIDTH-1:0];
        ready = 1'b0;
        vld_out = 1'b1;
      end
    endcase
  end

  always @(negedge rstn) begin
    if (~rstn) begin
      dividend_e <= 0;
      divisor_e <= 0;
      quotient_e <= 0;
      remainder_e <= 0;
      count <= 0;
    end
  end
endmodule