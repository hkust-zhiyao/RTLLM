module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Register declarations for pipeline stages
    reg [7:0] reg_a, reg_b; // Registers to hold inputs in the first stage
    reg [15:0] partial_product; // Register to hold the partial product
    reg mul_en_in_reg; // Register to hold the input enable signal
    
    // Pipeline stage 1 - capturing the inputs and enabling the multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a <= 0;
            reg_b <= 0;
            mul_en_in_reg <= 0;
        end else if (mul_en_in) begin
            reg_a <= mul_a;
            reg_b <= mul_b;
            mul_en_in_reg <= mul_en_in;
        end
    end
    
    // Pipeline stage 2 - performing the multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_product <= 0;
            mul_en_out <= 0;
        end else begin
            if (mul_en_in_reg) begin
                // Perform multiplication when enabled
                partial_product <= reg_a * reg_b;
                mul_en_out <= mul_en_in_reg; // Propagate the enable signal to the output
            end else begin
                partial_product <= 0; // Reset partial product if not enabled
                mul_en_out <= 0; // Reset output enable signal
            end
        end
    end
    
    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            if (mul_en_out) begin
                // Output the final product when enabled
                mul_out <= partial_product;
            end else begin
                mul_out <= 0; // Reset output if not enabled
            end
        end
    end

endmodule