module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    output [15:0] S,
    output C_out
);

    wire [15:0] G, P, C;
    
    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = A[0] & B[0];
    
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : generate_block
            assign G[i] = P[i-1] & C[i-1];
            assign P[i] = G[i-1] | (P[i-1] & ~C[i-1]);
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate
    
    assign S = P;
    assign C_out = C[15];
    
endmodule


module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [15:0] C;
    wire [15:0] S_intermediate;
    
    genvar j;
    generate
        for (j = 0; j < 2; j = j + 1) begin : cla_block
            cla_16bit cla (
                .A(A[16*j +: 16]),
                .B(B[16*j +: 16]),
                .S(S_intermediate[16*j +: 16]),
                .C_out(C[16*j])
            );
        end
    endgenerate
    
    wire [31:0] C_propagate;
    
    assign C_propagate[0] = C[0];
    
    genvar k;
    generate
        for (k = 1; k < 16; k = k + 1) begin : carry_propagation
            assign C_propagate[k] = C[k] | (C_propagate[k-1] & C[k-1]);
        end
    endgenerate
    
    assign S = {C_propagate[15], S_intermediate[15:0], S_intermediate[31:16]};
    assign C32 = C_propagate[15];
    
endmodule