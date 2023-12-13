module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    // Define the pipeline stages registers
    reg [63:0] stage0_adda, stage0_addb;
    reg [63:0] stage1_adda, stage1_addb;
    reg [63:0] stage2_adda, stage2_addb;
    reg [64:0] stage3_sum;
    
    // Define the enable signals for each stage
    reg stage0_en, stage1_en, stage2_en, stage3_en;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and enable signals
            {stage0_adda, stage0_addb, stage1_adda, stage1_addb, stage2_adda, stage2_addb, stage3_sum} <= 0;
            {stage0_en, stage1_en, stage2_en, stage3_en, o_en} <= 0;
            result <= 0;
        end else begin
            // Pipeline stage 0 (input latching)
            if (i_en) begin
                stage0_adda <= adda;
                stage0_addb <= addb;
                stage0_en <= 1'b1;
            end else begin
                stage0_en <= 1'b0;
            end
            
            // Pipeline stage 1 (propagation stage)
            if (stage0_en) begin
                stage1_adda <= stage0_adda;
                stage1_addb <= stage0_addb;
                stage1_en <= 1'b1;
            end else begin
                stage1_en <= 1'b0;
            end
            
            // Pipeline stage 2 (propagation stage)
            if (stage1_en) begin
                stage2_adda <= stage1_adda;
                stage2_addb <= stage1_addb;
                stage2_en <= 1'b1;
            end else begin
                stage2_en <= 1'b0;
            end
            
            // Pipeline stage 3 (addition stage)
            if (stage2_en) begin
                stage3_sum <= stage2_adda + stage2_addb;
                stage3_en <= 1'b1;
            end else begin
                stage3_en <= 1'b0;
            end
            
            // Output result
            if (stage3_en) begin
                result <= stage3_sum;
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule