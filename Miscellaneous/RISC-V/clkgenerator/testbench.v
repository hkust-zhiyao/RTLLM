module clkgenerator_tb;

    reg clk_tb; // Clock signal from the testbench
    reg res = 1'b0;
    integer error = 0;
    // Instantiate the clkgenerator module
    clkgenerator clkgenerator_inst (
        .clk(clk_tb)
    );

    initial begin
        // Monitor the clock signal
        // $monitor("Time=%0t, clk=%b", $time, clk_tb);

        // Simulate for a certain number of clock cycles
        repeat (20) begin // Simulate 20 clock cycles
            #5; // Time delay between clock cycles
            error = (res == clk_tb) ? error :error+1;
            res = res + 1;
            // $display(clk_tb);
        end
        if (error == 0) begin
        $display("=========== Your Design Passed ===========");
        end
        else begin
        $display("=========== Test completed with %d failures ===========", error);
        end
        // Finish simulation
        $finish;
    end

endmodule