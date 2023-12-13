module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [31:0] product;      // Accumulated product
    reg [15:0] multiplicand; // Register for the multiplicand
    reg [15:0] multiplier;   // Register for the multiplier
    reg [4:0] i;             // Shift count register (4 bits for 0-16 range)
    reg done_r;              // Internal completion flag

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset the registers and flags
            i <= 5'b0;
            multiplicand <= 16'b0;
            multiplier <= 16'b0;
            product <= 32'b0;
            done_r <= 1'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end else begin
            if (start) begin
                if (i < 17) begin
                    if (i == 0) begin
                        // Load the registers
                        multiplicand <= ain;
                        multiplier <= bin;
                        product <= 32'b0; // Clear the product register
                    end else begin
                        // Shift and accumulate
                        if (multiplicand[0]) begin
                            product <= product + (multiplier << (i - 1));
                        end
                        multiplicand <= multiplicand >> 1; // Shift right for the next cycle
                    end
                    i <= i + 1;
                end

                // Set the done flag when the operation is complete
                if (i == 16) begin
                    done_r <= 1'b1;
                    yout <= product; // Assign the accumulated product to the output
                end else if (i == 17) begin
                    // Clear the done flag for the next operation
                    done_r <= 1'b0;
                    i <= 0; // Reset the shift count register for the next operation
                end
            end else begin
                // Clear the shift count register if start is not active
                i <= 0;
                done_r <= 1'b0;
            end
            done <= done_r; // Output the done status
        end
    end

endmodule