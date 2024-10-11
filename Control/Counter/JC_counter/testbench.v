`timescale 1ns/1ns

module testbench;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in simulation time units
    
    // Inputs
    reg clk;
    reg rst_n;
    
    // Outputs
    wire [63:0] Q;

    // Instantiate the module
    JC_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );
    
    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;
    
    integer error=0;
    // Initial block for stimulus generation
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 1;
        
        // Wait for a few clock cycles
        #((CLK_PERIOD) * 2);
        
        // Release reset
        rst_n = 0;
        #((CLK_PERIOD) * 2);
        rst_n = 1;
        
        // Simulate for a number of clock cycles
        #((CLK_PERIOD) * 20);
        error = (Q ==64'b 1111111111111111111100000000000000000000000000000000000000000000)? error : error+1;
        #((CLK_PERIOD) * 44);
        error = (Q ==64'b 1111111111111111111111111111111111111111111111111111111111111111)? error : error+1;
        #((CLK_PERIOD) * 1);
        error = (Q ==64'b 0111111111111111111111111111111111111111111111111111111111111111)? error : error+1;
        #((CLK_PERIOD) * 62);
        error = (Q ==64'b 0000000000000000000000000000000000000000000000000000000000000001)? error : error+1;

        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Error===========");
        end
        // $display("Q = %b", Q); 
        
        // Finish simulation
        $finish;
    end

endmodule

