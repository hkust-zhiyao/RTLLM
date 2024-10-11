module clkgenerator (
    output reg clk
);

    parameter PERIOD = 10; // Clock period in time units

    // Initial block to set the initial state of the clock
    initial begin
        clk = 0; // Initialize the clock signal to 0
    end

    always begin
        # (PERIOD / 2) clk = ~clk; // Toggle the clock every half period
    end

endmodule
