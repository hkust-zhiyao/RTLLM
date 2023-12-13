module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Initialize the q register to 0
initial begin
    q = 8'b00000000;
end

// Perform the right shift operation on the rising edge of the clock
always @(posedge clk) begin
    q <= {d, q[7:1]}; // Insert the input bit d into the most significant bit of q, and shift the rest right
end

endmodule