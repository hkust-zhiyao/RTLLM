`timescale 1ns / 1ps

module freq_div(
    input CLK_in, // Input clock signal at 100MHz
    input RST,    // Active high reset signal
    output reg CLK_50,  // Output clock signal at 50MHz
    output reg CLK_10,  // Output clock signal at 10MHz
    output reg CLK_1    // Output clock signal at 1MHz
);

    // Counter for the 10MHz clock generation
    reg [2:0] cnt_10; // 3-bit counter for dividing by 10
    // Counter for the 1MHz clock generation
    reg [5:0] cnt_100; // 6-bit counter for dividing by 100

    // CLK_50 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset condition
            CLK_50 <= 1'b0;
        end else begin
            // Toggle CLK_50 every clock cycle to divide the frequency by 2
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset condition
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == 3'd4) begin
                // Toggle CLK_10 and reset the counter
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                // Increment the counter
                cnt_10 <= cnt_10 + 1;
            end
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset condition
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            if (cnt_100 == 6'd49) begin
                // Toggle CLK_1 and reset the counter
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                // Increment the counter
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule