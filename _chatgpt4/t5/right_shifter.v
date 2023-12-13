module right_shifter(
    input wire clk,
    input wire d,
    output reg [7:0] q
);

    // Initialize the shift register to 0
    initial begin
        q = 8'b00000000;
    end

    // Perform the shift operation on the rising edge of the clock
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Concatenate new bit 'd' at the MSB and shift right
    end

endmodule