module chatgpt_generate_adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

// Generate carry and sum signals for each bit
genvar i;
generate
    for (i = 1; i <= 32; i = i + 1) begin : cla_block
        wire P, G, carry;
        assign P = A[i] | B[i];
        assign G = A[i] & B[i];
        
        assign carry = (i == 1) ? 1'b0 : (P & {carry, G});
        assign S[i] = A[i] ^ B[i] ^ {carry, G};
    end
endgenerate

assign C32 = A[32] & B[32];

endmodule
