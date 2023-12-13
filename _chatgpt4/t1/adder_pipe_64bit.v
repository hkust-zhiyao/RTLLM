module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    // Pipeline stage registers
    reg [63:0] stage_adda;
    reg [63:0] stage_addb;
    reg stage_i_en;

    // Temp register for the sum of A and B
    reg [64:0] sum;

    // Pipeline registers for the sum
    reg [64:0] stage_sum;
    reg stage_sum_valid;

    // Synchronous reset and pipeline register control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            stage_adda <= 64'd0;
            stage_addb <= 64'd0;
            stage_i_en <= 1'b0;
            stage_sum <= 65'd0;
            stage_sum_valid <= 1'b0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Move data through the pipeline on each clock edge
            if (i_en) begin
                // Latch inputs into the pipeline
                stage_adda <= adda;
                stage_addb <= addb;
                stage_i_en <= i_en;
            end

            // Perform addition in the first pipeline stage
            sum <= stage_adda + stage_addb;

            // Move result to the next pipeline stage
            stage_sum <= sum;
            stage_sum_valid <= stage_i_en;

            // The final result and output enable are updated in the last pipeline stage
            result <= stage_sum;
            o_en <= stage_sum_valid;
        end
    end

endmodule