module freq_div(
    input CLK_in,  // Input clock signal at 100MHz
    input RST,     // Reset signal (active high)
    output reg CLK_50,   // Output clock signal at 50MHz
    output reg CLK_10,   // Output clock signal at 10MHz
    output reg CLK_1     // Output clock signal at 1MHz
);

    // Counter for the 10MHz clock
    reg [3:0] cnt_10 = 0;  // 5 stages (0-4), toggles at 5
    // Counter for the 1MHz clock
    reg [5:0] cnt_100 = 0; // 50 stages (0-49), toggles at 50

    // Frequency division for 50MHz
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50; // Toggles each clock cycle (50MHz)
        end
    end

    // Frequency division for 10MHz
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else begin
            if (cnt_10 == 4) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10; // Toggle the output clock
            end else begin
                cnt_10 <= cnt_10 + 1;
            end
        end
    end

    // Frequency division for 1MHz
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            if (cnt_100 == 49) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1; // Toggle the output clock
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule