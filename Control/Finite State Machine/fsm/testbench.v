`timescale 1ns/1ns

module main();

reg clk,rst;
reg IN;
wire MATCH;

fsm DUT(.CLK(clk),.RST(rst),.IN(IN),.MATCH(MATCH));

initial begin
	clk=0;
	forever #5 clk=~clk;
end

integer error = 0;
initial begin
	#10;
	rst =1;
	#28;
	rst = 0;
	IN = 0;
	#10 IN=0;
        // $display("%b, %b", MATCH, DUT.ST_cr);//0
        error = (MATCH==0)? error:error+1;
        #10 IN=0;
        // $display("%b, %b", MATCH, DUT.ST_cr);//00
        error = (MATCH==0)? error:error+1;
        #10 IN=1;
        // $display("%b, %b", MATCH, DUT.ST_cr);//001
        error = (MATCH==0)? error:error+1;
        #10 IN=1;  
        // $display("%b, %b", MATCH, DUT.ST_cr);//0011
        error = (MATCH==0)? error:error+1;
        #10 IN=0;
        // $display("%b, %b", MATCH, DUT.ST_cr);//00110
        error = (MATCH==0)? error:error+1;
        #10 IN=0;
        // $display("%b, %b", MATCH, DUT.ST_cr);//001100
        error = (MATCH==0)? error:error+1;
        #10 IN=1;
        // $display("%b, %b", MATCH, DUT.ST_cr);//0011001
        error = (MATCH==0)? error:error+1;
        #10 IN=1;
        // $display("%b, %b", MATCH, DUT.ST_cr);//00110011
        error = (MATCH==1)? error:error+1;
        #10 IN=0;
        // $display("%b, %b", MATCH, DUT.ST_cr);//001100110
        error = (MATCH==0)? error:error+1;
        #10 IN=0;
        // $display("%b, %b", MATCH, DUT.ST_cr);//0011001100
        error = (MATCH==0)? error:error+1;
        #10 IN=1;
        // $display("%b, %b", MATCH, DUT.ST_cr);//00110011001
        error = (MATCH==0)? error:error+1;
        #10 IN=1;
        // $display("%b, %b", MATCH, DUT.ST_cr);//001100110011
        error = (MATCH==1)? error:error+1;
        if(error==0)begin
                $display("===========Your Design Passed===========");
        end
        else begin
                $display("===========Error===========");
        end
	$finish;
end
endmodule