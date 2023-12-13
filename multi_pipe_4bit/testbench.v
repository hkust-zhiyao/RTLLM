`timescale 1ns/1ns

module multi_pipe_tb;
  reg clk;
  reg rst_n;
  reg [3:0] mul_a;
  reg [3:0] mul_b;
  wire [7:0] mul_out;
  wire signed [7:0] perfect = mul_a*mul_b;
  // Instantiate the DUT (Design Under Test)
  multi_pipe_4bit #(.size(4)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .mul_out(mul_out)
  );

  // Generate clock
  always #5 clk = ~clk;

  integer fail_count =0;
  integer i=0;
  initial begin
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    mul_a = 4'b0;
    mul_b = 4'b0;

    // Wait for a few clock cycles for reset to settle
    #10;

    // Apply reset
    rst_n = 1;
  
    // Perform test case
    for (i = 0; i < 100; i = i + 1) begin
      mul_a =  $random;
      mul_b =  $random;
      #10;
      // without pipeline
      fail_count = (perfect == mul_out)? fail_count+1:fail_count;
      #20;
      // $display("%d, %d, %d, %d", mul_a, mul_b, perfect, mul_out);
      fail_count = (perfect == mul_out)? fail_count:fail_count+1;
    end

    if (fail_count == 0) begin
        $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d / 100 failures===========", fail_count);
    end
    $finish;
  end
endmodule