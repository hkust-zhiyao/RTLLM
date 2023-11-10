`timescale 1ns/1ps
module verified_counter_12_tb;

  reg clk, rst_n, valid_count;
  wire [3:0] out;

  verified_counter_12 dut (
    .rst_n(rst_n),
    .clk(clk),
    .valid_count(valid_count),
    .out(out)
  );


  always #5 clk = ~clk;

  integer error = 0;
  initial begin
    clk = 0;
    rst_n = 0;
    valid_count = 0;

    #20 rst_n = 1;

    #100 valid_count = 1;
	//$display(out);
    error = (out==0)? error : error + 1;
    #400 valid_count = 0;
    #80
	//$display(out);
	error = (out==12)? error : error + 1;
	if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Failed===========", error);
        end
    $finish;
  end


endmodule