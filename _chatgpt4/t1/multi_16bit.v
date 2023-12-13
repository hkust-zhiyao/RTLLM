module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

    reg [3:0] i; // Shift count register
    reg [15:0] areg, breg; // Registers for multiplicand and multiplier
    reg [31:0] yout_r; // Register for the product
    reg done_r; // Register for the done signal

    // Initialize the output and internal registers
    initial begin
        i = 0;
        areg = 0;
        breg = 0;
        yout_r = 0;
        done_r = 0;
        yout = 0;
    end

    // Assign the done signal to the done_r register
    assign done = done_r;

    // Control logic for multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            i <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done_r <= 0;
        end else if (start) begin
            if (i == 0) begin
                // Load the input values into registers
                areg <= ain;
                breg <= bin;
                yout_r <= 0; // Clear the accumulator
            end else if (i < 17) begin
                // Perform shift and accumulate if the corresponding bit in areg is set
                if (areg[i-1])
                    yout_r <= yout_r + (breg << (i - 1));
            end

            // Increment the shift count register
            if (i < 17) begin
                i <= i + 1;
            end

            // Update the done flag
            done_r <= (i == 16);
        end else begin
            // If start is not active, reset the shift count and done flag
            i <= 0;
            done_r <= 0;
        end
    end

    // Update the output register at the end of multiplication
    always @(posedge clk) begin
        if (done_r) begin
            yout <= yout_r; // Assign the accumulated product to the output
        end
    end

endmodule