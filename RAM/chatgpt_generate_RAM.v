module chatgpt_generate_RAM (
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [3:0] read_data
);

reg [3:0] memory [0:7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the memory to all zeros
        for (int i = 0; i < 8; i++)
            memory[i] <= 4'b0000;
    end else begin
        // Write operation
        if (write_en) begin
            memory[write_addr] <= write_data;
        end
        // Read operation
        if (read_en) begin
            read_data <= memory[read_addr];
        end
    end
end

endmodule
