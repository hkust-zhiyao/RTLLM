module adder_8bit(
  input [7:0] a,
  input [7:0] b,
  input cin,
  output [7:0] sum,
  output cout
);

  // Define internal signals
  wire [7:0] carry;
  wire [7:0] sum_intermediate;

  // Instantiate full adders
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : full_adder_inst
      full_adder full_adder_inst(
        .a(a[i]),
        .b(b[i]),
        .cin(i ? carry[i-1] : cin),
        .sum(sum_intermediate[i]),
        .cout(carry[i])
      );
    end
  endgenerate

  // Assign the outputs
  assign sum = sum_intermediate;
  assign cout = carry[7];

endmodule

module full_adder(
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  // Implement full adder logic
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);

endmodule