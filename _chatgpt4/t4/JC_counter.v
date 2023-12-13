`timescale 1ns / 1ps

module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

    // On every rising edge of the clock or falling edge of reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low reset condition; reset the counter value
            Q <= 64'b0;
        end else begin
            // Check the least significant bit to decide on appending a '1' or '0'
            if (Q[0] == 1'b0) begin
                // LSB is '0', so shift left and append '1' at the MSB
                Q <= {Q[62:0], 1'b1};
            end else begin
                // LSB is '1', so shift left and append '0' at the MSB (inverting the sequence)
                Q <= {Q[62:0], 1'b0};
            end
        end
    end

endmodule