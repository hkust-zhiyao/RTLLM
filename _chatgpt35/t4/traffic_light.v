module traffic_light (
  input wire rst_n,
  input wire clk,
  input wire pass_request,
  output reg [7:0] clock,
  output reg red,
  output reg yellow,
  output reg green
);

  localparam [1:0] idle = 2'b00;
  localparam [1:0] s1_red = 2'b01;
  localparam [1:0] s2_yellow = 2'b10;
  localparam [1:0] s3_green = 2'b11;

  reg [1:0] state;
  reg [7:0] cnt;
  reg p_red, p_yellow, p_green;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= idle;
      cnt <= 8'd10;
      p_red <= 1'b0;
      p_yellow <= 1'b0;
      p_green <= 1'b0;
    end else begin
      case (state)
        idle:
          if (cnt == 8'd0)
            state <= s1_red;
          else
            state <= idle;
        s1_red:
          if (cnt == 8'd0)
            state <= s3_green;
          else
            state <= s1_red;
        s2_yellow:
          if (cnt == 8'd0)
            state <= s1_red;
          else
            state <= s2_yellow;
        s3_green:
          if (cnt == 8'd0)
            state <= s2_yellow;
          else
            state <= s3_green;
      endcase
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      cnt <= 8'd10;
    else if (pass_request && green)
      cnt <= 8'd10;
    else if (!rst_n && cnt == 8'd0)
      cnt <= 8'd10;
    else if (!rst_n && cnt == 8'd1 && p_green)
      cnt <= 8'd60;
    else if (!rst_n && cnt == 8'd1 && p_yellow)
      cnt <= 8'd5;
    else if (!rst_n && cnt == 8'd1 && p_red)
      cnt <= 8'd10;
    else if (cnt != 8'd0)
      cnt <= cnt - 1;
  end

  assign clock = cnt;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      red <= 1'b0;
      yellow <= 1'b0;
      green <= 1'b0;
    end else begin
      red <= p_red;
      yellow <= p_yellow;
      green <= p_green;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      p_red <= 1'b0;
      p_yellow <= 1'b0;
      p_green <= 1'b0;
    end else begin
      case (state)
        idle:
          p_red <= 1'b0;
          p_yellow <= 1'b0;
          p_green <= 1'b0;
        s1_red:
          p_red <= 1'b1;
          p_yellow <= 1'b0;
          p_green <= 1'b0;
        s2_yellow:
          p_red <= 1'b0;
          p_yellow <= 1'b1;
          p_green <= 1'b0;
        s3_green:
          p_red <= 1'b0;
          p_yellow <= 1'b0;
          p_green <= 1'b1;
      endcase
    end
  end

endmodule