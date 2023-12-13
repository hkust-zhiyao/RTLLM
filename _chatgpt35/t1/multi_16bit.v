module multi_16bit (
  input clk,
  input rst_n,
  input start,
  input [15:0] ain,
  input [15:0] bin,
  output reg [31:0] yout,
  output reg done
);
  reg [4:0] i;
  reg [31:0] areg;
  reg [31:0] breg;
  reg [31:0] yout_r;
  reg done_r;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      i <= 5'b0;
      done_r <= 1'b0;
      areg <= 32'b0;
      breg <= 32'b0;
      yout_r <= 32'b0;
    end
    else begin
      if (start && i < 17)
        i <= i + 1;
      else if (!start)
        i <= 5'b0;
      
      if (i == 16)
        done_r <= 1'b1;
      else if (i == 17)
        done_r <= 1'b0;
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      yout <= 32'b0;
    end
    else begin
      if (start) begin
        if (i == 0) begin
          areg <= {16'b0, ain};
          breg <= {16'b0, bin};
        end
        else if (i > 0 && i < 17) begin
          if (areg[i-1] == 1'b1)
            yout_r <= yout_r + (breg << (i-1));
        end
      end
      
      yout <= yout_r;
    end
  end
  
  assign done = done_r;
endmodule