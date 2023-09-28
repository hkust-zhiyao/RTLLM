module verified_mux(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);
    reg [3:0] data_reg;
    reg       data_en_a, data_en_b0, data_en_b1;
    
    always@(posedge clk_a or negedge arstn) begin
        if(~arstn)
            data_reg <= 0;
        else
            data_reg <= data_in;
    end
    
    always@(posedge clk_a or negedge arstn) begin
        if(~arstn)
            data_en_a <= 0;
        else
            data_en_a <= data_en;
    end
    
    always@(posedge clk_b or negedge brstn) begin
        if(~brstn) begin
            data_en_b0 <= 0;
            data_en_b1 <= 0;
        end
        else begin
            data_en_b0 <= data_en_a;
            data_en_b1 <= data_en_b0;
        end
    end
    
    always@(posedge clk_b or negedge brstn) begin
        if(~brstn) 
            dataout <= 0;
        else 
            dataout <= data_en_b1? data_reg: dataout;
    end

endmodule

