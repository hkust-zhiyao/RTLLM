module adder_bcd (
    input  [3:0] A,   // First BCD number (0-9)
    input  [3:0] B,   // Second BCD number (0-9)
    input  Cin,       // Input carry
    output [3:0] Sum, // BCD sum (0-9)
    output Cout       // Output carry
);
    wire [4:0] temp_sum;        // Temporary 5-bit sum to store initial result
    wire [3:0] corrected_sum;   // Adjusted BCD sum
    wire carry_out;             // Corrected carry-out

    // Step 1: Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // Step 2: If the sum is greater than 9, adjust the sum by adding 6
    assign carry_out = (temp_sum > 9) ? 1 : 0;  // If sum exceeds 9, set carry
    assign corrected_sum = (temp_sum > 9) ? (temp_sum + 4'b0110) : temp_sum;  // Add 6 to correct BCD

    // Output the corrected sum and the carry
    assign Sum = corrected_sum[3:0];  // The BCD sum is the lower 4 bits
    assign Cout = carry_out;          // Output the carry
endmodule
