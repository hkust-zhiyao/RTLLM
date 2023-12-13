module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

    // Define the maximum values for seconds, minutes, and hours
    localparam MAX_SECS = 6'd59;
    localparam MAX_MINS = 6'd59;
    localparam MAX_HOURS = 5'd23;

    // Seconds always block
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0; // Reset seconds to 0
        end else if (Secs == MAX_SECS) begin
            Secs <= 0; // Reset seconds to 0 when it reaches the max value
        end else begin
            Secs <= Secs + 1; // Increment seconds
        end
    end

    // Minutes always block
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 0; // Reset minutes to 0
        end else if (Secs == MAX_SECS) begin
            if (Mins == MAX_MINS) begin
                Mins <= 0; // Reset minutes to 0 when it and seconds reach the max value
            end else begin
                Mins <= Mins + 1; // Increment minutes
            end
        end
    end

    // Hours always block
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 0; // Reset hours to 0
        end else if (Mins == MAX_MINS && Secs == MAX_SECS) begin
            if (Hours == MAX_HOURS) begin
                Hours <= 0; // Reset hours to 0 when it, minutes, and seconds reach the max value
            end else begin
                Hours <= Hours + 1; // Increment hours
            end
        end
    end

endmodule