module traffic_light (
  input rst_n,
  input clk,
  input pass_request,
  output reg [7:0] clock,
  output reg red,
  output reg yellow,
  output reg green
);

  parameter idle = 2'b00;
  parameter s1_red = 2'b01;
  parameter s2_yellow = 2'b10;
  parameter s3_green = 2'b11;

  reg [2:0] cnt;
  reg [1:0] state;
  reg p_red, p_yellow, p_green;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 8'b0000_1010;
      state <= idle;
      p_red <= 1'b0;
      p_yellow <= 1'b0;
      p_green <= 1'b0;
    end else begin
      case (state)
        idle: begin
          state <= s1_red;
          cnt <= 8'b0000_0011;
          p_red <= 1'b1;
        end
        s1_red: begin
          if (cnt == 8'b0000_0000)
            state <= s3_green;
          else
            state <= s1_red;
          cnt <= cnt - 1;
          p_red <= 1'b1;
        end
        s2_yellow: begin
          if (cnt == 8'b0000_0000)
            state <= s1_red;
          else
            state <= s2_yellow;
          cnt <= cnt - 1;
          p_yellow <= 1'b1;
        end
        s3_green: begin
          if (cnt == 8'b0000_0000)
            state <= s2_yellow;
          else
            state <= s3_green;
          cnt <= cnt - 1;
          p_green <= 1'b1;
        end
        default: state <= idle;
      endcase
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      cnt <= 8'b0000_1010;
    else begin
      if (!rst_n || (pass_request && green))
        cnt <= 8'b0000_1010;
      else if (!p_green && !green)
        cnt <= 8'b0011_1100;
      else if (!p_yellow && !yellow)
        cnt <= 8'b0000_0101;
      else if (!p_red && !red)
        cnt <= 8'b0000_1010;
      else
        cnt <= cnt - 1;
    end
  end

  assign clock = cnt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      red <= 1'b0;
      yellow <= 1'b0;
      green <= 1'b0;
    end else begin
      if (state == s1_red)
        red <= 1'b1;
      else if (state == s2_yellow)
        yellow <= 1'b1;
      else if (state == s3_green)
        green <= 1'b1;
      else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
      end
    end
  end

endmodule