`timescale 1ns / 1ps

module tb_fixed_point_subtractor;

    // Parameters
    parameter Q = 15;
    parameter N = 32;

    // Inputs
    reg [N-1:0] a;
    reg [N-1:0] b;

    // Output
    wire [N-1:0] c;
    integer error = 0;
    reg [N-1:0] expected_result;

    // Instantiate the fixed point subtractor module
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Initial values for inputs
    initial begin


        for (integer i = 0; i < 100; i = i + 1) begin
            // Generate random N-bit inputs
            a = $random % (1 << N);
            b = $random % (1 << N);

            // Delay for the operation to complete
            #10;

            // Calculate expected results
            if (a[N-1] == b[N-1]) begin
                expected_result = a - b;
            end
            else if (a[N-1] == 0 && b[N-1] == 1) begin
                if (a[N-2:0] > b[N-2:0]) begin
                    expected_result = a + b;
                end
                else begin
                    expected_result = b - a;
                end
            end
            else begin
                if (a[N-2:0] > b[N-2:0]) begin
                    expected_result = a - b;
                end
                else begin
                    expected_result = b - a;
                end
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