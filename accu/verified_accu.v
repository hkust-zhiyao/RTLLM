`timescale 1ns/1ns

module verified_accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);
    
   reg [1:0] count;
   wire add_cnt;
   wire end_cnt;

   assign add_cnt = valid_a && ready_a;
   assign end_cnt = valid_a && ready_a && (count == 'd3);
   
   //count
   always @(posedge clk or negedge rst_n) begin
       if(!rst_n) begin
          count <= 0;
       end
       else if(end_cnt) begin
          count <= 0;
       end
       else if(add_cnt) begin
          count <= count + 1;
       end
   end

    //data_out
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        data_out <= 0;
      end
      else if (add_cnt && count == 0) begin
          data_out <= data_in;
      end
      else if (add_cnt) begin
          data_out <= data_out + data_in;
      end
   end

   //ready_a
   assign ready_a = !valid_b | ready_b;

   //valid_b
   always @(posedge clk or negedge rst_n) begin
       if(!rst_n) begin
           valid_b <= 0;
       end
       else if(end_cnt) begin
           valid_b <= 1;
       end
       else if(ready_b) begin
           valid_b <= 0;
       end
   end  
     
endmodule