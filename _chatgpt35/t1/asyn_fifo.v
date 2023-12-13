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

  reg [WIDTH-1:0] rdata_reg;
  reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
  reg [$clog2(DEPTH)-1:0] wptr, rptr;
  reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

  reg [WIDTH-1:0] dual_port_RAM [0:DEPTH-1];
  reg wenc, renc;

  // Dual-port RAM instantiation
  dual_port_RAM dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin),
    .rdata(rdata_reg)
  );

  // Write pointer increment logic
  always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
      waddr_bin <= 0;
      wptr <= 0;
      wptr_buff <= 0;
    end else begin
      if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= wptr + 1;
        wptr_buff <= wptr;
      end
    end
  end

  // Read pointer increment logic
  always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
      raddr_bin <= 0;
      rptr <= 0;
      rptr_buff <= 0;
    end else begin
      if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= rptr + 1;
        rptr_buff <= rptr;
      end
    end
  end

  // Gray code conversion for write pointer
  always @(posedge wclk) begin
    wenc <= winc;
    waddr_bin <= wptr ^ (wptr >> 1);
  end

  // Gray code conversion for read pointer
  always @(posedge rclk) begin
    renc <= rinc;
    raddr_bin <= rptr ^ (rptr >> 1);
  end

  // Full and empty signal generation
  always @(wptr or rptr) begin
    wfull = (wptr == ~{rptr[($clog2(DEPTH)-2):0], ~rptr[($clog2(DEPTH)-1)]});
    rempty = (rptr == wptr);
  end

  // Output data assignment
  always @(posedge rclk) begin
    if (renc)
      rdata <= rdata_reg;
  end

endmodule