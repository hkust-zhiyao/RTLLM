module synchronizer(
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data Register
    reg [3:0] data_reg;

    // Enable Data Register
    reg en_data_reg;

    // Enable Control Registers
    reg en_clap_one;
    reg en_clap_two;

    // Register data_in with clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0000;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Register data_en with clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // Synchronize the enable signal with clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Output assignment
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0000;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule