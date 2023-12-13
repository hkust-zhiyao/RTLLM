module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire write_en,
    input wire [WIDTH-1:0] write_addr,
    input wire [DEPTH-1:0] write_data,
    input wire read_en,
    input wire [WIDTH-1:0] read_addr,
    output reg [DEPTH-1:0] read_data
);

// Memory array
reg [DEPTH-1:0] ram[(1<<WIDTH)-1:0];

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset: Initialize all RAM locations to 0 on reset
        integer i;
        for (i = 0; i < (1<<WIDTH); i = i + 1) begin
            ram[i] <= {DEPTH{1'b0}};
        end
    end else if (write_en) begin
        // Write operation: Write data to RAM at write_addr
        ram[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset: Clear read_data on reset
        read_data <= {DEPTH{1'b0}};
    end else if (read_en) begin
        // Read operation: Read data from RAM at read_addr
        read_data <= ram[read_addr];
    end else begin
        read_data <= {DEPTH{1'b0}};
    end
end

endmodule