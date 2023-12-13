module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input clk,
    input rst_n,
    input write_en,
    input [DEPTH-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [DEPTH-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    // Declare the RAM array
    reg [WIDTH-1:0] RAM [2**DEPTH-1:0];

    // Initialize the RAM array values to 0 on reset
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 2**DEPTH; i = i + 1) begin
                RAM[i] <= 6'b000000;
            end
        end
        else if (write_en) begin
            // Write operation
            RAM[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b000000;
        end
        else if (read_en) begin
            read_data <= RAM[read_addr];
        end
        else begin
            read_data <= 6'b000000; // Optionally clear read_data if not enabled
        end
    end

endmodule