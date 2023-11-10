module chatgpt_generate_booth4_mul(
  input clk,
  input rstn,
  input vld_in,
  input [7:0] multiplicand,
  input [7:0] multiplier,
  output reg [15:0] mul_out,
  output reg done
);

reg [15:0] product; // 16-bit product register
reg [3:0] state; // 4-bit state register
reg signed [8:0] m; // signed 9-bit multiplicand register
reg signed [8:0] a; // signed 9-bit accumulator register
reg signed [8:0] q; // signed 9-bit quotient register
reg signed [8:0] n; // signed 9-bit negative multiplicand register
reg signed [4:0] cnt; // 5-bit counter register
reg sign; // sign bit of the product

always @(posedge clk) begin
  if (~rstn) begin
    product <= 16'b0;
    state <= 4'b0;
    m <= {1'b0, multiplicand};
    a <= 9'b0;
    q <= {1'b0, multiplier, 1'b0};
    n <= {1'b1, ~multiplicand + 1};
    cnt <= 5'b0;
    sign <= 1'b0;
    mul_out <= 16'b0;
    done <= 1'b0;
  end else if (vld_in) begin
    case (state)
      4'b0000: begin
        if (q[0] && ~q[1]) begin
          a <= m - a;
          q <= {q[7:1], a[8]};
          state <= 4'b0001;
        end else if (~q[0] && q[1]) begin
          a <= m + a;
          q <= {q[7:1], a[8]};
          state <= 4'b0010;
        end else begin
          q <= {q[7:1], q[0]};
          state <= 4'b0011;
        end
      end
      4'b0001: begin
        if (a[8]) begin
          a <= a + n;
          sign <= ~sign;
        end
        a <= a >> 1;
        q <= {q[7:1], a[8]};
        cnt <= cnt + 1;
        if (cnt == 5) begin
          product <= {sign, a[8], q[6:0]};
          done <= 1'b1;
          state <= 4'b0000;
          cnt <= 5'b0;
          sign <= 1'b0;
          mul_out <= product;
        end else begin
          state <= 4'b0000;
        end
      end
      4'b0010: begin
        if (a[8]) begin
          a <= a + m;
        end
        a <= a >> 1;
        q <= {q[7:1], a[8]};
        cnt <= cnt + 1;
        if (cnt == 5) begin
          product <= {sign, a[8], q[6:0]};
          done <= 1'b1;
          state <= 4'b0000;
          cnt <= 5'b0;
          sign <= 1'b0;
          mul_out <= product;
        end else begin
          state <= 4'b0000;
        end
      end
      4'b0011: begin
        cnt <= cnt + 1;
        if (cnt == 5) begin
          product <= {sign, a[8], q[6:0]};
          done <= 1'b1;
          state <= 4'b0000;
          cnt <= 5'b0;
          sign <= 1'b0;
          mul_out <= product;
        end else begin
          state <= 4'b0000;
        end
      end
      default: begin
        state <= 4'b0000;
      end
    endcase
  end
end

endmodule