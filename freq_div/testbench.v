module test ();

reg  clk,rst;

wire out1;
wire out2;
wire out3;

freq_div dut(.CLK_in(clk),.RST(rst),.CLK_50(out1),.CLK_10(out2),.CLK_1(out3));

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

integer error=0;

initial begin 
	#10;
	rst = 1;
	#35;
	rst = 0;
	// 45, clk: 1, clk50: 0, rclk10: 0, clk1: 0
	error = (out1 != 0 || out2 != 0 || out3 !=0 ) ? error+1 : error;
	// 55, clk: 1, clk50: 1, rclk10: 0, clk1: 0
	#10;
	error = (out1 != 1 || out2 != 0 || out3 !=0 ) ? error+1 : error;
	// 95, clk50: 0, rclk10: 1, clk1: 0
	#40;
	error = (out1 != 1 || out2 != 1 || out3 !=0 ) ? error+1 : error;
	// 225, clk: 1, clk50: 0, rclk10: 1, clk1: 0
	#130;
	error = (out1 != 0 || out2 != 1 || out3 !=0 ) ? error+1 : error;
	// 625, clk: 1, clk50: 0, rclk10: 1, clk1: 1
	#400;
	error = (out1 != 0 || out2 != 1 || out3 !=1 ) ? error+1 : error;
	// 1035, clk: 1, clk50: 1, rclk10: 1, clk1: 1
	#410;
	error = (out1 != 1 || out2 != 1 || out3 !=1 ) ? error+1 : error;
	if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Error===========", error);
        end
	$finish;
end

// initial begin 
// 	repeat(500) begin
// 		#5
// 		$display("Time: %t, clk: %b, clk50: %b, rclk10: %b, clk1: %b", $time, clk, out1, out2, out3);
// 	end
// end

endmodule