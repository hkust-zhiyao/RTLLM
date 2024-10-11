module multi_8bit (
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] product
);

  reg [7:0] multiplicand;
  reg [3:0] shift_count;

  always @* begin
    product = 16'b0; 
    multiplicand = A; 
    shift_count = 0;  

    for (int i = 0; i < 8; i = i + 1) begin
      if (B[i] == 1) begin
        product = product + (multiplicand << shift_count);
      end
      shift_count = shift_count + 1;
    end
  end

endmodule