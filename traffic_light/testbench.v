`timescale 1ns/1ns

module verified_traffic_light_tb;
  reg rst_n;
  reg clk;
  reg pass_request;
  wire [7:0] clock;
  wire red;
  wire yellow;
  wire green;

  // Instantiate the DUT (Design Under Test)
  verified_traffic_light dut (
    .rst_n(rst_n),
    .clk(clk),
    .pass_request(pass_request),
    .clock(clock),
    .red(red),
    .yellow(yellow),
    .green(green)
  );

  // Generate clock
  always #5 clk = ~clk;

  integer temp1 = 0;
  integer temp2 = 0;

  initial begin
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    pass_request = 0;

    // Wait for a few clock cycles for reset to settle
    #10;

    // Apply reset
    rst_n = 1;

    // Perform test case
    // $display("clock = %b, red = %b, yellow = %b, green = %b", clock, red, yellow, green);
    temp1 = red;
    #20;
    pass_request = 1;
    #10;
    #50;
    // Check the output
    // $display("clock = %b, red = %b, yellow = %b, green = %b", clock, red, yellow, green);
    temp2 = red;
    if(temp1 != temp2) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Failed===========");
        end
    // Finish simulation
    $finish;
  end
endmodule