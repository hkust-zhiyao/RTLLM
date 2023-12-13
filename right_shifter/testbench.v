`timescale 1ns/1ns
module right_shifter_tb;
  reg clk;
  reg d;
  wire [7:0] q;

  // Instantiate the DUT (Design Under Test)
  right_shifter dut (
    .clk(clk),
    .d(d),
    .q(q)
  );

  // Generate clock
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    d = 0;
    #20;
    d = 1;
    #10;
    d = 0;
    #10;
    d = 1;
    #10;
    d = 0;
    #10;
    d = 1;
    #10;
    d = 1;
    #10;
    d = 1;
    #10;
    
    // Check the output
    if(q==8'b11101010) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Failed===========");
    end
    // Finish simulation
    $finish;
  end
endmodule
