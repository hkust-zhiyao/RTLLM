module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input cin,      // Carry-in input
    output [7:0] sum,  // 8-bit output sum
    output cout       // Carry-out output
);

    // Intermediate carry signals
    wire [6:0] carry;

    // Instantiate the full adders
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_full_adders
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // The final carry-out
    assign cout = carry[7-1];

endmodule

// Full adder module
module full_adder(
    input a,     // Single bit input A
    input b,     // Single bit input B
    input cin,   // Carry-in
    output sum,  // Sum output
    output cout  // Carry-out
);

    // Internal signals
    wire sum_intermediate;
    wire carry_intermediate_a;
    wire carry_intermediate_b;

    // Sum calculation
    xor(sum_intermediate, a, b);
    xor(sum, sum_intermediate, cin);

    // Carry-out calculation
    and(carry_intermediate_a, a, b);
    and(carry_intermediate_b, sum_intermediate, cin);
    or(cout, carry_intermediate_a, carry_intermediate_b);

endmodule