`timescale 1ns / 1ps

module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg, breg;
    reg [4:0] i; // 5 bits to represent the count from 0 to 16
    reg [31:0] yout_r;
    reg done_r;
    
    // Reset and start conditions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (i < 17) begin
                    if (i == 0) begin
                        // Load the registers with the inputs
                        areg <= ain;
                        breg <= bin;
                        yout_r <= 32'b0;
                    end else begin
                        // Shift and accumulate
                        yout_r <= yout_r + ({16'b0, areg[0] ? breg : 16'b0} << (i - 1));
                        areg <= areg >> 1; // Shift the multiplicand right
                    end
                    i <= i + 1'b1;
                    done <= 1'b0;
                end else begin
                    // Multiplication is done
                    done <= 1'b1;
                    i <= 5'b0; // Reset the counter for the next operation
                end
            end else begin
                // Start is not active, reset the counter
                i <= 5'b0;
                done <= 1'b0;
            end
        end
    end
    
    // Assign the internal register to the output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'b0;
        end else begin
            if (done) begin
                yout <= yout_r;
            end
        end
    end

endmodule