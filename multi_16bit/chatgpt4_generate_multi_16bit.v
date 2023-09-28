module chatgpt4_generate_multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
    );
    
    reg [15:0] a, b;
    reg [31:0] product;
    reg [4:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            product <= 32'h0;
            done <= 0;
            i <= 5'b0;
        end
        else if (start)
        begin
            a <= ain;
            b <= bin;
            product <= 32'h0;
            done <= 0;
            i <= 5'b0;
        end
        else if (!done)
        begin
            if (i < 16)
            begin
                if (b[0])
                    product <= product + a;
                a <= a << 1;
                b <= b >> 1;
                i <= i + 1;
            end
            else
            begin
                done <= 1;
                yout <= product;
            end
        end
    end
endmodule