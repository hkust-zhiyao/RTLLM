module right_shifter(
    input wire clk,
    input wire d,
    output reg [7:0] q
);

    // Initialize the 'q' register to 0
    initial begin
        q = 8'b00000000;
    end

    // On each rising edge of the clock, shift 'q' right and insert 'd' at MSB
    always @(posedge clk) begin
        q <= {d, q[7:1]};
    end

endmodule