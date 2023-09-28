module chatgpt_generate_pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] partial_sum; // Register to store the partial sum

always @(posedge clk) begin
    if (rst) begin
        partial_sum <= 0; // Reset the partial sum to 0
    end else begin
        partial_sum <= partial_sum + (a * b); // Accumulate the result of "a multiplied by b"
    end
end

assign c = partial_sum; // Output the accumulated value

endmodule
