module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

    // Wires for the carry between lower and upper 8-bit adders
    wire carry;

    // Instantiate the 8-bit adders
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry) // Carry from lower 8 bits
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry), // Carry from lower 8 bits
        .sum(y[15:8]),
        .cout(Co) // Carry out from the entire 16-bit adder
    );

endmodule

// 8-bit adder module
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);

    wire [6:0] carry;

    // Instantiate the 1-bit full adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_loop
            if (i == 0) begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else if (i == 7) begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(cout)
                );
            end else begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

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
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule