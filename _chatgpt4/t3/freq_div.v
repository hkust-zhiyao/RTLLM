module freq_div(
    input CLK_in,  // Input clock signal
    input RST,     // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

    // Counter for the CLK_10 generation
    reg [3:0] cnt_10 = 4'd0; // 4 bits counter to count up to 9 (10 states)
    
    // Counter for the CLK_1 generation
    reg [6:0] cnt_100 = 7'd0; // 7 bits counter to count up to 99 (100 states)

    // CLK_50 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 4'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == 4'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 4'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == 7'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule