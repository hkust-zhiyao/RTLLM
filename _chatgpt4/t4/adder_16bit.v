module adder_16bit(
    input [15:0] a,   // 16-bit input operand A
    input [15:0] b,   // 16-bit input operand B
    input cin,        // Carry-in input
    output [15:0] y,  // 16-bit output sum
    output co         // Carry-out output
);

    // Internal signals to hold carry outputs from the 8-bit adders
    wire carry_out_8bit;

    // Instantiate the first 8-bit adder (for LSBs)
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cin),
        .sum(y[7:0]),
        .cout(carry_out_8bit)
    );

    // Instantiate the second 8-bit adder (for MSBs)
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_out_8bit),
        .sum(y[15:8]),
        .cout(co)
    );

endmodule

// 8-bit adder module
module adder_8bit(
    input [7:0] a,   // 8-bit input operand A
    input [7:0] b,   // 8-bit input operand B
    input cin,       // Carry-in input
    output [7:0] sum,// 8-bit output sum
    output cout      // Carry-out output
);

    // Internal signals for the sum and carry at each bit
    wire [6:0] carry;

    // Instantiate full adders for each bit
    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : adder_loop
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Connect the final carry out
    assign cout = carry[7-1];

endmodule

// Full adder module
module full_adder(
    input a,    // Single bit input A
    input b,    // Single bit input B
    input cin,  // Carry-in
    output sum, // Sum output
    output cout // Carry-out
);

    // Sum and carry logic
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule