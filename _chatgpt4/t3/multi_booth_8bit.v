`timescale 1ns / 1ps

module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [7:0] multiplicand;
    reg [8:0] multiplier; // extra bit for the booth algorithm
    reg [3:0] ctr; // counter for the iterations

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Synchronous reset initialization
            p <= 16'b0;
            multiplicand <= a;
            multiplier <= {1'b0, b}; // extra bit for the booth algorithm
            ctr <= 4'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 8) begin
                case (multiplier[1:0])
                    2'b01: p[15:0] <= p + {multiplicand, ctr[2:0]};
                    2'b10: p[15:0] <= p - {multiplicand, ctr[2:0]};
                    default: p <= p; // cases 2'b00 and 2'b11 result in no operation
                endcase
                // Shift multiplier to bring next pair of bits into position
                multiplier <= multiplier >> 2;
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1; // Multiplication process is completed
            end
        end
    end

endmodule