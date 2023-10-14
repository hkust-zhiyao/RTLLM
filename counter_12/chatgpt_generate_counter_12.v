module chatgpt_generate_counter_12(
  input          rst_n,
  input          clk,
  input          valid_count,
  output reg [3:0] out
);

  // Internal state register to control the counter
  reg [3:0] state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the counter and state on asynchronous reset
      state <= 4'b0000;
      out <= 4'b0000;
    end else begin
      // State machine to control the counter
      case (state)
        4'b0000:
          if (valid_count)
            state <= 4'b0001;
        4'b0001:
          if (valid_count)
            state <= 4'b0010;
          else
            state <= 4'b0000;
        4'b0010:
          if (valid_count)
            state <= 4'b0011;
          else
            state <= 4'b0000;
        4'b0011:
          if (valid_count)
            state <= 4'b0100;
          else
            state <= 4'b0000;
        4'b0100:
          if (valid_count)
            state <= 4'b0101;
          else
            state <= 4'b0000;
        4'b0101:
          if (valid_count)
            state <= 4'b0110;
          else
            state <= 4'b0000;
        4'b0110:
          if (valid_count)
            state <= 4'b0111;
          else
            state <= 4'b0000;
        4'b0111:
          if (valid_count)
            state <= 4'b1000;
          else
            state <= 4'b0000;
        4'b1000:
          if (valid_count)
            state <= 4'b1001;
          else
            state <= 4'b0000;
        4'b1001:
          if (valid_count)
            state <= 4'b1010;
          else
            state <= 4'b0000;
        4'b1010:
          if (valid_count)
            state <= 4'b1011;
          else
            state <= 4'b0000;
        4'b1011:
          if (valid_count)
            state <= 4'b0000;
          else
            state <= 4'b0000;
      endcase

      // Output the counter value based on the state
      case (state)
        4'b0000: out <= 4'b0000;
        4'b0001: out <= 4'b0001;
        4'b0010: out <= 4'b0010;
        4'b0011: out <= 4'b0011;
        4'b0100: out <= 4'b0100;
        4'b0101: out <= 4'b0101;
        4'b0110: out <= 4'b0110;
        4'b0111: out <= 4'b0111;
        4'b1000: out <= 4'b1000;
        4'b1001: out <= 4'b1001;
        4'b1010: out <= 4'b1010;
        4'b1011: out <= 4'b1011;
        default: out <= 4'b0000; // Default case, should not happen
      endcase
    end
  end

endmodule

