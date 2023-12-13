module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    reg [63:0] stage1;
    reg [63:0] stage2;
    reg [63:0] stage3;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            stage1 <= 64'b0;
            stage2 <= 64'b0;
            stage3 <= 64'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            if (i_en) begin
                stage1 <= adda + addb;
                stage2 <= stage1 + stage2[63:0];
                stage3 <= stage2 + stage3[63:0];
                result <= {stage3[63], stage3};
                o_en <= 1'b1;
            end else begin
                stage1 <= 64'b0;
                stage2 <= 64'b0;
                stage3 <= 64'b0;
                result <= 65'b0;
                o_en <= 1'b0;
            end
        end
    end

endmodule