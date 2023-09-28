`timescale 1ns/1ns
module verified_signal_generator(
	input clk,
	input rst_n,
	input [1:0] wave_choise,
	output reg [4:0]wave
	);

    reg [4:0] cnt;
    reg flag;
    
  	// square
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
            cnt <= 0;
        else
            cnt <= wave_choise!=0 ? 0:
                   cnt        ==19? 0:
                   cnt + 1;
    end
    
  	// tri
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
            flag <= 0;
        else
            flag <= wave_choise!=2 ? 0:
                    wave       ==1 ? 1:
                    wave       ==19? 0:
                    flag;
    end
    
  
  	// update
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n) 
            wave <= 0;
        else 
            case(wave_choise)
                0      : wave <= cnt == 9? 20    : 
                                 cnt ==19? 0     :
                                 wave;
                1      : wave <= wave==20? 0     : wave+1;
                2      : wave <= flag==0 ? wave-1: wave+1;
                default: wave <= 0;
            endcase
    end
endmodule