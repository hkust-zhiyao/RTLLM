module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    reg [2:0] state;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'd0;
            ins_p2 <= 8'd0;
        end else begin
            if (fetch == 2'b01) begin // Fetch operation 1, from REG
                ins_p1 <= data;
                ins_p2 <= ins_p2;
            end else if (fetch == 2'b10) begin // Fetch operation 2, from RAM/ROM
                ins_p1 <= ins_p1;
                ins_p2 <= data;
            end else begin
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        end
    end

    assign ins = ins_p1[7:5]; // High 3 bits, instructions
    assign ad1 = ins_p1[4:0];  // Low 5 bits, register address
    assign ad2 = ins_p2;
endmodule