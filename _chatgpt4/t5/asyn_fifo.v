`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
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
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Handle write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Handle read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    // Internal signals
    reg [$clog2(DEPTH):0] wptr, rptr, wptr_gray, rptr_gray;
    wire [$clog2(DEPTH):0] wptr_gray_next, rptr_gray_next;
    reg [$clog2(DEPTH):0] rptr_gray_sync1, rptr_gray_sync2;
    reg [$clog2(DEPTH):0] wptr_gray_sync1, wptr_gray_sync2;

    // Dual-port RAM instance
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM_inst (
        .wclk(wclk),
        .wenc(winc & ~wfull),
        .waddr(wptr[$clog2(DEPTH)-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & ~rempty),
        .raddr(rptr[$clog2(DEPTH)-1:0]),
        .rdata(rdata)
    );

    // Generate Gray code from binary pointer
    function [$clog2(DEPTH):0] bin_to_gray(input [$clog2(DEPTH):0] bin);
        bin_to_gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray code to binary
    function [$clog2(DEPTH):0] gray_to_bin(input [$clog2(DEPTH):0] gray);
        integer i;
        begin
            for (i = 0; i < $clog2(DEPTH); i = i + 1) begin
                if (i == 0)
                    gray_to_bin[i] = gray[i];
                else
                    gray_to_bin[i] = gray_to_bin[i-1] ^ gray[i];
            end
        end
    endfunction

    // Next gray code calculation
    assign wptr_gray_next = bin_to_gray(wptr + winc);
    assign rptr_gray_next = bin_to_gray(rptr + rinc);

    // Write pointer and Gray code update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr <= wptr + 1;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer and Gray code update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr <= rptr + 1;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Synchronize the read pointer to the write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Synchronize the write pointer to the read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Full flag generation
    wire full_cond = (wptr_gray_next[$clog2(DEPTH)] != rptr_gray_sync2[$clog2(DEPTH)] &&
                      wptr_gray_next[$clog2(DEPTH)-1] != rptr_gray_sync2[$clog2(DEPTH)-1] &&
                      wptr_gray_next[$clog2(DEPTH)-2:0] == rptr_gray_sync2[$clog2(DEPTH)-2:0]);

    assign wfull = full_cond;

    // Empty flag generation
    wire empty_cond = (wptr_gray_sync2 == rptr_gray);

    assign rempty = empty_cond;

endmodule