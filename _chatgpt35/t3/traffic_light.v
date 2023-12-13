module traffic_light (
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
  
  reg [7:0] cnt;
  reg [1:0] state;
  reg p_red, p_yellow, p_green;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 8'd10;
      state <= idle;
      p_red <= 1'b0;
      p_yellow <= 1'b0;
      p_green <= 1'b0;
    end
    else begin
      case (state)
        idle: begin
          red <= 1'b0;
          yellow <= 1'b0;
          green <= 1'b0;
          cnt <= 8'd0;
          if (cnt == 8'd0)
            state <= s1_red;
        end
        
        s1_red: begin
          red <= 1'b1;
          yellow <= 1'b0;
          green <= 1'b0;
          if (cnt == 8'd3)
            state <= s3_green;
        end
        
        s2_yellow: begin
          red <= 1'b0;
          yellow <= 1'b1;
          green <= 1'b0;
          if (cnt == 8'd3)
            state <= s1_red;
        end
        
        s3_green: begin
          red <= 1'b0;
          yellow <= 1'b0;
          green <= 1'b1;
          if (cnt == 8'd3)
            state <= s2_yellow;
        end
      endcase
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      cnt <= 8'd10;
    else if (pass_request && green)
      cnt <= 8'd10;
    else if (!green && p_green)
      cnt <= 8'd60;
    else if (!yellow && p_yellow)
      cnt <= 8'd5;
    else if (!red && p_red)
      cnt <= 8'd10;
    else
      cnt <= cnt - 1;
  end
  
  assign clock = cnt;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      p_red <= 1'b0;
      p_yellow <= 1'b0;
      p_green <= 1'b0;
    end
    else begin
      p_red <= red;
      p_yellow <= yellow;
      p_green <= green;
    end
  end
  
endmodule