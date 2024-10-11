`timescale 1ns / 1ps

module testbench;

  reg [63:0] A;          // Input A (64 bits)
  reg [63:0] B;          // Input B (64 bits)
  wire [63:0] result;    // Subtraction result (64 bits)
  wire overflow;         // Overflow signal
  integer i;             // Loop variable
  integer error = 0;     // Error count for failed tests

  // Instantiate the verified_sub_64bit module
  sub_64bit uut (
    .A(A),
    .B(B),
    .result(result),
    .overflow(overflow)
  );

  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 100; i = i + 1) begin
        // Generate random 64-bit inputs
        A = $random;
        B = $random;

        // Wait for the operation to complete
        #10;

        // Calculate expected result using system task
        // $monitor("A = %d, B = %d, Expected Result = %d, Overflow = %b", A, B, A - B, overflow);

        // Check the result of the subtraction
        if (result !== (A - B) || (A - B < 0 && overflow !== 1)) begin
            error = error + 1;
            $display("Test failed: A = %d, B = %d, Expected Result = %d, Got = %d, Overflow = %b", A, B, A - B, result, overflow);
        end
    end

    // Final test result summary
    if (error == 0) begin
      $display("=========== Your Design Passed ===========");
    end
    else begin
      $display("=========== Test completed with %d /100 failures ===========", error);
    end

    $finish;
  end

endmodule