`timescale 1ns/1ns

module verified_pulse_detect(
	input 				clk_fast	, 
	input 				clk_slow	,   
	input 				rst_n		,
	input				data_in		,

	output  		 	dataout
);
    reg data_level, data_level1, data_level2, data_level3;
    
  	
    always@(posedge clk_fast or negedge rst_n) begin
        if(~rst_n)
            data_level <= 0;
        else
            data_level <= data_in? ~data_level: data_level;
    end
    
  	
    always@(posedge clk_slow or negedge rst_n) begin
        if(~rst_n) begin
            data_level1 <= 0;
            data_level2 <= 0;
            data_level3 <= 0;
        end
        else begin
            data_level1 <= data_level;
            data_level2 <= data_level1;
            data_level3 <= data_level2;
        end
    end
    assign dataout = data_level3^data_level2;
endmodule
