module comparator_4bit(
    input [3:0] A,   // First 4-bit input operand
    input [3:0] B,   // Second 4-bit input operand
    output A_greater, 
    output A_equal,   
    output A_less     
);

    wire [3:0] diff;  
    wire cout;       

    assign {cout, diff} = A - B;

    // A > B: if there's no borrow and the difference isn't zero
    assign A_greater = (~cout && diff != 4'b0000);

    assign A_equal = (A == B);

    assign A_less = cout;

endmodule
