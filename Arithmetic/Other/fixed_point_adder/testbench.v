`timescale 1ns / 1ps

module testbench;
    // Parameters
    parameter Q = 15;
    parameter N = 32;

    // Inputs
    reg [N-1:0] a;
    reg [N-1:0] b;

    // Output
    wire [N-1:0] c;
    reg [N-1:0] expected_result;
    integer error = 0;

    fixed_point_adder #(.Q(Q), .N(N)) fp_adder (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin    
        for (integer i = 0; i < 100; i = i + 1) begin
            a = $random % (1 << N);
            b = $random % (1 << N);

            #10;

            if ((a[N-1] == b[N-1]) || (a[N-1] == 0 && b[N-1] == 1 && a[N-2:0] >= b[N-2:0]) || (a[N-1] == 1 && b[N-1] == 0 && a[N-2:0] < b[N-2:0])) begin
                expected_result = a + b;
            end
            else if (a[N-1] == 0 && b[N-1] == 1 && a[N-2:0] < b[N-2:0]) begin
                expected_result = b - a;
            end
            else begin
                expected_result = a - b;
            end

            if (c !== expected_result) begin
                error = error + 1;
                $display("Test failed: a = %b, b = %b, c = %b, expected_result = %b", a, b, c, expected_result);
            end
        end

        // Final test result summary
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end
        else begin
            $display("=========== Test completed with %d /100 failures ===========", error);
        end

        // End simulation
        $finish;
    end

endmodule