`timescale 1ns/1ns

module verified_asyn_fifo_tb;

  reg wclk, rclk, wrstn, rrstn, winc, rinc;
  reg [7:0] wdata;
  wire wfull, rempty;
  wire [7:0] rdata;
  
  verified_asyn_fifo #(.WIDTH(8), .DEPTH(16)) dut (
    .wclk(wclk),
    .rclk(rclk),
    .wrstn(wrstn),
    .rrstn(rrstn),
    .winc(winc),
    .rinc(rinc),
    .wdata(wdata),
    .wfull(wfull),
    .rempty(rempty),
    .rdata(rdata)
  );
  
  always #5 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  initial begin
    wclk = 0;
    rclk = 0;
    wrstn = 0;
    rrstn = 0;
    winc = 0;
    rinc = 0;
    wdata = 0;
    
    #20 wrstn = 1;
    #20 rrstn = 1;
    
    for (int i = 0; i < 16; i = i + 1) begin
      #10;
      winc = 1;
      wdata = i;
    end
    
    rinc = 1;
    #130;
    rinc = 1;
    if(rdata==15)begin
                $display("===========Your Design Passed===========");
    end
    else begin
                $display("===========Error===========");
    end
    
    
    #10 $finish;
  end
  
endmodule