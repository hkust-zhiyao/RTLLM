module chatgpt_generate_alu(
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

// ALU operation parameter definitions
parameter ADD  = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB  = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND  = 6'b100100;
parameter OR   = 6'b100101;
parameter XOR  = 6'b100110;
parameter NOR  = 6'b100111;
parameter SLT  = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL  = 6'b000000;
parameter SRL  = 6'b000010;
parameter SRA  = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI  = 6'b001111;

// Internal signals for ALU operations
reg carry_out;
reg [32:0] extended_b;

// ALU operation
always @*
begin
    case (aluc)
        ADD, ADDU:
            begin
                r = a + b;
                carry_out = (r < a) | (r < b); // Detect overflow for signed addition
            end
        SUB, SUBU:
            begin
                r = a - b;
                carry_out = (a < b);
            end
        AND:
            r = a & b;
        OR:
            r = a | b;
        XOR:
            r = a ^ b;
        NOR:
            r = ~(a | b);
        SLT:
            r = (a < b) ? 1 : 0;
        SLTU:
            r = (a < b) ? 1 : 0;
        SLL:
            r = a << (b[4:0]);
        SRL:
            r = a >> (b[4:0]);
        SRA:
            r = $signed(a) >>> (b[4:0]); // Arithmetic shift right (sign-extended)
        SLLV:
            r = a << (b & 0x1F);
        SRLV:
            r = a >> (b & 0x1F);
        SRAV:
            r = $signed(a) >>> (b & 0x1F); // Arithmetic shift right (sign-extended)
        LUI:
            r = {b, 16'b0};
    endcase
end

// Zero detection
assign zero = (r == 0);

// Carry detection
assign carry = carry_out;

// Negative detection
assign negative = (r[31] == 1);

// Overflow detection
assign overflow = (carry_out != carry);

// Set flag to output of SLT/SLTU
always @(posedge clk)
begin
    if (aluc == SLT || aluc == SLTU)
        flag = r;
    else
        flag = 0;
end

endmodule
