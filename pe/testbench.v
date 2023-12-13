`timescale 1ns / 1ps

module test54();

    reg clk;
    reg rst;
    reg [31:0] a,b;
    wire [31:0] c;
    
    pe dut(clk,rst,a,b,c);


    initial begin

    a=0;
    b=0;
    clk=0;
    rst=1;
    #5;
    clk=1;
    #5;
    clk=0;
    rst=0;
    #5;

    a=1;
    b=1;
    #5;
    clk=1;
    #5;
    clk=0;

    a=2;
    b=2;
    #5;
    clk=1;
    #5;
    clk=0;

    a=3;
    b=3;
    #5;
    clk=1;
    #5;
    clk=0;

    //$display("%h", c);

	if(c==32'h0000000e)
	begin
		$display("===========Your Design Passed===========");
        end
	else
	begin
		$display("===========Error===========");
	end
    end
endmodule
