`timescale 1ns / 1ps

module dual_port_ram #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    // Memory array
    reg [WIDTH-1:0] mem[0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule

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

    // Pointer width for the given DEPTH
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Binary and Gray code pointers
    reg [PTR_WIDTH:0] wptr_bin = 0, rptr_bin = 0, wptr_gray = 0, rptr_gray = 0;
    reg [PTR_WIDTH:0] wptr_gray_next, rptr_gray_next;
    reg [PTR_WIDTH:0] wptr_bin_next, rptr_bin_next;

    // Synchronized pointers
    reg [PTR_WIDTH:0] rptr_gray_sync = 0, wptr_gray_sync = 0;

    // RAM interface signals
    wire ram_wen;
    wire [PTR_WIDTH-1:0] ram_waddr, ram_raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram_inst (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(ram_waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(~rempty),  // Read enable is active when not empty
        .raddr(ram_raddr),
        .rdata(rdata)
    );

    // Convert binary to Gray code
    function [PTR_WIDTH:0] bin_to_gray(input [PTR_WIDTH:0] bin);
        bin_to_gray = bin ^ (bin >> 1);
    endfunction

    // Convert Gray to binary code
    function [PTR_WIDTH:0] gray_to_bin(input [PTR_WIDTH:0] gray);
        reg [PTR_WIDTH:0] bin;
        begin
            bin = gray;
            for (int i = 2; i <= PTR_WIDTH; i = i << 1) begin
                bin = bin ^ (bin >> i);
            end
            gray_to_bin = bin;
        end
    endfunction

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync <= 0;
        end else begin
            wptr_gray_sync <= wptr_gray;
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync <= 0;
        end else begin
            rptr_gray_sync <= rptr_gray;
        end
    end

    // Next state logic for binary pointers
    always @* begin
        wptr_bin_next = wptr_bin + 1'b1;
        rptr_bin_next = rptr_bin + 1'b1;
        wptr_gray_next = bin_to_gray(wptr_bin_next);
        rptr_gray_next = bin_to_gray(rptr_bin_next);
    end

    // Generate RAM addresses from the binary write and read pointers
    assign ram_waddr = wptr_bin[PTR_WIDTH-1:0];
    assign ram_raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write enable logic
    assign ram_wen = winc && !wfull;

    // Full flag logic
    always @* begin
        // Compare MSB and second MSB for full condition
        wfull = (wptr_gray_next[PTR_WIDTH] != rptr_gray_sync[PTR_WIDTH]) &&
                (wptr_gray_next[PTR_WIDTH-1] != rptr_gray_sync[PTR_WIDTH-1]) &&
                (wptr_gray_next[PTR_WIDTH-2:0] == rptr_gray_sync[PTR_WIDTH-2:0]);
    end

    // Empty flag logic
    always @* begin
        rempty = (rptr_gray == wptr_gray_sync);
    end

endmodule