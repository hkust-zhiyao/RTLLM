module fsm (
  input IN,
  input CLK,
  input RST,
  output reg MATCH
);
  
  reg [4:0] state;
  reg [4:0] next_state;
  
  always @(posedge CLK or posedge RST) begin
    if (RST)
      state <= 5'b00000;
    else
      state <= next_state;
  end
  
  always @(IN or posedge CLK or posedge RST) begin
    case (state)
      5'b00000: begin
        if (IN)
          next_state = 5'b00001;
        else
          next_state = 5'b00000;
      end
      5'b00001: begin
        if (IN)
          next_state = 5'b00010;
        else
          next_state = 5'b00000;
      end
      5'b00010: begin
        if (IN)
          next_state = 5'b00011;
        else
          next_state = 5'b00000;
      end
      5'b00011: begin
        if (IN)
          next_state = 5'b00100;
        else
          next_state = 5'b00000;
      end
      5'b00100: begin
        if (IN)
          next_state = 5'b00101;
        else
          next_state = 5'b00000;
      end
      5'b00101: begin
        if (IN)
          next_state = 5'b00101;
        else
          next_state = 5'b00000;
      end
      default: next_state = 5'b00000;
    endcase
  end
  
  always @(posedge CLK or posedge RST) begin
    if (RST)
      MATCH <= 1'b0;
    else if (state == 5'b00101)
      MATCH <= 1'b1;
    else
      MATCH <= 1'b0;
  end
  
endmodule