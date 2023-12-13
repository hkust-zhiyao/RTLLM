Please act as a professional verilog designer.

Implement a dual-port RAM with a depth of 8 and a bit width of 6 bits, with all data initialized to 000000. It has two groups of ports, respectively for reading data and writing data, and read and write operations can be carried out at the same time. When the read_en signal is 1, the read_data of the corresponding position is read through the read_addr signal and output; When the write_en signal is 1, data is written to the corresponding position through the write_addr signal and write-data signal.

Module name:  
    RAM               
Input ports:
	clk: Clock signal used for synchronous operation.
	rst_n: Active-low reset signal. Defined as 0 for reset and 1 for reset signal inactive.
	write_en: Write enable signal to initiate a write operation.
	write_addr: Address for the write operation.
	write_data: Data to be written to the RAM.
	read_en: Read enable signal to initiate a read operation.
	read_addr: Address for the read operation.

Output ports:
    read_data: Output signal representing the data read from the RAM.

Parameter: 
	WIDTH = 6;
    DEPTH = 8;

Implementation:
RAM Array:
The module includes a register array, RAM. The array is defined as reg [DEPTH - 1 : 0] RAM [2**WIDTH-1:0], allowing for 2^6 memory locations, each with a width of 6 bits.
Write Operation:
The first always block triggers on the positive edge of the clock signal (posedge clk) or the negative edge of the reset signal (negedge rst_n).
On reset, indicated by !rst_n, all memory locations in the RAM array are cleared to 0.
If the write enable signal (write_en) is active, the data (write_data) is written to the RAM array at the specified address (write_addr).
Read Operation:
The second always block triggers on the positive edge of the clock signal (posedge clk) or the negative edge of the reset signal (negedge rst_n).
On reset, indicated by !rst_n, the read_data register is cleared to 0.
If the read enable signal (read_en) is active, the data at the specified address (read_addr) in the RAM array is assigned to the read_data register.
If the read enable signal is not active, the read_data register is cleared to 0.

Give me the complete code.
