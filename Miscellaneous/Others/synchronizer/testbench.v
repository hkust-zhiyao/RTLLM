`timescale 1ns/1ns

module testbench;
    // Inputs
    reg clk_a;
    reg clk_b;
    reg arstn;
    reg brstn;
    reg [3:0] data_in;
    reg data_en;

    // Outputs
    wire [3:0] dataout;

    // Instantiate the mux module
    synchronizer dut(
        .clk_a(clk_a),
        .clk_b(clk_b),
        .arstn(arstn),
        .brstn(brstn),
        .data_in(data_in),
        .data_en(data_en),
        .dataout(dataout)
    );

    // Clock generation
    always #5 clk_a = ~clk_a;
    always #10 clk_b = ~clk_b;

    integer error=0;
    initial begin
        clk_a = 0;
        clk_b = 0;
        arstn = 0;
        brstn = 0;
        data_en = 0;
        data_in = 0;
        
        #20 arstn = 1; // Release reset
		#5 brstn = 1; 
        #50 data_in = 4; // Set data_in to 4
        #10 data_en = 1; // Enable data
        // $display(dataout);
        #100;
        error = (dataout == 4)? error : error+1;
        #10 data_en = 0; // Disable data
        #100;
        #50 data_in = 7; // Set data_in to 7
        #10 data_en = 1; // Enable data
        // $display(dataout);
        #80;
        error = (dataout == 7)? error : error+1;
        #10 data_en = 0; // Disable data
        #100;
        #50;
        #20 arstn = 0; // Assert reset
        #100;
        #20 arstn = 1; // Release reset
        #50 data_in = 9; // Set data_in to 9
        #10 data_en = 1; // Enable data
        // $display(dataout);
        #100;
        error = (dataout == 9)? error : error+1;
        #10 data_en = 0; // Disable data
        #100;

        // Display results
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Test completed with %d /3 failures===========", error);
        end
        $finish;
    end

endmodule
