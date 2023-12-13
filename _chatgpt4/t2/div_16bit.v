module div_16bit(
    input wire [15:0] A,  // 16-bit dividend
    input wire [7:0] B,   // 8-bit divisor
    output wire [15:0] result, // 16-bit quotient
    output wire [15:0] odd  // 16-bit remainder
);

    // Intermediate wires to hold the results of each step
    wire [15:0] subtract_results[7:0];
    wire [7:0] compare_results;

    // Initial partial dividend (most significant bits of A)
    wire [7:0] partial_dividend;
    assign partial_dividend = A[15:8];

    // The subtraction and comparison at each step
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : div_step
            // Compare and subtract
            assign compare_results[i] = (partial_dividend >= B) ? 1'b1 : 1'b0;
            assign subtract_results[i] = (partial_dividend >= B) ? (partial_dividend - B) : partial_dividend;
            
            // Prepare next partial dividend for the next stage
            if (i < 7) begin
                assign partial_dividend = {subtract_results[i][6:0], A[7-i]};
            end
        end
    endgenerate

    // Combine the compare results to form the quotient
    assign result = {compare_results, A[7:0]};

    // The final remainder is the result of the last subtraction
    assign odd = {subtract_results[7], A[7:0]};

endmodule