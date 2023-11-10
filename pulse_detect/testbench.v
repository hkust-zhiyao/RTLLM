`timescale 1ns/1ns

module verified_pulse_detect_tb;
  reg clk_fast;
  reg clk_slow;
  reg rst_n;
  reg data_in;
  wire dataout;

  // Instantiate the DUT (Design Under Test)
  verified_pulse_detect dut (
    .clk_fast(clk_fast),
    .clk_slow(clk_slow),
    .rst_n(rst_n),
    .data_in(data_in),
    .dataout(dataout)
  );

  // Generate clock
  always #2 clk_fast = ~clk_fast;
  always #20 clk_slow = ~clk_slow;

  integer error = 0;
  initial begin
    // Initialize inputs
    clk_fast = 0;
    clk_slow = 0;
    rst_n = 0;
    data_in = 0;

    // Wait for a few clock cycles for reset to settle
    #20;

    // Apply reset
    rst_n = 1;

    // Perform test case
    #10;
    data_in = 0;
    #50;
    data_in = 1;
    #50;
    data_in = 1;
    #50;
    // $display("dataout = %b", dataout);
    error = (dataout==1)? error :error+1;
    data_in = 1;
    #50;
    data_in = 0;
    #50;
    // $display("dataout = %b", dataout);
    error = (dataout==0)? error :error+1;

    if (error == 0) begin
            $display("===========Your Design Passed===========");
     end
     else begin
     $display("===========Failed===========");
     end
    // Finish simulation
    $finish;
  end
endmodule