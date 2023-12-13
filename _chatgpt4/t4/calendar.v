`timescale 1ns / 1ps

module calendar(
    input CLK,      // Clock input
    input RST,      // Active high reset
    output reg [5:0] Hours,  // 6-bit hours (0-23)
    output reg [5:0] Mins,   // 6-bit minutes (0-59)
    output reg [5:0] Secs    // 6-bit seconds (0-59)
);

    // Seconds logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0;
        end else if (Secs == 59) begin
            Secs <= 0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // Minutes logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 0;
        end else if (Secs == 59 && Mins == 59) begin
            Mins <= 0;
        end else if (Secs == 59) begin
            Mins <= Mins + 1;
        end
    end

    // Hours logic
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