module chatgpt4_generate_freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [0:0] div_50;
    reg [2:0] div_10;
    reg [6:0] div_1;

    always @(posedge CLK_in or negedge RST) begin
        if (!RST) begin
            div_50 <= 1'b0;
            div_10 <= 3'b000;
            div_1 <= 7'b0000000;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            if (div_50) begin
                div_50 <= ~div_50;
                CLK_50 <= ~CLK_50;
            end else begin
                div_50 <= ~div_50;
            end

            if (div_10 == 4'b101) begin
                div_10 <= 4'b000;
                CLK_10 <= ~CLK_10;
            end else begin
                div_10 <= div_10 + 1'b1;
            end

            if (div_1 == 7'b1100100) begin
                div_1 <= 7'b0000000;
                CLK_1 <= ~CLK_1;
            end else begin
                div_1 <= div_1 + 1'b1;
            end
        end
    end
endmodule