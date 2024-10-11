`timescale 1ns / 1ps
module freq_divbyfrac_tb;
    // Inputs
    reg clk;
    reg rst_n;
    // Outputs
    wire clk_div;
 
    // Instantiate the Unit Under Test (UUT)
    freq_divbyfrac uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .clk_div(clk_div)
    );
    always #5 clk = ~clk;
    
    integer error = 0;
    integer expected_value = 1;
    integer i;
    initial begin
        // Initialize Inputs
        clk = 1;
        rst_n = 0;
        # 10 rst_n = 1;
        #120;

        $finish;
    end
    initial begin
        // $monitor("clk=%d, clk_div=%d",clk,clk_div);
        #15;
        for (i = 0; i < 20; i = i + 1) begin
            if (clk_div !== expected_value) begin
                error = error + 1; 
                $display("Failed at%d: clk=%d, clk_div=%d (expected %d)", i,clk, clk_div, expected_value);
            end

            if (i < 2) expected_value = 1; 
            else if (i < 6) expected_value = 0; 
            else if (i < 9) expected_value = 1; 
            else if (i < 13) expected_value = 0; 
            else if (i < 16) expected_value = 1; 
            else if (i < 20) expected_value = 0; 
            else expected_value = 1; // Last five pairs
            #5;
        end
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
            end
        else begin
            $display("=========== Test completed with %d/20 failures ===========", error);
        end
    end
endmodule
 