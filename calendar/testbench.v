`timescale 1ns/1ps
module main();
reg clk,rst;

wire[5:0] out1,out2,out3;

calendar dut(.CLK(clk),.RST(rst),.Hours(out1),.Mins(out2),.Secs(out3));

initial begin
	clk=0;
	forever #5 clk=~clk;
end

integer outfile;
reg [17:0] clocktime;
always @(posedge clk) begin
    clocktime[17:12] <= out1;
    clocktime[11:6] <= out2;
    clocktime[5:0] <= out3;
end

reg [17:0] reference_data [0:4000];
integer i=0;
integer error = 0;
initial begin
	#10;
	rst = 1;
	#25;
	rst = 0;
	// outfile = $fopen("reference.txt", "w");
	$readmemh("reference.txt",reference_data);
	repeat(4000) begin	
		// $fwrite(outfile, "%h\n", clocktime);
		error = (reference_data[i] == clocktime) ? error :error +1;
		i = i + 1;

		#10;
	end
	if(error==0)
	begin
		$display("===========Your Design Passed===========");
        end
	else
	begin
		$display("===========Error===========");
	end
	// $fclose(outfile);
	$finish;
end

endmodule