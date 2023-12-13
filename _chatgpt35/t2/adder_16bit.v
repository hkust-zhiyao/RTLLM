module adder_8bit (
  input wire a,
  input wire b,
  input wire Cin,
  output wire y,
  output wire Co
);

  assign {Co, y} = a + b + Cin;

endmodule

module adder_16bit (
  input wire [15:0] a,
  input wire [15:0] b,
  input wire Cin,
  output wire [15:0] y,
  output wire Co
);

  wire [7:0] Co_intermediate;
  wire [7:0] y_intermediate;

  adder_8bit adder[7:0] (
    .a(a[7:0]),
    .b(b[7:0]),
    .Cin(Cin),
    .y(y_intermediate[7:0]),
    .Co(Co_intermediate[7:0])
  );

  adder_8bit adder8 (
    .a(a[15:8]),
    .b(b[15:8]),
    .Cin(Co_intermediate[7]),
    .y(y[15:8]),
    .Co(Co_intermediate[8])
  );

  assign Co = Co_intermediate[8];
  assign y[7:0] = y_intermediate[7:0];

endmodule