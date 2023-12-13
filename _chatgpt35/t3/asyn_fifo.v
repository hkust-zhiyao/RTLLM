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
  
  // Dual-port RAM submodule
  dual_port_RAM #(WIDTH, DEPTH) dual_port_RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr[3:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_syn[3:0]),
    .rdata(rdata)
  );
  
  reg [3:0] wptr;
  reg [3:0] rptr;
  reg [3:0] wptr_buff;
  reg [3:0] rptr_buff;
  reg [3:0] wptr_syn;
  reg [3:0] rptr_syn;
  reg wfull;
  reg rempty;
  
  always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
      wptr <= 4'b0;
      wptr_buff <= 4'b0;
    end
    else if (winc) begin
      wptr <= wptr + 1;
      wptr_buff <= wptr;
    end
  end
  
  always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
      rptr <= 4'b0;
      rptr_buff <= 4'b0;
    end
    else if (rinc) begin
      rptr <= rptr + 1;
      rptr_buff <= rptr;
    end
  end
  
  always @(wptr_buff or rptr_buff) begin
    wptr_syn = wptr_buff ^ (wptr_buff >> 1);
    rptr_syn = rptr_buff ^ (rptr_buff >> 1);
  end
  
  always @* begin
    wfull = (wptr[3] == ~rptr[3]) & (wptr[2:0] == rptr[2:0]);
    rempty = (wptr == rptr);
  end
  
endmodule

module dual_port_RAM #(parameter WIDTH = 8, parameter DEPTH = 16)(
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
  
  always @(posedge wclk) begin
    if (wenc)
      RAM_MEM[waddr] <= wdata;
  end
  
  always @(posedge rclk) begin
    if (renc)
      rdata <= RAM_MEM[raddr];
  end
endmodule