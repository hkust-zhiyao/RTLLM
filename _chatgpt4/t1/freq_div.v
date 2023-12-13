module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Internal counters for CLK_10 and CLK_1 generation
    reg [3:0] cnt_10 = 0;
    reg [6:0] cnt_100 = 0;

    // CLK_50 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50; // Toggle the CLK_50 output
        end
    end

    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else begin
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10; // Toggle the CLK_10 output
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1; // Toggle the CLK_1 output
                cnt_100 <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule