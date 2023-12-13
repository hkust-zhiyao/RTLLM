module div_16bit (
  input [15:0] A,
  input [7:0] B,
  output reg [15:0] result,
  output reg [15:0] odd
);

  reg [15:0] a_reg;
  reg [7:0] b_reg;

  always @(A, B) begin
    a_reg <= A;
    b_reg <= B;
  end

  always @(A, B) begin
    reg [31:0] tmp_a;
    reg [31:0] tmp_b;
    integer i;

    tmp_a = {16'b0, a_reg};
    tmp_b = {b_reg, 16'b0};

    for (i = 0; i < 16; i = i + 1) begin
      tmp_a = tmp_a << 1;
      if (tmp_a >= tmp_b)
        tmp_a = tmp_a - tmp_b + 1;
    end

    result = tmp_a[15:0];
    odd = tmp_a[31:16];
  end

endmodule