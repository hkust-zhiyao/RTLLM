module adder_16bit (
  input [15:0] a,
  input [15:0] b,
  input Cin,
  output [15:0] y,
  output Co
);

  wire [7:0] carry;
  wire [7:0] sum;

  // Instantiate eight 8-bit full adders
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : adder_inst
      full_adder_8bit adder (
        .a(a[i*2 +: 8]),
        .b(b[i*2 +: 8]),
        .Cin(carry[i]),
        .sum(sum[i]),
        .Co(carry[i+1])
      );
    end
  endgenerate

  assign y = {sum[7], sum[6], sum[5], sum[4], sum[3], sum[2], sum[1], sum[0]};
  assign Co = carry[8];

endmodule

module full_adder_8bit (
  input [7:0] a,
  input [7:0] b,
  input Cin,
  output [7:0] sum,
  output Co
);

  wire [6:0] carry;
  wire [7:0] sum_intermediate;

  assign sum_intermediate = a + b + Cin;
  assign sum = sum_intermediate[6:0];
  assign Co = sum_intermediate[7] | (carry[6] & sum_intermediate[6]);

  generate
    for (genvar i = 0; i < 7; i = i + 1) begin : carry_gen
      assign carry[i] = (i > 0) ? (sum_intermediate[i-1] & carry[i-1]) : (sum_intermediate[i]);
    end
  endgenerate

endmodule