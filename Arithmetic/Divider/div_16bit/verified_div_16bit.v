module verified_div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

reg [15:0] a_reg;
reg [15:0] b_reg;
reg [31:0] tmp_a;
reg [31:0] tmp_b;
integer i;

always@(*) begin
    a_reg = A;
    b_reg = B;
end

always@(*) begin
    begin
        tmp_a = {16'b0, a_reg};
        tmp_b = {b_reg, 16'b0};
        for(i = 0;i < 16;i = i+1) begin
            tmp_a = tmp_a << 1;
            if (tmp_a >= tmp_b) begin
                tmp_a = tmp_a - tmp_b + 1;
            end
            else begin
                tmp_a = tmp_a;
            end
        end
    end
end

assign odd = tmp_a[31:16];
assign result = tmp_a[15:0];

endmodule