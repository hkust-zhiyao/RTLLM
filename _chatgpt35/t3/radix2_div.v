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

  localparam LOG2_DATAWIDTH = $clog2(DATAWIDTH);
  
  reg [LOG2_DATAWIDTH:0] current_state;
  reg [LOG2_DATAWIDTH-1:0] dividend_e;
  reg [LOG2_DATAWIDTH-1:0] divisor_e;
  reg [LOG2_DATAWIDTH-1:0] quotient_e;
  reg [LOG2_DATAWIDTH-1:0] remainder_e;
  reg [LOG2_DATAWIDTH-1:0] count;
  
  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      // Reset condition
      current_state <= 0;
      dividend_e <= 0;
      divisor_e <= 0;
      quotient_e <= 0;
      remainder_e <= 0;
      count <= 0;
    end
    else begin
      // State transition logic
      case (current_state)
        0: begin // IDLE
          if (en) begin
            current_state <= 1; // Transition to SUB state
            dividend_e <= {dividend, {LOG2_DATAWIDTH{1'b0}}}; // Extend dividend
            divisor_e <= {divisor, {LOG2_DATAWIDTH{1'b0}}}; // Extend divisor
          end
        end
        1: begin // SUB
          if (dividend_e >= divisor_e) begin
            current_state <= 2; // Transition to SHIFT state
            quotient_e <= quotient_e + {1'b1, {LOG2_DATAWIDTH{1'b0}}}; // Increment quotient
            remainder_e <= dividend_e - divisor_e; // Calculate remainder
          end
          else begin
            current_state <= 1; // Stay in SUB state
            quotient_e <= quotient_e + {1'b0, {LOG2_DATAWIDTH{1'b0}}}; // Append 0 to quotient
            remainder_e <= dividend_e; // Remainder remains the same
          end
        end
        2: begin // SHIFT
          if (count == (DATAWIDTH - 1)) begin
            current_state <= 3; // Transition to DONE state
          end
          else begin
            current_state <= 2; // Stay in SHIFT state
            dividend_e <= dividend_e << 1; // Shift dividend left
            count <= count + 1; // Increment count
          end
        end
        3: begin // DONE
          current_state <= 0; // Transition back to IDLE state
        end
      endcase
    end
  end
  
  assign ready = (current_state == 0);
  assign quotient = quotient_e;
  assign remainder = remainder_e;
  assign vld_out = (current_state == 3);

endmodule