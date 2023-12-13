module adder_32bit(
    input [32:1] A,   // 32-bit input operand A
    input [32:1] B,   // 32-bit input operand B
    output [32:1] S,  // 32-bit output sum
    output C32        // Carry-out output
);

    wire C16; // Intermediate carry between lower and upper CLA blocks

    // Instantiate the lower 16-bit CLA block
    cla_16bit cla_lower(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0), // Assuming there is no initial carry-in
        .S(S[16:1]),
        .Cout(C16)
    );

    // Instantiate the upper 16-bit CLA block
    cla_16bit cla_upper(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule

// 16-bit CLA block
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);

    wire [16:0] C; // Internal carry bits, C[0] is Cin
    wire [16:1] G; // Generate terms
    wire [16:1] P; // Propagate terms

    assign C[0] = Cin;

    // Generate and propagate terms
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_prop
            assign G[i] = A[i] & B[i];   // Generate
            assign P[i] = A[i] | B[i];   // Propagate
            assign C[i] = G[i] | (P[i] & C[i-1]); // Carry
        end
    endgenerate

    // Calculate sum and carry out
    for (i = 1; i <= 16; i = i + 1) begin : sum_loop
        assign S[i] = A[i] ^ B[i] ^ C[i-1]; // Sum bit
    end

    assign Cout = C[16]; // Final carry-out

endmodule