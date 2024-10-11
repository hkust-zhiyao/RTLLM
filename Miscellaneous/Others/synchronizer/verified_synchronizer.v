module verified_synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

reg	[3:0]	data_reg;
always@(posedge clk_a or negedge arstn)
begin
	if(!arstn)	data_reg <= 0;
		else	data_reg <= data_in;
end
reg en_data_reg;	
always@(posedge clk_a or negedge arstn)
begin
	if(!brstn)	en_data_reg <= 0;
		else	en_data_reg <= data_en;   
end

reg	en_clap_one;	//1
reg en_clap_two;	//2
always@(posedge clk_b or negedge brstn)
begin
	if(!brstn)	en_clap_one <= 0;
		else	en_clap_one <= en_data_reg;	
end
always@(posedge clk_b or negedge brstn)
begin
	if(!brstn)	en_clap_two <= 0;
		else	en_clap_two <= en_clap_one;
end

always@(posedge clk_b or negedge brstn)
begin
	if(!brstn)	dataout <= 0;
		else	dataout <= (en_clap_two) ? data_reg : dataout;
end

endmodule
