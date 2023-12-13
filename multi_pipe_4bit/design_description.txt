Please act as a professional verilog designer.

Implement the design of 4bit unsigned number pipeline multiplier. It consists of two levels of registers to store intermediate values and control the multiplication process.

Module name:  
    multi_pipe_4bit 

Input ports:
    clk: Clock signal used for synchronous operation.
    rst_n: Active-low reset signal. Defined as 0 for chip reset and 1 for reset signal inactive.
    mul_a: Input signal representing the multiplicand with a data width of "size" bits.
    mul_b: Input signal representing the multiplier with a data width of "size" bits.	

Output ports:
    mul_out: Product output signal with a data width of 2*size bits.

Parameter:
    size = 4

Implementation:
Extension of input signals:
The input signals (mul_a and mul_b) are extended by adding "size" number of zero bits at the most significant bit positions.
Multiplication operation:
The module uses a generate block to perform multiplication for each bit position of the multiplier (mul_b) and generate the partial products.
For each bit position i from 0 to size-1, the partial product is calculated as follows:
If the corresponding bit in the multiplier is 1, the multiplicand is left-shifted by i positions.
If the corresponding bit in the multiplier is 0, the partial product is set to 0 ('d0).
Add of partial products:
The module uses registers to store the intermediate sum values.
On the positive edge of the clock signal (clk) or the falling edge of the reset signal (rst_n), the module performs add operations.
If the reset signal (rst_n) is low, indicating a reset condition, the registers are set to 0.
If the reset signal (rst_n) is high, the registers are updated with the sum of the corresponding partial products.
Final product calculation:
On the positive edge of the clock signal (clk) or the falling edge of the reset signal (rst_n), the module calculates the final product.
If the reset signal (rst_n) is low, indicating a reset condition, the product output (mul_out) is set to 0.
If the reset signal (rst_n) is high, the product output (mul_out) is updated with the sum of registers.

Give me the complete code.
