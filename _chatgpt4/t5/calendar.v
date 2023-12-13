module calendar (
    input CLK,  // Clock input
    input RST,  // Active high reset signal
    output reg [5:0] Hours, // 6-bit output for hours (0-23)
    output reg [5:0] Mins,  // 6-bit output for minutes (0-59)
    output reg [5:0] Secs   // 6-bit output for seconds (0-59)
);

    // Update seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset seconds to 0
            Secs <= 6'd0;
        end else if (Secs == 6'd59) begin
            // Reset seconds and increment minutes
            Secs <= 6'd0;
        end else begin
            // Increment seconds
            Secs <= Secs + 6'd1;
        end
    end

    // Update minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset minutes to 0
            Mins <= 6'd0;
        end else if (Secs == 6'd59) begin
            if (Mins == 6'd59) begin
                // Reset minutes when seconds and minutes are both 59
                Mins <= 6'd0;
            end else begin
                // Increment minutes
                Mins <= Mins + 6'd1;
            end
        end
        // If Secs is not 59, keep Mins unchanged
    end

    // Update hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset hours to 0
            Hours <= 6'd0;
        end else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 6'd23) begin
                // Reset hours when seconds, minutes, and hours are at their max
                Hours <= 6'd0;
            end else begin
                // Increment hours
                Hours <= Hours + 6'd1;
            end
        end
        // If Secs is not 59 or Mins is not 59, keep Hours unchanged
    end

endmodule