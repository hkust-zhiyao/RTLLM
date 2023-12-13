module pulse_detect (
  input clk,
  input rst_n,
  input data_in,
  output reg data_out
);
  reg [2:0] state;
  reg [2:0] next_state;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      state <= 3'b000;
    else
      state <= next_state;
  end
  
  always @(state, data_in) begin
    case (state)
      3'b000: begin
        if (data_in)
          next_state = 3'b001;
        else
          next_state = 3'b000;
      end
      
      3'b001: begin
        if (data_in)
          next_state = 3'b010;
        else
          next_state = 3'b000;
      end
      
      3'b010: begin
        if (data_in)
          next_state = 3'b011;
        else
          next_state = 3'b000;
      end
      
      3'b011: begin
        if (~data_in)
          next_state = 3'b100;
        else
          next_state = 3'b011;
      end
      
      default: next_state = 3'b000;
    endcase
  end
  
  always @(state) begin
    if (state == 3'b011)
      data_out = 1'b1;
    else
      data_out = 1'b0;
  end
endmodule