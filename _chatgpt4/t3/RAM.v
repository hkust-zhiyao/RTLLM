module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire write_en,
    input wire [DEPTH-1:0] write_addr,
    input wire [WIDTH-1:0] write_data,
    input wire read_en,
    input wire [DEPTH-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    // Memory array
    reg [WIDTH-1:0] RAM [(1<<DEPTH)-1:0];
    integer i;

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset RAM contents to 0 on reset
            for (i = 0; i < (1<<DEPTH); i = i + 1) begin
                RAM[i] <= 0;
            end
        end else if (write_en) begin
            // Write data to RAM
            RAM[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear read_data on reset
            read_data <= 0;
        end else if (read_en) begin
            // Read data from RAM
            read_data <= RAM[read_addr];
        end else begin
            // Optionally clear read_data if not reading
            read_data <= read_data; // Or you could clear it or do nothing
        end
    end

endmodule