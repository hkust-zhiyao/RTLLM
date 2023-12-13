module div_16bit (
  input [15:0] A,
  input [7:0] B,
  output reg [15:0] result,
  output reg [15:0] odd
);
  
  reg [15:0] a_reg;
  reg [7:0] b_reg;
  
  always @* begin
    a_reg = A;
    b_reg = B;
  end
  
  always @* begin
    reg [31:0] tmp_a;
    reg [15:0] tmp_b;
    
    tmp_a = {16'b0, a_reg};
    tmp_b = {b_reg, 8'b0};
    
    for (integer i = 0; i < 16; i = i + 1) begin
      tmp_a = tmp_a << 1;
      
      if (tmp_a >= tmp_b) begin
        tmp_a = tmp_a - tmp_b + 1;
        result[i] = 1;
      end else begin
        result[i] = 0;
      end
    end
    
    odd = tmp_a[31:16];
  end
  
endmodule