module chatgpt_generate_fsm (
  input CLK,
  input RST,
  input IN,
  output reg MATCH
);

parameter S_IDLE = 2'b00;
parameter S_1 = 2'b01;
parameter S_10 = 2'b10;
parameter S_100 = 2'b11;

reg [1:0] state = S_IDLE;

always @(posedge CLK) begin
  if (RST) begin
    state <= S_IDLE;
    MATCH <= 0;
  end
  else begin
    case (state)
      S_IDLE: begin
        if (IN == 1'b1) begin
          state <= S_1;
        end
        else begin
          state <= S_IDLE;
        end
      end
      
      S_1: begin
        if (IN == 1'b0) begin
          state <= S_10;
        end
        else begin
          state <= S_IDLE;
        end
      end
      
      S_10: begin
        if (IN == 1'b0) begin
          state <= S_100;
        end
        else begin
          state <= S_IDLE;
        end
      end
      
      S_100: begin
        if (IN == 1'b1) begin
          state <= S_IDLE;
          MATCH <= 1;
        end
        else begin
          state <= S_IDLE;
        end
      end
    endcase
  end
end

endmodule