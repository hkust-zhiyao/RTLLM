module adder_8bit (
  input [7:0] a,
  input [7:0] b,
  input cin,
  output [7:0] sum,
  output cout
);

  // Internal wires for connecting bit-level adders
  wire [7:0] carry;
  
  // Instantiate 8 bit-level adders
  // The first bit-level adder has the carry-in connected to cin
  // The last bit-level adder has the carry-out connected to cout
  full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);
  full_adder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
  full_adder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
  full_adder fa3(a[3], b[3], carry[2], sum[3], carry[3]);
  full_adder fa4(a[4], b[4], carry[3], sum[4], carry[4]);
  full_adder fa5(a[5], b[5], carry[4], sum[5], carry[5]);
  full_adder fa6(a[6], b[6], carry[5], sum[6], carry[6]);
  full_adder fa7(a[7], b[7], carry[6], sum[7], cout);

endmodule

module full_adder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  // Internal wires for intermediate signals
  wire s1, s2;

  // Calculate sum and carry
  xor(s1, a, b);
  xor(sum, s1, cin);
  and(s2, a, b);
  or(cout, s2, and(s1, cin));

endmodule