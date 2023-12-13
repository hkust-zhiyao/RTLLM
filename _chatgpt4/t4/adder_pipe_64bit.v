module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    // Pipeline stage registers
    reg [31:0] adda_stage1, addb_stage1;
    reg [63:0] sum_stage1;
    reg carry_stage1;
    reg stage1_en, stage2_en;

    // Intermediate sum and carry
    wire [31:0] sum_lower, sum_upper;
    wire carry_lower, carry_upper;

    // Lower 32-bit adder
    assign {carry_lower, sum_lower} = adda[31:0] + addb[31:0];

    // Upper 32-bit adder with carry-in
    assign {carry_upper, sum_upper} = adda[63:32] + addb[63:32] + carry_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            {adda_stage1, addb_stage1} <= 0;
            sum_stage1 <= 0;
            carry_stage1 <= 0;
            result <= 0;
            stage1_en <= 0;
            stage2_en <= 0;
            o_en <= 0;
        end else begin
            // Pipeline stage 1
            if (i_en) begin
                adda_stage1 <= adda[31:0];
                addb_stage1 <= addb[31:0];
                sum_stage1 <= {sum_upper, sum_lower};
                carry_stage1 <= carry_lower;
                stage1_en <= 1;
            end

            // Pipeline stage 2
            if (stage1_en) begin
                result <= {carry_upper, sum_stage1};
                stage2_en <= 1;
            end

            // Output enable logic
            o_en <= stage2_en;
            if (stage2_en) begin
                // Clear enable signals for the next operation
                stage1_en <= 0;
                stage2_en <= 0;
            end
        end
    end

endmodule