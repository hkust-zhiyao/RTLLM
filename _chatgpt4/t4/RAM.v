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

    // Declare the RAM array
    reg [WIDTH-1:0] RAM [(1<<DEPTH)-1:0];

    // Synchronous write operation with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear the RAM array
            integer i;
            for (i = 0; i < (1<<DEPTH); i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}}; // Initialize each bit to 0
            end
        end else if (write_en) begin
            // If write is enabled, write the data to RAM at the write address
            RAM[write_addr] <= write_data;
        end
    end

    // Synchronous read operation with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear the read_data output
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            // If read is enabled, read the data from RAM at the read address
            read_data <= RAM[read_addr];
        end
    end

endmodule