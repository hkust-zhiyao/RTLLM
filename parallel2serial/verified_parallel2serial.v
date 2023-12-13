`timescale 1ns/1ns
module verified_parallel2serial(
	input wire clk  ,
	input wire rst_n  ,
	input wire [3:0]d ,
	output wire valid_out ,
	output wire dout
	);


reg [3:0] data = 'd0;
reg [1:0]cnt;
reg valid;
assign dout = data[3];
assign valid_out =valid;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        data<= 'd0;
        cnt <= 'd0;
        valid <= 'd0;
    end
    else  begin
                
		if (cnt == 'd3) begin
			data <= d;
			cnt <= 'd0;
			valid <= 1;
		end
		else begin
			cnt <= cnt + 'd1;
			valid <= 0;
			data  <= {data[2:0],data[3]};
		end
    end
		
end


endmodule