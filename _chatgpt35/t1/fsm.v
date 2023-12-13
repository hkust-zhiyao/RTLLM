module fsm (
  input IN,
  input CLK,
  input RST,
  output reg MATCH
);
  reg [4:0] state;
  reg [4:0] next_state;
  
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      state <= 5'b00000;
      MATCH <= 1'b0;
    end
    else begin
      state <= next_state;
      MATCH <= (state == 5'b10011);
    end
  end
  
  always @(IN) begin
    case (state)
      5'b00000: next_state = (IN == 1'b1) ? 5'b00001 : 5'b00000;
      5'b00001: next_state = (IN == 1'b0) ? 5'b00010 : 5'b00000;
      5'b00010: next_state = (IN == 1'b0) ? 5'b00011 : 5'b00000;
      5'b00011: next_state = (IN == 1'b1) ? 5'b00100 : 5'b00000;
      5'b00100: next_state = (IN == 1'b1) ? 5'b10011 : 5'b00000;
      default: next_state = 5'b00000;
    endcase
  end
endmodule