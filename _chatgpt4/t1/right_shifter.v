module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

    // Initialize the register 'q' to 0
    initial q = 8'b00000000;

    // On each rising edge of the clock, perform the right shift operation
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Insert input 'd' into the MSB position after the shift
    end

endmodule