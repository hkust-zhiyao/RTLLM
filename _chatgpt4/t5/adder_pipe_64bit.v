module adder_pipe_64bit(
    input clk,          // Clock input
    input rst_n,        // Active low reset signal
    input i_en,         // Enable signal for addition operation
    input [63:0] adda,  // 64-bit input operand A
    input [63:0] addb,  // 64-bit input operand B
    output reg [64:0] result, // 65-bit output representing the sum of adda and addb
    output reg o_en           // Output enable signal
);

    // Intermediate registers for pipeline stages
    reg [63:0] reg_adda_stage1, reg_addb_stage1;
    reg [64:0] reg_sum_stage2;
    reg reg_i_en_stage1, reg_i_en_stage2;

    // Combinational logic for addition
    wire [64:0] sum_stage1; // 65-bit to store sum and carry out

    // First stage addition
    assign sum_stage1 = reg_adda_stage1 + reg_addb_stage1;

    // Sequential logic for registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and output enable
            reg_adda_stage1 <= 0;
            reg_addb_stage1 <= 0;
            reg_sum_stage2 <= 0;
            reg_i_en_stage1 <= 0;
            reg_i_en_stage2 <= 0;
            o_en <= 0;
            result <= 0;
        end else begin
            // Pipeline stage 1
            if (i_en) begin
                reg_adda_stage1 <= adda; // Load inputs into pipeline stage 1
                reg_addb_stage1 <= addb;
                reg_i_en_stage1 <= i_en; // Enable signal for stage 1
            end

            // Pipeline stage 2
            reg_sum_stage2 <= sum_stage1; // Output of adder goes into stage 2
            reg_i_en_stage2 <= reg_i_en_stage1; // Enable signal for stage 2

            // Result and output enable
            result <= reg_sum_stage2; // Result is stored in output register
            o_en <= reg_i_en_stage2;  // Output enable signal
        end
    end

endmodule