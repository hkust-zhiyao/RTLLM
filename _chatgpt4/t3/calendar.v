`timescale 1ns / 1ps

module calendar(
    input CLK,   // Clock input
    input RST,   // Active high reset signal
    output reg [5:0] Hours, // 6-bit output for hours
    output reg [5:0] Mins,  // 6-bit output for minutes
    output reg [5:0] Secs   // 6-bit output for seconds
);

    // Update seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0;
        end else if (Secs == 59) begin
            Secs <= 0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // Update minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 0;
        end else if (Secs == 59 && Mins == 59) begin
            Mins <= 0;
        end else if (Secs == 59) begin
            Mins <= Mins + 1;
        end
    end

    // Update hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 0;
        end else if (Secs == 59 && Mins == 59 && Hours == 23) begin
            Hours <= 0;
        end else if (Secs == 59 && Mins == 59) begin
            Hours <= Hours + 1;
        end
    end

endmodule