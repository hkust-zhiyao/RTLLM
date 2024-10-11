`timescale 1ns/1ns
`define width 8
`define TESTFILE "test_data.dat"

module booth4_mul_tb () ;
    reg signed [`width-1:0] a, b;
    reg             clk, reset;

    wire signed [2*`width-1:0] p;
    wire           rdy;

    integer total, err;
    integer i, s, fp, numtests;

    wire signed [2*`width-1:0] ans = a*b;

    multi_booth_8bit dut( .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .p(p),
        .rdy(rdy));

    // Set up 10ns clock
    always #5 clk = ~clk;

    task apply_and_check;
        input [`width-1:0] ain;
        input [`width-1:0] bin;
        begin
            // Set the inputs
            a = ain;
            b = bin;
            // Reset the DUT for one clock cycle
            reset = 1;
            @(posedge clk);
            // Remove reset 
            #1 reset = 0;

            while (rdy == 0) begin
                @(posedge clk); // Wait for one clock cycle
            end
            if (p == ans) begin
                // $display($time, " Passed %d * %d = %d", a, b, p);
            end else begin
                // $display($time, " Fail %d * %d: %d instead of %d", a, b, p, ans);
                err = err + 1;
            end
            total = total + 1;
        end
    endtask // apply_and_check

    initial begin
        clk = 1;
        total = 0;
        err = 0;

        // Get all inputs from file: 1st line has number of inputs
        fp = $fopen(`TESTFILE, "r");
        s = $fscanf(fp, "%d\n", numtests);
        // Sequences of values pumped through DUT 
        for (i=0; i<numtests; i=i+1) begin
            s = $fscanf(fp, "%d %d\n", a, b);
            apply_and_check(a, b);
        end
        if (err > 0) begin
            $display("=========== Failed ===========");
        end else begin
            $display("===========Your Design Passed===========");
        end
        $finish;
    end

endmodule