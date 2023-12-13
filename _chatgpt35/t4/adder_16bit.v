module adder_16bit (
  input [15:0] a,
  input [15:0] b,
  input Cin,
  output [15:0] y,
  output Co
);

  wire [7:0] carry;
  wire [7:0] sum;

  // Instantiating eight 8-bit adders
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : ADDER_INST
      // Instantiating 8-bit adder
      adder_8bit adder_inst (
        .a(a[i*2 +: 8]),  // Extracting 8-bit portion from a
        .b(b[i*2 +: 8]),  // Extracting 8-bit portion from b
        .Cin(i ? carry[i-1] : Cin),  // Using carry from previous adder or Cin for the first adder
        .y(y[i*2 +: 8]),  // Storing the 8-bit sum
        .Co(carry[i])  // Storing the carry-out
      );
    end
  endgenerate

  // Generating carry-out for the 16-bit output
  assign Co = carry[7];

endmodule

module adder_8bit (
  input [7:0] a,
  input [7:0] b,
  input Cin,
  output [7:0] y,
  output Co
);

  wire [7:0] carry;
  wire [7:0] sum;

  // Generating sum and carry for each bit position
  assign {carry[0], sum[0]} = a[0] + b[0] + Cin;
  assign {carry[1], sum[1]} = a[1] + b[1] + carry[0];
  assign {carry[2], sum[2]} = a[2] + b[2] + carry[1];
  assign {carry[3], sum[3]} = a[3] + b[3] + carry[2];
  assign {carry[4], sum[4]} = a[4] + b[4] + carry[3];
  assign {carry[5], sum[5]} = a[5] + b[5] + carry[4];
  assign {carry[6], sum[6]} = a[6] + b[6] + carry[5];
  assign {carry[7], sum[7]} = a[7] + b[7] + carry[6];

  // Storing the sum and carry-out
  assign y = sum;
  assign Co = carry[7];

endmodule