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
  
  wire [31:0] res;
  wire [31:0] a_signed, b_signed;
  
  always @(a, b) begin
    a_signed = $signed(a);
    b_signed = $signed(b);
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r <= 'z;
      zero <= 1'b0;
      carry <= 1'b0;
      negative <= 1'b0;
      overflow <= 1'b0;
      flag <= 'z;
    end
    else begin
      case (aluc)
        ADD:
          res = a + b;
          
        ADDU:
          res = a + b;
          
        SUB:
          res = a - b;
          
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
          flag = 1'b1;
          
        SLTU:
          res = (a < b) ? 1 : 0;
          flag = 1'b1;
          
        SLL:
          res = a << b[4:0];
          
        SRL:
          res = a >> b[4:0];
          
        SRA:
          res = $signed(a) >>> b[4:0];
          
        SLLV:
          res = a << b[4:0];
          
        SRLV:
          res = a >> b[4:0];
          
        SRAV:
          res = $signed(a) >>> b[4:0];
          
        LUI:
          res = {a[15:0], 16'b0};
          
        default:
          res = 'z;
      endcase
      
      r = res[31:0];
      zero = (res == 0) ? 1 : 0;
      carry = (res[32] == 1) ? 1 : 0;
      negative = (res[31] == 1) ? 1 : 0;
      overflow = 1'b0;
      flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 'z;
    end
  end
endmodule