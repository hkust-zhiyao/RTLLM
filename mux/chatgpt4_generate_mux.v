module chatgpt_generate_mux (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

    reg data_en_sync1, data_en_sync2, data_en_sync3;
    reg [3:0] data_in_sync1, data_in_sync2;
    
    // Synchronize data_en signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_en_sync1 <= 0;
            data_en_sync2 <= 0;
            data_en_sync3 <= 0;
        end else begin
            data_en_sync1 <= data_en;
            data_en_sync2 <= data_en_sync1;
            data_en_sync3 <= data_en_sync2;
        end
    end
    
    // Synchronize data_in signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_in_sync1 <= 0;
            data_in_sync2 <= 0;
        end else begin
            data_in_sync1 <= data_in;
            data_in_sync2 <= data_in_sync1;
        end
    end
    
    // Transfer data when data_en signal is synchronized
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) dataout <= 0;
        else if (data_en_sync3) dataout <= data_in_sync2;
    end

endmodule