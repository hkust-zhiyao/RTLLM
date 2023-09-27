module chatgpt4_generate_JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [3:0] Q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 4'b0000;
        end else begin
            case (Q)
                4'b0000: Q <= 4'b1000;
                4'b1000: Q <= 4'b1100;
                4'b1100: Q <= 4'b1110;
                4'b1110: Q <= 4'b1111;
                4'b1111: Q <= 4'b0111;
                4'b0111: Q <= 4'b0011;
                4'b0011: Q <= 4'b0001;
                4'b0001: Q <= 4'b0000;
            endcase
        end
    end
endmodule