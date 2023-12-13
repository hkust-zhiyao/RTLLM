module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

// Internal signal for the carry output of the lower 8-bit adder
wire carry;

// Instantiate the lower 8-bit adder (for bits [7:0])
adder_8bit lower_adder (
    .a(a[7:0]),
    .b(b[7:0]),
    .cin(Cin),
    .sum(y[7:0]),
    .cout(carry)
);

// Instantiate the upper 8-bit adder (for bits [15:8])
adder_8bit upper_adder (
    .a(a[15:8]),
    .b(b[15:8]),
    .cin(carry),
    .sum(y[15:8]),
    .cout(Co)
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

// Instantiate the full adders for each bit
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_full_adder
        full_adder fa (
            .a(a[i]),
            .b(b[i]),
            .cin(i == 0 ? cin : carry[i - 1]),
            .sum(sum[i]),
            .cout(carry[i])
        );
    end
endgenerate

// The final carry out
assign cout = carry[7];

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