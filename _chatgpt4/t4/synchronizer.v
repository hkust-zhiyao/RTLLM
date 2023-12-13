module synchronizer(
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Register to store the input data
    reg [3:0] data_reg;

    // Register to store the input enable signal
    reg en_data_reg;

    // Registers to synchronize the enable signal with clk_b
    reg en_clk_b_one;
    reg en_clk_b_two;

    // Synchronize data_in with clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (~arstn) begin
            data_reg <= 4'b0000;  // Clear data register on reset
        end else if (data_en) begin
            data_reg <= data_in;  // Update data register when data_en is high
        end
    end

    // Synchronize data_en with clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (~arstn) begin
            en_data_reg <= 1'b0;  // Clear enable data register on reset
        end else begin
            en_data_reg <= data_en;  // Update enable data register
        end
    end

    // Two-stage synchronizer for enable signal with clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (~brstn) begin
            en_clk_b_one <= 1'b0;
            en_clk_b_two <= 1'b0;
        end else begin
            en_clk_b_one <= en_data_reg;       // First D flip-flop stage
            en_clk_b_two <= en_clk_b_one;      // Second D flip-flop stage
        end
    end

    // Dataout based on the synchronized enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (~brstn) begin
            dataout <= 4'b0000;  // Clear output data on reset
        end else if (en_clk_b_two) begin
            dataout <= data_reg;  // Update output data when enable signal is high
        end
    end

endmodule