`timescale 1ns / 1ps

module testbench;
  
  reg [7:0] a;
  reg [7:0] b;
  reg cin;
  wire [7:0] sum;
  wire cout;
  
  integer i; // Declare the loop variable here
  integer fail_count;
  integer error = 0;
  
  // Instantiate the module
  adder_8bit uut (
    .a(a), 
    .b(b), 
    .cin(cin), 
    .sum(sum), 
    .cout(cout)
  );
  
  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 100; i = i + 1) begin
        a = $random & 8'hff;
        b = $random & 8'hff;
        cin = $random & 1'b1;
        #10;
        error = (sum !== a + b + cin) ? error+1 : error; 
    end
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Test completed with %d /100 failures===========", error);
    end

  end

endmodule