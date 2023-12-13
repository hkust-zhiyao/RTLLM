module traffic_light(
  input wire rst_n,
  input wire clk,
  input wire pass_request,
  output reg [7:0] clock,
  output reg red,
  output reg yellow,
  output reg green
);

  parameter idle = 2'b00;
  parameter s1_red = 2'b01;
  parameter s2_yellow = 2'b10;
  parameter s3_green = 2'b11;

  reg [1:0] state;
  reg [7:0] cnt;
  reg p_red, p_yellow, p_green;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= idle;
      cnt <= 8'b0000_1010;
      p_red <= 1'b0;
      p_yellow <= 1'b0;
      p_green <= 1'b0;
    end
    else begin
      case (state)
        idle:
          state <= s1_red;
        s1_red:
          if (cnt == 8'b0000_0001)
            state <= s3_green;
          else
            state <= s1_red;
        s2_yellow:
          if (cnt == 8'b0000_0001)
            state <= s1_red;
          else
            state <= s2_yellow;
        s3_green:
          if (cnt == 8'b0000_0001)
            state <= s2_yellow;
          else
            state <= s3_green;
      endcase
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      cnt <= 8'b0000_1010;
    else begin
      if (!pass_request && green)
        cnt <= 8'b0000_1010;
      else if (!green && p_green)
        cnt <= 8'b0011_1100;
      else if (!yellow && p_yellow)
        cnt <= 8'b0000_0101;
      else if (!red && p_red)
        cnt <= 8'b0000_1010;
      else if (cnt > 0)
        cnt <= cnt - 1;
    end
  end

  assign clock = cnt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      red <= 1'b0;
      yellow <= 1'b0;
      green <= 1'b0;
    end
    else begin
      case (state)
        idle:
          begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
          end
        s1_red:
          begin
            red <= 1'b1;
            yellow <= 1'b0;
            green <= 1'b0;
          end
        s2_yellow:
          begin
            red <= 1'b0;
            yellow <= 1'b1;
            green <= 1'b0;
          end
        s3_green:
          begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b1;
          end
      endcase
      p_red <= red;
      p_yellow <= yellow;
      p_green <= green;
    end
  end

endmodule