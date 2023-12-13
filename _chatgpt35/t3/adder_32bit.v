module adder_32bit (
  input [31:0] A,
  input [31:0] B,
  output [31:0] S,
  output C32
);

  wire [15:0] generate, propagate, carry;

  // Instantiate 16-bit CLA blocks
  genvar i;
  generate
    for (i = 0; i < 2; i = i + 1) begin : clablock
      assign generate[i] = A[16*i + 15] & B[16*i + 15];
      assign propagate[i] = A[16*i + 15] ^ B[16*i + 15];
      assign carry[i] = generate[i] | (propagate[i] & carry[i-1]);
      cla_16bit clablock_inst (
        .A(A[16*i + 15:16*i]),
        .B(B[16*i + 15:16*i]),
        .Cin(carry[i-1]),
        .Cout(carry[i]),
        .Sum(S[16*i + 15:16*i])
      );
    end
  endgenerate

  assign C32 = carry[1];
  
endmodule


module cla_16bit (
  input [15:0] A,
  input [15:0] B,
  input Cin,
  output Cout,
  output [15:0] Sum
);
  
  wire [15:0] generate, propagate, carry;
  
  assign generate = A & B;
  assign propagate = A ^ B;
  assign carry = generate | (propagate & Cin);
  
  assign Cout = carry[15];
  assign Sum = A + B + Cin;
  
endmodule