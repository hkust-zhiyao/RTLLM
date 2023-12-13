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

    wire [31:0] a_signed;
    wire [31:0] b_signed;
    reg [32:0] res;

    assign a_signed = a;
    assign b_signed = b;

    always @(a, b, aluc) begin
        case (aluc)
            ADD, ADDU: res = a + b;
            SUB, SUBU: res = a - b;
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = (a_signed < b_signed) ? 1'b1 : 1'b0;
                flag = 1'b1;
            end
            SLTU: begin
                res = (a < b) ? 1'b1 : 1'b0;
                flag = 1'b1;
            end
            SLL: res = a << b[4:0];
            SRL: res = a >> b[4:0];
            SRA: res = $signed(a) >>> b[4:0];
            SLLV: res = a << (b[4:0] & 5'b11111);
            SRLV: res = a >> (b[4:0] & 5'b11111);
            SRAV: res = $signed(a) >>> (b[4:0] & 5'b11111);
            LUI: res = {a[31:16], 16'b0};
            default: res = 33'bz;
        endcase

        r = res[31:0];
        zero = (res[31:0] == 32'b0) ? 1'b1 : 1'b0;
        carry = res[32];
        negative = (res[31] == 1'b1) ? 1'b1 : 1'b0;
        overflow = (aluc == ADD || aluc == SUB) ? (a[31] == b[31] && res[31] != a[31]) : 1'b0;
        flag = (aluc == SLT || aluc == SLTU) ? flag : 1'bz;
    end

endmodule