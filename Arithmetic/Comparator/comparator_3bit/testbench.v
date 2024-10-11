`timescale 1ns / 1ps

module testbench;

  reg [2:0] A;          // Input A (3 bits)
  reg [2:0] B;          // Input B (3 bits)
  wire A_greater;       
  wire A_equal;         
  wire A_less;          
  integer i;            
  integer error = 0;    

  comparator_3bit uut (
    .A(A),
    .B(B),
    .A_greater(A_greater),
    .A_equal(A_equal),
    .A_less(A_less)
  );


  initial begin

    for (i = 0; i < 100; i = i + 1) begin
      // Generate random 3-bit inputs
      A = $random % 8;
      B = $random % 8;

      // Wait for the operation to complete
      #10;

      // Calculate expected results
      if ((A > B && !A_greater) || (A == B && !A_equal) || (A < B && !A_less)) begin
        error = error + 1;
        $display("Test failed: A = %b, B = %b, A_greater = %b, A_equal = %b, A_less = %b",
                  A, B, A_greater, A_equal, A_less);
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