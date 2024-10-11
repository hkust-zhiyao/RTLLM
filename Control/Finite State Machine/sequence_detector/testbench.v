`timescale 1ns / 1ps

module tb_sequence_detector();

    reg clk, rst_n, data_in;
    wire sequence_detected;

    sequence_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .sequence_detected(sequence_detected)
    );
    integer error = 0;  
    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        data_in = 1;
        #2 rst_n = 1;


        // Sending 1001
        #6 data_in = 1;
        #10 data_in = 1;
        #10 data_in = 0;
        #10 data_in = 0;
        #10 data_in = 1;
        #10;data_in = 1; 
        if (!sequence_detected)
            error = error+1;
        #10;data_in = 1;
        #10 data_in = 0;
        if (sequence_detected)
            error = error+1;
        #10 data_in = 0;
        #10 data_in = 1;
        #10;
        if (!sequence_detected)
            error = error+1;
    if (error == 0) begin
      $display("=========== Your Design Passed ===========");
    end
    else begin
      $display("=========== Test completed with %d /100 failures ===========", error);
    end           
        $finish;
    end

endmodule