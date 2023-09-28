module chatgpt4_generate_RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [3:0] read_data
);

    reg [3:0] RAM [7:0]; // RAM with 8 locations each of 4 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < 8; i = i + 1) begin
                RAM[i] <= 4'b0000;
            end
        end else begin
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            read_data <= RAM[read_addr];
        end
    end

endmodule