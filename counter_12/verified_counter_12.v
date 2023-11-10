module dfflr #(
	parameter DW = 4
)(
	input clk,
	input rst_n,
	input load,
	input [DW-1:0] in,
	output [DW-1:0] out
    );
    	reg [DW-1:0] out_reg;
    	always@(posedge clk or negedge rst_n)  
    	begin
        	if(rst_n == 1'b0)
            		out_reg[DW-1:0] = {DW{1'b0}};
        	else if(load)
            		out_reg[DW-1:0] = in[DW-1:0];
        	else 
            		out_reg[DW-1:0] = out[DW-1:0];
   	 end
    	assign out[DW-1:0] = out_reg[DW-1:0];
endmodule

module verified_counter_12(
    input rst_n,
	input clk,
	input valid_count, 
	output [3:0] out
	);
	wire [3:0]count_nxt;
	wire [3:0]count_r;
    dfflr #(4) count(clk,rst_n,valid_count,count_nxt,count_r);
    assign out = count_r;
    assign count_nxt = (count_r==4'd12)?4'd12:count_r+4'b1;
       
endmodule




