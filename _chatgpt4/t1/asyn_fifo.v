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
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
module asyn_fifo #(
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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    // Pointer width for the specified DEPTH
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Binary and Gray code pointers
    reg [PTR_WIDTH:0] wptr_bin = 0, rptr_bin = 0;
    reg [PTR_WIDTH:0] wptr_gray = 0, rptr_gray = 0;
    reg [PTR_WIDTH:0] wptr_gray_next, rptr_gray_next;
    reg [PTR_WIDTH:0] wptr_bin_next, rptr_bin_next;
    
    // Synchronized pointers
    reg [PTR_WIDTH:0] rptr_gray_sync = 0, wptr_gray_sync = 0;
    reg [PTR_WIDTH:0] rptr_bin_sync = 0, wptr_bin_sync = 0;
    
    // Dual-port RAM instantiation
    dual_port_ram #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(!wfull && winc), // Write enable condition
        .waddr(wptr_bin[PTR_WIDTH-1:0]), // Lower bits for addressing
        .wdata(wdata),
        .rclk(rclk),
        .renc(!rempty && rinc), // Read enable condition
        .raddr(rptr_bin[PTR_WIDTH-1:0]), // Lower bits for addressing
        .rdata(rdata)
    );

    // Convert binary to Gray code
    function [PTR_WIDTH:0] bin_to_gray(input [PTR_WIDTH:0] bin);
        begin
            bin_to_gray = bin ^ (bin >> 1);
        end
    endfunction

    // Convert Gray code to binary
    function [PTR_WIDTH:0] gray_to_bin(input [PTR_WIDTH:0] gray);
        reg [PTR_WIDTH:0] bin;
        begin
            bin = gray;
            for (int i = 1; i <= PTR_WIDTH; i = i + 1) begin
                bin = bin ^ (gray >> i);
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

    // Update binary and Gray code pointers
    always @(*) begin
        wptr_bin_next = wptr_bin + 1;
        rptr_bin_next = rptr_bin```verilog
        + 1;
        wptr_gray_next = bin_to_gray(wptr_bin_next);
        rptr_gray_next = bin_to_gray(rptr_bin_next);
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync <= 0;
        end else begin
            wptr_gray_sync <= wptr_gray; // First stage of synchronization
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync <= 0;
        end else begin
            rptr_gray_sync <= rptr_gray; // First stage of synchronization
        end
    end

    // Convert synchronized Gray code pointers back to binary
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_bin_sync <= 0;
        end else begin
            rptr_bin_sync <= gray_to_bin(rptr_gray_sync);
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_bin_sync <= 0;
        end else begin
            wptr_bin_sync <= gray_to_bin(wptr_gray_sync);
        end
    end

    // Generate full and empty signals
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wptr_gray_next == {~rptr_gray_sync[PTR_WIDTH:PTR_WIDTH-1], rptr_gray_sync[PTR_WIDTH-2:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr_gray == wptr_gray_sync);
        end
    end

endmodule