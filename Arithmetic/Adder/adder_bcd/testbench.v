`timescale 1ns / 1ps

module testbench;

  reg [3:0] A;    // First BCD input (4 bits)
  reg [3:0] B;    // Second BCD input (4 bits)
  reg Cin;        // Carry-in input (1 bit)
  wire [3:0] Sum; // BCD sum output (4 bits)
  wire Cout;      // Carry-out output (1 bit)

  integer i;      
  integer error = 0; 
  reg [4:0] expected_sum; 


  adder_bcd uut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
  );

  initial begin
    for (i = 0; i < 100; i = i + 1) begin
        A = $random % 10; 
        B = $random % 10;
        Cin = $random % 2;
        if (A > 9) A = A % 10;
        if (B > 9) B = B % 10;
        // Wait for the operation to complete
        #10;

        expected_sum = A + B + Cin;

        // Adjust for BCD overflow (sum greater than 9)
        if (expected_sum > 9) begin
            expected_sum = expected_sum + 6;  // Correct the sum for BCD
        end

        // Check the result of the BCD adder
        if ({Cout, Sum} !== expected_sum) begin
            error = error + 1;
            $display("Test failed: A = %d, B = %d, Cin = %d | Expected = %d, Got = %d, Cout = %d", 
                     A, B, Cin, expected_sum, Sum, Cout);
        end
    end
    
    if (error == 0) begin
      $display("=========== Your Design Passed ===========");
    end
    else begin
      $display("=========== Test completed with %d /100 failures ===========", error);
    end

    $finish;
  end

endmodule
