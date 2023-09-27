module chatgpt_generate_calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Internal registers to hold the count values
reg [5:0] sec_count;
reg [5:0] min_count;
reg [5:0] hr_count;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_count <= 6'b000000;
        min_count <= 6'b000000;
        hr_count  <= 6'b000000;
    end else begin
        // Seconds counter logic
        if (sec_count == 6'b011101) begin // 59 in binary
            sec_count <= 6'b000000;
            // Minutes increment logic
            if (min_count == 6'b011101) begin // 59 in binary
                min_count <= 6'b000000;
                // Hours increment logic
                if (hr_count == 6'b001100) // 24 in binary
                    hr_count <= 6'b000000;
                else
                    hr_count <= hr_count + 1;
            end else
                min_count <= min_count + 1;
        end else
            sec_count <= sec_count + 1;
    end
end

// Assign the output ports
assign Secs = sec_count;
assign Mins = min_count;
assign Hours = hr_count;

endmodule
