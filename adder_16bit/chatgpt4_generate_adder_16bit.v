// Define the 1-bit full adder
module full_adder (
    input a, b, c_in,
    output sum, c_out
);
    assign sum = a ^ b ^ c_in;
    assign c_out = (a & b) | (c_in & (a ^ b));
endmodule

// Define the 16-bit full adder
module chatgpt_generate_adder_16bit (
    input [15:0] a, b,
    input c_up,
    output [15:0] y,
    output Co
);
    wire [15:0] c; // carry bits

    // Create 16 1-bit full adders
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin: adder_bit
            full_adder FA (
                .a(a[i]),
                .b(b[i]),
                .c_in(i == 0 ? c_up : c[i-1]),
                .sum(y[i]),
                .c_out(c[i])
            );
        end
    endgenerate

    // The carry out is the carry from the last 1-bit full adder
    assign Co = c[15];
endmodule