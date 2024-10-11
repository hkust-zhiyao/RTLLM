module testbench;

    reg clk;
    reg reset;
    wire [7:0] out;

    ring_counter ring_counter_inst (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    always begin
        #5 clk <= ~clk;
    end

    

    reg [3:0] i;
    reg [7:0] data [0:9] = {8'b00000001, 8'b00000001, 8'b00000010, 8'b00000100, 8'b00001000,8'b00010000, 8'b00100000, 8'b01000000, 8'b10000000, 8'b00000001};

    initial begin
        clk = 0;
        reset = 1;
        i=0;
        #10 reset = 0;
    end
    // Monitor for displaying output
    always @(posedge clk) begin
        
        if (out !== data[i]) begin
            $display("Failed at i=%d, out=%b, expected=%b", i, out, data[i]);
            // $finish;
        end
        i = i + 1;
    end

    // Stop simulation after checking all values
    always @(posedge clk) begin
        if (i == 9) begin
            $display("=========== Your Design Passed ===========");
            $finish;
        end
    end
    // Stop simulation after 100 clock cycles
    initial begin
        #100 $finish;
    end

endmodule
