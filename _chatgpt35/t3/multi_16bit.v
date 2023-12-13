module multi_16bit (
  input clk,
  input rst_n,
  input start,
  input [15:0] ain,
  input [15:0] bin,
  output reg [31:0] yout,
  output reg done
);

  reg [3:0] i;
  reg [15:0] areg;
  reg [15:0] breg;
  reg [31:0] yout_r;
  reg done_r;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      i <= 4'b0;
      yout_r <= 32'b0;
      done_r <= 1'b0;
    end
    else begin
      if (start && (i < 4'b10000)) begin
        i <= i + 1;
      end
      else if (!start) begin
        i <= 4'b0;
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      areg <= 16'b0;
      breg <= 16'b0;
    end
    else begin
      if (start) begin
        if (i == 4'b0) begin
          areg <= ain;
          breg <= bin;
        end
        else if ((i > 4'b0) && (i < 4'b10001)) begin
          if (areg[i-1] == 1'b1) begin
            yout_r <= yout_r + (breg << (i-1));
          end
        end
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      yout <= 32'b0;
      done <= 1'b0;
    end
    else begin
      yout <= yout_r;
      done <= done_r;
      if (i == 4'b10000) begin
        done_r <= 1'b1;
      end
      else if (i == 4'b10001) begin
        done_r <= 1'b0;
      end
    end
  end

endmodule