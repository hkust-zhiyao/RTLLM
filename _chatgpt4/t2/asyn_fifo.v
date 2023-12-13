`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Calculate the width of the pointers based on DEPTH, using $clog2 system function
localparam PTR_WIDTH = $clog2(DEPTH);

// Dual-port RAM instantiation
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(!wfull && winc),   // Write enable condition
    .waddr(waddr[PTR_WIDTH-1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(!rempty && rinc),   // Read enable condition
    .raddr(raddr[PTR_WIDTH-1:0]),
    .rdata(rdata)
);

// Write and read address pointers
reg [PTR_WIDTH-1:0] waddr, raddr;
reg [PTR_WIDTH-1:0] waddr_gray, raddr_gray;
reg [PTR_WIDTH-1:0] waddr_gray_sync, raddr_gray_sync;
reg [PTR_WIDTH-1:0] wptr, rptr;

// Binary to Gray conversion
function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] binary);
    bin2gray = (binary >> 1) ^ binary;
endfunction

// Gray to Binary conversion
function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
    integer i;
    reg [PTR_WIDTH-1:0] binary;
    begin
        binary = gray;
        for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
            binary[i] = binary[i+1] ^ gray[i];
        end
        gray2bin = binary;
    end
endfunction

// Write pointer management
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr <= 0;
        waddr_gray <= 0;
    end else if (!wfull && winc) begin
        waddr <= waddr + 1;
        waddr_gray <= bin2gray(waddr + 1);
    end
end

// Read pointer management
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr <= 0;
        raddr_gray <= 0;
    end else if (!rempty && rinc) begin
        raddr <= raddr + 1;
        raddr_gray <= bin2gray(raddr + 1);
    end
end

// Synchronize write pointer to read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_gray_sync <= 0;
        rptr <= 0;
    end else begin
        raddr_gray_sync <= waddr_gray;
        rptr <= gray2bin(raddr_gray_sync);
    end
end

// Synchronize read pointer to write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_gray_sync <= 0;
        wptr <= 0;
    end else begin
        waddr_gray_sync <= raddr_gray;
        wptr <= gray2bin(waddr_gray_sync);
    end
end

// FIFO full condition check
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wfull <= 0;
    end else begin
        wfull <= (waddr_gray[PTR_WIDTH-1] != waddr_gray_sync[PTR_WIDTH-1]) &&
                 (waddr_gray[PTR_WIDTH-2] != waddr_gray_sync[PTR_WIDTH-2]) &&
                 (waddr_gray[PTR_WIDTH-3:0] == waddr_gray_sync[PTR_WIDTH-3:0]);
    end
end

// FIFO empty condition check
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rempty <= 1```verilog
`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Calculate the width of the pointers based on DEPTH
localparam PTR_WIDTH = $clog2(DEPTH);

// Define the Gray code width for the pointers
localparam GRAY_WIDTH = 4; // For a FIFO depth of 8, we use 4-bit Gray code

// Registers for binary and Gray code pointers
reg [GRAY_WIDTH-1:0] wptr_gray, rptr_gray;
reg [GRAY_WIDTH-1:0] wptr_gray_next, rptr_gray_next;
reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
reg [PTR_WIDTH-1:0] wptr_bin_next, rptr_bin_next;

// Synchronization registers
reg [GRAY_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;
reg [GRAY_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;

// FIFO memory - dual-port RAM instantiation
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) fifo_ram (
    .wclk(wclk),
    .wenc(!wfull && winc), // Write enable
    .waddr(wptr_bin[PTR_WIDTH-2:0]), // Lower bits for addressing
    .wdata(wdata),
    .rclk(rclk),
    .renc(!rempty && rinc), // Read enable
    .raddr(rptr_bin[PTR_WIDTH-2:0]), // Lower bits for addressing
    .rdata(rdata)
);

// Binary to Gray conversion
function [GRAY_WIDTH-1:0] bin_to_gray(input [GRAY_WIDTH-1:0] binary);
    bin_to_gray = (binary >> 1) ^ binary;
endfunction

// Gray to binary conversion
function [GRAY_WIDTH-1:0] gray_to_bin(input [GRAY_WIDTH-1:0] gray);
    reg [GRAY_WIDTH-1:0] binary;
    reg [GRAY_WIDTH-1:0] g;
    begin
        g = gray;
        binary = 0;
        for (integer i = GRAY_WIDTH-1; i >= 0; i--) begin
            binary[i] = g[i] ^ binary[i+1];
            g[i-1] = g[i] ^ g[i-1];
        end
        gray_to_bin = binary;
    end
endfunction

// Write pointer and full flag logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
        wfull <= 0;
    end else begin
        wptr_bin <= wptr_bin_next;
        wptr_gray <= wptr_gray_next;
        wfull <= (wptr_gray_next == {~rptr_gray_sync2[GRAY_WIDTH-1:GRAY_WIDTH-2], rptr_gray_sync2[GRAY_WIDTH-3:0]});
    end
end

// Generate next write pointer
always @(*) begin
    wptr_bin_next = wptr_bin;
    wptr_gray_next = wptr_gray;
    if (winc && !wfull) begin
        wptr_bin_next = wptr_bin + 1'b1;
        wptr_gray_next = bin_to_gray(wptr_bin_next);
    end
end

// Read pointer and empty flag logic
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
        rempty <= 1;
    end else begin
        rptr_bin <= rptr_bin_next;
        rptr_gray <= rptr_gray_next;
        rempty <= (rptr_gray_next == wptr_gray_sync2);
    end
end

// Generate next read pointer
always @(*) begin
    rptr_bin_next = rptr_bin;
    rptr_gray_next = rptr_gray;
    if (rinc && !rempty) begin
        rptr_bin_next = rptr_bin + 1'b1;
        rptr_gray_next = bin_to_gray(rptr_bin_next);
    end
end

// Synchronize write pointer to read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        r