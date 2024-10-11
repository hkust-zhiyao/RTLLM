module testbench;

    reg clk;
    reg reset;
    reg up_down;
    wire [15:0] count;

    // Instantiate the up_down_counter module
    up_down_counter uut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    integer error = 0;
    always begin
        #5 clk <= ~clk;
    end

    // Initial 
    initial begin
        clk = 0;
        reset = 1;
        up_down = 1; 
        #10 reset = 0;
    end

    // Monitor for displaying count
    // always @(posedge clk) begin
    //     $display("Count = %d", count);
    // end

    // Test counting up
    initial begin
        #20 up_down = 1;
        #100 up_down = 0; // Switch to counting down
        // $display("Count = %d", count);
        error = (count==11)?error : error+1;
        #200 up_down = 1; // Switch back to counting up
        // $display("Count = %d", count);
        error = (count==65527)?error : error+1;
        #300 ;
        // $display("Count = %d", count);
        error = (count==21)?error : error+1;
        if (error == 0) begin
        $display("=========== Your Design Passed ===========");
        end
        else begin
        $display("=========== Test completed with %d failures ===========", error);
        end

        $finish;
    end

endmodule
