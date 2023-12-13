`timescale 1ns/1ps
module tb_division();

reg [15:0] A;
reg [7:0] B;
wire [15:0] result;
wire [15:0] odd;

integer i; 
reg [15:0] expected_result; 
integer error = 0; 
reg [15:0] expected_result;
reg [15:0] expected_odd;
initial begin
   for (i = 0; i < 100; i = i + 1) begin
      A = $urandom_range(1'b0, 16'b1111_1111_1111_1111);
      B = $urandom_range(1'b1, 8'b1111_1111);
      expected_result = A/B;
      expected_odd = A%B;
      #10; 
      error = (expected_odd != odd || expected_result != result) ? error+1 : error;
      // $display("A = %d, B = %d, Result = %d, odd = %d", A, B, result, odd);
   end
   
   if (error == 0) begin
            $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d /100 failures===========", error);
    end
    
    $finish;
end

div_16bit uut (.A(A), .B(B), .result(result), .odd(odd));

endmodule