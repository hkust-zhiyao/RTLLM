module RAM #(
    parameter WIDTH = 6, // Bit width of each memory element
    parameter DEPTH = 8  // Depth of the memory
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
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize the RAM with all zeros on reset
            integer i;
            for (i = 0; i < (1<<DEPTH); i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            // Write data to RAM if write enable is active
            RAM[write_addr] <= write_data;
        end
    end
    
    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear read data on reset
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            // Read data from RAM if read enable is active
            read_data <= RAM[read_addr];
        end
    end

endmodule