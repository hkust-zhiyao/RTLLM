module chatgpt_generate_asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [WIDTH-1:0] rdata_reg;
reg [WIDTH-1:0] rdata_reg2;
reg [$clog2(DEPTH)-1:0] wptr_reg;
reg [$clog2(DEPTH)-1:0] rptr_reg;

assign rdata = rdata_reg;

// Dual-port RAM submodule
dual_port_ram #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram (
    .clk(wclk),
    .en(winc),
    .we(wrstn),
    .addr(wptr_reg),
    .data(wdata),
    .q()
);

// Data write controller
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wptr_reg <= 0;
    else if (winc && !wfull)
        wptr_reg <= wptr_reg + 1;
end

// Data read controller
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rptr_reg <= 0;
    else if (rinc && !rempty)
        rptr_reg <= rptr_reg + 1;
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rdata_reg2 <= rdata_reg;
end

// Write pointer synchronizer
always @(posedge rclk) begin
    rdata_reg <= mem[rptr_reg];
end

// Empty and Full signal generation
assign rempty = (wptr_reg == rptr_reg);
assign wfull = (wptr_reg + 1 == rptr_reg || (wptr_reg[$clog2(DEPTH)-1] != rptr_reg[$clog2(DEPTH)-1] && wptr_reg[$clog2(DEPTH)-2:0] == rptr_reg[$clog2(DEPTH)-2:0]));

endmodule