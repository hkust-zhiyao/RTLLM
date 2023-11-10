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
    //parameter 
    parameter N = size * 2;
    //defination
    wire [N - 1 : 0] temp [0 : 3];
    
    reg [N - 1 : 0] adder_0;
    reg [N - 1 : 0] adder_1;
    
    //output 
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1)begin : loop
            assign temp[i] = mul_b[i] ? mul_a << i : 'd0;
        end
    endgenerate
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) adder_0 <= 'd0;
        else adder_0 <= temp[0] + temp[1];
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) adder_1 <= 'd0;
        else adder_1 <= temp[2] + temp[3];
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) mul_out <= 'd0;
        else mul_out <= adder_0 + adder_1;
    end
endmodule
