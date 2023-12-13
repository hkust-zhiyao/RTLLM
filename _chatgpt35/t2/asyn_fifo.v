module asyn_fifo (
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
  
  parameter WIDTH = 8;
  parameter DEPTH = 16;
  parameter PTR_WIDTH = $clog2(DEPTH);
  
  // Dual-port RAM submodule
  dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr[PTR_WIDTH-1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr[PTR_WIDTH-1:0]),
    .rdata(rdata)
  );

  reg [PTR_WIDTH-1:0] waddr_bin;
  reg [PTR_WIDTH-1:0] raddr_bin;
  reg [PTR_WIDTH-1:0] wptr;
  reg [PTR_WIDTH-1:0] rptr;
  reg [PTR_WIDTH-1:0] wptr_buff;
  reg [PTR_WIDTH-1:0] rptr_buff;
  reg [PTR_WIDTH-1:0] rptr_syn;

  always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
      waddr_bin <= 0;
      wptr <= 0;
      wptr_buff <= 0;
    end else begin
      waddr_bin <= waddr_bin + winc;
      wptr <= wptr_buff ^ (wptr_buff >> 1);
      wptr_buff <= wptr;
    end
  end

  always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
      raddr_bin <= 0;
      rptr <= 0;
      rptr_buff <= 0;
    end else begin
      raddr_bin <= raddr_bin + rinc;
      rptr <= rptr_buff ^ (rptr_buff >> 1);
      rptr_buff <= rptr;
      rptr_syn <= rptr_buff;
    end
  end

  always @(wptr_syn, rptr_syn) begin
    wfull = (wptr_syn[PTR_WIDTH-1] ^ ~wptr_syn[PTR_WIDTH-2:PTR_WIDTH-1]) & (wptr_syn[PTR_WIDTH-2:0] == rptr_syn[PTR_WIDTH-2:0]);
    rempty = (rptr_syn == wptr_syn);
  end

endmodule