module calendar(
    input wire CLK,  // Clock input
    input wire RST,  // Active high reset signal
    output reg [5:0] Hours,  // 6-bit output for hours (0-23)
    output reg [5:0] Mins,   // 6-bit output for minutes (0-59)
    output reg [5:0] Secs    // 6-bit output for seconds (0-59)
);

    // Always block for seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset seconds to 0
            Secs <= 0;
        end else if (Secs == 59) begin
            // Wrap around and increment minutes
            Secs <= 0;
        end else begin
            // Increment seconds
            Secs <= Secs + 1;
        end
    end

    // Always block for minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset minutes to 0
            Mins <= 0;
        end else if (Secs == 59 && Mins == 59) begin
            // Wrap around and increment hours
            Mins <= 0;
        end else if (Secs == 59) begin
            // Increment minutes
            Mins <= Mins + 1;
        end
        // No else part needed, minutes stay the same if Secs is not 59
    end

    // Always block for hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset hours to 0
            Hours <= 0;
        end else if (Secs == 59 && Mins == 59 && Hours == 23) begin
            // Wrap around to 0 after 23:59:59
            Hours <= 0;
        end else if (Secs == 59 && Mins == 59) begin
            // Increment hours
            Hours <= Hours + 1;
        end
        // No else part needed, hours stay the same if Secs and Mins are not 59
    end

endmodule