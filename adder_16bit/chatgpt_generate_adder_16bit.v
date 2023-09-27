//GPT3.5
module chatgpt_generate_adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input c_up,
    output [15:0] y,
    output Co
);

wire [15:0] sum;
wire [15:1] carry;

genvar i;

generate
    for (i = 0; i < 16; i=i+1) begin : generate_block
        assign {carry[i+1], sum[i]} = a[i] + b[i] + carry[i];
    end
endgenerate

assign Co = carry[16];
assign y = sum;

endmodule
