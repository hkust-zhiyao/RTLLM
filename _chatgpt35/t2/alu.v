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

  wire [31:0] a_signed;
  wire [31:0] b_signed;
  reg [32:0] res;

  assign a_signed = $signed(a);
  assign b_signed = $signed(b);

  always @(a_signed, b_signed, aluc) begin
    case (aluc)
      6'b100000: res = a_signed + b_signed; // ADD
      6'b100001: res = a + b; // ADDU
      6'b100010: res = a_signed - b_signed; // SUB
      6'b100011: res = a - b; // SUBU
      6'b100100: res = a & b; // AND
      6'b100101: res = a | b; // OR
      6'b100110: res = a ^ b; // XOR
      6'b100111: res = ~(a | b); // NOR
      6'b101010: begin // SLT
        res = (a_signed < b_signed) ? 32'b1 : 32'b0;
        flag = 1'b1;
      end
      6'b101011: begin // SLTU
        res = (a < b) ? 32'b1 : 32'b0;
        flag = 1'b1;
      end
      6'b000000: res = a << b[4:0]; // SLL
      6'b000010: res = a >> b[4:0]; // SRL
      6'b000011: res = a_signed >>> b[4:0]; // SRA
      6'b000100: res = a << b; // SLLV
      6'b000110: res = a >> b; // SRLV
      6'b000111: res = a_signed >>> b; // SRAV
      6'b001111: res = {a[15:0], 16'b0}; // LUI
      default: res = 33'bz; // Default (undefined operation)
    endcase
  end

  always @(posedge clk) begin
    r <= res[31:0];
    zero <= (r == 0);
    carry <= res[32];
    negative <= (r[31] == 1);
    overflow <= (r[31] ^ res[31]);
  end

endmodule