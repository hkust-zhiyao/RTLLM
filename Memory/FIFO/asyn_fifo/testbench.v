`timescale 1ns/1ns

module asyn_fifo_tb;

  reg wclk, rclk, wrstn, rrstn, winc, rinc;
  reg [7:0] wdata;
  wire wfull, rempty;
  wire [7:0] rdata;
  
  asyn_fifo #(.WIDTH(8), .DEPTH(16)) dut (
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
  end

  // Apply reset and initialize FIFO
  initial begin
    wrstn = 0;
    rrstn = 0;
    #20;
    wrstn = 1;
    rrstn = 1;
    #10;
    winc = 1; // Enable write
    wdata = 8'hAA; // Write data
    #10;
    winc = 0; // Disable write
    #500;
    rinc = 1;
    #500;
    #10;
    $finish;
  end
  integer outfile1;
  integer outfile2;
  integer outfile3;
  reg[31:0]data1[0:50];
  reg[31:0]data2[0:50];
  reg[31:0]data3[0:50];
  integer i = 0;
  integer error =0;

  initial begin
    #550;
    $readmemh("wfull.txt",data1);
    $readmemh("rempty.txt",data2);
    $readmemh("tdata.txt",data3);
    // outfile1 = $fopen("wfull.txt", "w");
    // outfile2 = $fopen("rempty.txt", "w");
    // outfile3 = $fopen("tdata.txt", "w");
    repeat(48) begin
      #10;
      // $fwrite(outfile1, "%h\n", wfull);
      // $fwrite(outfile2, "%h\n", rempty);
      // $fwrite(outfile3, "%h\n", rdata);
      error = (wfull==data1[i] && rempty == data2[i] && rdata ==data3[i]) ? error:error+1;
      i = i + 1;
    end
    if(error==0)
      begin
        $display("===========Your Design Passed===========");
            end
      else
      begin
        $display("===========Error===========");
      end

    // $fclose(outfile1);
    // $fclose(outfile2);
    // $fclose(outfile3);
  end
  // Display FIFO status
  // always @(posedge wclk) begin
  //   $display("wfull=%d, rempty=%d, rdata=%h", wfull, rempty, rdata);
  // end

  initial begin
  repeat (17) begin
    #20;
    if (wfull) begin
      // $display("FIFO is full (wfull=1) at depth %d", $time);
      break;
    end
    winc = 1; // Enable write
    wdata = wdata + 1; // Write data
    #10;
    winc = 0; // Disable write
  end
  end
  
endmodule