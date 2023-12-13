module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Internal signals for pipeline stages
reg [63:0] adda_reg, addb_reg;
reg [64:0] sum_reg;
reg i_en_reg, i_en_reg2; // Registered versions of i_en to create pipeline stages

// Pipeline stage 1: Register inputs and i_en
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 0;
        addb_reg <= 0;
        i_en_reg <= 0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        i_en_reg <= i_en; // Capture the enable signal
    end
end

// Pipeline stage 2: Perform addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 0;
        i_en_reg2 <= 0;
    end else begin
        if (i_en_reg) begin
            sum_reg <= adda_reg + addb_reg; // Perform the addition
        end
        i_en_reg2 <= i_en_reg; // Move enable signal down the pipeline
    end
end

// Pipeline stage 3: Output result and o_en
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= sum_reg; // Pass the sum to the output
        o_en <= i_en_reg2; // Output enable signal goes high when the result is valid
    end
end

endmodule