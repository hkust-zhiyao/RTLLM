module cla_16bit(
  input [15:0] A,
  input [15:0] B,
  input C_in,
  output [16:0] S,
  output C_out
);

  wire [16:0] P, G;
  wire [16:0] C;
  
  assign P[0] = A[0] ^ B[0];
  assign G[0] = A[0] & B[0];
  assign C[0] = C_in;
  
  generate
    genvar i;
    for (i = 1; i < 16; i = i + 1) begin : gen
      assign P[i] = A[i] ^ B[i];
      assign G[i] = A[i] & B[i];
      assign C[i] = G[i - 1] | (P[i - 1] & C[i - 1]);
    end
  endgenerate
  
  assign S = {C[15], C};
  assign C_out = G[15] | (P[15] & C[15]);

endmodule

module adder_32bit(
  input [31:0] A,
  input [31:0] B,
  output [31:0] S,
  output C32
);

  wire [16:0] C;
  wire [16:0] S_intermediate;
  
  cla_16bit cla0(.A(A[15:0]), .B(B[15:0]), .C_in(1'b0), .S(S_intermediate[15:0]), .C_out(C[0]));
  cla_16bit cla1(.A(A[31:16]), .B(B[31:16]), .C_in(C[0]), .S(S_intermediate[31:16]), .C_out(C[1]));
  
  assign S = {S_intermediate[31], S_intermediate[31:16]};
  assign C32 = C[1];
  
endmodule