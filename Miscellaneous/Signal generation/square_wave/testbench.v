module square_wave_tb;

    reg clk_tb = 0;        
    reg [8:0] freq_tb = 8'b0000100; 
    wire wave_out_tb;       
    integer ones_count = 0;  // Counter for consecutive ones
    integer error = 0;       // Error flag

    square_wave square_wave_inst (
        .clk(clk_tb),
        .freq(freq_tb),
        .wave_out(wave_out_tb)
    );

    initial begin
        // Monitor output
        // $monitor("Time: %0t | Clock: %b | Frequency: %d | Square Wave Output: %b | Error: %d", $time, clk_tb, freq_tb, wave_out_tb, error);

        // Simulate for a certain time
        repeat (200) begin
            if (wave_out_tb == 1) begin
                ones_count = ones_count + 1;
                if (ones_count > 8) begin
                    $display("Error: More than 8 consecutive ones detected at time %0t", $time);
                    error = 1;  // Set error flag
                    $finish;    // Stop the simulation
                end
            end else begin
                ones_count = 0;
            end
            #5; // Time delay between clock cycles
        end
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end
        $finish;  // Finish the simulation
    end

    always #5 clk_tb = ~clk_tb;

endmodule