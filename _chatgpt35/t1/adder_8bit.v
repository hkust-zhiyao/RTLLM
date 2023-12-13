module adder_8bit(
  input [7:0] a,
  input [7:0] b,
  input cin,
  output [7:0] sum,
  output cout
);

  wire [7:0] carry; // Carry signals between bit-level adders

  // Bit-level adder instantiation
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : adder_inst
      full_adder fa(
        .a(a[i]),
        .b(b[i]),
        .cin(carry[i]),
        .sum(sum[i]),
        .cout(carry[i+1])
      );
    end
  endgenerate

  // Last carry-out
  assign cout = carry[8];

endmodule


// Bit-level Full Adder
module full_adder(
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a ^ b));

endmodule