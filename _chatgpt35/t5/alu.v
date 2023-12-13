module alu (
  input [31:0] a,
  input [31:0] b,
  input [5:0] aluc,
  output reg [31:0] r,
  output reg zero,
  output reg carry,
  output reg negative,
  output reg overflow,
  output reg flag
);

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

reg [32:0] res;

wire signed [31:0] a_signed;
wire signed [31:0] b_signed;

assign a_signed = $signed(a);
assign b_signed = $signed(b);

assign r = res[31:0];
assign zero = (r == 0);
assign carry = res[32];
assign negative = (r[31] == 1);
assign overflow = (res[31] != res[32]);

assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;

always @(a, b, aluc) begin
  case (aluc)
    ADD:
      res = a + b;
    ADDU:
      res = a + b;
    SUB:
      res = a_signed - b_signed;
    SUBU:
      res = a - b;
    AND:
      res = a & b;
    OR:
      res = a | b;
    XOR:
      res = a ^ b;
    NOR:
      res = ~(a | b);
    SLT:
      res = (a_signed < b_signed) ? 1 : 0;
    SLTU:
      res = (a < b) ? 1 : 0;
    SLL:
      res = {a << (b[4:0]), 1'b0};
    SRL:
      res = {a >> (b[4:0]), a[31]};
    SRA:
      res = {a >>> (b[4:0]), a[31]};
    SLLV:
      res = {a << (b[4:0]), 1'b0};
    SRLV:
      res = {a >> (b[4:0]), a[31]};
    SRAV:
      res = {a >>> (b[4:0]), a[31]};
    LUI:
      res = {a[15:0], 16'b0};
    default:
      res = 33'bz;
  endcase
end

endmodule