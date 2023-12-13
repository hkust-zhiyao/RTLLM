module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

// Internal register declarations
reg [3:0] data_reg_a; // Register on clock A domain
reg en_data_reg_a; // Enable register on clock A domain
reg en_data_reg_b; // Enable register on clock B domain (first stage)
reg en_data_reg_bb; // Enable register on clock B domain (second stage)

// Data register update with clock A
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg_a <= 4'b0000;
        en_data_reg_a <= 1'b0;
    end else begin
        data_reg_a <= data_in;
        en_data_reg_a <= data_en;
    end
end

// Enable signal synchronization with clock B
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_data_reg_b <= 1'b0;
        en_data_reg_bb <= 1'b0;
    end else begin
        en_data_reg_b <= en_data_reg_a;
        en_data_reg_bb <= en_data_reg_b;
    end
end

// Output assignment with clock B
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0000;
    end else if (en_data_reg_bb) begin
        dataout <= data_reg_a; // Synchronized data transfer on the second enable activation
    end
    // No need for an else clause to retain the previous value, as this is implicit with registers
end

endmodule