`timescale 1ns/1ps
module counter_12_tb;

  reg clk, rst_n, valid_count;
  wire [3:0] out;

  counter_12 dut (
    .rst_n(rst_n),
    .clk(clk),
    .valid_count(valid_count),
    .out(out)
  );


  always #5 clk = ~clk;
  integer i = 0;
  integer error = 0;
  initial begin
    clk = 0;
    rst_n = 0;
    valid_count = 0;

    #20 rst_n = 1;
    // testcase1: validation of valid_count
    repeat(15) begin	
      error = (out == 0) ?error:error+1;
      #10;
    end
    // testcase2: counter
    #100 valid_count = 1;
    repeat(11) begin	
      error = (out == i) ?error:error+1;
      i = i+1;
      #10;
    end
    // testcase3: the count is paused if valid_count is invalid
    valid_count = 0;
    repeat(5) begin	
      error = (out == 11) ?error:error+1;
      #10;
    end

    if (error == 0) begin
              $display("===========Your Design Passed===========");
          end
          else begin
          $display("===========Failed===========", error);
          end
    $finish;
  end


endmodule