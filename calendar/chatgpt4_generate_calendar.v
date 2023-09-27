module chatgpt_generate_calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

    localparam SEC = 50_000_000; // Assuming the clock frequency is 50MHz
    localparam MIN = 60 * SEC;
    localparam HOUR = 60 * MIN;

    reg [26:0] count = 0; // 27-bit counter to count for 1 hour

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            count <= 0;
            Secs <= 0;
            Mins <= 0;
            Hours <= 0;
        end else if (count == HOUR - 1) begin
            count <= 0;
            Secs <= 0;
            Mins <= 0;
            Hours <= Hours + 1;
        end else begin
            count <= count + 1;
            if (count % SEC == SEC - 1) begin
                if (Secs == 59) begin
                    Secs <= 0;
                    if (Mins == 59) begin
                        Mins <= 0;
                    end else begin
                        Mins <= Mins + 1;
                    end
                end else begin
                    Secs <= Secs + 1;
                end
            end
        end
    end
endmodule