`timescale 1ns/1ns

module verified_multi_pipe_tb;
  reg clk;
  reg rst_n;
  reg [3:0] mul_a;
  reg [3:0] mul_b;
  wire [7:0] mul_out;

  // Instantiate the DUT (Design Under Test)
  verified_multi_pipe #(.size(4)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .mul_out(mul_out)
  );

  // Generate clock
  always #5 clk = ~clk;

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
    mul_a = 4'b1010;
    mul_b = 4'b0110;
    #30;
    // Check the output
    if (mul_out != 8'b00111100) begin
            $display("=========== Failed ===========");
        end else begin
            $display("===========Your Design Passed===========");
        end
    // Finish simulation
    $finish;
  end
endmodule