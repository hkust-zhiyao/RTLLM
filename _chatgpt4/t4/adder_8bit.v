module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);

wire [6:0] carry; // Internal carry wires

// Instantiate 8 full adders
full_adder FA0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(carry[0])
);

full_adder FA1 (
    .a(a[1]),
    .b(b[1]),
    .cin(carry[0]),
    .sum(sum[1]),
    .cout(carry[1])
);

full_adder FA2 (
    .a(a[2]),
    .b(b[2]),
    .cin(carry[1]),
    .sum(sum[2]),
    .cout(carry[2])
);

full_adder FA3 (
    .a(a[3]),
    .b(b[3]),
    .cin(carry[2]),
    .sum(sum[3]),
    .cout(carry[3])
);

full_adder FA4 (
    .a(a[4]),
    .b(b[4]),
    .cin(carry[3]),
    .sum(sum[4]),
    .cout(carry[4])
);

full_adder FA5 (
    .a(a[5]),
    .b(b[5]),
    .cin(carry[4]),
    .sum(sum[5]),
    .cout(carry[5])
);

full_adder FA6 (
    .a(a[6]),
    .b(b[6]),
    .cin(carry[5]),
    .sum(sum[6]),
    .cout(carry[6])
);

full_adder FA7 (
    .a(a[7]),
    .b(b[7]),
    .cin(carry[6]),
    .sum(sum[7]),
    .cout(cout)
);

endmodule

// Full adder module
module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule