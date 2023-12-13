module multi_16bit (
  input clk,
  input rst_n,
  input start,
  input [15:0] ain,
  input [15:0] bin,
  output [31:0] yout,
  output reg done
);

  reg [3:0] i;
  reg [15:0] areg;
  reg [15:0] breg;
  reg [31:0] yout_r;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      i <= 4'b0000;
      areg <= 16'b0;
      breg <= 16'b0;
      yout_r <= 32'b0;
      done <= 0;
    end
    else begin
      if (start && (i < 4'b10001))
        i <= i + 1;
      else if (!start)
        i <= 4'b0000;

      if (i == 4'b10000)
        done <= 1;
      else if (i == 4'b10001)
        done <= 0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      areg <= 16'b0;
      breg <= 16'b0;
      yout_r <= 32'b0;
    end
    else begin
      if (start) begin
        if (i == 4'b0000) begin
          areg <= ain;
          breg <= bin;
        end
        else if ((i > 4'b0000) && (i < 4'b10001)) begin
          if (areg[i-1])
            yout_r <= yout_r + (breg << (i-1));
        end
      end
    end
  end

  assign yout = yout_r;

endmodule