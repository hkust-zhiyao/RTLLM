module div_16bit(
    input [15:0] A,   // 16-bit dividend
    input [7:0] B,    // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

    // Internal signals for the operation
    reg [15:0] dividend;
    reg [8:0] divisor; // 9 bits to accommodate subtraction
    reg [15:0] quotient;
    reg [15:0] remainder;
    integer i;

    always @(*) begin
        // Initialize the internal signals
        dividend = A;
        divisor = {1'b0, B}; // Extend divisor to 9 bits for subtraction
        quotient = 0;
        remainder = 0;

        // Perform division operation
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift the remainder to the left by 1 bit
            remainder = remainder << 1;
            // Bring down the next bit from the dividend
            remainder[0] = dividend[i];

            // Compare the upper bits of the remainder with the divisor
            if (remainder[8:1] >= divisor) begin
                // If remainder is greater or equal, subtract divisor from remainder
                remainder = remainder - divisor;
                // Set the quotient bit to 1
                quotient[i] = 1'b1;
            end
            else begin
                // Otherwise, the quotient bit remains 0
                quotient[i] = 1'b0;
            end
        end

        // Set the output values
        result = quotient;
        odd = remainder;
    end

endmodule