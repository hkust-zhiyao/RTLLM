module fsm (
  input IN,
  input CLK,
  input RST,
  output reg MATCH
);

  reg [4:0] state;
  reg [4:0] next_state;

  parameter S0 = 5'b00000;
  parameter S1 = 5'b00001;
  parameter S2 = 5'b00010;
  parameter S3 = 5'b00011;
  parameter S4 = 5'b00100;
  parameter S5 = 5'b00101;

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      state <= S0;
      MATCH <= 1'b0;
    end else begin
      state <= next_state;
      MATCH <= (state == S4);
    end
  end

  always @(IN, state) begin
    case (state)
      S0: begin
        if (IN)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (IN)
          next_state = S1;
        else
          next_state = S2;
      end
      S2: begin
        if (IN)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if (IN)
          next_state = S1;
        else
          next_state = S4;
      end
      S4: begin
        if (IN)
          next_state = S5;
        else
          next_state = S2;
      end
      S5: begin
        if (IN)
          next_state = S5;
        else
          next_state = S0;
      end
      default: next_state = S0;
    endcase
  end

endmodule