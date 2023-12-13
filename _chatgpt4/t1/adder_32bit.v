// 4-bit carry-lookahead adder block
module cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output [3:0] p,
    output [3:0] g
);
    // Generate propagate and generate signals
    assign p = a ^ b; // Propagate
    assign g = a & b; // Generate

    // Internal carry signals
    wire [4:1] c;

    // Carry-lookahead logic
    assign c[1] = cin;
    assign c[2] = g[0] | (p[0] & c[1]);
    assign c[3] = g[1] | (p[1] & c[2]);
    assign c[4] = g[2] | (p[2] & c[3]);

    // Sum and carry out
    assign sum = p ^ {c[3], c[2], c[1], cin};
    assign cout = g[3] | (p[3] & c[4]);

endmodule

// 16-bit carry-lookahead adder block using 4-bit blocks
module cla_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum,
    output cout
);
    wire [3:0] c; // Internal carries between 4-bit blocks
    wire [3:0] p0, g0, p1, g1, p2, g2, p3, g3; // Propagate and generate for each block

    // Instantiate the 4-bit CLA blocks
    cla_4bit cla0(.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(sum[3:0]), .cout(c[0]), .p(p0), .g(g0));
    cla_4bit cla1(.a(a[7:4]), .b(b[7:4]), .cin(c[0]), .sum(sum[7:4]), .cout(c[1]), .p(p1), .g(g1));
    cla_4bit cla2(.a(a[11:8]), .b(b[11:8]), .cin(c[1]), .sum(sum[11:8]), .cout(c[2]), .p(p2), .g(g2));
    cla_4bit cla3(.a(a[15:12]), .b(b[15:12]), .cin(c[2]), .sum(sum[15:12]), .cout(c[3]), .p(p3), .g(g3));

    // Calculate the final carry out using the generate and propagate signals of the highest block
    assign cout = g3[3] | (p3[3] & c[3]);

endmodule

// 32-bit carry-lookahead adder using two 16-bit blocks
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire c16; // Internal carry between 16-bit blocks

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lower(.a(A[15:0]), .b(B[15:0]), .sum(S[15:0]), .cout(c16));
    cla_16bit cla_upper(.a(A[31:16]), .b(B[31:16]), .sum(S[31:16]), .cout(C32));

endmodule