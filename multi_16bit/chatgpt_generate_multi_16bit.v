module chatgpt_generate_multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);
// integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done <= 0;
    else if (start)
        done <= 0;
end

always @(posedge clk) begin
    if (rst_n && start) begin
        // Initialize the output and other internal variables
        yout <= 0;
        done <= 0;
        
        // Perform the multiplication
        for (int i = 0; i < 16; i = i + 1) begin
            if (bin[i] == 1)
                yout <= yout + (ain << i);
        end
        
        // Set the done signal when multiplication is complete
        done <= 1;
    end
end

endmodule
