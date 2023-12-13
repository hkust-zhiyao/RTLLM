module alu (
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

    // Opcode parameters
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

    // Internal signals
    reg [31:0] res;
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] b_inv;
    wire [32:0] sum;   // For carry and overflow detection
    wire slt_set;

    // Calculate zero flag
    assign zero = (r == 32'b0);

    // Calculate SLT set condition
    assign slt_set = signed_a < signed_b;

    // Extended b inversion for SUB and SUBU
    assign b_inv = ~b + 1'b1;

    // 33-bit sum for carry and overflow detection
    assign sum = {1'b0, a} + (aluc == SUB || aluc == SUBU ? {1'b0, b_inv} : {1'b0, b}) + (aluc == SUB);

    always @(*) begin
        case (aluc)
            ADD, ADDU: begin
                res = a + b;
                carry = sum[32];
                overflow = (a[31] == b[31]) && (res[31] != a[31]);
            end
            SUB, SUBU: begin
                res = a - b;
                carry = !sum[32];
                overflow = (a[31] != b[31]) && (res[31] != a[31]);
            end
            AND: res = a & b;
            OR: res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = slt_set;
                flag = slt_set;
            end
            SLTU: begin
                res = a < b;
                flag = a < b;
            end
            SLL: res = b << a[4:0];
            SRL: res = b >> a[4:0];
            SRA: res = signed_b >>> a[4:0];
            SLLV: res = b << b[4:0];
            SRLV: res = b >> b[4:0];
            SRAV: res = signed_b >>> b[4:0];
            LUI: res = b << 16;
            default: res = 32'bz; // High-impedance for undefined operations
        endcase

        // Set the output register to the computed result
        r = res;

        // Set flags
        negative = r[31];
        flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'b0;

        // Clear carry and overflow for logical operations
        if (aluc[5:3] == 3'b100) begin
            carry = 1'b0;
            overflow = 1'b0;
        end
    end

endmodule