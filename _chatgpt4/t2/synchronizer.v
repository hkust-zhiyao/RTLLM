module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register to store input data on clk_a
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0000;
        else if (data_en)
            data_reg <= data_in;
    end

    // Enable data register to store input enable on clk_a
    reg en_data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            en_data_reg <= 1'b0;
        else
            en_data_reg <= data_en;
    end

    // Synchronizer flip-flops for the enable signal on clk_b
    reg en_clk_b_one, en_clk_b_two;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clk_b_one <= 1'b0;
            en_clk_b_two <= 1'b0;
        end else begin
            en_clk_b_one <= en_data_reg;
            en_clk_b_two <= en_clk_b_one;
        end
    end

    // Output assignment based on the synchronized enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0000;
        else if (en_clk_b_two)
            dataout <= data_reg;
        // No else condition to hold the previous value when not enabled
    end

endmodule