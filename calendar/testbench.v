`timescale 1ns/1ps
module main();
reg clk,rst;

wire[5:0] out1,out2,out3;

verified_calendar dut(.CLK(clk),.RST(rst),.Hours(out1),.Mins(out2),.Secs(out3));

initial begin
	clk=0;
	forever #5 clk=~clk;
end

integer outfile;
initial begin
	#10;
	rst = 1;
	#25;
	rst = 0;
	// outfile = $fopen("reference_output.txt", "a");
	repeat(500) begin	
		$display("[%d : %d : %d]", out1, out2, out3);
		#10;
	end
	$display("=====You can compare the output to the ground truth(reference_output.txt)====");
	// $fclose(outfile);
	$finish;
end

endmodule