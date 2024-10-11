module ROM (
    input wire [7:0] addr,        // 8-bit Address input
    output reg [15:0] dout        // 16-bit Data output
);

    // Declare a memory array of 256 locations, each 16 bits wide, initialized with fixed data
    reg [15:0] mem [0:255];

    // Initial block to initialize the ROM with data
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize other memory locations as needed
    end

    // Combinational logic: Read data from the ROM at the specified address
    always @(*) begin
        dout = mem[addr];
    end
endmodule