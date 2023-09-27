module chatgpt_generate_alu (
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

    always @* begin
        case (aluc)
            ADD, ADDU: begin
                r = a + b;
                carry = r[31];
                overflow = (a[31] == b[31]) && (r[31] != a[31]);
            end
            SUB, SUBU: begin
                r = a - b;
                carry = (a >= b) ? 1 : 0;
                overflow = (a[31] != b[31]) && (r[31] != a[31]);
            end
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = $signed(a) < $signed(b);
                flag = r[0];
            end
            SLTU: begin
                r = a < b;
                flag = r[0];
            end
            SLL: r = b << a;
            SRL: r = b >> a;
            SRA: r = $signed(b) >>> a;
            SLLV: r = a << b[4:0];
            SRLV: r = a >> b[4:0];
            SRAV: r = $signed(a) >>> b[4:0];
            LUI: r = b << 16;
            default: r = 0;
        endcase

        zero = (r == 0);
        negative = r[31];
    end
endmodule