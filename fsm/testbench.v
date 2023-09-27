`timescale 1ns/1ns

module main();

reg clk,rst;
reg IN;
wire MATCH;

verified_fsm DUT(.CLK(clk),.RST(rst),.IN(IN),.MATCH(MATCH));

initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
	#10;
	rst =1;
	#30;
	rst = 0;
	IN = 0;
	#10 IN=0;
        #10 IN=0;
        #10 IN=1;
        #10 IN=1;  
        #10 IN=0;
        #10 IN=0;
        #10 IN=1;
        #10 IN=1;
        #20;
        if(MATCH==1)begin
                $display("===========Your Design Passed===========");
        end
        else begin
                $display("===========Error===========");
        end
	$finish;
end
endmodule