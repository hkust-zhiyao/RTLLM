module verified_radix2_div(
    input 			[7:0]  		dividend 	,  		
    input 			[7:0]  		divisor 	,   	
    input						clk 	 	,	 	
    input                       rst_n       ,       
    output wire 		[7:0] 	quotient 	,  		
    output wire 		[7:0] 	remainder  			
);

reg [7:0] remainder_reg; 
reg [7:0] divisor_reg;   
reg [7:0] quotient_reg;  
reg [3:0] i;             

always@(posedge  clk or negedge rst_n) begin
    if (!rst_n ) begin
            remainder_reg <= dividend;
            divisor_reg <= divisor;
            quotient_reg <= 0;
    end
    else begin
  
        if(remainder_reg >= {divisor_reg,4'b0}) begin
            remainder_reg <= remainder_reg - {divisor_reg,4'b0};
            quotient_reg[7] <= 1;
        end
        else begin
            quotient_reg[7] <= 0;
        end
        
        
        if(remainder_reg >= {divisor_reg,3'b0,1'b0}) begin
            remainder_reg <= remainder_reg - {divisor_reg,3'b0,1'b0};
            quotient_reg[6] <= 1;
        end
        else begin
            quotient_reg[6] <= 0;
        end
        
      
        if(remainder_reg >= {divisor_reg,2'b0,2'b0}) begin
            remainder_reg <= remainder_reg - {divisor_reg,2'b0,2'b0};
            quotient_reg[5] <= 1;
        end
        else begin
            quotient_reg[5] <= 0;
        end
        
       
        if(remainder_reg >= {divisor_reg,1'b0,3'b0}) begin
            remainder_reg <= remainder_reg - {divisor_reg,1'b0,3'b0};
            quotient_reg[4] <= 1;
        end
        else begin
            quotient_reg[4] <= 0;
        end
        
        
        for(i=0;i<4;i=i+1) begin
            quotient_reg[i] <= quotient_reg[i+4];
        end
    end
end


assign quotient = quotient_reg;
assign remainder = remainder_reg;
    
endmodule