`timescale 1ns/1ns

module verified_accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    
   reg [1:0] count;
   wire add_cnt;
   wire ready_add;
   wire end_cnt;
   reg [9:0]   data_out_reg;

   assign add_cnt = ready_add;
   assign end_cnt = ready_add && (count == 'd3);
   
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

    //data_out_reg
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        data_out_reg <= 0;
      end
      else if (add_cnt && count == 0) begin
          data_out_reg <= data_in;
      end
      else if (add_cnt) begin
          data_out_reg <= data_out_reg + data_in;
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

   //ready_add
   assign ready_add = !valid_out | valid_in;

   //valid_out
   always @(posedge clk or negedge rst_n) begin
       if(!rst_n) begin
           valid_out <= 0;
       end
       else if(end_cnt) begin
           valid_out <= 1;
       end
       else begin
           valid_out <= 0;
       end
   end  
     
endmodule