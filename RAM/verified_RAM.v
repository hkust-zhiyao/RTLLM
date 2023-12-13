module verified_RAM (
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0]write_addr,
	input [5:0]write_data,
	
	input read_en,
	input [7:0]read_addr,
	output reg [5:0]read_data
);
    
    //defination
    reg [7 : 0] RAM [11:0];

    //output 
    integer i;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
               for(i = 0; i < 8; i = i + 1) begin
                   RAM[i] <= 'd0;
               end
        end
        else if(write_en) 
            RAM[write_addr] <= write_data;
    end
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) 
            read_data <= 'd0;
        else if(read_en) 
            read_data <= RAM[read_addr];
        else 
            read_data <= 'd0;
    end
endmodule
