module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem[0:3];
    reg [2:0] SP;
    integer i;

    always @ (posedge Clk) begin
        if (EN == 0) begin
            // Do nothing if EN is 0
        end else begin
            if (Rst == 1) begin
                SP = 3'd4;
                EMPTY = SP[2];
                dataOut = 4'h0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] = 0;
                end
            end else if (Rst == 0) begin
                FULL = SP ? 0 : 1;
                EMPTY = SP[2];
                dataOut = 4'hx;
                
                if (FULL == 1'b0 && RW == 1'b0) begin
                    SP = SP - 1'b1;
                    FULL = SP ? 0 : 1;
                    EMPTY = SP[2];
                    stack_mem[SP] = dataIn;
                end else if (EMPTY == 1'b0 && RW == 1'b1) begin
                    dataOut = stack_mem[SP];
                    stack_mem[SP] = 0;
                    SP = SP + 1;
                    FULL = SP ? 0 : 1;
                    EMPTY = SP[2];
                end else begin
                    // Do nothing if neither condition is met
                end
            end else begin
                // Do nothing if neither condition is met
            end
        end
    end
endmodule
