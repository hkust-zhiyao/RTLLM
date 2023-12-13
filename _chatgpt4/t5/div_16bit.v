`timescale 1ns / 1ps

module div_16bit(
    input [15:0] A,      // 16-bit dividend
    input [7:0] B,       // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

    // Temporary registers to hold intermediate values and shifted divisor
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg [15:0] remainder;

    integer i;

    always @* begin
        // Initialize the values
        dividend = A;
        divisor = {B, 8'd0}; // Align the divisor with the higher bits of the dividend
        remainder = 0;
        result = 0;

        // Loop to process each bit from MSB to LSB
        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder and bring down the next bit of the dividend
            remainder = (remainder << 1) | (dividend[15] & 1'b1);
            dividend = dividend << 1; // Shift the dividend

            // Compare the upper bits of the dividend with the divisor
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                result = (result << 1) | 1'b1;
            end else begin
                result = result << 1;
            end
        end

        // Assign the final remainder value
        odd = remainder;
    end

endmodule