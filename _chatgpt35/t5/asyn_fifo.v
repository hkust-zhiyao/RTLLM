module dual_port_RAM (
  input wclk,
  input wenc,
  input [$clog2(DEPTH)-1:0] waddr,
  input [WIDTH-1:0] wdata,
  input rclk,
  input renc,
  input [$clog2(DEPTH)-1:0] raddr,
  output reg [WIDTH-1:0] rdata
);

  reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

  always @(posedge wclk)
    if (wenc)
      RAM_MEM[waddr] <= wdata;

  always @(posedge rclk)
    if (renc)
      rdata <= RAM_MEM[raddr];

endmodule

module asyn_fifo (
  input wclk,
  input rclk,
  input wrstn,
  input rrstn,
  input winc,
  input rinc,
  input [WIDTH-1:0] wdata,
  output wfull,
  output rempty,
  output reg [WIDTH-1:0] rdata
);
  parameter WIDTH = 8;
  parameter DEPTH = 16;

  reg [WIDTH-1:0] wptr;
  reg [WIDTH-1:0] rptr;
  reg [WIDTH-1:0] wptr_buff;
  reg [WIDTH-1:0] rptr_buff;
  reg winc_sync;
  reg rinc_sync;

  wire [$clog2(DEPTH)-1:0] waddr;
  wire [$clog2(DEPTH)-1:0] raddr;
  wire wenc;
  wire renc;

  assign waddr = wptr[($clog2(DEPTH)-1):0];
  assign raddr = rptr[($clog2(DEPTH)-1):0];
  assign wenc = wrstn & winc & (~wfull);
  assign renc = rrstn & rinc & (~rempty);

  dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
  );

  always @(posedge wclk) begin
    if (~wrstn)
      wptr <= 0;
    else if (winc)
      wptr <= wptr + 1;
  end

  always @(posedge rclk) begin
    if (~rrstn)
      rptr <= 0;
    else if (rinc)
      rptr <= rptr + 1;
  end

  always @(posedge wclk) begin
    if (~wrstn)
      wptr_buff <= 0;
    else
      wptr_buff <= wptr;
  end

  always @(posedge rclk) begin
    if (~rrstn)
      rptr_buff <= 0;
    else
      rptr_buff <= rptr;
  end

  reg [WIDTH-1:0] rptr_syn;
  reg [WIDTH-1:0] wptr_syn;
  reg [WIDTH-2:0] wptr_inv;

  always @(posedge wclk) begin
    wptr_syn <= wptr ^ (wptr >> 1);
    wptr_inv <= ~wptr_syn[WIDTH-2:0];
  end

  always @(posedge rclk) begin
    rptr_syn <= rptr ^ (rptr >> 1);
  end

  assign wfull = (wptr == {wptr_inv, rptr_syn[WIDTH-2:0]});
  assign rempty = (rptr == wptr_syn);

endmodule