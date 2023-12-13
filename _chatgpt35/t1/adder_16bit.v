module adder_16bit (
  input [15:0] a,
  input [15:0] b,
  input Cin,
  output [15:0] y,
  output Co
);

  wire [7:0] carry; // Carry signals between 8-bit adders

  // Instantiate eight 8-bit adders
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : adder_inst
      assign y[i] = a[i] + b[i] + carry[i];
      assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
    end
  endgenerate

  assign y[8:15] = a[8:15] + b[8:15] + carry[8];

  assign Co = carry[8];

endmodule