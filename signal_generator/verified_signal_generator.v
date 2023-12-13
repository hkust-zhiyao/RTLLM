module verified_signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

  reg [1:0] state;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b0;
      wave <= 5'b0;
    end
    else begin
      case (state)
        2'b00:
          begin
            if (wave == 5'b11111)
              state <= 2'b01;
            else
              wave <= wave + 1;
          end
          
        2'b01:
          begin
            if (wave == 5'b00000)
              state <= 2'b00;
            else
              wave <= wave - 1;
          end
      endcase
    end
  end

endmodule