// Define an 8-bit adder module
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Internal wires for carry propagation
    wire carry_internal;
    
    // Lower 8 bits addition
    assign {carry_internal, sum[7:0]} = a[7:0] + b[7:0] + cin;
    
    // Carry-out is the MSB of the 9-bit result
    assign cout = carry_internal;

endmodule

// Define the 16-bit adder module using two 8-bit adders
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Internal wire to carry the carry-out from the lower adder to the higher adder
    wire carry_internal;
    
    // Instantiate the lower 8-bit adder
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_internal) // Carry-out of lower adder is carry-in of higher adder
    );
    
    // Instantiate the higher 8-bit adder
    adder_8bit higher_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_internal), // Carry-in is the carry-out from the lower adder
        .sum(y[15:8]),
        .cout(Co) // Carry-out of the full 16-bit adder
    );

endmodule