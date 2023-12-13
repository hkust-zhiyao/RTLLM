module cla_16bit (
  input [15:0] A,
  input [15:0] B,
  output [15:0] S,
  output Cout
  );

  wire [15:0] P, G;
  wire [15:0] C;
  
  assign P = A ^ B;
  assign G = A & B;
  
  assign S[0] = P[0];
  assign C[0] = G[0];
  
  generate
    genvar i;
    generate
      for (i = 1; i < 16; i = i + 1) begin : gen_carry
        assign S[i] = P[i] ^ C[i-1];
        assign C[i] = G[i] | (P[i] & C[i-1]);
      end
    endgenerate
  endgenerate
  
  assign Cout = C[15];
  
endmodule


module adder_32bit (
  input [31:0] A,
  input [31:0] B,
  output [31:0] S,
  output C32
  );
  
  wire [15:0] S0, S1, S2, S3;
  wire C1, C2, C3, C4;
  
  cla_16bit u1 (.A(A[15:0]), .B(B[15:0]), .S(S0), .Cout(C1));
  cla_16bit u2 (.A(A[31:16]), .B(B[31:16]), .S(S1), .Cout(C2));
  cla_16bit u3 (.A(S0), .B(S1), .S(S2), .Cout(C3));
  cla_16bit u4 (.A(A[31:16]), .B(B[31:16]), .S(S3), .Cout(C4));
  
  assign S = {S3, S2};
  assign C32 = C4;
  
endmodule