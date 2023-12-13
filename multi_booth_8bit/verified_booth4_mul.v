`timescale 1ns / 1ps

module verified_multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;
   
   reg [15:0] p;
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   reg rdy;
   reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
    rdy     <= 0;
    p   <= 0;
    ctr     <= 0;
    multiplier <= {{8{a[7]}}, a};
    multiplicand <= {{8{b[7]}}, b};
    end 
    else 
    begin 
      if(ctr < 16) 
          begin
          multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1)
            begin
                p <= p + multiplicand;
            end
            ctr <= ctr + 1;
          end
       else 
           begin
           rdy <= 1;
           end
    end
  end //End of always block
    
endmodule