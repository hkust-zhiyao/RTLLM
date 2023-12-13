module alu (
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
);

    // Define operation parameters
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
    reg [32:0] extended_result; // 32-bit result with carry
    wire [31:0] b_negated;
    wire set;
    wire unsigned_set;

    assign b_negated = ~b + 1'b1; // Two's complement for subtraction
    assign set = r[31]; // Negative flag for SLT
    assign unsigned_set = !r[31]; // Unsigned comparison for SLTU
    assign zero = (r == 32'b0); // Zero flag
    assign negative = r[31]; // Negative flag

    always @(*) begin
        carry = 0; // Default carry
        overflow = 0; // Default overflow
        flag = 0; // Default flag

        case (aluc)
            ADD: {carry, r} = {1'b0, a} + {1'b0, b};
            ADDU: r = a + b;
            SUB: {carry, r} = {1'b0, a} + {1'b0, b_negated};
            SUBU: r = a - b;
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = set;
                flag = set;
            end
            SLTU: begin
                r = unsigned_set;
                flag = unsigned_set;
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << (a[4:0]);
            SRLV: r = b >> (a[4:0]);
            SRAV: r = $signed(b) >>> (a[4:0]);
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bz; // High-impedance for undefined operations
        endcase

        // Check for overflow in signed addition and subtraction
        if (aluc == ADD || aluc == SUB) begin
            overflow = (a[31] && b[31] && !r[31]) || (!a[31] && !b[31] && r[31]);
        end
    end

endmodule