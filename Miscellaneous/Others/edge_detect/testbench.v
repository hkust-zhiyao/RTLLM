`timescale 1ns/1ns

module testbench;
    reg clk;
    reg rst_n;
    reg a;
    wire rise;
    wire down;

    edge_detect dut (
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
        #5;

        // Test scenario 1: No edge
        a = 0;
        #10;
        a = 0;
        #10;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 0 && down != 0) ? error+1 : error;
        // Test scenario 2: Rising edge
        a = 0;
        #10;
        a = 1;
        #10;
        a = 1;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 1 && down != 0) ? error+1 : error;
        // Test scenario 3: Falling edge
        a = 1;
        #10;
        a = 0;
        #10;
        a = 0;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 0 && down != 1) ? error+1 : error;
       // Test scenario 4: Reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        // $display("rise: %b, down: %b", rise, down);
        error = (rise != 0 && down != 0) ? error+1 : error;
        
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Error===========", error);
        end

        // Finish simulation
        $finish;
    end

    always #5 clk = ~clk;
    
endmodule
