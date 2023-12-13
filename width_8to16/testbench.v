`timescale 1ns/1ns
module testbench();
    reg rst,valid_in;
	reg clk=1;
	reg[7:0] data_in;
	wire valid_out;
	wire [15:0] data_out;

width_8to16 dut(
	.clk (clk),   
	.rst_n(rst),
	.valid_in(valid_in),
	.data_in(data_in),
	.valid_out(valid_out),
	.data_out(data_out)
);
	always #5 clk = ~clk;  

integer error = 0;
initial 
begin
	rst=0;valid_in=0;
 	#10 rst=1;valid_in=1;data_in=8'b10100000;
	// $display("data_out = %b", data_out);
	// $display("valid_out = %b", valid_out);
	error = valid_out ==0 ? error : error+1; 
	#10 data_in=8'b10100001; 
	// $display("data_out = %b", data_out); 
	#10 data_in=8'b10110000;
	// $display("data_out = %b", data_out); 
	// $display("valid_out = %b", valid_out);
	error = (data_out == 16'b1010000010100001 && valid_out ==1 )? error : error+1;
	#10 valid_in=0;
	#20 valid_in=1;data_in=8'b10110001; 
	#10 valid_in=0;
	// $display("data_out = %b", data_out); 
	// $display("valid_out = %b", valid_out);
	error = (data_out == 16'b1011000010110001 && valid_out ==1 )? error : error+1;
	#30

	if (error == 0) begin
		$display("===========Your Design Passed===========");
	end
	else begin
	$display("===========Test completed with %d / 3 failures===========", error);
	end

	$finish;
end  

endmodule