module full_adder_1bit(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire[6:0] carry;

    genvar i;
    generate
        for(i = 0; i < 7; i = i + 1) begin : gen_full_adder
            if (i == 0) begin
                full_adder_1bit fa(a[i], b[i], cin, sum[i], carry[i]);
            end else begin
                full_adder_1bit fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
            end
        end
    endgenerate

    full_adder_1bit fa_last(a[7], b[7], carry[6], sum[7], cout);
endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire cout_first; // Carry out from the first 8-bit adder

    // First 8-bit adder
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(cout_first)
    );

    // Second 8-bit adder
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_first),
        .sum(y[15:8]),
        .cout(Co)
    );

endmodule