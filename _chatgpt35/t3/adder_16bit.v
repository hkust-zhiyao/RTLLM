module adder_8bit (
  input wire a,
  input wire b,
  input wire Cin,
  output wire y,
  output wire Cout
);

  assign {Cout, y} = a + b + Cin;

endmodule

module adder_16bit (
  input wire [15:0] a,
  input wire [15:0] b,
  input wire Cin,
  output wire [15:0] y,
  output wire Co
);

  wire [7:0] carry;
  wire [7:0] sum;

  adder_8bit adder0 (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(sum[7:0]),
    .Cout(carry[0])
  );

  adder_8bit adder1 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(carry[0]),
    .y(sum[15:8]),
    .Cout(carry[1])
  );

  assign Co = carry[7];
  assign y = {carry[7:2], sum[15:8], sum[7:0]};

endmodule