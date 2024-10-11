module verified_multi_pipe_8bit#(
    parameter size = 8
)(
          clk,      
          rst_n,       
          mul_a,       
          mul_b, 
          mul_en_in,
 
          mul_en_out,      
          mul_out    
);
 
   input clk;           
   input rst_n; 
   input mul_en_in;      
   input [size-1:0] mul_a;       
   input [size-1:0] mul_b;       
 
   output reg mul_en_out;  
   output reg [size*2-1:0] mul_out;    
 
            
   reg [2:0] mul_en_out_reg;
 always@(posedge clk or negedge rst_n)
       if(!rst_n)begin
            mul_en_out_reg <= 'd0;             
            mul_en_out     <= 'd0;                           
       end
       else begin
            mul_en_out_reg <= {mul_en_out_reg[1:0],mul_en_in};            
            mul_en_out     <= mul_en_out_reg[2];                  
       end
 
 
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
  always @(posedge clk or negedge rst_n)
         if(!rst_n) begin
              mul_a_reg <= 'd0;
              mul_a_reg <= 'd0;
         end
         else begin
              mul_a_reg <= mul_en_in ? mul_a :'d0;
              mul_b_reg <= mul_en_in ? mul_b :'d0;
         end
 
  
     wire [15:0] temp [size-1:0];
  assign temp[0] = mul_b_reg[0]? {8'b0,mul_a_reg} : 'd0;
  assign temp[1] = mul_b_reg[1]? {7'b0,mul_a_reg,1'b0} : 'd0;
  assign temp[2] = mul_b_reg[2]? {6'b0,mul_a_reg,2'b0} : 'd0;
  assign temp[3] = mul_b_reg[3]? {5'b0,mul_a_reg,3'b0} : 'd0;
  assign temp[4] = mul_b_reg[4]? {4'b0,mul_a_reg,4'b0} : 'd0;
  assign temp[5] = mul_b_reg[5]? {3'b0,mul_a_reg,5'b0} : 'd0;
  assign temp[6] = mul_b_reg[6]? {2'b0,mul_a_reg,6'b0} : 'd0;
  assign temp[7] = mul_b_reg[7]? {1'b0,mul_a_reg,7'b0} : 'd0; 
 
 
     reg [15:0] sum [3:0];//[size/2-1:1]
 always @(posedge clk or negedge rst_n) 
       if(!rst_n) begin
          sum[0]  <= 'd0;
          sum[1]  <= 'd0;
          sum[2]  <= 'd0;
          sum[3]  <= 'd0;
       end 
       else begin
          sum[0] <= temp[0] + temp[1];
          sum[1] <= temp[2] + temp[3];
          sum[2] <= temp[4] + temp[5];
          sum[3] <= temp[6] + temp[7];
       end
 
     reg [15:0] mul_out_reg;
 always @(posedge clk or negedge rst_n) 
       if(!rst_n)
          mul_out_reg <= 'd0;
       else 
          mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3];
 
 
 always @(posedge clk or negedge rst_n) 
       if(!rst_n)
          mul_out <= 'd0;
       else if(mul_en_out_reg[2])
          mul_out <= mul_out_reg;
       else
          mul_out <= 'd0;
 
          
endmodule