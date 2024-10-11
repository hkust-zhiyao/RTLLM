module verified_pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

reg [31:0] cc;
assign c = cc;
always@(posedge clk or posedge rst)
begin

  if(rst)
  begin
    cc <= 0;
  end

  else
  begin
    cc <= cc + a*b;
  end

end

endmodule