`timescale 1ns/1ps

module verified_radix2_div 
#(
parameter DATAWIDTH=8
)
(
  input                       clk,
  input                       rstn,
  input                       en,
  output  wire                ready,
  input  [DATAWIDTH-1:0]      dividend,
  input  [DATAWIDTH-1:0]      divisor,
  output wire [DATAWIDTH-1:0] quotient,
  output wire [DATAWIDTH-1:0] remainder,
  output wire                 vld_out
);

parameter IDLE =0;
parameter SUB  =1;
parameter SHIFT=2 ;
parameter DONE =3;

reg [DATAWIDTH*2-1:0] dividend_e ;
reg [DATAWIDTH*2-1:0] divisor_e  ;
reg [DATAWIDTH-1:0]   quotient_e ;
reg [DATAWIDTH-1:0]   remainder_e;


reg [1:0] current_state,next_state;

reg [DATAWIDTH-1:0] count;


always@(posedge clk or negedge rstn)
  if(!rstn) current_state <= IDLE;
  else current_state <= next_state;

always @(*) begin
  next_state <= 2'bx;
  case(current_state)
    IDLE: if(en) next_state <= SUB;
          else next_state <= IDLE;
    SUB:  next_state <= SHIFT;
    SHIFT:if(count < DATAWIDTH) next_state <= SUB;
          else next_state <= DONE;
    DONE: next_state <= IDLE;
  endcase
end

always@(posedge clk or negedge rstn) begin
 if(!rstn)begin
   dividend_e  <= 0;
   divisor_e   <= 0;
   quotient_e  <= 0;
   remainder_e <= 0;
   count       <= 0;
 end 
 else begin 
  case(current_state)
  IDLE:begin
         dividend_e <= {{DATAWIDTH{1'b0}},dividend};
         divisor_e  <= {divisor,{DATAWIDTH{1'b0}}};
       end
  SUB:begin
        if(dividend_e>=divisor_e)begin
           dividend_e <= dividend_e-divisor_e+1'b1;
         end
        else begin
           dividend_e <= dividend_e;
        end
      end
  SHIFT:begin
       if(count<DATAWIDTH)begin
         dividend_e <= dividend_e<<1;
         count      <= count+1;      
       end
       else begin
         quotient_e<= dividend_e[DATAWIDTH-1:0];
         remainder_e <= dividend_e[DATAWIDTH*2-1:DATAWIDTH];
       end
     end
  DONE:begin
        count       <= 0;
  end    
  endcase
 end
end

assign quotient  = quotient_e;
assign remainder = remainder_e;

assign ready=(current_state==IDLE)? 1'b1:1'b0;
assign vld_out=(current_state==DONE)? 1'b1:1'b0;

endmodule