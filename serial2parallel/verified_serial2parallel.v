
module verified_serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);

	reg[7:0]din_tmp;
	reg[3:0]cnt;
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 0;
		else if(din_valid)
			cnt <= (cnt == 4'd8)?0:cnt+1'b1;
		else	
			cnt <= 0;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			din_tmp <= 8'b0;
		else if(din_valid && cnt <= 4'd7)
			din_tmp <= {din_tmp[6:0],din_serial};
	
	end 
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			dout_valid <= 1'b0;
			dout_parallel <= 8'b0;
		end
		else if(cnt == 4'd8)begin
			dout_valid <= 1'b1;
			dout_parallel <= din_tmp;
		end
		else begin
			dout_valid <= 1'b0;
		end
	end 
	
endmodule
