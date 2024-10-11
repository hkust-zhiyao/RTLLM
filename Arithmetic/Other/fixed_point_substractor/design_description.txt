Please act as a professional Verilog designer.

Implement a module of a fixed-point subtractor for precise arithmetic operations with fixed precision.

Module name:
    fixed_point_subtractor

Parameterized values:
    Q: Represents the number of fractional bits in the fixed-point representation.
    N: Represents the total number of bits (both integer and fractional) used for inputs and outputs.

Input ports:
    a [N-1:0]: First N-bit fixed-point input operand.
    b [N-1:0]: Second N-bit fixed-point input operand.

Output ports:

    c [N-1:0]: N-bit output representing the result of the fixed-point subtraction.
Internal registers:
    res [N-1:0]: N-bit register used to store the result of the subtraction operation.

Implementation:
    Same Sign Subtraction: When the signs of a and b are the same, their fractional and integer parts are subtracted. The sign of the result will be the same as the inputs.

Different Sign Subtraction:
    If a is positive and b is negative, the absolute values of a and b are added. The result will have a positive sign if a is greater than b, and a negative sign otherwise.
    If a is negative and b is positive, the same logic applies, with the result's sign depending on the relative sizes of a and b.

Handling Zero: 
    When the result is zero, the sign bit is explicitly set to 0 to handle this edge case.

Precision: 
    The fixed-point precision is defined by the parameters Q (fractional bits) and N (total bits). This ensures that the subtraction is performed accurately while maintaining the necessary precision for both integer and fractional parts.

Give me the complete code.