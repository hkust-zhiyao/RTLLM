module dual_port_RAM #(
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
    // Declare the RAM variable
    reg [WIDTH-1:0] ram [DEPTH-1:0];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            ram[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= ram[raddr];
        end
    end
endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wrstn,
    input winc,
    input [WIDTH-1:0] wdata,
    input rclk,
    input rrstn,
    input rinc,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    // Define the pointer width for the given DEPTH, extra bit for full/empty distinction
    localparam PTR_WIDTH = $clog2(DEPTH) + 1;

    // Binary and Gray code pointers
    reg [PTR_WIDTH-1:0] wptr_bin = 0, wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_bin = 0, rptr_gray = 0;

    // Synchronized pointers
    reg [PTR_WIDTH-1:0] wptr_gray_sync = 0, rptr_gray_sync = 0;

    // Internal wires for RAM
    wire renc;
    wire wenc;
    wire [$clog2(DEPTH)-1:0] waddr;
    wire [$clog2(DEPTH)-1:0] raddr;

    // Instantiate the dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Convert binary to Gray code
    function [PTR_WIDTH-1:0] bin_to_gray(input [PTR_WIDTH-1:0] bin);
        bin_to_gray = bin ^ (bin >> 1);
    endfunction

    // Convert Gray code to binary
    function [PTR_WIDTH-1:0] gray_to_bin(input [PTR_WIDTH-1:0] gray);
        reg [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin = gray;
            for (i = 1; i < PTR_WIDTH; i = i + 1) begin
                bin = bin ^ (gray >> i);
            end
            gray_to_bin = bin;
        end
    endfunction

    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin_to_gray(wptr_bin + 1);
        end
    end

    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin_to_gray(rptr_bin + 1);
        end
    end

    // Write pointer synchronizer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync <= 0;
        end else begin
            wptr_gray_sync <= wptr_gray;
        end
    end

    // Read pointer synchronizerContinuing from where we left off with the read pointer synchronizer:

    // Read pointer synchronizer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync <= 0;
        end else begin
            rptr_gray_sync <= rptr_gray;
        end
    end

    // Generate full signal
    always @(*) begin
        // When the MSB bits are opposite and the rest are the same, it's full
        wfull = (wptr_gray[PTR_WIDTH-1 : PTR_WIDTH-2] == ~rptr_gray_sync[PTR_WIDTH-1 : PTR_WIDTH-2]) &&
                (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync[PTR_WIDTH-3:0]);
    end

    // Generate empty signal
    always @(*) begin
        // FIFO is empty when read and write Gray pointers match
        rempty = (rptr_gray == wptr_gray_sync);
    end

    // Write enable and address calculation
    assign wenc = winc && !wfull;
    assign waddr = wptr_bin[$clog2(DEPTH)-1:0];

    // Read enable and address calculation
    assign renc = rinc && !rempty;
    assign raddr = rptr_bin[$clog2(DEPTH)-1:0];

endmodule