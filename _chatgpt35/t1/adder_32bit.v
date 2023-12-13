module cla_16bit (
  input [15:0] A,
  input [15:0] B,
  output [15:0] S,
  output C_out
);

  wire [16:0] G, P, C;
  wire [16:0] G_i, P_i, C_i;
  
  assign G_i[0] = A[0] & B[0];
  assign P_i[0] = A[0] ^ B[0];
  assign C_i[0] = A[0] | B[0];
  
  generate
    genvar i;
    for (i = 1; i < 16; i = i + 1) begin : gen
      assign G_i[i] = A[i] & B[i];
      assign P_i[i] = A[i] ^ B[i];
      assign C_i[i] = A[i] | B[i];
    end
  endgenerate
  
  assign G[0] = G_i[0];
  assign P[0] = P_i[0];
  assign C[0] = C_i[0];
  
  generate
    genvar i;
    for (i = 1; i < 16; i = i + 1) begin : gen
      assign G[i] = G_i[i] | (P_i[i] & G[i - 1]);
      assign P[i] = P_i[i] & P[i - 1];
      assign C[i] = C_i[i] | (P_i[i] & C[i - 1]);
    end
  endgenerate
  
  assign S[0] = A[0] ^ B[0] ^ C[0];
  assign C_out = G[15] | (P[15] & C[15]);
  
  generate
    genvar i;
    for (i = 1; i < 16; i = i + 1) begin : gen
      assign S[i] = A[i] ^ B[i] ^ C[i];
    end
  endgenerate

endmodule


module adder_32bit (
  input [31:0] A,
  input [31:0] B,
  output [31:0] S,
  output C32
);

  wire [15:0] G_1, P_1, C_1;
  wire [15:0] G_2, P_2, C_2;
  wire [15:0] G_3, P_3, C_3;
  wire [15:0] G_4, P_4, C_4;
  
  cla_16bit cla_1 (.A(A[15:0]), .B(B[15:0]), .S(S[15:0]), .C_out(C_1));
  cla_16bit cla_2 (.A(A[31:16]), .B(B[31:16]), .S(S[31:16]), .C_out(C_2));
  cla_16bit cla_3 (.A({C_2, A[15:0]}), .B({C_1, B[15:0]}), .S(S[15:0]), .C_out(C_3));
  cla_16bit cla_4 (.A(A[31:16]), .B(B[31:16]), .S(S[31:16]), .C_out(C_4));
  
  assign G_1 = cla_1.G;
  assign P_1 = cla_1.P;
  assign G_2 = cla_2.G;
  assign P_2 = cla_2.P;
  assign G_3 = cla_3.G;
  assign P_3 = cla_3.P;
  assign G_4 = cla_4.G;
  assign P_4 = cla_4.P;
  
  assign C32 = G_4[15] | (P_4[15] & C_4[15]);
  
endmodule