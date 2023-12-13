module alu (
    input [31:0] a, b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
);

    // ALU control codes
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

    // Temporary variables for calculations
    reg [31:0] temp;
    reg [63:0] extended_result;

    // Set the zero flag
    assign zero = (r == 32'b0);

    // Set the negative flag
    assign negative = r[31];

    // Set the carry flag - only makes sense for addition/subtraction
    assign carry = (aluc == ADD || aluc == SUB) && (extended_result[32]);

    // Set the overflow flag - only makes sense for addition/subtraction
    assign overflow = ((aluc == ADD || aluc == SUB) &&
                      ((a[31] && b[31] && !r[31]) ||
                       (!a[31] && !b[31] && r[31])));

    always @(*) begin
        flag = 1'b0; // Default flag
        case (aluc)
            ADD: begin
                extended_result = {1'b0, a} + {1'b0, b};
                r = extended_result[31:0];
            end
            ADDU: r = a + b;
            SUB: begin
                extended_result = {1'b0, a} - {1'b0, b};
                r = extended_result[31:0];
            end
            SUBU: r = a - b;
            AND: r = a & b;
            OR: r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = $signed(a) < $signed(b);
                flag = r;
            end
            SLTU: begin
                r = a < b;
                flag = r;
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << a;
            SRLV: r = b >> a;
            SRAV: r = $signed(b) >>> a;
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bz; // High-impedance for undefined operation
        endcase
    end
endmodule