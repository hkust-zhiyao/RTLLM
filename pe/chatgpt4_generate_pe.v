module chatgpt4_generate_pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

    // 64-bit register to hold the intermediate results
    reg [63:0] acc = 0;

    always @(posedge clk or posedge rst) begin
        if (rst)
            acc <= 0;  // reset the accumulator
        else
            acc <= acc + ((a * b));  // multiply and accumulate
    end

    assign c = acc[31:0];  // output the lower 32 bits of the accumulator

endmodule