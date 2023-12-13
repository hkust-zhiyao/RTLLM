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

    // Opcodes for the operations
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

    // Assign zero flag
    assign zero = (r == 32'b0);

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                {carry, r} = a + b;
                overflow = (a[31] & b[31] & ~r[31]) | (~a[31] & ~b[31] & r[31]);
            end
            ADDU: begin
                r = a + b; // Carry is ignored in ADDU.
            end
            SUB: begin
                {carry, r} = a - b;
                overflow = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
            end
            SUBU: begin
                r = a - b; // Carry is ignored in SUBU.
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
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << a;
            SRLV: r = b >> a;
            SRAV: r = $signed(b) >>> a;
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'hz; // High-impedance for undefined operations
        endcase

        negative = r[31]; // Set the negative flag based on the result's sign bit.
    end

endmodule