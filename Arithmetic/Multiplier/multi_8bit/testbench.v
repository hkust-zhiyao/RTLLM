`timescale 1ns / 1ps

module testbench;

  reg [7:0] A;          // Input A (8 bits)
  reg [7:0] B;          // Input B (8 bits)
  wire [15:0] product;  // Product result (16 bits)
  integer i;            // Loop variable
  integer error = 0;    // Error count for failed tests

  multi_8bit uut (
    .A(A),
    .B(B),
    .product(product)
  );

  // Test cases
  initial begin

    for (i = 0; i < 100; i = i + 1) begin
      // Generate random 8-bit inputs
      A = $random;
      B = $random;

      // Wait for the operation to complete
      #10;

    //   $display("A = %d, B = %d, Expected Product = %d", A, B, A * B);

      // Check the result of the multiplication
      if (product !== A * B) begin
        error = error + 1;
        $display("Test failed: A = %d, B = %d, Expected Product = %d, Got = %d", A, B, A * B, product);
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