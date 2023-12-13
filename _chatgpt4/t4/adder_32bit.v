module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16; // Carry out from the lower 16-bit CLA block

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lower(
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(1'b0), // no carry-in for the least significant block
        .S(S[16:1]),
        .cout(C16)
    );

    cla_16bit cla_upper(
        .A(A[32:17]),
        .B(B[32:17]),
        .cin(C16), // carry-in is the carry-out from the lower 16-bit block
        .S(S[32:17]),
        .cout(C32)
    );

endmodule

// 16-bit CLA block
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input cin,
    output [16:1] S,
    output cout
);

    wire [4:0] c; // intermediate carries between CLA blocks, c[0] is cin

    assign c[0] = cin;

    // Instantiate four 4-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_block
            cla_4bit cla_unit(
                .A(A[i*4+4:i*4+1]),
                .B(B[i*4+4:i*4+1]),
                .cin(c[i]),
                .S(S[i*4+4:i*4+1]),
                .cout(c[i+1])
            );
        end
    endgenerate

    assign cout = c[4]; // The carry-out of the last CLA block is the carry-out of the entire 16-bit block

endmodule

// 4-bit CLA block
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input cin,
    output [4:1] S,
    output cout
);

    wire [4:1] g; // generate
    wire [4:1] p; // propagate
    wire [4:0] c; // carries, c[0] is cin

    // Generate and propagate terms
    assign g = A & B;
    assign p = A ^ B;

    // Calculate carries
    assign c[0] = cin;
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);

    // Calculate the sum
    assign S = p ^ c[4:1];

    // Carry-out is the last carry bit
    assign cout = c[4];

endmodule