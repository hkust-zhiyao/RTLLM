`timescale 1ns/1ns

module testbench;
    reg clk;
    reg rst_n;
    reg a;
    wire rise;
    wire down;

    verified_edge_detect dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .rise(rise),
        .down(down)
    );

    integer error=0;
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 1;
        a = 0;

        // Wait for a few clock cycles to ensure the module stabilizes
        #10;

        // Test scenario 1: No edge
        a = 0;
        #5;
        a = 0;
        #5;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 0 || down != 0) ? error+1 : error;
        // Test scenario 2: Rising edge
        a = 0;
        #5;
        a = 1;
        #5;
        a = 1;
        #5;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 1 || down != 0) ? error+1 : error;
        // Test scenario 3: Falling edge
        a = 1;
        #5;
        a = 0;
        #5;
        a = 0;
        #5;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 0 || down != 1) ? error+1 : error;
        // Test scenario 4: Both edges
        a = 0;
        #5;
        a = 1;
        #5;
        a = 0;
        #5;
        a = 1;
        #5;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 0 || down != 0) ? error+1 : error;
        // Test scenario 5: Reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;

        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Test completed with %d /100 failures===========", error);
        end

        // Finish simulation
        $finish;
    end

    always #5 clk = ~clk;
    
endmodule
