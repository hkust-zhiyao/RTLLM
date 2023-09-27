module chatgpt_generate_edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            rise <= a & ~a_prev;
            down <= ~a & a_prev;
            a_prev <= a;
        end
    end
endmodule