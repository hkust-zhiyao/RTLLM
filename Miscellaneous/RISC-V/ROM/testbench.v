module rom_tb;

    reg [7:0] addr_tb;          // Address input for the ROM
    wire [15:0] dout_tb;        // Data output from the ROM

    ROM rom_inst (
        .addr(addr_tb),
        .dout(dout_tb)
    );

    integer error;

    initial begin
        // Initialize simulation
        $display("Starting ROM Testbench...");
        error = 0;

        // Test reading data from different memory locations
        addr_tb = 8'h00;  // Read from address 0
        #10;
        if (dout_tb !== 16'hA0A0) begin
            $display("Error: Data read from address 0 is incorrect");
            error = error + 1;
        end

        addr_tb = 8'h01;  // Read from address 1
        #10;
        if (dout_tb !== 16'hB1B1) begin
            $display("Error: Data read from address 1 is incorrect");
            error = error + 1;
        end

        addr_tb = 8'h02;  // Read from address 2
        #10;
        if (dout_tb !== 16'hC2C2) begin
            $display("Error: Data read from address 2 is incorrect");
            error = error + 1;
        end

        addr_tb = 8'h03;  // Read from address 3
        #10;
        if (dout_tb !== 16'hD3D3) begin
            $display("Error: Data read from address 3 is incorrect");
            error = error + 1;
        end

        // Add more test cases here if needed

        // Check for errors
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
        end else begin
            $display("Test completed with %d errors.", error);
        end

        $finish;
    end

endmodule