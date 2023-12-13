module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

    // Data and enable registers for clk_a domain
    reg [3:0] data_reg;
    reg en_data_reg;

    // Double-registering for en_data_reg in clk_b domain for synchronization
    reg en_clap_one;
    reg en_clap_two;

    // Register data_in on clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Synchronize the enable signal to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg; // First D flip-flop for en_data_reg
            en_clap_two <= en_clap_one;  // Second D flip-flop for en_data_reg
        end
    end

    // Assign dataout based on synchronized enable signal (en_clap_two)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_clap_two) begin
            // Only update dataout when the enable signal has been stable high for two clk_b cycles
            dataout <= data_reg;
        end
        // If en_clap_two is low, retain the previous value (no need for an else statement)
    end

endmodule