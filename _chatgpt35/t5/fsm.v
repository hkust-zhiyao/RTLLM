module fsm (
  input IN,
  input CLK,
  input RST,
  output reg MATCH
);

  reg [4:0] state;
  reg [4:0] next_state;

  parameter S0 = 5'b00000; // Initial state
  parameter S1 = 5'b00001; // State after detecting 1
  parameter S2 = 5'b00010; // State after detecting 10
  parameter S3 = 5'b00011; // State after detecting 100
  parameter S4 = 5'b00100; // State after detecting 1001
  parameter S5 = 5'b00101; // State after detecting 10011

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      MATCH <= 0;
      state <= S0;
    end
    else begin
      state <= next_state;
      MATCH <= (state == S5);
    end
  end

  always @(state or IN) begin
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
          next_state = S1;
        else
          next_state = S3;
      end
      S3: begin
        if (IN)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        if (IN)
          next_state = S1;
        else
          next_state = S5;
      end
      S5: begin
        if (IN)
          next_state = S1;
        else
          next_state = S5;
      end
      default: next_state = S0;
    endcase
  end

endmodule