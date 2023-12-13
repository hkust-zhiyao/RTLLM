module asyn_fifo #
  (
   parameter WIDTH = 8,
   parameter DEPTH = 16
  )
  (
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

  // Dual-port RAM submodule
  dual_port_RAM #
    (
     .WIDTH(WIDTH),
     .DEPTH(DEPTH)
    )
    ram
    (
     .wclk(wclk),
     .wenc(winc),
     .waddr(wptr[3:0]),
     .wdata(wdata),
     .rclk(rclk),
     .renc(rinc),
     .raddr(rptr[3:0]),
     .rdata(rdata)
    );

  reg [3:0] wptr;
  reg [3:0] rptr;
  reg [3:0] wptr_buff;
  reg [3:0] rptr_buff;
  reg [3:0] wptr_syn;
  reg [3:0] rptr_syn;

  // Write pointer logic
  always @(posedge wclk or negedge wrstn)
  begin
    if (~wrstn)
      wptr <= 4'b0000;
    else if (winc)
      wptr <= wptr + 1;
  end

  // Read pointer logic
  always @(posedge rclk or negedge rrstn)
  begin
    if (~rrstn)
      rptr <= 4'b0000;
    else if (rinc)
      rptr <= rptr + 1;
  end

  // Gray code conversion for write pointer
  always @*
  begin
    wptr_syn[0] = wptr[0];
    wptr_syn[1] = wptr[0] ^ wptr[1];
    wptr_syn[2] = wptr[1] ^ wptr[2];
    wptr_syn[3] = wptr[2] ^ wptr[3];
  end

  // Gray code conversion for read pointer
  always @*
  begin
    rptr_syn[0] = rptr[0];
    rptr_syn[1] = rptr[0] ^ rptr[1];
    rptr_syn[2] = rptr[1] ^ rptr[2];
    rptr_syn[3] = rptr[2] ^ rptr[3];
  end

  // Pointer buffers
  always @(posedge wclk or negedge wrstn)
  begin
    if (~wrstn)
      wptr_buff <= 4'b0000;
    else
      wptr_buff <= wptr_syn;
  end

  always @(posedge rclk or negedge rrstn)
  begin
    if (~rrstn)
      rptr_buff <= 4'b0000;
    else
      rptr_buff <= rptr_syn;
  end

  // Full and empty signals
  always @*
  begin
    wfull = (wptr_syn == ~rptr_buff[3] & rptr_buff[2:0]);
    rempty = (rptr_syn == wptr_buff);
  end

endmodule