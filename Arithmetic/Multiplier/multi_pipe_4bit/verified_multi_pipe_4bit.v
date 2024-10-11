`timescale 1ns/1ns
module verified_multi_pipe#(
	parameter size = 4
)(
	input 						clk 		,   
	input 						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
 	output	reg	[size*2-1:0]	mul_out		
);

parameter N = 2 * size;

reg     [N-1:0]     sum_tmp1                ;
reg     [N-1:0]     sum_tmp2                ;
wire    [N-1:0]     mul_a_extend            ;
wire    [N-1:0]     mul_b_extend            ;

wire    [N-1:0]     mul_result[size-1:0]    ;

genvar i;
generate
    for(i = 0; i < size; i = i + 1) begin:add
        assign mul_result[i] = mul_b[i] ? mul_a_extend << i : 'd0;
    end
endgenerate

assign mul_a_extend = {{size{1'b0}}, mul_a};
assign mul_b_extend = {{size{1'b0}}, mul_b};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_tmp1 <= 'd0;
        sum_tmp2 <= 'd0;
    end
    else begin
        sum_tmp1 <= mul_result[0] + mul_result[1];
        sum_tmp2 <= mul_result[2] + mul_result[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_out <= 'd0;
    end
    else begin
        mul_out <= sum_tmp1 + sum_tmp2;
    end
end

endmodule

